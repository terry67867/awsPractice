### 1. CRUD 끝내기 (non scaffold)

**RESTful** 하게 짜기! (posts 컨트롤러, post 모델!)

RESTful이란, 주소창(url)을 통해서 자원(리소스)과 행위(HTTP Verb)를 표현하는 것.

[가장 깔끔한 설명](http://meetup.toast.com/posts/92)

[routes](#1. routes.rb)

#### 0. 기본 사항

- `git` 셋팅(git init부터)
- C/R/U/D 마다 **commit** 하기
- `posts` 컨트롤러와 `post` 모델만!

# 1. routes.rb

```ruby
  # index
  get '/posts' => 'posts#index'
  # Create
  get '/posts/new' => 'posts#new'
  post '/posts'=> 'posts#create'
  # Read
  get '/posts/:id' => 'posts#show'
  # Update
  get '/posts/:id/edit' => 'posts#edit'
  put '/posts/:id' => 'posts#update'
  # Delete
  delete '/posts/:id' => 'posts#destroy'
```

1. controller

   - [filter](http://guides.rorlab.org/action_controller_overview.html#%ED%95%84%ED%84%B0)

   ```ruby
   before_action :set_post, only: [:show, :edit, :update, :destroy]

   private

   def set_post
     @post = Post.find(params[:id])
   end
   ```

   - [strong parameters](http://guides.rorlab.org/action_controller_overview.html#strong-parameters)

   ```ruby
   private

   def post_params
     params.require(:post).permit(:title, :content)
   end
   ```

2. view - form_tag / form_for

   - [폼 헬퍼](http://guides.rorlab.org/form_helpers.html)

### 2. scaffolding.. 편하게 CRUD

1. `routes.rb`

```ruby
  resources :posts
```

1. `scaffold` 명령어

```console
$ rails g scaffold post title:string content:text
```

`posts` 컨트롤러와 `post` 모델을 만들어줌! 코드도 겁나 많음..

### 3. [파일업로드](https://github.com/carrierwaveuploader/carrierwave)

```
1. `gemfile`
```

```ruby
  gem carrierwave
```

```console
  $ bundle install
```

```
2. 파일업로더 생성
```

```console
  $ rails generate uploader Avatar
```

1. 서버 작업

   - migration : string 타입의 column 추가

   - `post.rb`

     ```ruby
     mount_uploader :컬럼명, AvatarUploader
     ```

   - `posts_controller.rb`

     ```ruby
     # strong parameter에 받아주거나, create 단계에서 사진 받을 준비
     ```

2. `new.html.erb`

```html
  <form enctype="multipart/form-data">
    <input type="file" name="post[postimage]">
  </form>

  <%= form_tag ("/posts", method: "post", multipart: true) do %>
    <%= file_field_tag("post[postimage]") %><br />
  <% end %>
```

### 3-1. 사진 크기 조절하여 저장

  `gem mini_magick`

### 4. 인스타처럼 꾸미기(카드형 배치)



#5.Devise로 회원가입 기능 구현

*[devise] https://github.com/plataformatec/devise/*

### 기초시작하기

- 'Gemfile'에 devise 추가 후 'bundle install' 하기

```
gem 'devise'
```
- devise를 설치함

```console
$ rails generate devise:install
```
> Console에서 3번 복사 > layout > application > yield위에 붙여넣기
>
> 주요하게 만들어 지는 것들
>
> devise.rb

- User 모델 만들기 with devise

```console
$ rails generate devise User
```

> 주요하게 만들어지는 것들
>
> migration파일 / user.rb/ routes에 경로 추가 됨.

- 마이그레이션

> 별도의 커스터마이징 column이 없다면 바로, 아니면 추가하고 실행할 것

```$rake db:migrate
$rake db:migrate
```

- 서버실행!

  - rake routes로 만들어진 url들 확인

  - 예시

    - /users/sign_up:회원가입

    - /users/sign_in:로그인

    - /users/sign_out:로그아웃

      주의: get이 아니라 delete http method임! (url 접근 불가)

2. 추가내용

- 사용 가능한 helper
  - current_user:로그인 되어 있으면, 해당 user를 불러올 수 있다.
  - user_signed_in?:로그인 되어있는지 => return boolean
- 로그인해야 페이지 보여주는 법(post_controller.rb)

```before_action
before_action :authenticate_user!, except: :index
```

- view에서 로그인/로그아웃/회원가입 링크 보여주기(application.html.erb)

```
<% if user_signed_in? %>
	<li>
	<%= current_user.email%>님이 로그인 하셨습니다.
	<%= link_to('Logout', destroy_user_session_path, method: :delete) %>
	</li>
<% else %>
	<li>
	<%= link_to('Login', new_user_session_path)  %>
	<%= link_to('회원가입', new_user_registration_path)  %>
	</li>
<% end %>
```

- devise view파일 가져오기(커스터마이징)

```$rails
$rails g devise:views
```

- devise controller 커스터마이징 하기

```
$rails g devise:controllers users
```

````
users/ 많은 컨트롤러가 생김
````

- 반드시 routes.rb 수정

```
devise_for :users, controllers: {
  sessions: 'users/sessions'
}
```

- 커스터마이징 column

  1)migration 파일에 원하는대로 만들기!

  2)해당 view에서 input 박스만들기!

  3)strong parameter설정(컨트롤러 직접가능 /application_controller.rb에서도 가능)

```
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
```

```
#이것은 컨트롤러 만들고 주석 해제만 하면 됩니다.

class Users::RegistrationsController < Devise::RegistrationsController
 	before_action :configure_sign_up_params, only: [:create]
   	before_action :configure_account_update_params, only: [:update]
   
   protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
   end

  # If you have extra params to permit, append them to the sanitizer.
   def configure_account_update_params
     devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
   end

   The path used after sign up.
   def after_sign_up_path_for(resource)
     super(resource)
   end
   end
```



###admin 추가 기능

wiki > search admin > option2 

>```
>$rails generate migration add_admin_to_users admin:boolean
>```

직접입력해야한다. 

rails c > pry > User.create(username: "관리자", email: "admin@admin", password: "123123", admin: true)  



##admin아니면 접근 못하게하는 방법?

```
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin?

  def index
      @users=User.all
  end

  private
  def is_admin?
    redirect_to '/' and return unless current_user.admin?
  end

end

```

## 기존의 유저 admin으로 변경하려면?

```
User.find(2).update_attribute(:admin, true)
```

새롭게 생성시

```
User.create(username: '관리자', email: 'admin@admin', password: '123123', admin: true)
```



##회원 권한 부여 설정기능

cancancan https://github.com/CanCanCommunity/cancancan

- gemfile 추가

```
$gem 'cancancan', '~> 1.10'
```

```
$bundle install
```

```
$rails g cancan:ability
```

> wiki > Defining Abilities > 코드 복사한 후, 

- model > ability.rb 에 붙여넣기

```
class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all  # permissions for every user, even if not logged in    
    if user.present?  # additional permissions for logged in users (they can manage their posts)
      can :manage, Post, user_id: user.id 
      if user.admin?  # additional permissions for administrators
        can :manage, :all
      end
    end
  end
end
```

- 각 action에서 권한 확인 posts_controller.rb 수정

```
class PostsController < ApplicationController
	def show
    # @post=Post.find(params[:id])
    # authorize! :read, @post
    # 글 볼 수 있는 권한확인
  end

  def edit
    authorize! :update, @post
  end

  def update
    # @post=Post.find(params[:id])
    authorize! :update, @post
    @post.update(post_params)
    redirect_to "/posts/#{@post.id}"
  end

  def destroy
    authorize! :destroy, @post
    # @posts=Post.find(params[:id])
    @post.destroy
    redirect_to '/'
  end
end


```



##Handler Authorization

```
class ApplicationController < ActionController::Base
	rescue_from CanCan::AccessDenied do |exception|
      flash[:alert] = "권한없지롱~"
      redirect_to '/'
      # respond_to do |format|
      #   format.json { head :forbidden, content_type: 'text/html' }
      #   format.html { redirect_to main_app.root_url, notice: exception.message }
      #   format.js   { head :forbidden, content_type: 'text/html' }
      # end
  	end
 end
```



##Check Authorization   

(show.html.erb에서 수정)

```
<% if can? :update, @post %>
<p><a href="/posts/<%=@post.id%>/edit">수정</a></p>
<% end %>
<% if can? :destroy, @post %>
<p><a href="/posts/<%=@post.id%>" data-method="delete" date-confirm="삭제할래?">삭제</a></p>
<% end %>

```

> 권한있을 때만 수정버튼이 표시됨



###Loaders  

- 규칙을 지킨 경우 한 줄로 권한확인을 설정할 수 있다.

```
class ArticlesController < ApplicationController
  load_and_authorize_resource except: :edit, param_method: :post_params

  def show
    # @article is already loaded and authorized
  end
end
```

> edit제외하고 권한을 확인한다.



