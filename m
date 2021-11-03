Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CA14446C6
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhKCRPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhKCRPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 13:15:16 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50B9C061714;
        Wed,  3 Nov 2021 10:12:39 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id b3so5764678uam.1;
        Wed, 03 Nov 2021 10:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vjB+quBdNOJqFSJL3ekERhxYHi9YgOpneayP+iYe40Y=;
        b=UB1r/+pWlXT9Hp/Dj36xmNrIh4E0FzbXkjlF/TxZbRc+l10XBYxhWsIVYKDorA9UeP
         VTldpEcTccNhy0OQt5a/Qz09csRmZhecZcvguYU88qL6wvjksfGhi9EBrNu+OfXrRs+g
         rJeQDiAezKDk3Nyo9TCEVAyYly7H9cV1iAicI4DCEHgvhsSqd2bj8k5wj3/xBBqcmA98
         NtHqSWmPsBBh+z4vEu9w07Cn9iCUiCouLqgb375Ed2qWGintuKvMVodFOprDBu8R/hoQ
         pdL6KIrm876BfrqK0h3dnfQrZ0wxeeIK38a5iEv7rZvtz84OBOeGXP/jyuSlp5UWMjwX
         dfhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vjB+quBdNOJqFSJL3ekERhxYHi9YgOpneayP+iYe40Y=;
        b=rxvoibegiJn5niEOGs6g+E9+GoSEZnHFqURANuOp5ajiouw/zzzZyInNDbFEm5KdUn
         tha8cfX0KxyPpmJDtVxUJKD0py9AM2nvXj+TKkMRRXR1PDn7MeoN5gn9MEDA1H/OmUW+
         4d+Awf86pTeZHitfvb97wkgJ+dwU6gVaaIZGH7hh/iy1Cq4vMeKoGXgsdc0tj4bu253z
         wUptLeURDr3jaMwU23LOrAxLUURcpX8fzwrEL1859vfEOIswd8MlaqqRPNIGvQWKMR/4
         pVQWra1R27RkHEe9Rxb1HT0wPtYRUFnnJxgXU02UnrxyYnJZGZti4R1uVR0qsaH2a1Ph
         51jA==
X-Gm-Message-State: AOAM530/z90zSmPu4WYBsJZmIRC7/XJDzIxjGvIKqx2kuijhKWttUUZE
        3GJTPMzfhg6J851K/VFT39H5p0iAfWQTq7kz0h9QjYx7+xs=
X-Google-Smtp-Source: ABdhPJxK4J1rYehPyOp71dazx2uXMeK5WFjkgrHlgBDL1dRTYmyKH+9Gu5KoTrYxWn6oLCWlXGokDxQnxCNKpo5Va+I=
X-Received: by 2002:ab0:6f47:: with SMTP id r7mr44424221uat.85.1635959559048;
 Wed, 03 Nov 2021 10:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+vNU3zKEVz=fHu2hLmEpsQKzinUFW-28Lm=2wSEghjMvQtmw@mail.gmail.com>
 <20211103165415.2016-1-tharvey@gateworks.com>
In-Reply-To: <20211103165415.2016-1-tharvey@gateworks.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 3 Nov 2021 14:12:28 -0300
Message-ID: <CAOMZO5CgieZCte+z7s6HronZs-MEMgSkGcCnv9Fu7nqMZfsf4g@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: disable CMDQ support
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        BOUGH CHEN <haibo.chen@nxp.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        Adam Ford <aford173@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Peng Fan <peng.fan@nxp.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tim,

On Wed, Nov 3, 2021 at 1:54 PM Tim Harvey <tharvey@gateworks.com> wrote:
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

It seem this is the best approach we can do at the moment, until
the ESDHC_FLAG_CQHCI issue is debugged.

Reviewed-by: Fabio Estevam <festevam@gmail.com>
