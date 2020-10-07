Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DD12867C7
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 20:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgJGSx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 14:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbgJGSx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 14:53:28 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8E2C0613D2
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 11:53:28 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id md26so4458170ejb.10
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 11:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rdre9jrmRp+/9/Y6RnzGhKU8N5YkFWVxUCgScft3zmU=;
        b=OFMCe2fA7ENUSEpSD1GFyoJSxPtUoTVyvWQ0nTA6wRiRt3SeCvMFuQ4bQDkdqLvM/7
         /4/nQ7dvOnsthrJcz2BG09maCJRRIa5jdEe9z525GK+fBvhK5hoj+nY4WiqXn/+83XDh
         S1DVmBDjd9f3ZJU+WCAmMSwUQKH5R7gZLwd0KA+PNuih6PquuL2Ls5p5Cm2oRCwrTKVb
         gE//eAYWWZWyOQ2AUskNBJ2OZS/7EWasnYJSqWZCGBpRxgRegLepOnSxQGG0NnrrjdRF
         A9Ig8OW1Jz0RU6RtM10weytdPGoUgw+vqeM8WxFQLNtnef/z4F/K2lWeKD/tuNez14nM
         kYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rdre9jrmRp+/9/Y6RnzGhKU8N5YkFWVxUCgScft3zmU=;
        b=I7XOffynSmCdBVs40sWLng06x7axpHiUwlptPt+VtvwxDPXtv2fPNt9yeCSov2PP97
         Cn3fhhNHfgxEnamU5Nde0icX4u7/N8CWytFEsF8eSpmWdhYslOXY/o4Lu3WWkHRw6Jok
         zzxMoWmHDCQdS3TWVi7fbSx6dKboRehiababnkiAovBqggElzPsw3V0VhpTfLWk+0yIK
         kmXkdaKUrepVmX4z7TvCJirtLbPqCeCeeBy+Xz1xE1/Vhh99F0rm2HG1IM5HInv9iaUy
         zDMmx4dR0j4ErX+nZsFxPFINzV4XnBoNF5tcBxdEfPqlVFFJQCQA2Y90FB5V6im4nFZo
         es7Q==
X-Gm-Message-State: AOAM531GBUmVHCgUup8zsL3xG51Mufv7nCV5FU47OH+/ZLRHkNEcj/KX
        qNHyzTAP3hk/tV6vKY44VYfu1gadoCKPnWtdS9QCIA==
X-Google-Smtp-Source: ABdhPJwTY40tXBoCGJvpR0HSEuM3/x/Oubwtv2I1I6/MuM6iQLQYOQ6MDqfOLpfRHPqQEuX+JWoAr7Ap/AtWi0NxOJA=
X-Received: by 2002:a17:906:7e47:: with SMTP id z7mr4723987ejr.418.1602096807136;
 Wed, 07 Oct 2020 11:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <160197822988.7002.13716982099938468868.tip-bot2@tip-bot2>
 <20201007111447.GA23257@zn.tnic> <20201007164536.GJ5607@zn.tnic> <20201007170305.GK5607@zn.tnic>
In-Reply-To: <20201007170305.GK5607@zn.tnic>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 7 Oct 2020 11:53:15 -0700
Message-ID: <CAPcyv4jgLRzDzXkbdHwA-XUwWuSoA1tZfVqgvFQ5jxq=m2P_Bg@mail.gmail.com>
Subject: Re: [tip: ras/core] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-tip-commits@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        stable <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 7, 2020 at 11:47 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Oct 07, 2020 at 06:45:36PM +0200, Borislav Petkov wrote:
> > It doesn't look like it is toolchain-specific and in both cases,
> > copy_mc_fragile's checksum is 0.
> >
> > SUSE Leap 15.1:
> >
> > Name           : binutils
> > Version        : 2.32-lp151.3.6.1
> >
> > $ grep -E "(copy_mc_fragile|copy_user_generic_unrolled)" Module.symvers
> > 0x00000000      copy_mc_fragile vmlinux EXPORT_SYMBOL_GPL
> > 0xecdcabd2      copy_user_generic_unrolled      vmlinux EXPORT_SYMBOL
> >
> > debian testing:
> >
> > Package: binutils
> > Version: 2.35-2
> >
> > $ grep -E "(copy_mc_fragile|copy_user_generic_unrolled)" Module.symvers
> > 0x00000000      copy_mc_fragile vmlinux EXPORT_SYMBOL_GPL
> > 0xecdcabd2      copy_user_generic_unrolled      vmlinux EXPORT_SYMBOL
>
> Ok, I think I have it:
>
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Wed, 7 Oct 2020 18:55:35 +0200
> Subject: [PATCH] x86/mce: Allow for copy_mc_fragile symbol checksum to be generated
>
> Add asm/mce.h to asm/asm-prototypes.h so that that asm symbol's checksum
> can be generated in order to support CONFIG_MODVERSIONS with it and fix:
>
>   WARNING: modpost: EXPORT symbol "copy_mc_fragile" [vmlinux] version \
>           generation failed, symbol will not be versioned.
>
> For reference see:
>
>   4efca4ed05cb ("kbuild: modversions for EXPORT_SYMBOL() for asm")
>   334bb7738764 ("x86/kbuild: enable modversions for symbols exported from asm")

Oh nice! I just sent a patch [1] to fix this up as well, but mine goes
after minimizing when it is exported, I think perhaps both are needed.

http://lore.kernel.org/r/160209507277.2768223.9933672492157583642.stgit@dwillia2-desk3.amr.corp.intel.com
