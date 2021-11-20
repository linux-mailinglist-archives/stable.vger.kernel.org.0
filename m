Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1835C457AF5
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 04:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbhKTD7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 22:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbhKTD7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 22:59:51 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0609C06173E
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 19:56:48 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d27so21486030wrb.6
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 19:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M02PfsqksLPda89nlrI5PxBf9KrvqVjaq7MtFU6lXW4=;
        b=1EKDk2SnM+bUg+Im8VsXxIZJwVRqeo9beponAjLTV/vhNdMWHU5+kOE7/zyB9K+q5g
         2dbfw5bRuZWRboaQyAhWIXtl/ERVgnEDW4OG/yZEqdatGag+tGWRUofT+asXPr02qjjf
         m7e3svTTvXsmNy1jflwuHBZqyahyqDyaMYNYpPYwuSS6CL1pL/i4eyHkcVjK+IZPmuV3
         NrT9vGReddULSLOC0mImoWdpD7+eyJAFesX35/szAWBunR5qRiDiX9LqYGmIsTN4DPbY
         JoRL37Ip7wahWy4BAX9H8tvLjd1x9srJo5lFrzBvzoBQVpE36VsC00etiH0nMqZURxvz
         73Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M02PfsqksLPda89nlrI5PxBf9KrvqVjaq7MtFU6lXW4=;
        b=D368GCr1n5rbbouo3JzN13+NMEczkpBCzCH4Kxln9ZnID71WM68sbMDlmlhVs/PC9o
         UefvSb31zAiU2O3SertdXllzei3poiUwQQTRwNreTiiw6xwoxdke8G6OaVbp8ldhJ78H
         cSmziHgIjVJtW7HZHi2Etzq+Xubrbl5RrIMIcwAtz87hOrYjPt4Q9CFOvVF5N37ha20V
         BUAUJwoXvryCm9GjkxsRpVAJAc2lyycKqezgIe7Ry/0k3wwuhIHHorMr/EeCFXT1+3xq
         RwRNNkNxx3jYDNImrFxz2Kpn0ARhbkSck4JJGv1qUlhLavGpp0Q8EsqyCCB7R3kikvgY
         QYcQ==
X-Gm-Message-State: AOAM531PnmW+K4jaciEusS8Z7TRFH2dgGuJAEP5W3yPPIjR44kv0qZPA
        zyMWi4ptykWGZorzYM+OvGX0cHCk5KIRuEJWDptcIFeqYWA=
X-Google-Smtp-Source: ABdhPJzGZ2FRjxzdL13lLUsnFVAOo8OzdTpxDEYsb8XDAjJ7NFcBANTW6pXcFbMnXX/A9+MkpASidyBFA9nV0l5ri4w=
X-Received: by 2002:adf:8165:: with SMTP id 92mr14513881wrm.199.1637380607106;
 Fri, 19 Nov 2021 19:56:47 -0800 (PST)
MIME-Version: 1.0
References: <20211119164413.29052-1-palmer@rivosinc.com> <20211119164413.29052-2-palmer@rivosinc.com>
In-Reply-To: <20211119164413.29052-2-palmer@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 20 Nov 2021 09:26:35 +0530
Message-ID: <CAAhSdy1wGprfMAKQg8CZOtg79Lu_fCuw_TjkAqpPHLYkn6ZZaw@mail.gmail.com>
Subject: Re: [PATCH 01/12] RISC-V: defconfigs: Set CONFIG_FB=y, for FB console
To:     Palmer Dabbelt <palmer@rivosinc.com>
Cc:     linux-riscv <linux-riscv@lists.infradead.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Atish Patra <atish.patra@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Damien Le Moal <damien.lemoal@wdc.com>, axboe@kernel.dk,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 10:14 PM Palmer Dabbelt <palmer@rivosinc.com> wrote:
>
> From: Palmer Dabbelt <palmer@rivosinc.com>
>
> We have CONFIG_FRAMEBUFFER_CONSOLE=y in the defconfigs, but that depends
> on CONFIG_FB so it's not actually getting set.  I'm assuming most users
> on real systems want a framebuffer console, so this enables CONFIG_FB to
> allow that to take effect.
>
> Fixes: 33c57c0d3c67 ("RISC-V: Add a basic defconfig")
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/configs/defconfig      | 1 +
>  arch/riscv/configs/rv32_defconfig | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
> index ef473e2f503b..11de2ab9ed6e 100644
> --- a/arch/riscv/configs/defconfig
> +++ b/arch/riscv/configs/defconfig
> @@ -78,6 +78,7 @@ CONFIG_DRM=m
>  CONFIG_DRM_RADEON=m
>  CONFIG_DRM_NOUVEAU=m
>  CONFIG_DRM_VIRTIO_GPU=m
> +CONFIG_FB=y
>  CONFIG_FRAMEBUFFER_CONSOLE=y
>  CONFIG_USB=y
>  CONFIG_USB_XHCI_HCD=y
> diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_defconfig
> index 6e9f12ff968a..05b6f17adbc1 100644
> --- a/arch/riscv/configs/rv32_defconfig
> +++ b/arch/riscv/configs/rv32_defconfig
> @@ -73,6 +73,7 @@ CONFIG_POWER_RESET=y
>  CONFIG_DRM=y
>  CONFIG_DRM_RADEON=y
>  CONFIG_DRM_VIRTIO_GPU=y
> +CONFIG_FB=y
>  CONFIG_FRAMEBUFFER_CONSOLE=y
>  CONFIG_USB=y
>  CONFIG_USB_XHCI_HCD=y
> --
> 2.32.0
>
