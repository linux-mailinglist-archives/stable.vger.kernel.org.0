Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D464578A0
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 23:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbhKSW10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 17:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235728AbhKSW10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 17:27:26 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932A2C061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 14:24:23 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id l22so49372007lfg.7
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 14:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NdJEe0Hof8919DyD2sTLLKuQGBB4CBJGUYCLgg1/XqM=;
        b=l5GagTo3atJwGhB9B4SPrshfrE49WEXtB2QfuGl8xql46cf4XGfYrCUQhp188PpRHq
         715ZUKSIqrQ6fUIProooRcG504jNLNytJm8R6ScxY5WQRUDBCMgLAbgvQaxOF4SeUgkT
         p+9WpJA/bgCIvuqoSgBH6GYsRjujb22kDMSGrEYBAkyC9HstJojxtE0Yr2gQ+Pr5eNVo
         63UdaDH628JpnKgk2hr7wg4QsFAK4u47INY5nHnqr6803kpB/KqrGO+uRhn73PdgGaMt
         DcNe8pBHQSSeSDKP6fIluM8C0BB2YY1RR00G29jOzHlIGINCnr9PqJXrQqcBuBnsE/lO
         Hh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NdJEe0Hof8919DyD2sTLLKuQGBB4CBJGUYCLgg1/XqM=;
        b=3By9easjNuSSRv19QdG9mvcqElAl/2/cy1Uv+GqzjCcPSftscMJqNyENU85+bHVU7X
         CMuS5cwNUX2Xt2lgLkmh1/FXp6uF4X4RiPeZ58vn46b0wP1hmx2sXYKHkcvkQkKwcajC
         5APv4mVon3dZBBoRjRFavKEyDW8U/j5Fen+6RU9BPPhbx2KE5LGaxdhUbOq+gYHco/jj
         vH6IgzZAJXWwTE3KNxHBhshMgCWJTwA/bi78V2MtS7bVuEV6VT3XmsdJarGs2DPbmZw4
         p/f2Pa6AW6TMGZipBMCDkBfiLMP3LxnRBVD8PQII1FI+OluJ5U7i5mKHgdpcLZH/Y3/V
         vbgg==
X-Gm-Message-State: AOAM531i+UVFhlBOJmObhR7Ffr+MDOmL8kdne7Bhpdg97vBdpTGytC2m
        3oCoNhuwEXGnUKcTxIy/dCxthuDG0tT/65122IsSWA==
X-Google-Smtp-Source: ABdhPJzJ7uzc5do/XXU1O2EORT7+FjGhiGysNQf/zvyCJBySDujWxibpQada+RexzeOrlTxa50cNm4sTyu4YTf9hzCs=
X-Received: by 2002:a2e:b6ce:: with SMTP id m14mr29564074ljo.128.1637360661680;
 Fri, 19 Nov 2021 14:24:21 -0800 (PST)
MIME-Version: 1.0
References: <20211119171443.892729043@linuxfoundation.org> <20211119171444.250202515@linuxfoundation.org>
 <20211119214713.GB23353@amd>
In-Reply-To: <20211119214713.GB23353@amd>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 19 Nov 2021 14:24:09 -0800
Message-ID: <CAKwvOdnxTRuMDDnriD5y26uWeUD8eoTH=6wrcFWvQZj8qOt2yA@mail.gmail.com>
Subject: Re: [PATCH 5.10 11/21] arm64: vdso32: suppress error message for make mrproper
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lucas Henneman <henneman@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 1:47 PM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > commit 14831fad73f5ac30ac61760487d95a538e6ab3cb upstream.
> >
> > When running the following command without arm-linux-gnueabi-gcc in
> > one's $PATH, the following warning is observed:
> >
> > $ ARCH=arm64 CROSS_COMPILE_COMPAT=arm-linux-gnueabi- make -j72 LLVM=1 mrproper
> > make[1]: arm-linux-gnueabi-gcc: No such file or directory
> >
> > This is because KCONFIG is not run for mrproper, so CONFIG_CC_IS_CLANG
> > is not set, and we end up eagerly evaluating various variables that try
> > to invoke CC_COMPAT.
>
> Upstream commit is fine, but 5.10 port misses the 2> part of the
> change.

You're right; thanks for the report. Greg, can you drop this version
of the backport for 5.10 and 5.4? I'll resubmit an updated version.

>
> > +++ b/arch/arm64/kernel/vdso32/Makefile
> > @@ -48,7 +48,8 @@ cc32-as-instr = $(call try-run,\
> >  # As a result we set our own flags here.
> >
> >  # KBUILD_CPPFLAGS and NOSTDINC_FLAGS from top-level Makefile
> > -VDSO_CPPFLAGS := -D__KERNEL__ -nostdinc -isystem $(shell $(CC_COMPAT) -print-file-name=include)
> > +VDSO_CPPFLAGS := -D__KERNEL__ -nostdinc
> > +VDSO_CPPFLAGS += -isystem $(shell $(CC_COMPAT) -print-file-name=include)
> >  VDSO_CPPFLAGS += $(LINUXINCLUDE)
> >
> >  # Common C and assembly flags
> >
>
> Best regards,
>                                                                 Pavel
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany



-- 
Thanks,
~Nick Desaulniers
