Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54C9486A8D
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 20:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiAFTfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 14:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiAFTfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 14:35:43 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746FAC061245
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 11:35:43 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id bp20so7441411lfb.6
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 11:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FfmDmwqYIGhVMcvUurbBioTiku7PCLSXH4rSDHJzVGo=;
        b=FT5N4+LNApn/FKGqtK6z6SNe8b8FrMZHMrW4dNPsOpPgTvMWqsF1HnFv6G44Fku/4k
         X7Acze2GvMTifnnkE22kPssxwrTT+oL23S0ienQs6XN07jrrszWTnndwl89RDH7gTAS3
         YTUkiPdrhDFbQ1J6yLlkGC3RM8vV6niK5bWr5r8rK96X8JznPoP1FHK61YHYU4gkVCuR
         6/CFKOmVTTtSP1LzeL7EM2MJEitKjyKQm6QaULuHSMaDKuMHqTRndbIVtpIP4H+5c78F
         9EZDf6B+NG77KDkH6a/BOtt1ZGSaa6tW9fZkLahheQS4gNEeLAx3GF0c+ZTt50L1MFO1
         rLwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FfmDmwqYIGhVMcvUurbBioTiku7PCLSXH4rSDHJzVGo=;
        b=ZMjtBTicyEw2FDMS3IDrwAxUqS1AM2SkNIsYDcNC3Ag2o/irXSA+uo2A9XD9U9pwcg
         AV44202x+GL+zpebyzCGwM5D2OAsm6e7QWak+T2pfIdmYUJ7VVDypkLz4poT6Fh5FDvQ
         aU0wou54rA4H7JEz0hS7DEF0y/tLysau4C5nCP/BmoX4atjQjT/XrYs+cuJVipSiS2FJ
         naklRfalYpDZMnwMPaCTm/EpFXFQ4EZKInvPCVbx4BZlAwpOZxsBEj7RYZu2HIKNnu+O
         hfoerHGtYO+Xey0a3FVbQ2cyTqEIUS9PlTPzvLie9GiwfW8TOu1CVyblINUwF7J7Ax8t
         p7Zw==
X-Gm-Message-State: AOAM5333DuOpjRN9eTkFxcABNG1KXvc8foACI7Ns80u18eY2xrhcIrTZ
        yco3MtKmGwd9fYz39eUaUjNOvnEVC65SwYT7hrcPGA==
X-Google-Smtp-Source: ABdhPJwjJziWwZLigmvOQYM2mWQRB8lCxSgVYhTv3dJjM4OmG/EDWZCUKHtGcgffKzPUO0gOZdLt29u0YCu+p4jdvqM=
X-Received: by 2002:a2e:9cc7:: with SMTP id g7mr42869458ljj.128.1641497741456;
 Thu, 06 Jan 2022 11:35:41 -0800 (PST)
MIME-Version: 1.0
References: <CAKwvOdkrNMED1-3QUL4YfhHbA8dnEn+Ws3-uhH6nedG4J1sQBg@mail.gmail.com>
 <Yc2LyGw951rCGsO6@kroah.com>
In-Reply-To: <Yc2LyGw951rCGsO6@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 6 Jan 2022 11:35:32 -0800
Message-ID: <CAKwvOdn5sVJYCJ=WSa9RoKE+u7yPwUHx39C3UybXw-GLaXSO+g@mail.gmail.com>
Subject: Re: AS_IS_LLVM=y v5.10.y patches
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Will Deacon <will@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Bernhard Rosenkraenzer <bero@lindev.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 30, 2021 at 2:37 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 29, 2021 at 01:55:34PM -0800, Nick Desaulniers wrote:
> > Dear Stable Kernel Maintainers,
> > Please consider applying the attached mbox file to v5.10.y.
> >
> > For Android's T release in 2022, I'd like to verify whether clang's
> > integrated assembler was used.
>
> While I can appreciate your quest to make your Android kernel trees
> smaller, this really looks like a "new feature".  What bug/issue is this
> fixing that is currently present in 5.10 that people are hitting today?

Sure, not really a bug, I'll keep these downstream then.
-- 
Thanks,
~Nick Desaulniers
