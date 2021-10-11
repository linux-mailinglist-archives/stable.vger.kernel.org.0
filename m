Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC48428CE3
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 14:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhJKMTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 08:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236521AbhJKMTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 08:19:35 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00C3C061745
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 05:17:34 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z5so38596106ybj.2
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 05:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uQcC4EVCneQ86gX61CREu6J2s2hk7KYmPE9oUIPxBiE=;
        b=d7WJeQ6yfe5T9Wla0V6Dzcj+KY/PoE2WnbB4ILoxG1dQCNvs5iH5lJGp9xZEB5Jva4
         xVzOW14EFwiahaci/9kKoBY41FqlUEmfgoXrSthzslXSZ9gekmaaDl79lOXYVa6CbiWN
         vKPr0uQwFjM8a6L/8NYNfKWZQp154t5C+uyHgpJR8gSrnMHachvFlKkYgAuDNijtHTYY
         F1uQrX1LXYEXeD2Qh4dVTB6O7B9MJJ81dUiUrGUTDOEXh1IG1bzw9ZMo85RJbmcAdrzi
         A6P/ACiTFCiu6IusCxAmUX4lWBs8aYTBmNwz094YecWctacXPoU3wX0Un2RbMIJwAu1e
         fWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uQcC4EVCneQ86gX61CREu6J2s2hk7KYmPE9oUIPxBiE=;
        b=FBmo0+2CDkmJXsm8pf+JTSzobBoHS4EmXUs7up9OvptUfcM+bBSNDjL2rJm8KImgGT
         FvROvmjFOwVV3Wb/rCYyr+se5OBiynu/eeyVoH3dCL0FTzTuLllG2j/NJ5pXDsvNEurj
         W3lV9CIp4s9KL4vak8epBaFbm/mxluP+M/kvBsGj8yluMOPVjqLXZMJjP/7/ev3uiTec
         ds2tFjllEK4KmG3oqTUMyXudc+8xWRNGzKZU91lsttDTO2HchYfOxATb9nDsMypa31p3
         kdZviTT5RKMF4P3kJ+wMdQVlZKJuJBmrBYNrd9ODvSDSKUxedjeEyB25zXt9XOtlIGP9
         +lCQ==
X-Gm-Message-State: AOAM533Z6FNr2R3cOxCqtLil22GGU/hTB29ArYjhe/2DzZU5Cbg910qH
        hit2/Ps/IQ8UhfDVI1Dag9OYPZLNqj2ewPV8aoqqTwJQrsA=
X-Google-Smtp-Source: ABdhPJw0jN1Ez4O02SsYz053gsrAtcrQCByjlNzHeOTNq+nujy2H6u/WZA3Ts9dHGQ4A08n05PWp4NKKMFUKyrvBtFE=
X-Received: by 2002:a25:accb:: with SMTP id x11mr19787573ybd.154.1633954654064;
 Mon, 11 Oct 2021 05:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <16339379649423@kroah.com>
In-Reply-To: <16339379649423@kroah.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 11 Oct 2021 14:07:51 +0200
Message-ID: <CAKXUXMwBG2q0wxR4G6N2rTin6giP-zroTPAw+vhfG9s3Lo2cbw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] x86/Kconfig: Correct reference to
 MWINCHIP3D" failed to apply to 4.19-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 9:39 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>


I have provided a manually adjusted patch here:

https://lore.kernel.org/stable/20211011120309.16365-1-lukas.bulwahn@gmail.com/

I hope you can pick this up for all stable releases for v5.4 and
before. So, this also applies for v4.19.

Lukas

> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 225bac2dc5d192e55f2c50123ee539b1edf8a411 Mon Sep 17 00:00:00 2001
> From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Date: Tue, 3 Aug 2021 13:35:25 +0200
> Subject: [PATCH] x86/Kconfig: Correct reference to MWINCHIP3D
>
> Commit in Fixes intended to exclude the Winchip series and referred to
> CONFIG_WINCHIP3D, but the config symbol is called CONFIG_MWINCHIP3D.
>
> Hence, scripts/checkkconfigsymbols.py warns:
>
> WINCHIP3D
> Referencing files: arch/x86/Kconfig
>
> Correct the reference to the intended config symbol.
>
> Fixes: 69b8d3fcabdc ("x86/Kconfig: Exclude i586-class CPUs lacking PAE support from the HIGHMEM64G Kconfig group")
> Suggested-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: <stable@vger.kernel.org>
> Link: https://lkml.kernel.org/r/20210803113531.30720-4-lukas.bulwahn@gmail.com
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ab83c22d274e..8055da49f1c0 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1405,7 +1405,7 @@ config HIGHMEM4G
>
>  config HIGHMEM64G
>         bool "64GB"
> -       depends on !M486SX && !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !WINCHIP3D && !MK6
> +       depends on !M486SX && !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !MWINCHIP3D && !MK6
>         select X86_PAE
>         help
>           Select this if you have a 32-bit processor and more than 4
>
