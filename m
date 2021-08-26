Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F3B3F8E66
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 21:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243356AbhHZTCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 15:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243339AbhHZTCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 15:02:49 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28ACAC0613C1
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:02:02 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id v33-20020a0568300921b0290517cd06302dso4804955ott.13
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:jubject:from:user-agent:date
         :message-id:subject:to:cc;
        bh=+iVPuEHGBickynSlN/aspzgM+vCXS1pxLKvIBYzPHaY=;
        b=m1Qh8c1JI8bJtMbx2zXs3H9EO3V3B24CTfDZ0E0MweKP5VXvP8ajaNkOgqAv29OW/F
         xjby+KYB85j/qh0w1BGUe1u8LtcQThDspoEcg6Ho/K9SiquHynat2V84AQwXD9k8D+AX
         lUHCf/zIj2pOkXaqiiOBJBZ//d85EfeL9KDEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:jubject:from
         :user-agent:date:message-id:subject:to:cc;
        bh=+iVPuEHGBickynSlN/aspzgM+vCXS1pxLKvIBYzPHaY=;
        b=kcBu9ZV/4+5QsxG/YJrbPZIZ4UlXRgxluJlD8de2wqmDfSt231haIUGSDd9C6kjYSa
         9FxGs/qylY6GaipT6vIyWyz+Rm+1f5tn26+53rlfPl0qCe/9QD9FNFdwwu+5iKFyuWCb
         BZ6tTZthXiKdWzlQE+LQRi9fTTdo0OBfRuo2WZ6a0szc3XSneZ9XrE/O1ecT7zWFrkZx
         B+ilPXSANLRoIyLlflDzlNDjaj/9L8CklL6o02DRyd4NfmZapoMRIN6xh8dgzDLkKxH8
         kUmIl4uqKzIsEC0YOPn8eBWyTevjMS6w72z1waMI6Pyu1EzNROx0wjWXsOAdrqVi5v9e
         6Dlg==
X-Gm-Message-State: AOAM533niwrDVqXILpMQ8uVc2So67OACZWoCEm7Ogoi1GyuP/Zq7FAE7
        FbnWvpy6oEIjT62d2ZX0ixyozV2hlbw6o846xgifjw==
X-Google-Smtp-Source: ABdhPJzdZYXAXrUOl9mGtjohncFB+oGrYX4mON9av982YMT3gjRIDsaw7nD/2scpYTZBlBNfwQfReCj7diwhE7RBlNg=
X-Received: by 2002:a05:6830:88:: with SMTP id a8mr4600325oto.233.1630004521512;
 Thu, 26 Aug 2021 12:02:01 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 26 Aug 2021 19:02:00 +0000
MIME-Version: 1.0
In-Reply-To: <YSfioM5cEnvD3pGb@sashalap>
References: <20210824025754.658394-1-sashal@kernel.org> <CAE-0n53zk0ogf=TUknMoCAPDd97=jq3Czpp6b1c9E29ormuCSQ@mail.gmail.com>
 <YSfioM5cEnvD3pGb@sashalap>
jubject: Re: FAILED: Patch "mmc: sdhci-msm: Update the software timeout value
 for sdhc" failed to apply to 5.4-stable tree
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.9.1
Date:   Thu, 26 Aug 2021 19:02:00 +0000
Message-ID: <CAE-0n50brNnTASH8xR_jSCr0=OAQohcA4cG3HFAeDmt=4U-4Uw@mail.gmail.com>
Subject: 
To:     Sasha Levin <sashal@kernel.org>
Cc:     sbhanu@codeaurora.org, stable@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sasha Levin (2021-08-26 11:51:12)
> On Thu, Aug 26, 2021 at 07:51:45AM +0000, Stephen Boyd wrote:
> >From cd5d41c802f7b3e20c0c0ebd6bf0cb335954fd89 Mon Sep 17 00:00:00 2001
> >From: Shaik Sajida Bhanu <sbhanu@codeaurora.org>
> >Date: Fri, 16 Jul 2021 17:16:14 +0530
> >Subject: [PATCH] mmc: sdhci-msm: Update the software timeout value for sdhc
> >
> >commit 67b13f3e221ed81b46a657e2b499bf8b20162476 upstream.
> >
> >Whenever SDHC run at clock rate 50MHZ or below, the hardware data
> >timeout value will be 21.47secs, which is approx. 22secs and we have
> >a current software timeout value as 10secs. We have to set software
> >timeout value more than the hardware data timeout value to avioid seeing
> >the below register dumps.
> >
> >[  332.953670] mmc2: Timeout waiting for hardware interrupt.
> >[  332.959608] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
> >[  332.966450] mmc2: sdhci: Sys addr:  0x00000000 | Version:  0x00007202
> >[  332.973256] mmc2: sdhci: Blk size:  0x00000200 | Blk cnt:  0x00000001
> >[  332.980054] mmc2: sdhci: Argument:  0x00000000 | Trn mode: 0x00000027
> >[  332.986864] mmc2: sdhci: Present:   0x01f801f6 | Host ctl: 0x0000001f
> >[  332.993671] mmc2: sdhci: Power:     0x00000001 | Blk gap:  0x00000000
> >[  333.000583] mmc2: sdhci: Wake-up:   0x00000000 | Clock:    0x00000007
> >[  333.007386] mmc2: sdhci: Timeout:   0x0000000e | Int stat: 0x00000000
> >[  333.014182] mmc2: sdhci: Int enab:  0x03ff100b | Sig enab: 0x03ff100b
> >[  333.020976] mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000000
> >[  333.027771] mmc2: sdhci: Caps:      0x322dc8b2 | Caps_1:   0x0000808f
> >[  333.034561] mmc2: sdhci: Cmd:       0x0000183a | Max curr: 0x00000000
> >[  333.041359] mmc2: sdhci: Resp[0]:   0x00000900 | Resp[1]:  0x00000000
> >[  333.048157] mmc2: sdhci: Resp[2]:   0x00000000 | Resp[3]:  0x00000000
> >[  333.054945] mmc2: sdhci: Host ctl2: 0x00000000
> >[  333.059657] mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr:
> >0x0000000ffffff218
> >[  333.067178] mmc2: sdhci_msm: ----------- VENDOR REGISTER DUMP
> >-----------
> >[  333.074343] mmc2: sdhci_msm: DLL sts: 0x00000000 | DLL cfg:
> >0x6000642c | DLL cfg2: 0x0020a000
> >[  333.083417] mmc2: sdhci_msm: DLL cfg3: 0x00000000 | DLL usr ctl:
> >0x00000000 | DDR cfg: 0x80040873
> >[  333.092850] mmc2: sdhci_msm: Vndr func: 0x00008a9c | Vndr func2 :
> >0xf88218a8 Vndr func3: 0x02626040
> >[  333.102371] mmc2: sdhci: ============================================
> >
> >So, set software timeout value more than hardware timeout value.
> >
> >Signed-off-by: Shaik Sajida Bhanu <sbhanu@codeaurora.org>
> >Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> >Cc: stable@vger.kernel.org
> >Link: https://lore.kernel.org/r/1626435974-14462-1-git-send-email-sbhanu@codeaurora.org
> >Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> >Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> >---
> > drivers/mmc/host/sdhci-msm.c | 18 ++++++++++++++++++
> > 1 file changed, 18 insertions(+)
> >
> >diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> >index 8bed81cf03ad..8ab963055238 100644
> >--- a/drivers/mmc/host/sdhci-msm.c
> >+++ b/drivers/mmc/host/sdhci-msm.c
> >@@ -1589,6 +1589,23 @@ static void sdhci_msm_set_clock(struct
> >sdhci_host *host, unsigned int clock)
>
> I've queued this up, thanks!

Thanks!

>
> Note that the patch was linewrapped (see above).

Indeed. Must be something wrong with my mailer setup. I'll look into
fixing it. Thanks.
