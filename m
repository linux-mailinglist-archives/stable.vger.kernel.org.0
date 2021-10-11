Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A123428CDF
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 14:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhJKMTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 08:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbhJKMTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 08:19:02 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18242C061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 05:17:03 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id i84so38470088ybc.12
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 05:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=t9yKwVV3p3HiD1jrgtsPccdL31CqYVWcL2qVwy+fWWE=;
        b=jVk8ou38QBD4FlmnArad//NXyplTz6AUycq69/o9W8YkdLtlK8E74xGaiitQCIUMXD
         GjZwHnVmbjZPXoVfJoeKH1yY0nU+JbSi1PkzhkSTQtJJ46hHkSzT3MXg6mrrqXg61/Su
         6+o9tvU76jFmzpAcwer3HpSQC7F1WFRf/zoo9NMWHplkyCtk3P8vWmjRDuAdFbdZr2ZG
         iS4cyHdesEVh6j0ssrguZA7XYp8LZwAfyenfkC8IlpqZPJczouhDPk8+mBx0rqsiWgPo
         y4eis7a+1TC+zlhdB8v0WxhM+PIUV5hKCiZMAGHjpQsyMAAIQ4uMAVbt34O5ZJZgOEts
         O1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=t9yKwVV3p3HiD1jrgtsPccdL31CqYVWcL2qVwy+fWWE=;
        b=f71wiih08rc35viLxrERbmc3Bn9XSudTBXJ/TyF29+N6SvI4+1X33obPTZwlEuq12F
         sgmlrFjqhg2shQf3FBtMUOg7F4sgJenldIKtGL703csWGksWXMyTwFc96ySheND+rJA1
         X+gXxA4n1qwNO4C0iuc20l6ke5SqKHCwNbqxSFnjJgfi6fj4BU9irG6WmBe53C8+coyo
         RmV8Q1oT2FXDg1aRl7IOgCKwLSF3w1iQYZzTBsoBMLkAInNeL+ovDW573IYYpSpP1ahZ
         bkFH42NAqLhnMApomh3d415YDNuUcrxZjBfFNsCtUTKCfmgC16Tlwq0KnndU/pRN+dUu
         cEJg==
X-Gm-Message-State: AOAM530DexPJG9uW09zHdhLYhFOValJPxjb18hGumnfpcGaZnPbbOxFa
        op3k1aiW849/o0Xpn5+0shN7PAAgWD2MFCKRRXA=
X-Google-Smtp-Source: ABdhPJz9yfnurLG3msi+yqXem/DkTplCvI8hQYRi8IoVEqKZPbL7weAnaQH4r+beKdaVXIc+K8gEvfuoggXCWlM5UYc=
X-Received: by 2002:a25:5604:: with SMTP id k4mr22342582ybb.359.1633954622277;
 Mon, 11 Oct 2021 05:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <163393796424292@kroah.com>
In-Reply-To: <163393796424292@kroah.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 11 Oct 2021 14:07:19 +0200
Message-ID: <CAKXUXMw09jiLXACc4St1S1AxPz0rNZACfgXkKeGbp64=B3NWrw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] x86/Kconfig: Correct reference to
 MWINCHIP3D" failed to apply to 5.4-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 9:39 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>

I have provided a manually adjusted patch here:

https://lore.kernel.org/stable/20211011120309.16365-1-lukas.bulwahn@gmail.com/

I hope you can pick this up for all stable releases for v5.4 and before.

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
