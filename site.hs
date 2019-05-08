--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Text.Pandoc


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "static/*/*" $ do
        route idRoute
        compile copyFileCompiler

    {-
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler
    -}

    match (fromList ["about.md", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html" siteCtx
            >>= loadAndApplyTemplate "templates/default.html" siteCtx
            >>= relativizeUrls

    match "tils/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/til.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "stories/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/story.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    siteCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    create ["tils.html"] $ do
        route idRoute
        compile $ do
            tils <- recentFirst =<< loadAll "tils/*"
            let tilCtx =
                    listField "tils" postCtx (return tils) `mappend`
                    constField "title" "TILs"             `mappend`
                    siteCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/tils.html" tilCtx
                >>= loadAndApplyTemplate "templates/default.html" tilCtx
                >>= relativizeUrls

    create ["stories.html"] $ do
        route idRoute
        compile $ do
            stories <- recentFirst =<< loadAll "stories/*"
            let tilCtx =
                    listField "stories" postCtx (return stories) `mappend`
                    constField "title" "stories"             `mappend`
                    siteCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/stories.html" tilCtx
                >>= loadAndApplyTemplate "templates/default.html" tilCtx
                >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            tils <- recentFirst =<< loadAll "tils/*"
            stories <- recentFirst =<< loadAll "stories/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    listField "tils" postCtx (return tils) `mappend`
                    listField "stories" postCtx (return stories) `mappend`
                    constField "title" "Home"                `mappend`
                    siteCtx

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    siteCtx

siteCtx :: Context String
siteCtx =
    constField "baseurl" "" `mappend`
    constField "site_description" "" `mappend`
    constField "instagram_username" "" `mappend`
    constField "twitter_username" "_rbutler_" `mappend`
    constField "github_username" "rbutler" `mappend`
    constField "google_username" "" `mappend`
    defaultContext
