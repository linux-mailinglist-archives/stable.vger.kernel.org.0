Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38B73F8363
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 09:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhHZHwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 03:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240362AbhHZHwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 03:52:34 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EA2C06179A
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 00:51:46 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id g66-20020a9d12c8000000b0051aeba607f1so2366136otg.11
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 00:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=CyZYAhkROzPRMkmMMIprqB951HD27oZOBMzECb71gRI=;
        b=ml6/ZvuQFhRGrvXuaRRdVOF++ZY5PCzIIf/AwSLdVunsgOgdViEMDDG8Hy4E/xr8vZ
         l+5q3cxu4OxHoEQDd6LP1ylRdpdGsIaxJVsX0PZehoM47D0UqTLkHouZrwY0k7aGQqS9
         v00D93CPO3oq1j/t6ibQWjkqdc//1F2c9ChyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=CyZYAhkROzPRMkmMMIprqB951HD27oZOBMzECb71gRI=;
        b=TSQMJKrNClp64kdQG0Vz4/b0tzicLBpAb8SY1EvfNAxSTv1BBE9DZHhSY44l+MLa9B
         l7B59v3LGVkeRyGMtUKAiH7F7VOqFPbVnnrLvhcWPT2gCS+IDop0/Ey9L7MHmkPtXKzr
         w/GIb1sywhsF9Ca0WG8kXKGh+u0u1fBGpCksAuPhyRm/yCK48ylJ1uNQk7MR/z3HjWYF
         aU3l/uLdw6dFHSQySEgdDc4Tyf5opJJ5WNoh5jQS3TrqbtW6IZX38N/jckEfabTy6sOJ
         4Gqq6LT14vzhPfEQVJAZ0PPJaElCnByeL3XHzpzEgcjcinxEoDcX9ESC4sk977Pp3Tjw
         Uu2Q==
X-Gm-Message-State: AOAM530laldL/bUmiJOQlaL4flePiK/Bt/W90y/zymwLocQz5vAfJdG5
        7dbt5etzM2J5yzTJthUdbL1pTREwqdnZgMmubDsiCQ==
X-Google-Smtp-Source: ABdhPJwhUhC9AQF+4ej141s0LxvKyUaWJdZNiwS88bsmazg5jh3Pkj8ZjWU40SpErKftIgsV5l/Myw/S3Gvn5bVJw9s=
X-Received: by 2002:a05:6830:88:: with SMTP id a8mr2016395oto.233.1629964305960;
 Thu, 26 Aug 2021 00:51:45 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 26 Aug 2021 07:51:45 +0000
MIME-Version: 1.0
In-Reply-To: <20210824025754.658394-1-sashal@kernel.org>
References: <20210824025754.658394-1-sashal@kernel.org>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.9.1
Date:   Thu, 26 Aug 2021 07:51:45 +0000
Message-ID: <CAE-0n53zk0ogf=TUknMoCAPDd97=jq3Czpp6b1c9E29ormuCSQ@mail.gmail.com>
Subject: Re: FAILED: Patch "mmc: sdhci-msm: Update the software timeout value
 for sdhc" failed to apply to 5.4-stable tree
To:     Sasha Levin <sashal@kernel.org>, sbhanu@codeaurora.org,
        stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sasha Levin (2021-08-23 19:57:54)
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>

It looks like it conflicts with inline crypto code. This is equivalent
and compiles on v5.4.142

------8<-------
From cd5d41c802f7b3e20c0c0ebd6bf0cb335954fd89 Mon Sep 17 00:00:00 2001
From: Shaik Sajida Bhanu <sbhanu@codeaurora.org>
Date: Fri, 16 Jul 2021 17:16:14 +0530
Subject: [PATCH] mmc: sdhci-msm: Update the software timeout value for sdhc

commit 67b13f3e221ed81b46a657e2b499bf8b20162476 upstream.

Whenever SDHC run at clock rate 50MHZ or below, the hardware data
timeout value will be 21.47secs, which is approx. 22secs and we have
a current software timeout value as 10secs. We have to set software
timeout value more than the hardware data timeout value to avioid seeing
the below register dumps.

[  332.953670] mmc2: Timeout waiting for hardware interrupt.
[  332.959608] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
[  332.966450] mmc2: sdhci: Sys addr:  0x00000000 | Version:  0x00007202
[  332.973256] mmc2: sdhci: Blk size:  0x00000200 | Blk cnt:  0x00000001
[  332.980054] mmc2: sdhci: Argument:  0x00000000 | Trn mode: 0x00000027
[  332.986864] mmc2: sdhci: Present:   0x01f801f6 | Host ctl: 0x0000001f
[  332.993671] mmc2: sdhci: Power:     0x00000001 | Blk gap:  0x00000000
[  333.000583] mmc2: sdhci: Wake-up:   0x00000000 | Clock:    0x00000007
[  333.007386] mmc2: sdhci: Timeout:   0x0000000e | Int stat: 0x00000000
[  333.014182] mmc2: sdhci: Int enab:  0x03ff100b | Sig enab: 0x03ff100b
[  333.020976] mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000000
[  333.027771] mmc2: sdhci: Caps:      0x322dc8b2 | Caps_1:   0x0000808f
[  333.034561] mmc2: sdhci: Cmd:       0x0000183a | Max curr: 0x00000000
[  333.041359] mmc2: sdhci: Resp[0]:   0x00000900 | Resp[1]:  0x00000000
[  333.048157] mmc2: sdhci: Resp[2]:   0x00000000 | Resp[3]:  0x00000000
[  333.054945] mmc2: sdhci: Host ctl2: 0x00000000
[  333.059657] mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr:
0x0000000ffffff218
[  333.067178] mmc2: sdhci_msm: ----------- VENDOR REGISTER DUMP
-----------
[  333.074343] mmc2: sdhci_msm: DLL sts: 0x00000000 | DLL cfg:
0x6000642c | DLL cfg2: 0x0020a000
[  333.083417] mmc2: sdhci_msm: DLL cfg3: 0x00000000 | DLL usr ctl:
0x00000000 | DDR cfg: 0x80040873
[  333.092850] mmc2: sdhci_msm: Vndr func: 0x00008a9c | Vndr func2 :
0xf88218a8 Vndr func3: 0x02626040
[  333.102371] mmc2: sdhci: ============================================

So, set software timeout value more than hardware timeout value.

Signed-off-by: Shaik Sajida Bhanu <sbhanu@codeaurora.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1626435974-14462-1-git-send-email-sbhanu@codeaurora.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/mmc/host/sdhci-msm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 8bed81cf03ad..8ab963055238 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1589,6 +1589,23 @@ static void sdhci_msm_set_clock(struct
sdhci_host *host, unsigned int clock)
 	__sdhci_msm_set_clock(host, clock);
 }

+static void sdhci_msm_set_timeout(struct sdhci_host *host, struct
mmc_command *cmd)
+{
+	u32 count, start = 15;
+
+	__sdhci_set_timeout(host, cmd);
+	count = sdhci_readb(host, SDHCI_TIMEOUT_CONTROL);
+	/*
+	 * Update software timeout value if its value is less than hardware data
+	 * timeout value. Qcom SoC hardware data timeout value was calculated
+	 * using 4 * MCLK * 2^(count + 13). where MCLK = 1 / host->clock.
+	 */
+	if (cmd && cmd->data && host->clock > 400000 &&
+	    host->clock <= 50000000 &&
+	    ((1 << (count + start)) > (10 * host->clock)))
+		host->data_timeout = 22LL * NSEC_PER_SEC;
+}
+
 /*
  * Platform specific register write functions. This is so that, if any
  * register write needs to be followed up by platform specific actions,
@@ -1753,6 +1770,7 @@ static const struct sdhci_ops sdhci_msm_ops = {
 	.set_uhs_signaling = sdhci_msm_set_uhs_signaling,
 	.write_w = sdhci_msm_writew,
 	.write_b = sdhci_msm_writeb,
+	.set_timeout = sdhci_msm_set_timeout,
 };

 static const struct sdhci_pltfm_data sdhci_msm_pdata = {
-- 
https://chromeos.dev

> Thanks,
> Sasha
>
> ------------------ original commit in Linus's tree ------------------
>
> From 67b13f3e221ed81b46a657e2b499bf8b20162476 Mon Sep 17 00:00:00 2001
> From: Shaik Sajida Bhanu <sbhanu@codeaurora.org>
> Date: Fri, 16 Jul 2021 17:16:14 +0530
> Subject: [PATCH] mmc: sdhci-msm: Update the software timeout value for sdhc
>
> Whenever SDHC run at clock rate 50MHZ or below, the hardware data
> timeout value will be 21.47secs, which is approx. 22secs and we have
> a current software timeout value as 10secs. We have to set software
> timeout value more than the hardware data timeout value to avioid seeing
> the below register dumps.
>
> [  332.953670] mmc2: Timeout waiting for hardware interrupt.
> [  332.959608] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
> [  332.966450] mmc2: sdhci: Sys addr:  0x00000000 | Version:  0x00007202
> [  332.973256] mmc2: sdhci: Blk size:  0x00000200 | Blk cnt:  0x00000001
> [  332.980054] mmc2: sdhci: Argument:  0x00000000 | Trn mode: 0x00000027
> [  332.986864] mmc2: sdhci: Present:   0x01f801f6 | Host ctl: 0x0000001f
> [  332.993671] mmc2: sdhci: Power:     0x00000001 | Blk gap:  0x00000000
> [  333.000583] mmc2: sdhci: Wake-up:   0x00000000 | Clock:    0x00000007
> [  333.007386] mmc2: sdhci: Timeout:   0x0000000e | Int stat: 0x00000000
> [  333.014182] mmc2: sdhci: Int enab:  0x03ff100b | Sig enab: 0x03ff100b
> [  333.020976] mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000000
> [  333.027771] mmc2: sdhci: Caps:      0x322dc8b2 | Caps_1:   0x0000808f
> [  333.034561] mmc2: sdhci: Cmd:       0x0000183a | Max curr: 0x00000000
> [  333.041359] mmc2: sdhci: Resp[0]:   0x00000900 | Resp[1]:  0x00000000
> [  333.048157] mmc2: sdhci: Resp[2]:   0x00000000 | Resp[3]:  0x00000000
> [  333.054945] mmc2: sdhci: Host ctl2: 0x00000000
> [  333.059657] mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr:
> 0x0000000ffffff218
> [  333.067178] mmc2: sdhci_msm: ----------- VENDOR REGISTER DUMP
> -----------
> [  333.074343] mmc2: sdhci_msm: DLL sts: 0x00000000 | DLL cfg:
> 0x6000642c | DLL cfg2: 0x0020a000
> [  333.083417] mmc2: sdhci_msm: DLL cfg3: 0x00000000 | DLL usr ctl:
> 0x00000000 | DDR cfg: 0x80040873
> [  333.092850] mmc2: sdhci_msm: Vndr func: 0x00008a9c | Vndr func2 :
> 0xf88218a8 Vndr func3: 0x02626040
> [  333.102371] mmc2: sdhci: ============================================
>
> So, set software timeout value more than hardware timeout value.
>
> Signed-off-by: Shaik Sajida Bhanu <sbhanu@codeaurora.org>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/1626435974-14462-1-git-send-email-sbhanu@codeaurora.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/mmc/host/sdhci-msm.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index e44b7a66b73c..290a14cdc1cf 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -2089,6 +2089,23 @@ static void sdhci_msm_cqe_disable(struct mmc_host *mmc, bool recovery)
>         sdhci_cqe_disable(mmc, recovery);
>  }
>
> +static void sdhci_msm_set_timeout(struct sdhci_host *host, struct mmc_command *cmd)
> +{
> +       u32 count, start = 15;
> +
> +       __sdhci_set_timeout(host, cmd);
> +       count = sdhci_readb(host, SDHCI_TIMEOUT_CONTROL);
> +       /*
> +        * Update software timeout value if its value is less than hardware data
> +        * timeout value. Qcom SoC hardware data timeout value was calculated
> +        * using 4 * MCLK * 2^(count + 13). where MCLK = 1 / host->clock.
> +        */
> +       if (cmd && cmd->data && host->clock > 400000 &&
> +           host->clock <= 50000000 &&
> +           ((1 << (count + start)) > (10 * host->clock)))
> +               host->data_timeout = 22LL * NSEC_PER_SEC;
> +}
> +
>  static const struct cqhci_host_ops sdhci_msm_cqhci_ops = {
>         .enable         = sdhci_msm_cqe_enable,
>         .disable        = sdhci_msm_cqe_disable,
> @@ -2438,6 +2455,7 @@ static const struct sdhci_ops sdhci_msm_ops = {
>         .irq    = sdhci_msm_cqe_irq,
>         .dump_vendor_regs = sdhci_msm_dump_vendor_regs,
>         .set_power = sdhci_set_power_noreg,
> +       .set_timeout = sdhci_msm_set_timeout,
>  };
>
>  static const struct sdhci_pltfm_data sdhci_msm_pdata = {
> --
> 2.30.2
