Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACA024C6BC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgHTU1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgHTU1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:27:46 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AC4C061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 13:27:45 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e4so1478064pjd.0
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 13:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQFE6bWtnK0x+f/S3dNY2Gd6QicBS+t28UD5U6DOMoU=;
        b=Pu0bTstjLW0DfKeYeXrEzT1kRBByjInuEJWai3R3eJ/sDCCmeahqG9LFQmyX+PRGQn
         DOOzxhHlrdqITv0wj9JAKUKvKdBvz8xa3zwRpjYbAcLL3X0n8GuBF7r2jMaYqzBtWo8e
         h65jrx4NAOtyUG2rfFE8twFTLQbZTgP9fhxIJFsQMU5rdYhviwQfu+HbB75FRGrkh0A7
         yrx8sqmWWY8rEOLrPkSFMEMKdjAOxeI704Ec9JpJRV13vNzOfG/cYuf7NPd3qbX69KEb
         c4sKef1RyAriXXEaQCirPCiik7zhuGqDnCpVpphHi6vHNu2KF2ACcgymYyQ1UYwbyv+O
         MiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQFE6bWtnK0x+f/S3dNY2Gd6QicBS+t28UD5U6DOMoU=;
        b=uN57bI/hynuQtxKjsepDtEfZu6iGS3HRvknu5XfGrS/CXXH+yfyAhUsqV0UK9//9M3
         755HUYcMRgHszf7TdF41QGofkd6JHDHlgSot9XaKUoQVKE9i73e+Lc/mtJiJkLgwv845
         AIt6wezqnmCOe0oXmuW7ZJAt0Fm2z60PdlNWK+B1JL0gUeUsWYJ4073TgYx4usCFDnEF
         edjxEFXmVG3pthLAkyJsbtBnXH5Z6WcE4c6XGtEPMvEhjAKyY0V85/j1SNEt3JX4DHov
         OSu/Ye+LQc0NSLykr1Kv4q01uBtWGQ/Yx+D4VAh/9gGA2QJokTZQB8qPJ2oRNERDf8ph
         hapg==
X-Gm-Message-State: AOAM530c7tiyN/3cXN1B5bzXpfJ+9RiIm9f5n3U4jiLsPhWeoxTrx3qM
        89X/ccfc1+g5ROPwYZdlBRt2WfloGfrph69j9T4axg==
X-Google-Smtp-Source: ABdhPJwz1Xuc9Gn2tm11mwmHvSnBZs9KaT8NjuuhaIeOBn1lQSXc4CTUdsw7qZ7FAX9XkTAf6dygD+dpP5YnBDytThU=
X-Received: by 2002:a17:90a:fc98:: with SMTP id ci24mr11045pjb.101.1597955264646;
 Thu, 20 Aug 2020 13:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOd=Ko_UHWF-bYotqjPVw=chW_KMUFuBp_o8uOg0wOyHyWA@mail.gmail.com>
In-Reply-To: <CAKwvOd=Ko_UHWF-bYotqjPVw=chW_KMUFuBp_o8uOg0wOyHyWA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 20 Aug 2020 13:27:32 -0700
Message-ID: <CAKwvOd=ojdFXs1ceoBwSnFBzyP7PW+-AknF0WjgJix60BKdgZQ@mail.gmail.com>
Subject: Re: LLVM=1 patches for 5.4
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Dmitry Golovin <dima@golovin.in>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fangrui Song <maskray@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 1:14 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:

Oh, I almost forgot, here's a picture of my cat who helped me by
trying to lay on my keyboard mid-interactive rebase of this series.
https://photos.app.goo.gl/J7CtBJtHmiuzhSfq7
I asked him nicely to move; he proceeded to bite me, and not comply.

>
> Dear stable kernel maintainers,
> Please consider the attached mbox file, which contains 9 patches which
> cherry pick cleanly onto 5.4:
>
> 1. commit fcf1b6a35c16 ("Documentation/llvm: add documentation on
> building w/ Clang/LLVM")
> 2. commit 0f44fbc162b7 ("Documentation/llvm: fix the name of llvm-size")
> 3. commit 63b903dfebde ("net: wan: wanxl: use allow to pass
> CROSS_COMPILE_M68k for rebuilding firmware")
> 4. commit 734f3719d343 ("net: wan: wanxl: use $(M68KCC) instead of
> $(M68KAS) for rebuilding firmware")
> 5. commit eefb8c124fd9 ("x86/boot: kbuild: allow readelf executable to
> be specified")
> 6. commit 94f7345b7124 ("kbuild: remove PYTHON2 variable")
> 7. commit aa824e0c962b ("kbuild: remove AS variable")
> 8. commit 7e20e47c70f8 ("kbuild: replace AS=clang with LLVM_IAS=1")
> 9. commit a0d1c951ef08 ("kbuild: support LLVM=1 to switch the default
> tools to Clang/LLVM")
>
> This series improves/simplifies building kernels with Clang and LLVM
> utilities; it will help the various CI systems testing kernels built
> with Clang+LLVM utilities (in fact I will be pointing to this, if
> accepted, next week at plumbers with those CI system maintainers), and
> we will make immediate use of it in Android (see also:
> https://android-review.googlesource.com/c/platform/prebuilts/clang/host/linux-x86/+/1405387).
> We can always carry it out of tree in Android, but I think the series
> is fairly tame, and would prefer not to.
>
> I only particularly care about 5+8+9 (eefb8c124fd9, 7e20e47c70f8, and
> a0d1c951ef08), but the rest are required for them to cherry-pick
> cleanly.  I don't mind separating those three out, though they won't
> be clean cherry-picks at that point.  It might be good to have
> Masahiro review the series.  If accepted, I plan to wire up test
> coverage of these immediately in
> https://github.com/ClangBuiltLinux/continuous-integration/issues/300.
>
> Most of the above landed in v5.7-rc1, with 94f7345b7124 landing in
> v5.6-rc1 and eefb8c124fd9 landing in v5.5-rc3.
> --
> Thanks,
> ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
