Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3065225563B
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 10:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgH1ISC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 04:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgH1IR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 04:17:57 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E9AC061264;
        Fri, 28 Aug 2020 01:17:56 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q93so248944pjq.0;
        Fri, 28 Aug 2020 01:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aswj7xwvAIu6nys34emjMluVrPcbKJ+vc/0BaVZH3Ac=;
        b=btByG8dmGaGD9R64d8RAP0/DB4NCszheOGTB5OIMtIoS5178Mv00WsL3rrcwuwsv+F
         c1kj5ZxMXQ6oDJyHtUA4nXrP1VdqRt2UEUcRXjRmwP5r/Ft0rTLnqCY1accq0WzfQpPO
         l5tMMcEMifqneKIJOblG4/UqLioGXhzBlRx78k5iqWmxZQXx2hr3GfXraprcaAh3LTj3
         EUAXdG+098SsKOERIYgVeMo6f1R3z8T1rQsDDn+gNMeqx/1kxZFB8raG78eQv0kDS1FJ
         wcELS2Ij7qGr3Ot6nNn6fM3pB7OZopyr4txhluLc0CCGH8w6lLRVRojZYRQV8SfnzNur
         nUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aswj7xwvAIu6nys34emjMluVrPcbKJ+vc/0BaVZH3Ac=;
        b=K5G2CNasTy/EybnA+U6mRnBYxMFdeEoXsGcwYDamZbFraX1Q0nOoXUjK3Wps3egUkz
         zjm75yCh2OuDeYGHrG0v1NKidUrVlQMKwKcSxFJSg/gtGi1Y23fYzer1SqozLhi5e/qz
         S9asR1O3wwYNLTfELCOIYZR+EiXS/lYsAjXvAaAaapuP72Yc36C5wAsyVVyJnlmND/Ct
         Gzcv18epRyHjUAG1ztOzK9ZYL+tPgZiS1Qx7yU4MSCRmbdYE+EV+XKGuGObSHTKX4zb6
         AVI1kgD/rrjp56+pzkqbV0LT2ikxhiS6sO9KfJBmBKjcebkHuaBaxidmo781oH8oiGwT
         Fghg==
X-Gm-Message-State: AOAM533nguNhBYQUgu9L9V+bNbtbMMKuWp22KWwvrzLxTtbOY8dZsC6p
        vUvGiiumId2mjjrMIg1Dk3SI7iz4HmAy9ppLM3M=
X-Google-Smtp-Source: ABdhPJy//aecMU8sofPsAjeKqSX3B39ovsYSrcHqn+U6ahFsMlF77T31wtOCWQkfLadrl8KX0LFkhwtjOqhyGeubcpg=
X-Received: by 2002:a17:90a:e7cb:: with SMTP id kb11mr229317pjb.181.1598602675912;
 Fri, 28 Aug 2020 01:17:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
 <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
 <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
 <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
 <202008261627.7B2B02A@keescook> <CAHp75VfniSw3AFTyyDk2OoAChGx7S6wF7sZKpJXNHmk97BoRXA@mail.gmail.com>
 <202008271126.2C397BF6D@keescook> <CAHp75VeA6asim81CwxPD7LKc--DEvOWH9fwgQ9Bbb1Xf55OYKw@mail.gmail.com>
 <202008271523.88796F201F@keescook>
In-Reply-To: <202008271523.88796F201F@keescook>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 28 Aug 2020 11:17:39 +0300
Message-ID: <CAHp75VcGOvYOXCaQeux5PQ+tHRYF3W=173s80U=mDE-0zzwTXg@mail.gmail.com>
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
To:     Kees Cook <keescook@chromium.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>, Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 28, 2020 at 1:26 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Aug 27, 2020 at 11:05:42PM +0300, Andy Shevchenko wrote:
> > In general it's better to have a robust API, but what may go wrong
> > with the interface where we have no length of  the buffer passed, but
> > we all know that it's PAGE_SIZE?
> > So, what's wrong with doing something like
> > strcpy(buf, "Yes, we know we won't overflow here\n");
>
> (There's a whole thread[1] about this right now, actually.)
>
> The problem isn't the uses where it's safe (obviously), it's about the
> uses where it is NOT safe. (Or _looks_ safe but isn't.) In order to
> eliminate bug classes, we need remove the APIs that are foot-guns. Even
> if one developer never gets it wrong, others might.
>
> [1] https://lore.kernel.org/lkml/c256eba42a564c01a8e470320475d46f@AcuMS.aculab.com/T/#mac95487d7ae427de03251b49b75dd4de40c2462d

Seems to me that this is a fixation on an abstract problem that never
exists (of course, if a developer has brains to think).

-- 
With Best Regards,
Andy Shevchenko
