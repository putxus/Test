USE [master]
GO 
/****** Object:  Database [nxd_cmv]    Script Date: 29/10/2014 21:09:05 ******/
CREATE DATABASE [nxd_cmv] 
  
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [nxd_cmv].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [nxd_cmv] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [nxd_cmv] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [nxd_cmv] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [nxd_cmv] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [nxd_cmv] SET ARITHABORT OFF 
GO
ALTER DATABASE [nxd_cmv] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [nxd_cmv] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [nxd_cmv] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [nxd_cmv] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [nxd_cmv] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [nxd_cmv] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [nxd_cmv] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [nxd_cmv] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [nxd_cmv] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [nxd_cmv] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [nxd_cmv] SET  DISABLE_BROKER 
GO
ALTER DATABASE [nxd_cmv] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [nxd_cmv] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [nxd_cmv] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [nxd_cmv] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [nxd_cmv] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [nxd_cmv] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [nxd_cmv] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [nxd_cmv] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [nxd_cmv] SET  MULTI_USER 
GO
ALTER DATABASE [nxd_cmv] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [nxd_cmv] SET DB_CHAINING OFF 
GO
USE [nxd_cmv]
GO
/****** Object:  StoredProcedure [dbo].[get_accounts_without_followers]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_accounts_without_followers] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   DECLARE @TMP_analytics TABLE(
        [id_analytics] [int] NOT NULL ,
       [following]  [int] NOT NULL ,
	   [follower] [int] NOT NULL ,
	    [Date] [datetime] NOT NULL ,
	   [cf_account] [int] NOT NULL ,
	   [tweets] [int] NOT NULL
)
 
INSERT INTO @TMP_analytics
SELECT * FROM [dbo].[mxd_cmv_analytics] WITH (NOLOCK) WHERE [Date]>=DateAdd (hour, -1 , GETDATE ())


DECLARE @TMP_analytics2 TABLE(
        [id_analytics] [int] NOT NULL ,
       [following]  [int] NOT NULL ,
	   [follower] [int] NOT NULL ,
	    [Date] [datetime] NOT NULL ,
	   [cf_account] [int] NOT NULL ,
	   [tweets] [int] NOT NULL
)

INSERT INTO @TMP_analytics2
SELECT * FROM [dbo].[mxd_cmv_analytics] WITH (NOLOCK) WHERE [Date]<DateAdd (hour, -24 , GETDATE ()) and [Date]>=DateAdd (hour, -25 , GETDATE ())

DECLARE @TMP_analyticsResult TABLE(
        [numFollowers] [int] NOT NULL ,
	   [cf_account] [int] NOT NULL 

)

INSERT INTO @TMP_analyticsResult
SELECT a.follower-b.follower as numFollowers,a.cf_account FROM @TMP_analytics2 as a inner join @TMP_analytics as b on a.cf_account = b.cf_account

select b.login from @TMP_analyticsResult as a inner join dbo.nxd_cmv_accounts as b on b.id_account = a.cf_account where numFollowers = 0 and (b.cf_client = 1 or  b.cf_client = 4)

END


GO
/****** Object:  StoredProcedure [dbo].[get_accounts_without_following]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_accounts_without_following] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   DECLARE @TMP_analytics TABLE(
        [id_analytics] [int] NOT NULL ,
       [following]  [int] NOT NULL ,
	   [follower] [int] NOT NULL ,
	    [Date] [datetime] NOT NULL ,
	   [cf_account] [int] NOT NULL ,
	   [tweets] [int] NOT NULL
)
 
INSERT INTO @TMP_analytics
SELECT * FROM [dbo].[mxd_cmv_analytics] WITH (NOLOCK) WHERE [Date]>=DateAdd (hour, -1 , GETDATE ())


DECLARE @TMP_analytics2 TABLE(
        [id_analytics] [int] NOT NULL ,
       [following]  [int] NOT NULL ,
	   [follower] [int] NOT NULL ,
	    [Date] [datetime] NOT NULL ,
	   [cf_account] [int] NOT NULL ,
	   [tweets] [int] NOT NULL
)

INSERT INTO @TMP_analytics2
SELECT * FROM [dbo].[mxd_cmv_analytics] WITH (NOLOCK) WHERE [Date]<DateAdd (hour, -4 , GETDATE ()) and [Date]>=DateAdd (hour, -5 , GETDATE ())

DECLARE @TMP_analyticsResult TABLE(
        [numFollowing] [int] NOT NULL ,
	   [cf_account] [int] NOT NULL 

)

INSERT INTO @TMP_analyticsResult
SELECT a.following-b.following as numFollowing,a.cf_account FROM @TMP_analytics2 as a inner join @TMP_analytics as b on a.cf_account = b.cf_account

select b.login from @TMP_analyticsResult as a inner join dbo.nxd_cmv_accounts as b on b.id_account = a.cf_account where numFollowing = 0 and (b.cf_client = 1 or  b.cf_client = 4)

END



GO
/****** Object:  StoredProcedure [dbo].[get_accounts_without_tweets]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_accounts_without_tweets] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   DECLARE @TMP_analytics TABLE(
        [id_analytics] [int] NOT NULL ,
       [following]  [int] NOT NULL ,
	   [follower] [int] NOT NULL ,
	    [Date] [datetime] NOT NULL ,
	   [cf_account] [int] NOT NULL ,
	   [tweets] [int] NOT NULL
)
 
INSERT INTO @TMP_analytics
SELECT * FROM [dbo].[mxd_cmv_analytics] WITH (NOLOCK) WHERE [Date]>=DateAdd (hour, -1 , GETDATE ())


DECLARE @TMP_analytics2 TABLE(
        [id_analytics] [int] NOT NULL ,
       [following]  [int] NOT NULL ,
	   [follower] [int] NOT NULL ,
	    [Date] [datetime] NOT NULL ,
	   [cf_account] [int] NOT NULL ,
	   [tweets] [int] NOT NULL
)

INSERT INTO @TMP_analytics2
SELECT * FROM [dbo].[mxd_cmv_analytics] WITH (NOLOCK) WHERE [Date]<DateAdd (hour, -23 , GETDATE ()) and [Date]>=DateAdd (hour, -24 , GETDATE ())

DECLARE @TMP_analyticsResult TABLE(
        [numTweets] [int] NOT NULL ,
	   [cf_account] [int] NOT NULL 

)

INSERT INTO @TMP_analyticsResult
SELECT a.tweets-b.tweets as numTweets,a.cf_account FROM @TMP_analytics2 as a inner join @TMP_analytics as b on a.cf_account = b.cf_account

select b.login from @TMP_analyticsResult as a inner join dbo.nxd_cmv_accounts as b on b.id_account = a.cf_account where numTweets = 0 and (b.cf_client = 1 or  b.cf_client = 4)

END

GO
/****** Object:  StoredProcedure [dbo].[get_current_state]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_current_state]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SET ANSI_WARNINGS OFF

 
DECLARE @TMP_analytics TABLE(
        [id_analytics] [int] NOT NULL ,
       [following]  [int] NOT NULL ,
	   [follower] [int] NOT NULL ,
	    [Date] [datetime] NOT NULL ,
	   [cf_account] [int] NOT NULL ,
	   [tweets] [int] NOT NULL
)
 
INSERT INTO @TMP_analytics
SELECT * FROM [dbo].[mxd_cmv_analytics] WITH (NOLOCK) WHERE [Date]>=DateAdd (hour, -1 , GETDATE ());
 
SELECT * FROM @TMP_analytics
END

GO
/****** Object:  Table [dbo].[mxd_cmv_analytics]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mxd_cmv_analytics](
	[id_analytics] [int] IDENTITY(1,1) NOT NULL,
	[following] [int] NULL,
	[follower] [int] NULL,
	[date] [datetime] NULL,
	[cf_account] [int] NULL,
	[tweets] [int] NULL,
 CONSTRAINT [PK_mxd_cmv_analytics] PRIMARY KEY CLUSTERED 
(
	[id_analytics] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mxd_cmv_analytics_instagram]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mxd_cmv_analytics_instagram](
	[id_analytics] [int] IDENTITY(1,1) NOT NULL,
	[following] [int] NULL,
	[follower] [int] NULL,
	[date] [datetime] NULL,
	[cf_account] [int] NULL,
	[post] [int] NULL,
 CONSTRAINT [PK_mxd_cmv_analytics_instagram] PRIMARY KEY CLUSTERED 
(
	[id_analytics] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_accounts]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_accounts](
	[cf_client] [int] NOT NULL,
	[id_account] [int] IDENTITY(1,1) NOT NULL,
	[email] [nchar](50) NULL,
	[login] [nchar](50) NULL,
	[password] [nchar](50) NULL,
	[hootsuitmail] [nchar](50) NULL,
	[key_adfly] [nchar](50) NULL,
	[uid_adfly] [nchar](50) NULL,
	[time_min] [int] NULL,
	[order_hootsuite] [nchar](10) NULL,
	[logo_image] [text] NULL,
	[background_image] [text] NULL,
	[published] [bit] NOT NULL,
	[shchedule_daily] [int] NOT NULL,
	[password_hootsuite] [nchar](50) NULL,
	[consumerKey] [ntext] NULL,
	[consumerSecret] [ntext] NULL,
	[token] [ntext] NULL,
	[tokenSecret] [ntext] NULL,
	[unfollows] [int] NULL,
	[follows] [int] NULL,
	[schedulle] [smallint] NULL,
 CONSTRAINT [PK_nxd_cmv_accounts] PRIMARY KEY CLUSTERED 
(
	[id_account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_accounts_down]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_accounts_down](
	[cf_client] [int] NOT NULL,
	[id_account] [int] IDENTITY(1,1) NOT NULL,
	[email] [nchar](50) NULL,
	[login] [nchar](50) NULL,
	[password] [nchar](50) NULL,
	[hootsuitmail] [nchar](50) NULL,
	[key_adfly] [nchar](50) NULL,
	[uid_adfly] [nchar](50) NULL,
	[time_min] [int] NULL,
	[order_hootsuite] [nchar](10) NULL,
	[logo_image] [text] NULL,
	[background_image] [text] NULL,
	[published] [bit] NOT NULL,
	[shchedule_daily] [int] NOT NULL,
	[password_hootsuite] [nchar](50) NULL,
	[consumerKey] [ntext] NULL,
	[consumerSecret] [ntext] NULL,
	[token] [ntext] NULL,
	[tokenSecret] [ntext] NULL,
	[unfollows] [int] NULL,
	[follows] [int] NULL,
	[schedulle] [smallint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_accounts_instagram]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_accounts_instagram](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[login] [nchar](10) NULL,
	[password] [nchar](10) NULL,
	[cf_clients] [int] NULL,
	[id_instagram_client] [nchar](10) NULL,
	[likes] [bit] NULL,
	[orig_following] [int] NULL,
 CONSTRAINT [PK_nxd_cmv_accounts_instagram] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_analytics_monthly]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_analytics_monthly](
	[id_analytics] [int] IDENTITY(1,1) NOT NULL,
	[following] [int] NULL,
	[follower] [int] NULL,
	[date] [datetime] NULL,
	[cf_account] [int] NULL,
 CONSTRAINT [PK_nxd_cmv_analytics_monthly] PRIMARY KEY CLUSTERED 
(
	[id_analytics] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_analytics_yearly]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_analytics_yearly](
	[id_analytics] [int] IDENTITY(1,1) NOT NULL,
	[following] [int] NULL,
	[follower] [int] NULL,
	[date] [datetime] NULL,
	[cf_account] [int] NULL,
 CONSTRAINT [PK_nxd_cmv_analytics_yearly] PRIMARY KEY CLUSTERED 
(
	[id_analytics] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_black_list_unfollow]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_black_list_unfollow](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[accout] [nchar](20) NULL,
	[cf_account] [int] NULL,
 CONSTRAINT [PK_nxd_cmv_black_list_unfollow] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_change_password]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_change_password](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cf_account] [int] NULL,
	[old_password] [nvarchar](max) NULL,
	[login] [nvarchar](max) NULL,
	[state] [nvarchar](max) NULL,
	[fecha] [datetime] NULL,
 CONSTRAINT [PK_nxd_cmv_change_password] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_clients]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_clients](
	[id_client] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](40) NULL,
	[surname] [nchar](10) NULL,
	[cif] [nchar](10) NULL,
	[adress] [ntext] NULL,
	[cp] [nchar](10) NULL,
	[telf1] [nchar](10) NULL,
	[telf2] [nchar](10) NULL,
	[city] [nchar](10) NULL,
	[cf_country] [nchar](10) NULL,
 CONSTRAINT [PK_nxd_cmv_clients] PRIMARY KEY CLUSTERED 
(
	[id_client] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_follower_origin]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_follower_origin](
	[id_follower_origin] [int] IDENTITY(1,1) NOT NULL,
	[cf_account] [int] NOT NULL,
	[follower_name] [nchar](50) NULL,
 CONSTRAINT [PK_nxd_cmv_follower_origin] PRIMARY KEY CLUSTERED 
(
	[id_follower_origin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_follower_origin_instagram]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_follower_origin_instagram](
	[id_follower_origin] [int] IDENTITY(1,1) NOT NULL,
	[cf_account] [int] NOT NULL,
	[follower_name] [nchar](50) NULL,
 CONSTRAINT [PK_[nxd_cmv_follower_origin_instagram] PRIMARY KEY CLUSTERED 
(
	[id_follower_origin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_newAccounts]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_newAccounts](
	[id_newAccounts] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[loginAccount] [nvarchar](50) NULL,
	[password] [nvarchar](50) NULL,
	[email] [nvarchar](50) NULL,
	[logo] [nvarchar](300) NULL,
	[BackGround] [nvarchar](300) NULL,
	[Rss1] [nvarchar](300) NULL,
	[Rss2] [nvarchar](300) NULL,
	[Rss3] [nvarchar](300) NULL,
	[SearcherName] [text] NULL,
	[ListAccounts] [text] NULL,
	[TwitterCreated] [bit] NULL,
 CONSTRAINT [PK_nxd_cmv_newAccounts] PRIMARY KEY CLUSTERED 
(
	[id_newAccounts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_recoverypass]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_recoverypass](
	[login] [nvarchar](max) NULL,
	[pass] [nvarchar](max) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_nxd_cmv_recoverypass] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_url_origin]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_url_origin](
	[id_url_origin] [int] IDENTITY(1,1) NOT NULL,
	[url] [nchar](500) NULL,
	[cf_accounts] [int] NULL,
 CONSTRAINT [PK_nxd_cmv_url_origin] PRIMARY KEY CLUSTERED 
(
	[id_url_origin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_users]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_users](
	[login] [nchar](10) NULL,
	[password] [nchar](10) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cf_client] [int] NULL,
	[bloqued] [bit] NULL,
 CONSTRAINT [PK_nxd_cmv_users] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nxd_cmv_vpn]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nxd_cmv_vpn](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[zone] [nvarchar](50) NULL,
	[ip] [nchar](10) NULL,
	[date] [date] NULL,
	[continent] [nvarchar](50) NULL,
 CONSTRAINT [PK_nxd_cmv_vpn] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Test2]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Test2](
	[ip] [nvarchar](50) NULL,
	[user] [nvarchar](300) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[URLFilter]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[URLFilter](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[url] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[AnalitycsPrepared]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AnalitycsPrepared]
AS
SELECT     id_analytics, following, follower, cf_account, tweets, CAST(DATEPART(year, date) AS varchar(4)) + CAST(DATEPART(month, date) AS varchar(4)) + CAST(DATEPART(day, 
                      date) AS varchar(4)) + CAST(DATEPART(hour, date) AS varchar(4)) AS date_group, date
FROM         dbo.mxd_cmv_analytics

GO
/****** Object:  View [dbo].[AnalitycsDay]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AnalitycsDay]
AS
SELECT     id_analytics, following, follower, cf_account, tweets, date_group, date
FROM         dbo.AnalitycsPrepared
WHERE     (date >= CAST(DATEPART(year, GETDATE()) AS varchar(4)) + ' - ' + CAST(DATEPART(month, GETDATE()) AS varchar(2)) + ' - ' + CAST(DATEPART(day, GETDATE()) 
                      AS varchar(2)) + 'T00:00:00.001') AND (date <= CAST(DATEPART(year, GETDATE()) AS varchar(4)) + ' - ' + CAST(DATEPART(month, GETDATE()) AS varchar(2)) 
                      + ' - ' + CAST(DATEPART(day, GETDATE()) AS varchar(2)) + 'T23:59:59.000')

GO
/****** Object:  View [dbo].[AccountsForbbiden]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AccountsForbbiden]
AS
SELECT LTRIM(RTRIM(b.login)) as login ,b.email,a.fecha, a.state,a.old_password, b.[password]
FROM     dbo.nxd_cmv_change_password AS a INNER JOIN
                  dbo.nxd_cmv_accounts AS b ON a.cf_account = b.id_account AND (b.cf_client = 1 OR
                  b.cf_client = 4)
GROUP BY b.login,b.email,a.fecha, a.state,a.old_password, b.[password]
GO
/****** Object:  View [dbo].[AccountsNotRss]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AccountsNotRss]
AS
SELECT     cf_client, id_account, email, login, password, hootsuitmail, key_adfly, uid_adfly, time_min, order_hootsuite, logo_image, background_image, published, 
                      shchedule_daily, password_hootsuite, consumerKey, consumerSecret, token, tokenSecret, unfollows, follows, schedulle
FROM         dbo.nxd_cmv_accounts AS a
WHERE     (id_account NOT IN
                          (SELECT     dbo.nxd_cmv_accounts.id_account
                            FROM          dbo.nxd_cmv_accounts INNER JOIN
                                                   dbo.nxd_cmv_url_origin ON dbo.nxd_cmv_accounts.id_account = dbo.nxd_cmv_url_origin.cf_accounts)) AND (cf_client = 1 OR
                      cf_client = 4) AND (login NOT LIKE '%edulle%')

GO
/****** Object:  View [dbo].[AccountsUrl]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AccountsUrl]
AS
SELECT     dbo.nxd_cmv_url_origin.url, dbo.nxd_cmv_accounts.id_account, dbo.nxd_cmv_accounts.login, dbo.nxd_cmv_accounts.email
FROM         dbo.nxd_cmv_accounts INNER JOIN
                      dbo.nxd_cmv_url_origin ON dbo.nxd_cmv_accounts.id_account = dbo.nxd_cmv_url_origin.cf_accounts
WHERE     (dbo.nxd_cmv_accounts.cf_client = 1)

GO
/****** Object:  View [dbo].[AccountsWith1Rss]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AccountsWith1Rss]
AS
SELECT     dbo.nxd_cmv_accounts.login, dbo.nxd_cmv_url_origin.cf_accounts, COUNT(dbo.nxd_cmv_url_origin.cf_accounts) AS countAC
FROM         dbo.nxd_cmv_url_origin INNER JOIN
                      dbo.nxd_cmv_accounts ON dbo.nxd_cmv_url_origin.cf_accounts = dbo.nxd_cmv_accounts.id_account
GROUP BY dbo.nxd_cmv_url_origin.cf_accounts, dbo.nxd_cmv_accounts.login
HAVING      (COUNT(dbo.nxd_cmv_url_origin.cf_accounts) = 1)

GO
/****** Object:  View [dbo].[AccountsWithNoTweets]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AccountsWithNoTweets]
AS
SELECT     TOP (1000) b.cf_account, a.login, COUNT(b.cf_account) AS id
FROM         dbo.mxd_cmv_analytics AS b INNER JOIN
                      dbo.nxd_cmv_accounts AS a ON a.id_account = b.cf_account
WHERE     (b.tweets = 0) AND (b.date > '2014-05-21') AND (a.cf_client = 1)
GROUP BY b.cf_account, a.login
ORDER BY b.cf_account

GO
/****** Object:  View [dbo].[AccountWitoutOriginFollower]    Script Date: 29/10/2014 21:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AccountWitoutOriginFollower]
AS
SELECT     cf_client, id_account, email, login, password, hootsuitmail, key_adfly, uid_adfly, time_min, order_hootsuite, logo_image, background_image, published, 
                      shchedule_daily, password_hootsuite, consumerKey, consumerSecret, token, tokenSecret, unfollows, follows, schedulle
FROM         dbo.nxd_cmv_accounts AS a
WHERE     (id_account NOT IN
                          (SELECT     dbo.nxd_cmv_accounts.id_account
                            FROM          dbo.nxd_cmv_accounts INNER JOIN
                                                   dbo.nxd_cmv_follower_origin ON dbo.nxd_cmv_accounts.id_account = dbo.nxd_cmv_follower_origin.cf_account)) AND (cf_client = 1 OR
                      cf_client = 4) AND (login NOT LIKE '%dulle%')

GO
/****** Object:  Index [IX_mxd_cmv_analytics]    Script Date: 29/10/2014 21:09:07 ******/
CREATE NONCLUSTERED INDEX [IX_mxd_cmv_analytics] ON [dbo].[mxd_cmv_analytics]
(
	[id_analytics] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_nxd_cmv_accounts]    Script Date: 29/10/2014 21:09:07 ******/
CREATE NONCLUSTERED INDEX [IX_nxd_cmv_accounts] ON [dbo].[nxd_cmv_accounts]
(
	[id_account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_nxd_cmv_analytics_monthly]    Script Date: 29/10/2014 21:09:07 ******/
CREATE NONCLUSTERED INDEX [IX_nxd_cmv_analytics_monthly] ON [dbo].[nxd_cmv_analytics_monthly]
(
	[id_analytics] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[nxd_cmv_accounts] ADD  CONSTRAINT [DF_nxd_cmv_accounts_published]  DEFAULT ((0)) FOR [published]
GO
ALTER TABLE [dbo].[nxd_cmv_accounts] ADD  CONSTRAINT [DF_nxd_cmv_accounts_shchedule_daily]  DEFAULT ((0)) FOR [shchedule_daily]
GO
ALTER TABLE [dbo].[nxd_cmv_accounts] ADD  CONSTRAINT [DF_nxd_cmv_accounts_password_hootsuite]  DEFAULT (N'Border11') FOR [password_hootsuite]
GO
ALTER TABLE [dbo].[nxd_cmv_accounts] ADD  CONSTRAINT [DF_nxd_cmv_accounts_unfollows]  DEFAULT ((250)) FOR [unfollows]
GO
ALTER TABLE [dbo].[nxd_cmv_accounts] ADD  CONSTRAINT [DF_nxd_cmv_accounts_follows]  DEFAULT ((600)) FOR [follows]
GO
ALTER TABLE [dbo].[nxd_cmv_accounts] ADD  CONSTRAINT [DF_nxd_cmv_accounts_schedulle]  DEFAULT ((0)) FOR [schedulle]
GO
ALTER TABLE [dbo].[nxd_cmv_change_password] ADD  CONSTRAINT [DF_nxd_cmv_change_password_fecha]  DEFAULT (getdate()) FOR [fecha]
GO
ALTER TABLE [dbo].[nxd_cmv_newAccounts] ADD  DEFAULT ((0)) FOR [TwitterCreated]
GO
ALTER TABLE [dbo].[nxd_cmv_accounts]  WITH CHECK ADD  CONSTRAINT [FK_nxd_cmv_accounts_nxd_cmv_clients] FOREIGN KEY([cf_client])
REFERENCES [dbo].[nxd_cmv_clients] ([id_client])
GO
ALTER TABLE [dbo].[nxd_cmv_accounts] CHECK CONSTRAINT [FK_nxd_cmv_accounts_nxd_cmv_clients]
GO
ALTER TABLE [dbo].[nxd_cmv_users]  WITH CHECK ADD  CONSTRAINT [FK_nxd_cmv_users_nxd_cmv_clients1] FOREIGN KEY([cf_client])
REFERENCES [dbo].[nxd_cmv_clients] ([id_client])
GO
ALTER TABLE [dbo].[nxd_cmv_users] CHECK CONSTRAINT [FK_nxd_cmv_users_nxd_cmv_clients1]
GO
EXEC [nxd_cmv].sys.sp_addextendedproperty @name=N'Name Applicaction', @value=N'Nexedigital Comunity Manager Virtual' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 308
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 7
               Left = 356
               Bottom = 170
               Right = 616
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountsForbbiden'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountsForbbiden'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[23] 4[30] 2[8] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 23
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1995
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 2610
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountsNotRss'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountsNotRss'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[11] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "nxd_cmv_accounts"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "nxd_cmv_url_origin"
            Begin Extent = 
               Top = 6
               Left = 253
               Bottom = 168
               Right = 404
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountsUrl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountsUrl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "nxd_cmv_url_origin"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 99
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "nxd_cmv_accounts"
            Begin Extent = 
               Top = 6
               Left = 243
               Bottom = 114
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountsWith1Rss'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountsWith1Rss'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[28] 4[34] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 243
               Bottom = 114
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 2505
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountsWithNoTweets'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountsWithNoTweets'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[10] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2235
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountWitoutOriginFollower'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AccountWitoutOriginFollower'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[21] 4[31] 2[23] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "AnalitycsPrepared"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 4320
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AnalitycsDay'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AnalitycsDay'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[26] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "mxd_cmv_analytics"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AnalitycsPrepared'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AnalitycsPrepared'
GO
USE [master]
GO
ALTER DATABASE [nxd_cmv] SET  READ_WRITE 
GO
