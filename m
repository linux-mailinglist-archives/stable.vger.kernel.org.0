Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F806342BDA
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhCTLOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231308AbhCTLNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:13:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 510A061A5E;
        Sat, 20 Mar 2021 11:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616238276;
        bh=X9SdFkAclfqwkAS8jJ3bUUF/yF3kvCkknoYL/W6KzkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NamoRo/+zUVafWqH1CyZzs+rlBOoZXhofkb582TD8RWq+vqN27Hh6MmhOomXMzYzO
         uQh38DucBlf3JOtwj00oJNQXY4GA6RmJTg/CoR5fWnSgH341bL57rb5hK+7fndVace
         wZgr8bt7uB31odhWocZlFWkKQsOFIt4y1Hkihyu8=
Date:   Sat, 20 Mar 2021 12:04:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 5.4 2/2] ARM: 9044/1: vfp: use undef hook for VFP support
 detection
Message-ID: <YFXWwlmJ4xV3bF5B@kroah.com>
References: <CAMj1kXGT8Zgz3Pn+DDJnY6HRz3ugbkFozJycGBW+Cm6RvyYBHA@mail.gmail.com>
 <20210316165918.1794549-1-ndesaulniers@google.com>
 <YFR3jWxAdb7gJ1Cu@kroah.com>
 <CAKwvOdmb04CD0msrieHj6zj5NjsZ4E90V5sjuXHnt=XwN68uQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmb04CD0msrieHj6zj5NjsZ4E90V5sjuXHnt=XwN68uQw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 01:14:12PM -0700, Nick Desaulniers wrote:
> On Fri, Mar 19, 2021 at 3:06 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Mar 16, 2021 at 09:59:18AM -0700, Nick Desaulniers wrote:
> > > If it's preferrable to send an .mbox file or a series with cover letter,
> > > I'm happy to resend it as such, just let me know.
> >
> > Please resend it that way, makes it easier to figure out what is going
> > on here...
> 
> Dear stable kernel maintainers,
> Please consider applying the following mbox file to linux-5.4.y.  It
> contains 2 cherry-picks of `Fixes:` for a patch in 5.4.
> 
> Ard reported linux-5.4.y with CONFIG_THUMB2_KERNEL=y was broken without these in
> https://lore.kernel.org/stable/CAMj1kXGLrVXZPAoxTtMueB9toeoktuKza-mRpd4vZ0SLN6bSSQ@mail.gmail.com/.
> 
> The mbox contains:
> commit f77ac2e378be ("ARM: 9030/1: entry: omit FP emulation for UND
> exceptions taken in kernel mode")
> commit 3cce9d44321e ("ARM: 9044/1: vfp: use undef hook for VFP support
> detection")
> 
> They first landed in v5.11-rc1.  The first is a fixup for:
> commit eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input sections")
> 
> which exists in 5.4.90 as 87ea51c90280.
> 
> The first has a conflict in arch/arm/vfp/vfphw.S due to missing
> commit 2cbd1cc3dcd3 ("ARM: 8991/1: use VFP assembler mnemonics if available")]
> in 5.4.  2cbd1cc3dcd3 causes breakage in ARCH=axm55xx_defconfig
> previously reported:
> https://lore.kernel.org/stable/be846d89-ab5a-f02a-c05e-1cd40acc5baa@roeck-us.net/
> and will need to be reworked if we ever do backport it.

Now queued up, thanks.

greg k-h
