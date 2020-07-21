Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43372282D1
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 16:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgGUOxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 10:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgGUOxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 10:53:08 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871C0C061794;
        Tue, 21 Jul 2020 07:53:08 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id o3so16603829ilo.12;
        Tue, 21 Jul 2020 07:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=gefT0usPwNpk++e6uaRtXlpKcI6kuzb4kMCCKqrFfP8=;
        b=b4fbwZfv+f+CQ9FRW+4R1nY4ruQn7glFZMb4qq/JTveq+aXeE+zXcMmaJh2Vkk0c/Q
         987BntmeC5ecl+70X0t4cfoLbLO87lOBiRyW5DwwBGFT3lfGPxcH1D9Fs1qMr23BCdb/
         gSsZKQg77hQblYcYrDIMkSZF4RIZFIpVvbmCFGed9/MhnIIJHmEInyDHfVb8h52g257g
         NcR29IgeofNpWEhP8+qwGfmQ46cV1A46cQM3D1aiWAN6MTNpRMxdBzTkma5XQJmULqgU
         Tc4niZ+Ws6OiBLSS3M9kMmodmp8lyctXD/71ScwWam4HX4ereBTpCfG2qyZailXTOG9P
         S1Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=gefT0usPwNpk++e6uaRtXlpKcI6kuzb4kMCCKqrFfP8=;
        b=MyXPT9VZADq5xpnqEAJD5W94dMmisRcovpzoP2woMkXHuWc4CyD6LWQU2KouywHNl/
         /mLpSP3x4W/JEkDv2vRPSEOHrzZRaV7/7XoboMzDDPjpz9TAtbBr7SW8XWIOnupKfRy4
         6hXJmXQB+XKFKB9hp4BgDs1H2U8aGl84eKXlAq5+dgzuNh8OPbQ0xSVGo5we12kdglM2
         5TsMqO3ETc2jJ7SLk/TLPkYX5g8EF1fKfk1GH01DbeycXaBqxGCddeGDFaYMl6kcde+q
         R9DteryPJBTF709X8cArsufT8eA+ggSPumSSw+b4wHa+roIVogCcorDmRsIQvX/5llX2
         /+XQ==
X-Gm-Message-State: AOAM5318r2OUGSnpTOqnr8hTckU1blhTpSOK4y1Moel79v5DZGWxeiCb
        Oyj5yHZ9iKfaCfv0yT+WmeR1duwM+Ua6p0GJEsQ=
X-Google-Smtp-Source: ABdhPJw31yfOcTIu5NemOQg+BEwWwEa2rR/37X3QOEqy0M15pG5KgWNiEKxHOFs2dwz+hEByGN7QRUBYHSL246GMMt0=
X-Received: by 2002:a92:dc09:: with SMTP id t9mr29451057iln.226.1595343187823;
 Tue, 21 Jul 2020 07:53:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200721041940.4029552-1-maskray@google.com> <20200721104035.GC1676612@kroah.com>
In-Reply-To: <20200721104035.GC1676612@kroah.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 21 Jul 2020 16:52:56 +0200
Message-ID: <CA+icZUW9JhZEEcXfL5bid7+M-Qtw22XzSm2x-JxW1bU15HJ6sA@mail.gmail.com>
Subject: Re: [PATCH v2] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Fangrui Song <maskray@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org, Jian Cai <jiancai@google.com>,
        Bill Wendling <morbo@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 12:40 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jul 20, 2020 at 09:19:38PM -0700, Fangrui Song wrote:
> > When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
> > $(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
> > GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
> > /usr/bin/ and Clang as of 11 will search for both
> > $(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.
> >
> > GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
> > $(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
> > $(prefix)aarch64-linux-gnu/$needle rarely contains executables.
> >
> > To better model how GCC's -B/--prefix takes in effect in practice, newer
> > Clang (since
> > https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
> > only searches for $(prefix)$needle. Currently it will find /usr/bin/as
> > instead of /usr/bin/aarch64-linux-gnu-as.
> >
> > Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
> > (/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
> > appropriate cross compiling GNU as (when -no-integrated-as is in
> > effect).
> >
> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > Signed-off-by: Fangrui Song <maskray@google.com>
> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1099
> > ---
> > Changes in v2:
> > * Updated description to add tags and the llvm-project commit link.
> > * Fixed a typo.
>
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>
>

Hi Fangrui,

your patch needs to be accepted first in Linus tree - among other
things to have a unique commit-id for inclusion into any affected
Linux-stable trees.

Regards,
- Sedat -
