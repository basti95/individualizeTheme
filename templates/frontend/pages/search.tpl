{assign var="pageTitleTranslated" value={translate key="common.search"}}
{if $query}
  {assign var="pageTitleTranslated" value={translate key="plugins.themes.individualizeTheme.search.pageTitle" phrase=$query|escape}}
{/if}


{extends file="frontend/layout.tpl"}

{block name="content"}

  <main class="search" id="skip-to-main">
    <div class="search-header">
      <h1 class="search-title">
        {if !$query}
          {translate key="common.search"}
        {else}
          {translate key="search.searchResults"}
        {/if}
      </h1>
      <div class="search-desc">
        {if !$query}
          <div>
            {translate
              key="plugins.themes.individualizeTheme.search.description"
              url={url page="issue" op="archive"}
            }
          </div>
        {else}
          <div class="search-desc-results">
            {translate
              key="plugins.themes.individualizeTheme.search.countResults"
              number=$results->count
            }
          </div>
          <div>
            {if $results->getCount()}
              {assign var="start" value=(($results->getPage() - 1) * $results->itemsPerPage) + 1}
              {assign var="end" value=(min($results->getCount(), ($results->getPage() * $results->itemsPerPage)))}
              {translate
                key="plugins.themes.individualizeTheme.search.showing"
                start=$start
                end=$end
                phrase=$query|escape
              }
            {else}
              {translate
                key="plugins.themes.individualizeTheme.search.noMatches"
                phrase=$query|escape
              }
            {/if}
          </div>
        {/if}
      </div>
      {if $results->getPageCount() > 1}
        {capture assign="urlPattern"}{url
          page="search"
          op="search"
          query=$query
          searchJournal=$searchJournal
          abstract=$abstract
          authors=$authors
          title=$title
          galleyFullText=$galleyFullText
          discipline=$discipline
          subject=$subject
          type=$type
          coverage=$coverage
          indexTerms=$indexTerms
          dateFromMonth=$dateFromMonth
          dateFromDay=$dateFromDay
          dateFromYear=$dateFromYear
          dateToMonth=$dateToMonth
          dateToDay=$dateToDay
          dateToYear=$dateToYear
          orderBy=$orderBy
          orderDir=$orderDir
          searchPage="__page__"
          escape=false
        }{/capture}
        {* Preserve literal placeholders in filters; only searchPage is substituted. *}
        {assign var="urlPattern" value=$urlPattern|replace:'__page__':'%5F%5Fpage%5F%5F'|replace:'searchPage=%5F%5Fpage%5F%5F':'searchPage=__page__'}
        {th_pagination
          assignPages="pages"
          assignCurrent="currentPage"
          perPage=$results->itemsPerPage
          total=$results->getCount()
          start=(($results->getPage() - 1) * $results->itemsPerPage) + 1
        }
        {include
          file="frontend/components/pagination-custom.tpl"
          pages=$pages
          currentPage=$currentPage
          urlPattern=$urlPattern
          firstPageUrl=$urlPattern|replace:'__page__':1
        }
      {/if}
    </div>

    <div class="
      search-body
      {if $results->getCount()}
        search-body-has-results
      {/if}
    ">

      {* Results *}
      {if $results->getCount()}
        <h2 class="sr-only">
          {translate key="search.searchResults"}
        </h2>
        <ul class="search-results">
      		{iterate from="results" item="result"}
            <li>
              {include
                file="frontend/components/article-summary.tpl"
                article=$result.publishedSubmission
                context=$currentContext
                heading="h3"
                galleys=true
                abstract=true
              }
            </li>
          {/iterate}
        </ul>
      {/if}

      {* Search form *}
      {include
        file="frontend/components/search-form.tpl"
        query=$query
      }
    </div>

    {if $results->getPageCount()> 1}
      {include
        file="frontend/components/pagination-custom.tpl"
        pages=$pages
        currentPage=$currentPage
        urlPattern=$urlPattern
        firstPageUrl=$urlPattern|replace:'__page__':1
      }
    {/if}
  </main>

{/block}