Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CED2D69B0
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394023AbgLJVYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394028AbgLJVYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:24:06 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76C4C0613D6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:23:26 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 11so5348571pfu.4
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=6FBEBqC9O9xCIGCxCBvAdo9hn7EHmsB+dt3e8j6643g=;
        b=jF1hXSGSHVgZg+YJC2KFshhFf/ZN7/NoKkPBz9D9Zlui3n2GoMics8NyJO8gpJFrFQ
         4e0Sc5VXRlLhf/08sVGoWiAZ8RgqUSltJOOKBQt3m4RNsJEJ8FGrRTYWZoPkfuQ3/4VQ
         8047hFWwNmi7ugQn7VV73PtUyXNffvlJo1teY+dj7G/qoV4e2Bxz8KEZPEgE8vaJscVh
         1jlbEIKhFo84e2isSUeP8Da5k038FXyfvc9nx8382wQ6AB2+WlK4r+KwJBiiVpLgZATk
         r3EKLYn+NYn7tr80pvoQlgbxDfYkv2/xcCV4VR0EKAWwDzJWGWg2EqKBMg8ys5DZs0tj
         9NTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=6FBEBqC9O9xCIGCxCBvAdo9hn7EHmsB+dt3e8j6643g=;
        b=o1F9V+2VBgYi6qQv9+mQpq8H19AUIMAfJn0h1hVsboLOA3pYPQbSCkFjxA7hfuoFCX
         DHZ1Cp3nKzKU8mgLIcq/UmGniqhr0KOJpcnalO7q2ilUkEgCBZTly/3+gkCNb2sSvkbA
         um0b9i99EQPWqKuuiZlPlWmhQmYQOHDU3iYMJq72VeleNeMG+Yy54m8rhQYnr/LYJole
         HbgvK0qmtacQtKBgwvUoXc0P0q5R5eccrZjjqj86X/mKs82ZTiwoMHJClfilFMJv1OIs
         wCYsymnCVGAQLXpAPDqmm6jQrPb8xYpfwIIaxuROF2QqYK8Jg6Ez5rD+gHo/UF7n6xm+
         XZdA==
X-Gm-Message-State: AOAM5325dSrqHWoL7GByySQdLtXh4FsgtUmKL6MoZ7B/WrSOLpF1yhJ4
        KsklYQvEYZ1kE9ttnMieH6tX/LRu8BNA7rHoph1y3g==
X-Received: by 2002:a17:90b:1957:: with SMTP id nk23mt2904168pjb.32.1607635406232;
 Thu, 10 Dec 2020 13:23:26 -0800 (PST)
MIME-Version: 1.0
References: <160750466017491@kroah.com>
In-Reply-To: <160750466017491@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 10 Dec 2020 13:23:14 -0800
Message-ID: <CAKwvOdn+zxenbh4UVosr=yO6U9Bhwd7CiVGZq9WaE5cXZ7WWTg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] Kbuild: do not emit debug info for
 assembly with LLVM_IAS=1" failed to apply to 5.9-stable tree
Cc:     Dmitry Golovin <dima@golovin.in>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 9, 2020 at 1:03 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Cross referencing the thread where manual backports were provided:
https://lore.kernel.org/stable/CAKwvOdnGDHn+Y+g5AsKvOFiuF7iVAJ8+x53SgWxH9ejqEZwY9w@mail.gmail.com/
Sorry for the noise.

>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From b8a9092330da2030496ff357272f342eb970d51b Mon Sep 17 00:00:00 2001
> From: Nick Desaulniers <ndesaulniers@google.com>
> Date: Mon, 9 Nov 2020 10:35:28 -0800
> Subject: [PATCH] Kbuild: do not emit debug info for assembly with LLVM_IAS=1
>
> Clang's integrated assembler produces the warning for assembly files:
>
> warning: DWARF2 only supports one section per compilation unit
>
> If -Wa,-gdwarf-* is unspecified, then debug info is not emitted for
> assembly sources (it is still emitted for C sources).  This will be
> re-enabled for newer DWARF versions in a follow up patch.
>
> Enables defconfig+CONFIG_DEBUG_INFO to build cleanly with
> LLVM=1 LLVM_IAS=1 for x86_64 and arm64.
>
> Cc: <stable@vger.kernel.org>
> Link: https://github.com/ClangBuiltLinux/linux/issues/716
> Reported-by: Dmitry Golovin <dima@golovin.in>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Suggested-by: Dmitry Golovin <dima@golovin.in>
> Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
> Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Reviewed-by: Fangrui Song <maskray@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> diff --git a/Makefile b/Makefile
> index 87d659d3c8de..ae1592c1f5d6 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -828,7 +828,9 @@ else
>  DEBUG_CFLAGS   += -g
>  endif
>
> +ifneq ($(LLVM_IAS),1)
>  KBUILD_AFLAGS  += -Wa,-gdwarf-2
> +endif
>
>  ifdef CONFIG_DEBUG_INFO_DWARF4
>  DEBUG_CFLAGS   += -gdwarf-4
>


-- 
Thanks,
~Nick Desaulniers
