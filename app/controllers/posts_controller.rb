class PostsController < ApplicationController
  #before_action은 하나의 액션을 실행하기 전에 해당 메소드를 실행.
  #컨트롤러 filter
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  #뒤에있는 action 실행전에 set_post실행
  before_action :authenticate_user!, except: :index
  #before_action :is_owner?, only: [:edit, :update, :destroy]
  load_and_authorize_resource except: :edit, param_method: :post_params

  def index
    #@posts=Post.all
      @posts = Post.where("title LIKE ?","%#{params["q"]}%")
  end

  def new
  end

  def create
    current_user.posts.create(post_params)

    redirect_to '/'
  end

  def show
    # @post=Post.find(params[:id])
    # authorize! :read, @post
    # 글 볼 수 있는 권한확인
  end

  def edit
    #authorize! :update, @post
  end

  def update
    # @post=Post.find(params[:id])
    #authorize! :update, @post
    @post.update(post_params)
    redirect_to "/posts/#{@post.id}"
  end

  def destroy
    #authorize! :destroy, @post
    # @posts=Post.find(params[:id])
    @post.destroy
    redirect_to '/'
  end

  # private 위에는 public 상태라서 하나의 url로 요청오면 그것을 받아서 뷰를 보여준다.
  private
  # private은 해당 컨트롤러(PostsController)에서만 사용가능함.
  # 객체에서 private속성을 가지면 클래스 내부에서만 접근이 가능했었고,
  # 이 외의 상속받은 클래스나 객체 인스턴스에서도 접근이 불가능했음.
  def set_post
    @post = Post.find(params[:id])
  end
  # strong parameter - 원하는 parameter만 접근할 수 있도록
  def post_params
    params.require(:post).permit(:title, :content, :postimage)
    #post만 뽑고, title content postimage만
  end

  def is_owner?
    #게시글의 주인, 로그인한 사람이 같지 않으면
    redirect_to '/' and return unless @post.user_id == current_user.id
    #redirect_to '/'
  end

end
