# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  before(:all) do
    @user = create(:user)
    @user_otp_auth = create(:user, :otp_auth)
    @user_with_otp_code = create(:user, :with_otp_code)
  end

  describe 'Авторизация' do
    describe 'POST /auth/sign_in' do
      it 'return 200' do
        post user_session_path, params: { user: { email: @user.email, password: @user.password } }
        expect(response).to have_http_status(:ok)
        expect(response).to match_json_schema('users/sign_in/ok')
      end
      describe '2-х факторная авторизация' do
        it 'return 200' do
          post user_session_path, params: { user: { email: @user_otp_auth.email, password: @user_otp_auth.password, otp_attempt: @user_otp_auth.current_otp } }
          expect(response).to have_http_status(:ok)
          expect(response).to match_json_schema('users/sign_in/ok')
        end
        describe 'Проверка токена' do
          it 'Токен отстствует' do
            post user_session_path, params: { user: { email: @user_otp_auth.email, password: @user_otp_auth.password } }
            expect(response).to have_http_status(:unauthorized)
            expect(response).to match_json_schema('users/sign_in/password_error')
          end
          it 'Неверный токен' do
            post user_session_path, params: { user: { email: @user_otp_auth.email, password: @user_otp_auth.password, otp_attempt: '152486' } }
            expect(response).to have_http_status(:unauthorized)
            expect(response).to match_json_schema('users/sign_in/password_error')
          end
        end
      end
      describe 'Проверка валидации' do
        it 'Нет пароля' do
          post user_session_path, params: { user: { email: @user.email } }
          expect(response).to have_http_status(:unauthorized)
          expect(response).to match_json_schema('users/sign_in/password_error')
        end
        it 'Неверный пароль' do
          post user_session_path, params: { user: { email: @user.email, password: 'неверный пароль' } }
          expect(response).to have_http_status(:unauthorized)
          expect(response).to match_json_schema('users/sign_in/password_error')
        end
      end
    end

    describe 'POST /auth/totp' do
      it 'Включение' do
        post auth_totp_path, headers: auth_headers(@user)
        expect(response).to have_http_status(:ok)
        expect(response).to match_json_schema('users/totp/create')
        @user.otp_secret.present?
      end
      it 'Подтверждение включения' do
        post auth_totp_path, headers: auth_headers(@user_with_otp_code), params: { code: @user_with_otp_code.current_otp }
        expect(response).to have_http_status(:created)
      end
      it 'Ошибка неверный код' do
        post auth_totp_path, headers: auth_headers(@user_with_otp_code), params: { code: '32143' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'Ошибка при уже включённом totp' do
        post auth_totp_path, headers: auth_headers(@user_otp_auth)
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'DELETE /auth/totp' do
      it 'return 200' do
        delete auth_totp_path, headers: auth_headers(@user_otp_auth), params: { code: @user_otp_auth.current_otp }
        expect(response).to have_http_status(:ok)
        expect(response).to match_json_schema('users/totp/delete')
      end
      it 'Ошибка при уже выключенном totp' do
        delete auth_totp_path, headers: auth_headers(@user)
        expect(response).to have_http_status(:forbidden)
      end
      it 'Ошибка при отсутствующем коде' do
        delete auth_totp_path, headers: auth_headers(@user_otp_auth)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to match_json_schema('users/totp/code_error')
      end
      it 'Ошибка при неверном коде' do
        delete auth_totp_path, headers: auth_headers(@user_otp_auth), params: { code: 'code' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to match_json_schema('users/totp/code_error')
      end
    end

    describe 'POST /auth/send_code' do
      it 'return 200' do
        post auth_send_code_path, params: { email: @user_otp_auth.email }
        expect(response).to have_http_status(:created)
      end
      it 'Ошибка для отключённой авторизации по коду' do
        post auth_send_code_path, params: { email: @user.email }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
