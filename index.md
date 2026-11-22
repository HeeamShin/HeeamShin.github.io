---
title: 어느 Technical Writer의 일기장
---

# 어느 Technical Writer의 일기장

좋은 글을 적기 위해서는 많이 적어봐야 된다는 격언을 실천하는 공간입니다.

## 독서 노트

{% assign books = site.pages | where_exp: "p", "p.path contains 'docs/books/'" | sort: "title" %}
<ul>
{% for book in books %}
  <li><a href="{{ book.url | relative_url }}">{{ book.title }}</a></li>
{% endfor %}
</ul>
