Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43176A35DE
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 01:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjB0AQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 19:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjB0AQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 19:16:21 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A2215554
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 16:16:18 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so8401084pjb.1
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 16:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KU2d3krd8jU71w/aSLBfB0ISLKVxkdpbc4h5LL6Vtmw=;
        b=ERQewpNAimW1462AkeZKLB7VV6wMzO/wMbH5YD3De7jb+mHr3Djg39xFNorSxaRB43
         tZa8zUry9QH9rzu5v/ntOXlN+Pq/C1uwGMMtoepAL8l+O5xrXgAqaHxwrH/LWpYbryFX
         gwURbwtw/WPY/pWj5ragqtnuRubYvWTMgWPWdC/d/PZ9PijNHQ2roid1tKOTrAY3biha
         c+b6upfTJQZ57J35mlvCz1QcVFz6OUt27Tj5ewtEvIHLLksF0mC6tWVCa5wmkJyv5/2j
         i4GI5PE5GIvFyirwHnwywBWLxrYYn1JAvlMyucEQCgx+ejPT9DzcmFeeo4n28KRCuvfa
         mVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KU2d3krd8jU71w/aSLBfB0ISLKVxkdpbc4h5LL6Vtmw=;
        b=FXQ3Z+pOdT5RW6PdtgKpfDbAmmj9efEzqsfWhdp0vAWAH0RNFNZR8UyoDYXB8ZODPC
         E8aPIlt0WcDhJ/jfkSA/HVbZpJAswdx5JyLtY379gg4XaOn7AkIhQ3fa2Xyf4wz6mQKc
         HpM331EH9WeKGkkYyMXyhMIpw4rMqPRoH+WR8AyJlWg6wlqMz2hdVI03QADZyB6WrTi4
         ao2ZEUKJCi9lR5ZXG3UlSWcKHlN/sfHvB3U66PiUjR6vDo6IKtzZCwYcNEKKv5+kZZDF
         Ed7dFbL62fwJ9d4SOdVw4oJ76kYe3X3I0d4l1rNd7RAQ6nCILSjcXPApSfx0y7t8tPef
         G6ow==
X-Gm-Message-State: AO0yUKULQbYvCoKcCGVI4PBiltZLHYb03rDHLEJ8qiYj6jxWZf5+f1xz
        0mqexbit98k7GPF3mBYgrg91Y5LEWntqLelVB3s=
X-Google-Smtp-Source: AK7set+zCbQSPTu6bzEHsjty7yBuno/hKAW4gqy7Hq1uXEE1lpEGGIHoc9YAgUzzs4/VENWs+O6VyGsf0CLgRbUPV78=
X-Received: by 2002:a17:903:4285:b0:198:dd3d:59 with SMTP id
 ju5-20020a170903428500b00198dd3d0059mr5351285plb.13.1677456977861; Sun, 26
 Feb 2023 16:16:17 -0800 (PST)
MIME-Version: 1.0
References: <20230224061550.177541-1-pcc@google.com>
In-Reply-To: <20230224061550.177541-1-pcc@google.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Mon, 27 Feb 2023 01:16:06 +0100
Message-ID: <CA+fCnZepwNj2OXqHHeztOuZQ7UGp5i0M=SBkzQpTSnnMGL0dvA@mail.gmail.com>
Subject: Re: [PATCH] Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
To:     Peter Collingbourne <pcc@google.com>
Cc:     catalin.marinas@arm.com, linux-mm@kvack.org,
        kasan-dev@googlegroups.com, ryabinin.a.a@gmail.com,
        linux-arm-kernel@lists.infradead.org, vincenzo.frascino@arm.com,
        will@kernel.org, eugenis@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 24, 2023 at 7:16 AM Peter Collingbourne <pcc@google.com> wrote:
>
> This reverts commit 487a32ec24be819e747af8c2ab0d5c515508086a.
>
> The should_skip_kasan_poison() function reads the PG_skip_kasan_poison
> flag from page->flags. However, this line of code in free_pages_prepare():
>
> page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
>
> clears most of page->flags, including PG_skip_kasan_poison, before calling
> should_skip_kasan_poison(), which meant that it would never return true
> as a result of the page flag being set. Therefore, fix the code to call
> should_skip_kasan_poison() before clearing the flags, as we were doing
> before the reverted patch.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Fixes: 487a32ec24be ("kasan: drop skip_kasan_poison variable in free_pages_prepare")
> Cc: <stable@vger.kernel.org> # 6.1
> Link: https://linux-review.googlesource.com/id/Ic4f13affeebd20548758438bb9ed9ca40e312b79
> ---
>  mm/page_alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ac1fc986af44..7136c36c5d01 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1398,6 +1398,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
>                         unsigned int order, bool check_free, fpi_t fpi_flags)
>  {
>         int bad = 0;
> +       bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
>         bool init = want_init_on_free();
>
>         VM_BUG_ON_PAGE(PageTail(page), page);
> @@ -1470,7 +1471,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
>          * With hardware tag-based KASAN, memory tags must be set before the
>          * page becomes unavailable via debug_pagealloc or arch_free_page.
>          */
> -       if (!should_skip_kasan_poison(page, fpi_flags)) {
> +       if (!skip_kasan_poison) {
>                 kasan_poison_pages(page, order, init);
>
>                 /* Memory is already initialized if KASAN did it internally. */
> --
> 2.39.2.637.g21b0678d19-goog
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thank you for fixing this, Peter!
