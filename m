Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1A125845E
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 01:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgHaXVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 19:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgHaXVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 19:21:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D75C061575
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 16:21:30 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b124so1557037pfg.13
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 16:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mt+GWnZGCielYLw6Usto6nHCeUaR+Vbl+GzxV4IYrLk=;
        b=B+QR2Q9cNnqcDRd3ngHkguNsK27Aa8urnh/UgCCWG8gbHKUSwKIokxbL+3hi8yN7Kd
         T1JbrTzXDmYjuSfrTuT3BYyCEhd5pF7gftMQG6lGuGE1Gj0RrAQnfokKfVxU8eR2DTu3
         s2P7q6tKx1fTcZvC80nAKKXLaqqwl6Ukwja1hG+8ofsYoHxnlV7YkKN31e31drFqgdKq
         hFevBrVF6ohLFSt5tZglIe5GWptVIriFaGc3AYPfNEApI8yNGe7wx/0ZADn+oMJgesmS
         zYAI5SIjV+bk9R3kBoQGd2u7QS5684jSKycZtRO4fBCRBFqq0pXouX6QDIVa+nLF8eai
         DHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mt+GWnZGCielYLw6Usto6nHCeUaR+Vbl+GzxV4IYrLk=;
        b=rF/lmquLkTkGf0tRg5bYvNQTba1OuCjmSgptojcpMqn+ou0B+jf/mQdgVYTSwGYHFJ
         zD1rc3qc40HcZ33BcZY3qd8/0QBTAeHhx9r8LOlPih2aEbkBTDMYoHljfAnyF6cyh0p7
         tjm8FeJS4i2xXLIBkyyuR36eyHaWIn5HnPofg8KXtUUcUBoo6sHfwUoHMFOj8vGjQS2E
         i83+gAx1Y1VUOadOPqgm2NhNf+MQvZPmBCt5wbL9ivpGVqxl/6jDo8uug0UnAuOjLdGr
         G1KKMCh8to+LC01aZVmAhbEcJp0+s/RExUG1UY/23oWK2typV5MEeDw11/5aMAeCq3C1
         6I9g==
X-Gm-Message-State: AOAM532EaCsF+LcnSIWaUurCfa55elKrhM8x4ukAerH6Qzur84sCFjKd
        7vMZjttKi+xTEpBYlEIDoNP2hSu+AF98UDhLdgIUDw==
X-Google-Smtp-Source: ABdhPJz8aRK4esNS5HoyMDSHQY1SD7cQDVjktOAPDdAsbZnHl2mZesvczgElpZv6AP6aZwg1tbSh4BX8xyMrnqeM908=
X-Received: by 2002:a63:31d2:: with SMTP id x201mr3173789pgx.263.1598916089341;
 Mon, 31 Aug 2020 16:21:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
 <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
 <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
 <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
 <202008261627.7B2B02A@keescook> <CAHp75VfniSw3AFTyyDk2OoAChGx7S6wF7sZKpJXNHmk97BoRXA@mail.gmail.com>
 <202008271126.2C397BF6D@keescook> <CAHp75VeA6asim81CwxPD7LKc--DEvOWH9fwgQ9Bbb1Xf55OYKw@mail.gmail.com>
 <202008271523.88796F201F@keescook> <CAHp75VcGOvYOXCaQeux5PQ+tHRYF3W=173s80U=mDE-0zzwTXg@mail.gmail.com>
In-Reply-To: <CAHp75VcGOvYOXCaQeux5PQ+tHRYF3W=173s80U=mDE-0zzwTXg@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 31 Aug 2020 16:21:17 -0700
Message-ID: <CAKwvOdnV6GySbhKGVEUBV5GdanR9xRWAFE0JPcpORR=2dmRWPg@mail.gmail.com>
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kees Cook <keescook@chromium.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
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

On Thu, Aug 27, 2020 at 1:59 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> strcpy() is not a bad API for the cases when you know what you are
> doing. A problem that most of the developers do not know what they are
> doing.
> No need to split everything to bad and good by its name or semantics,
> each API has its own pros and cons and programmers must use their
> brains.

On Fri, Aug 28, 2020 at 1:17 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> Seems to me that this is a fixation on an abstract problem that never
> exists (of course, if a developer has brains to think).

Of course, no "True Scotsman" would accidentally misuse C string.h API!
https://yourlogicalfallacyis.com/no-true-scotsman

(I will note the irony of my off by one in my v1 implementation of
stpcpy. I've also missed strncpy zeroing the rest of a destination
buffer before.  I might not be a "True Scotsman.")

On Thu, Aug 27, 2020 at 11:30 AM Kees Cook <keescook@chromium.org> wrote:
>
> I equate "unsafe" or "fragile" with "bad". There's no reason to use our
> brains for remembering what's safe or not when we can just remove unsafe
> things from the available APIs, and/or lean on the compiler to help
> (e.g. CONFIG_FORTIFY_SOURCE).

Having seatbelts is great (ie. fortify source), but is no substitute
for driving carefully (having proper APIs that help me not shoot my
foot off).  I think it's nice to have *both*, but if I drove solely
relying on my seatbelts, we might all be in trouble.  Not disagreeing
with you, Kees.
-- 
Thanks,
~Nick Desaulniers
