Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22D14578D0
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 23:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhKSWda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 17:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbhKSWd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 17:33:29 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E4EC06173E
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 14:30:27 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id t26so49466213lfk.9
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 14:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gb6DJ5DQJ8d8n/pzGXXmbwQTl8pHSuAAtPMhI2ncwL4=;
        b=Hgml2IugRLSk+dAVCRLMQCrykgMbgDpd3VP1x0lAQpTwmYfxxlqxu+79jHjq/WB6TY
         tPwF8FPSdowAEQFfJDvyJq61vlSzQUOBYyxcpAnsm4XUkfwnM7i5BKtYrZ8LrZNU88Sj
         8th2/LbXQEKHJYp0TfWS/kPp4/aTH3jOcFl80r9E4XZyaRqHly1iimKguZGLb1J+1/XW
         JFxVmL9VAkBqWKuPYjnPmP62FKZZkYNtEciCTve5a0siodV+ZNeuwD9H6uvGS0EAxK61
         iJ+3hMy2lO5kaceP4agXsO2oKoWQBGK5FrKtAOdVeyWZRPy113cjJ8V9HTmvfeCuc6Sw
         8L1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gb6DJ5DQJ8d8n/pzGXXmbwQTl8pHSuAAtPMhI2ncwL4=;
        b=inPeryrgyYqM3O29LsUljCGm4L7JHSy6EJ1xDuzT5qk/v5UhqGNaM074BxhjLN6PXR
         n3GZDA142NhotSpbRizrVE/4XH2uSc/NlFaMBDXdeqD5tb5MN/YOSc84H2Ha/Odbun9e
         RHV81xA1vtldKHTWNykfc9v/GFk0vDAfJGd5c7rPBl/2kLeSlvUupVs5VKZHrPo/4k+L
         0Cfy29D1XPN8iaIF87TxBxKjyDfXNI00kqLsogj26CkrWca0z/Xkrxh+v21fJ2OzYUh1
         fXRshe3zy4G0H+1kyr4OJ7Y22aOJ9PQpvElxC9jOo/f1DlXDyF2GYKk4z0Vp16hkgg+Y
         OQLw==
X-Gm-Message-State: AOAM530VgkkeUqT2yfRlUorNpgVbWZ9INbjWFmDztX2KruBjv3PUlMAI
        TZJA/CxAFIFtCa2SnRNtiazMhu0D00FOe788nC6pAw==
X-Google-Smtp-Source: ABdhPJxsTRG9T5xPG7viwUpKNna/wqOSpxwg9/Ci7jmaVEF8uQRUQkffK18TtZFmDsdpyxdZOiSKWj1XVD4ChuJZw+Q=
X-Received: by 2002:a2e:b6ce:: with SMTP id m14mr29600483ljo.128.1637361025473;
 Fri, 19 Nov 2021 14:30:25 -0800 (PST)
MIME-Version: 1.0
References: <20211119171443.892729043@linuxfoundation.org> <20211119171444.250202515@linuxfoundation.org>
 <20211119214713.GB23353@amd> <CAKwvOdnxTRuMDDnriD5y26uWeUD8eoTH=6wrcFWvQZj8qOt2yA@mail.gmail.com>
In-Reply-To: <CAKwvOdnxTRuMDDnriD5y26uWeUD8eoTH=6wrcFWvQZj8qOt2yA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 19 Nov 2021 14:30:14 -0800
Message-ID: <CAKwvOdkFAiDN_tnDUH+tDdEoUfpiXQFN2qN-bT=RGAbbcFGpMA@mail.gmail.com>
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

On Fri, Nov 19, 2021 at 2:24 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Fri, Nov 19, 2021 at 1:47 PM Pavel Machek <pavel@denx.de> wrote:
> >
> > Hi!
> >
> > > commit 14831fad73f5ac30ac61760487d95a538e6ab3cb upstream.
> > >
> > > When running the following command without arm-linux-gnueabi-gcc in
> > > one's $PATH, the following warning is observed:
> > >
> > > $ ARCH=arm64 CROSS_COMPILE_COMPAT=arm-linux-gnueabi- make -j72 LLVM=1 mrproper
> > > make[1]: arm-linux-gnueabi-gcc: No such file or directory
> > >
> > > This is because KCONFIG is not run for mrproper, so CONFIG_CC_IS_CLANG
> > > is not set, and we end up eagerly evaluating various variables that try
> > > to invoke CC_COMPAT.
> >
> > Upstream commit is fine, but 5.10 port misses the 2> part of the
> > change.
>
> You're right; thanks for the report. Greg, can you drop this version
> of the backport for 5.10 and 5.4? I'll resubmit an updated version.

V2 sent:
https://lore.kernel.org/stable/CAKwvOdkZ1ydLs2VwvVLtT7QK+e1gNB0ZE5RqTxMY15QQvhxZ1w@mail.gmail.com/

>
> >
> > > +++ b/arch/arm64/kernel/vdso32/Makefile
> > > @@ -48,7 +48,8 @@ cc32-as-instr = $(call try-run,\
> > >  # As a result we set our own flags here.
> > >
> > >  # KBUILD_CPPFLAGS and NOSTDINC_FLAGS from top-level Makefile
> > > -VDSO_CPPFLAGS := -D__KERNEL__ -nostdinc -isystem $(shell $(CC_COMPAT) -print-file-name=include)
> > > +VDSO_CPPFLAGS := -D__KERNEL__ -nostdinc
> > > +VDSO_CPPFLAGS += -isystem $(shell $(CC_COMPAT) -print-file-name=include)
> > >  VDSO_CPPFLAGS += $(LINUXINCLUDE)
> > >
> > >  # Common C and assembly flags
> > >
> >
> > Best regards,
> >                                                                 Pavel
> > --
> > DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> > HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
>
>
>
> --
> Thanks,
> ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
