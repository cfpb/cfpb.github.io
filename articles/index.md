---
published: true
layout: page
author:
title: "Article archive"
permalink: /articles/
---

<ul class="nav-list">
{% for post in site.posts %}
    <li class="sidebar_list_item">
        <h3 class="sidebar_list_item_head">
            <a href="../../{{ post.url | remove_first:'/'}}">
                {{ post.title }}
            </a>
        </h3>

        <div class="sidebar_list_item_meta entry_meta">
            {% if post.author %}
            By <span class="author">{{ post.author }}</span> &ndash;
            {% endif %}

            {% if post.date %}
            <time datetime="{{ post.date | date: '%b %d, %Y' }}">
                {{ post.date | date: '%b %d, %Y' }}
            </time>
            {% endif %}
        </div>
    </li>
{% endfor %}
</ul>
