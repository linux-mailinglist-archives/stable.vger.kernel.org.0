Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800BD450798
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 15:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhKOO5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 09:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhKOO5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 09:57:46 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CCEC061570
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 06:54:50 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id z8so36075385ljz.9
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 06:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g5ZgJ9ybSmxZaOHHfIm4FqhKxdTXF1lea99HqmX4/j4=;
        b=S91lIxy96BaMvhkT0VPnFcikbWRtwwutqfr3lTkCtCq1PrRMkdxqm2RG7xPV7dcvMn
         ixNALaIF3BB2n+gjkWhO9X8eTUozOK2MYQSbNgOqSxK5+pE6XsnCZHjA+CIujIbSbL2i
         hwvZ5eKAZjpU15iwildNA/UmGQ6IlDMsKBppAJKy4OIhVLvPDcnaB41YJjyL+GaPTLmJ
         /3pEmGWXKH6jtNVews2k/Rpksn8k4DPH2VrbJ/86u92kDlpa5MnkP8NFO962MG5OKDUe
         6J1WNZJZJpOxZKYfKbjA4/0jYytSaINvifSuXG+Hkj6EMCT/Wso4PkZvTO2KGK6YmPwL
         ECeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g5ZgJ9ybSmxZaOHHfIm4FqhKxdTXF1lea99HqmX4/j4=;
        b=xqqGLQEcwlC+rye65/p2LGUA3a0CgQC9LhM/9FGmoqVsZ5Vazukd66Jo9RQ8Kvxz0T
         cCIkROMnYs1AOqraWIKth/IP6V9HXpFWO+IIG3gLlPxrPHK3hYpVioOa1vIgKjZIfhZ1
         Y+lny9S8hoWMtfjxvkP8zF8W5oeqT6D5Rn9iFao+iEwxf4bslOOoiZAMBo67tmYA7Xqz
         4rLfsEvVK4rGwhi5qAB9Wh5fvfaYwOOPEerWsgc+WPfDitJThosHvPloGTnxyvRS8GPN
         +N07Oqh5RuCcfoK9lyUvSGlwk1aZgNwZzMBeYJ6i4H0XQhfo8ytMsktrkfXfNn9P5fX7
         Mzdg==
X-Gm-Message-State: AOAM530VzEk95GBA2y3VC1RqOlhwH7tEfbqdcnZom9OHj6fqNdgev9fC
        dbUuV24N1CSg6z8D32Ij+NhnxIK+dbZcfeEmp16jqw==
X-Google-Smtp-Source: ABdhPJygyd5g7ToVRwbyKiuO6zgP6SOT0F2D9JY8QzEtk3bx0lvD5R8Wkifd26j79pvUhJhXZOxfQukEdkytUIffyyw=
X-Received: by 2002:a2e:80c3:: with SMTP id r3mr39387862ljg.4.1636988088500;
 Mon, 15 Nov 2021 06:54:48 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU3zKEVz=fHu2hLmEpsQKzinUFW-28Lm=2wSEghjMvQtmw@mail.gmail.com>
 <20211103165415.2016-1-tharvey@gateworks.com>
In-Reply-To: <20211103165415.2016-1-tharvey@gateworks.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 15 Nov 2021 15:54:11 +0100
Message-ID: <CAPDyKFqb_muY2AwpxpgFObH74EdkSif0qH0YjADb-MfKB83oHg@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: disable CMDQ support
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <Kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        BOUGH CHEN <haibo.chen@nxp.com>, linux-mmc@vger.kernel.org,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        Adam Ford <aford173@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Peng Fan <peng.fan@nxp.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Nov 2021 at 17:54, Tim Harvey <tharvey@gateworks.com> wrote:
>
> On IMX SoC's which support CMDQ the following can occur during high a
> high cpu load:
>
> mmc2: cqhci: ============ CQHCI REGISTER DUMP ===========
> mmc2: cqhci: Caps:      0x0000310a | Version:  0x00000510
> mmc2: cqhci: Config:    0x00001001 | Control:  0x00000000
> mmc2: cqhci: Int stat:  0x00000000 | Int enab: 0x00000006
> mmc2: cqhci: Int sig:   0x00000006 | Int Coal: 0x00000000
> mmc2: cqhci: TDL base:  0x8003f000 | TDL up32: 0x00000000
> mmc2: cqhci: Doorbell:  0xbf01dfff | TCN:      0x00000000
> mmc2: cqhci: Dev queue: 0x00000000 | Dev Pend: 0x08000000
> mmc2: cqhci: Task clr:  0x00000000 | SSC1:     0x00011000
> mmc2: cqhci: SSC2:      0x00000001 | DCMD rsp: 0x00000800
> mmc2: cqhci: RED mask:  0xfdf9a080 | TERRI:    0x00000000
> mmc2: cqhci: Resp idx:  0x0000000d | Resp arg: 0x00000000
> mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
> mmc2: sdhci: Sys addr:  0x7c722000 | Version:  0x00000002
> mmc2: sdhci: Blk size:  0x00000200 | Blk cnt:  0x00000020
> mmc2: sdhci: Argument:  0x00018000 | Trn mode: 0x00000023
> mmc2: sdhci: Present:   0x01f88008 | Host ctl: 0x00000030
> mmc2: sdhci: Power:     0x00000002 | Blk gap:  0x00000080
> mmc2: sdhci: Wake-up:   0x00000008 | Clock:    0x0000000f
> mmc2: sdhci: Timeout:   0x0000008f | Int stat: 0x00000000
> mmc2: sdhci: Int enab:  0x107f4000 | Sig enab: 0x107f4000
> mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000502
> mmc2: sdhci: Caps:      0x07eb0000 | Caps_1:   0x8000b407
> mmc2: sdhci: Cmd:       0x00000d1a | Max curr: 0x00ffffff
> mmc2: sdhci: Resp[0]:   0x00000000 | Resp[1]:  0xffc003ff
> mmc2: sdhci: Resp[2]:   0x328f5903 | Resp[3]:  0x00d07f01
> mmc2: sdhci: Host ctl2: 0x00000088
> mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr: 0xfe179020
> mmc2: sdhci-esdhc-imx: ========= ESDHC IMX DEBUG STATUS DUMP ====
> mmc2: sdhci-esdhc-imx: cmd debug status:  0x2120
> mmc2: sdhci-esdhc-imx: data debug status:  0x2200
> mmc2: sdhci-esdhc-imx: trans debug status:  0x2300
> mmc2: sdhci-esdhc-imx: dma debug status:  0x2400
> mmc2: sdhci-esdhc-imx: adma debug status:  0x2510
> mmc2: sdhci-esdhc-imx: fifo debug status:  0x2680
> mmc2: sdhci-esdhc-imx: async fifo debug status:  0x2750
> mmc2: sdhci: ============================================
>
> For now, disable CMDQ support on the imx8qm/imx8qxp/imx8mm until the
> issue is found and resolved.
>
> Fixes: bb6e358169bf6 ("mmc: sdhci-esdhc-imx: add CMDQ support")
> Fixes: cde5e8e9ff146 ("mmc: sdhci-esdhc-imx: Add an new esdhc_soc_data
> for i.MX8MM")
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>

Applied for fixes, thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/host/sdhci-esdhc-imx.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index e658f0174242..60f19369de84 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -300,7 +300,6 @@ static struct esdhc_soc_data usdhc_imx8qxp_data = {
>         .flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
>                         | ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
>                         | ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
> -                       | ESDHC_FLAG_CQHCI
>                         | ESDHC_FLAG_STATE_LOST_IN_LPMODE
>                         | ESDHC_FLAG_CLK_RATE_LOST_IN_PM_RUNTIME,
>  };
> @@ -309,7 +308,6 @@ static struct esdhc_soc_data usdhc_imx8mm_data = {
>         .flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
>                         | ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
>                         | ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
> -                       | ESDHC_FLAG_CQHCI
>                         | ESDHC_FLAG_STATE_LOST_IN_LPMODE,
>  };
>
> --
> 2.17.1
>
