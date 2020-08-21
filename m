Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F052F24CF96
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 09:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgHUHka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 03:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgHUHkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 03:40:09 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959B2C06138B
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 00:40:08 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id y8so377261vsq.8
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 00:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bAU9iZW9yGALOB30mTlHDeoRf5CRh/Snlg+xCwRu8JU=;
        b=kOxOuxMxSQ+ksSLjKg3Ni5aIYiY5w0RxKooi0DNSCKve7b14PccYxmywLlnGxld6mc
         WqavXtK7TC9i0AqdD3XPTGzIoa5x8gqELOCV/+vAlvOIAyKSZztrQsMbO4Rg2Sd1UFPg
         SiEMKltZUmr8lz2zr42CVDG7YdRtLuErHINARiW/rqVexyezip3RnwlVXtlEpgakssZH
         NiFgJ9BjbUnADlw9BpI2N/RodkTY07zEH8wagrgldLZZX2bBReCzCGOX1V/M9Lb+z/Vk
         +T51a1HYvojPzfuH4UOvwvYnJe1ukLKul84xO8Z6/4GZPuwyMPAeamxXv+di9soZ/b3m
         KOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bAU9iZW9yGALOB30mTlHDeoRf5CRh/Snlg+xCwRu8JU=;
        b=BRyw2pjV+JE8Q45Y9aRAJ/VlX5VkyU/B/xv0ndsswumcM1lug9kR7kMq4ndZdBgKvx
         /qDgLDP9cAU+dEWu49IN0wVfM1aDy6+L3DPHisLg5rG6iUYA8mBgSCyG2s7/7HVLHgKR
         62LEBvtniUeEx+jxO2CBtfCaiLyZ/D3v9Go07ql1cfTWxWo1MKe+Ubph5J5N6snuHHbA
         iBsHFsmdOq14k2iNol7kmb1i9tWk8XO1iVkaddL+oiiL4ACYbYbC3Cr9eDWPZmh19bRu
         NjDeCJNRRIW9jBWVvr/ZanvxlsAzzWpzyDQeBoFrSsMRPWQr85S6JO4OYCT7xW5HdWIp
         uDew==
X-Gm-Message-State: AOAM533JdWu9pu2vfrKIw5YbPVayWgJk3bgPn2XzwnLiHxn1VQsN6Hrl
        MfzQyYqNIziskzpmrhivsuO+qwn8bjGmb1bNNpgypw==
X-Google-Smtp-Source: ABdhPJwcZWnwUZBTqM0sxN5IRp11B+ol/YTZpoa5qsJpj61ysTHH9tG19j4VKQcti7QxF7eU+rcXtzQeNyrlpU0p/zI=
X-Received: by 2002:a67:e9d8:: with SMTP id q24mr887206vso.165.1597995607373;
 Fri, 21 Aug 2020 00:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <1596673949-1571-1-git-send-email-skomatineni@nvidia.com>
In-Reply-To: <1596673949-1571-1-git-send-email-skomatineni@nvidia.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 21 Aug 2020 09:39:31 +0200
Message-ID: <CAPDyKFre3Rpfd-XW=kMzuKJAfUcr4v-vEj9KVkPyAvkbTdRuGg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Fix timeout clock used by hardware data timeout
To:     Sowjanya Komatineni <skomatineni@nvidia.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Aug 2020 at 02:32, Sowjanya Komatineni <skomatineni@nvidia.com> wrote:
>
> Tegra210/Tegra186/Tegra194 has incorrectly enabled
> SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK from the beginning of their support.
>
> Tegra210 and later SDMMC hardware default uses sdmmc_legacy_tm (TMCLK)
> all the time for hardware data timeout instead of SDCLK and this TMCLK
> need to be kept enabled by Tegra sdmmc driver.
>
> This series includes patches to fix this for Tegra210/Tegra186/Tegra194.
>
> These patches need to be manually backported for 4.9, 4.14 and 4.19.
>
> Will send patches to backport separately once these patches are ack'd.
>
> Delta between patch versions:
> [v3]:   Same as v2 with fixes tag
>
> [v2]:   Includes minor fix
>         - Patch-0006: parentheses around operand of '!'
>
> Sowjanya Komatineni (6):
>   sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra210
>   sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra186
>   arm64: tegra: Add missing timeout clock to Tegra210 SDMMC
>   arm64: tegra: Add missing timeout clock to Tegra186 SDMMC nodes
>   arm64: tegra: Add missing timeout clock to Tegra194 SDMMC nodes
>   sdhci: tegra: Add missing TMCLK for data timeout
>
>  arch/arm64/boot/dts/nvidia/tegra186.dtsi | 20 +++++++++------
>  arch/arm64/boot/dts/nvidia/tegra194.dtsi | 15 ++++++-----
>  arch/arm64/boot/dts/nvidia/tegra210.dtsi | 20 +++++++++------
>  drivers/mmc/host/sdhci-tegra.c           | 43 ++++++++++++++++++++++++++++++--
>  4 files changed, 74 insertions(+), 24 deletions(-)
>
> --
> 2.7.4
>

This looks good to me.

If it helps, I can also pick the arm64 patches for my fixes branch,
but I need an ack from Thierry/Jon to do that.

Kind regards
Uffe
