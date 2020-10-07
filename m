Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3708928663E
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 19:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgJGRv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 13:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgJGRv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 13:51:57 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E91C0613D2
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 10:51:56 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id qp15so4252947ejb.3
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 10:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FPzK5wBGWXJ9ijQIa+MDEBmpqmiIgIO3bGZX4u/BEvA=;
        b=nJPlU34scXnjiguAFIm85t6n6hLkeHlGL7e06cFqc/xH6ug3oqr+c8thc4+lGHQ5fx
         lKeD7w/D2ioAqMwoDiwBD6S4hyshsY7Twe954sIGgO+/iQ0Mi/yPzn2W4I5yqilFTvtK
         v9c+EwouCRUoiD+AZDe+4a3vKd1upWDLYjNF/fAW6OpsCdzuxZHuiXYAcdXLN9wLKiGW
         CtnwYPgmru3RPJjTBUtiUqhEAteIsddfm3Bo5/m/f3kTOoxnPIhg9+f655c+DlQJctrk
         Te6UIWNqPBU/Lkg3oAYqY7CnP3BgTBbc1fXBLLvERFPXRemYRj95PRMVSvby7tJuuAzE
         Jqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FPzK5wBGWXJ9ijQIa+MDEBmpqmiIgIO3bGZX4u/BEvA=;
        b=Mwqvqy6c6pNtB4l3xT0xx/YBK2vxKx2T9otVzO20G4zqfFXEtXHrbl6lTvbI/XKV0x
         S53+gA8WDPhrYIb+kixGqulCvwzlW7ohciB8Lgcgmfsz//vWYaxTD0dwQu5dugF/pQDE
         4wnQP+JQmpbOR0WHuX2hZpz4Q9/MpoWeD/wKqpnbxEKYOnaoTdqIHLhZwKOdtVEZ5fW1
         mOgLxY5wUQ8+7orQb4tfQMF4cw3ygcWIyTtBHdCgzwtuy3hozQHw2Xl4OXI+I/YuiKGw
         WMNj2/+/Y2dtT/rRCv2B8zpFX3FqXOdf/ukVhD3Az87/w6Y52THzkyEGzBGNmN9qAw7J
         fQGA==
X-Gm-Message-State: AOAM531/kNwE0DkP+ClIGYfRUBbPWhq5m1FmGBiY5U3CJdoCjkwv/OUe
        YGa1EDvRYaHzvGl8YYHgwhnWWRPYm6wzuGqaNZYEXw==
X-Google-Smtp-Source: ABdhPJwXVJmp1Qp9M+2Fs5BW+I60lTtmt2Do0xLP53x9QM8x+a2tn+YyAAHGWKgvuYFp3ZpcVKtis4+aGvbyHP17gYk=
X-Received: by 2002:a17:906:4306:: with SMTP id j6mr4716173ejm.523.1602093115565;
 Wed, 07 Oct 2020 10:51:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <160197822988.7002.13716982099938468868.tip-bot2@tip-bot2>
 <20201007111447.GA23257@zn.tnic> <20201007164536.GJ5607@zn.tnic>
In-Reply-To: <20201007164536.GJ5607@zn.tnic>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 7 Oct 2020 10:51:42 -0700
Message-ID: <CAPcyv4hYEbFxtRYD+nPOhbLEPTHs3JVDAtWr8Y+-hfdwPY1v1w@mail.gmail.com>
Subject: Re: [tip: ras/core] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-tip-commits@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        stable <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ add kbuild robot so they can add this check to their reports ]

On Wed, Oct 7, 2020 at 9:47 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Oct 07, 2020 at 01:14:47PM +0200, Borislav Petkov wrote:
> > On Tue, Oct 06, 2020 at 09:57:09AM -0000, tip-bot2 for Dan Williams wrote:
> > > +   /* Copy successful. Return zero */
> > > +.L_done_memcpy_trap:
> > > +   xorl %eax, %eax
> > > +.L_done:
> > > +   ret
> > > +SYM_FUNC_END(copy_mc_fragile)
> > > +EXPORT_SYMBOL_GPL(copy_mc_fragile)
> >
> > That export together with CONFIG_MODVERSIONS causes
> >
> > WARNING: modpost: EXPORT symbol "copy_mc_fragile" [vmlinux] version generation failed, symbol will not be versioned.
> >
> > here.
> >
> > I don't see why tho...
>
> It doesn't look like it is toolchain-specific and in both cases,
> copy_mc_fragile's checksum is 0.
>
> SUSE Leap 15.1:
>
> Name           : binutils
> Version        : 2.32-lp151.3.6.1
>
> $ grep -E "(copy_mc_fragile|copy_user_generic_unrolled)" Module.symvers
> 0x00000000      copy_mc_fragile vmlinux EXPORT_SYMBOL_GPL
> 0xecdcabd2      copy_user_generic_unrolled      vmlinux EXPORT_SYMBOL
>
> debian testing:
>
> Package: binutils
> Version: 2.35-2
>
> $ grep -E "(copy_mc_fragile|copy_user_generic_unrolled)" Module.symvers
> 0x00000000      copy_mc_fragile vmlinux EXPORT_SYMBOL_GPL
> 0xecdcabd2      copy_user_generic_unrolled      vmlinux EXPORT_SYMBOL

Yes, I'm seeing this too on Fedora, I'll take a look.
