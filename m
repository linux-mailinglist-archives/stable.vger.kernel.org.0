Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE50607DD1
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 19:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJURpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 13:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiJURpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 13:45:50 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57825F47;
        Fri, 21 Oct 2022 10:45:47 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id cr19so2154526qtb.0;
        Fri, 21 Oct 2022 10:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9jf1Or+O0WATniMBydkpibsCp44mV74kwc+1uNXS0e0=;
        b=MaUeJGs+YkNZIKBbZ8z/Z9S2HZlo6KAmfqilfv+d+s+Y3O9zurejymgbKOf7JSvPqO
         0fVlj99M/nNWb/k86FK/5YdSrVsIK45/Uu7net3R/SKvCZ4BHFR+orBGxHdCbkfmm4Cp
         FUgVWZyPq+cJEXCG0EN5RBL6H1s6kAXhjA/2M8P4hheiqaYA1eLhV/hUv/2IqduQr1W0
         9XbyIrp3u5e+AC5Wr41vwQ4TZa3FW5tE/PQxe7Irh01QJJYK5aJ8IFYAGvCcwwCDI07H
         GxgkE53xpRDM/OS16msJZEUFZd4QJcRApOUgUO3fAdgUXYy+6piNHX/NMCUNkakzBvxT
         NbFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9jf1Or+O0WATniMBydkpibsCp44mV74kwc+1uNXS0e0=;
        b=fc2+59Z9hlpezbWB3+Jn7UNZUREvaHoLEQTq08ssUAZxh3kW9HGJhcSIxd0CahI8ud
         yuROqijXK91GdMnhEEhO6q7Kei7RAbe5LBYNWFaLEcr2IdJYYQaOBP7klbmYFFXA6hUb
         g13ghO/5FvcYIo2q83NKCBkqoU+GnKfIrCS9PiCsbzM3xxMyeOxujZ2Wz4qCFHjV6qU4
         LcgaE65OA2/qlpI9FP7YBRrbKOIymrZW+QRhdWZ30MQD9RkE+83ofzlkjfwmbZSN/CZ2
         w/ffX7h4pgEY4z0c6s7o3efQgPYhvI6/59pOLa5nZd2A12N6jXZbT0Mc/LSJwdquvQuQ
         /8FQ==
X-Gm-Message-State: ACrzQf0E0Ex3216WJzvBllfD5Cfe7EAqMbIkbIqI0FHTAZe+386eJUzo
        mZqXM/mVBfrBZCtgV9ybIvQ=
X-Google-Smtp-Source: AMsMyM4geCAzB+hp+wq+emgUYQlwUd2aBYl5rvEbU1iMuZ+NC4ysO0kWjtTcWnCX/l/FutMzq+ybog==
X-Received: by 2002:ac8:5b90:0:b0:39c:e9b9:c002 with SMTP id a16-20020ac85b90000000b0039ce9b9c002mr17475349qta.3.1666374346793;
        Fri, 21 Oct 2022 10:45:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l13-20020ac84a8d000000b00342f8d4d0basm8418189qtq.43.2022.10.21.10.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 10:45:46 -0700 (PDT)
Message-ID: <9fe9c826-9b1a-0471-e30c-7fa949d2b08e@gmail.com>
Date:   Fri, 21 Oct 2022 10:45:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 2/7] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for
 CQHCI
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Brian Norris <briannorris@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Faiz Abbas <faiz_abbas@ti.com>, linux-mmc@vger.kernel.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Al Cooper <alcooperx@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org
References: <20221019215440.277643-1-briannorris@chromium.org>
 <20221019145246.v2.2.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
 <14efb3e6-96cf-f42e-16aa-c45001ec632e@gmail.com>
 <Y1B36AnqJtolGQEP@google.com>
 <5f1adbf7-b477-914e-0a07-5c76532e85cd@intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <5f1adbf7-b477-914e-0a07-5c76532e85cd@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/22 23:29, Adrian Hunter wrote:
> On 20/10/22 01:19, Brian Norris wrote:
>> On Wed, Oct 19, 2022 at 02:59:39PM -0700, Florian Fainelli wrote:
>>> On 10/19/22 14:54, Brian Norris wrote:
>>>> The same bug was already found and fixed for two other drivers, in v5.7
>>>> and v5.9:
>>>>
>>>> 5cf583f1fb9c mmc: sdhci-msm: Deactivate CQE during SDHC reset
>>>> df57d73276b8 mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers
>>>>
>>>> The latter is especially prescient, saying "other drivers using CQHCI
>>>> might benefit from a similar change, if they also have CQHCI reset by
>>>> SDHCI_RESET_ALL."
>>
>>>> --- a/drivers/mmc/host/sdhci-of-arasan.c
>>>> +++ b/drivers/mmc/host/sdhci-of-arasan.c
>>>> @@ -366,6 +366,9 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
>>>>    	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>>>>    	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
>>>> +	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL))
>>>> +		cqhci_deactivate(host->mmc);
>>>> +
>>>>    	sdhci_reset(host, mask);
>>>
>>> Cannot this be absorbed by sdhci_reset() that all of these drivers appear to
>>> be utilizing since you have access to the host and the mask to make that
>>> decision?
>>
>> It potentially could.
>>
>> I don't know if this is a specified SDHCI behavior that really belongs
>> in the common helper, or if this is just a commonly-shared behavior. Per
>> the comments I quote above ("if they also have CQHCI reset by
>> SDHCI_RESET_ALL"), I chose to leave that as an implementation-specific
>> behavior.
>>
>> I suppose it's not all that harmful to do this even if some SDHCI
>> controller doesn't have the same behavior/quirk.
>>
>> I guess I also don't know if any SDHCI controllers will support command
>> queueing (MMC_CAP2_CQE) via somethings *besides* CQHCI. I see
>> CQE support in sdhci-sprd.c without CQHCI, although that driver doesn't
>> set MMC_CAP2_CQE.
> 
> SDHCI and CQHCI are separate modules and are not dependent, so they cannot
> call into each other directly (and should not).  A new CQE API would be
> needed in mmc_cqe_ops e.g. (*cqe_notify_reset)(struct mmc_host *host),
> and wrapped in mmc/host.h:
> 
> static inline void mmc_cqe_notify_reset(struct mmc_host *host)
> {
> 	if (host->cqe_ops->cqe_notify_reset)
> 		host->cqe_ops->cqe_notify_reset(host);
> }
> 
> Alternatively, you could make a new module for SDHCI/CQHCI helper functions,
> although in this case there is so little code it could be static inline and
> added in a new include file instead, say sdhci-cqhci.h e.g.
> 
> #include "cqhci.h"
> #include "sdhci.h"
> 
> static inline void sdhci_cqhci_reset(struct sdhci_host *host, u8 mask)
> {
> 	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL) &&
> 	    host->mmc->cqe_private)
> 		cqhci_deactivate(host->mmc);
> 	sdhci_reset(host, mask);
> }
> 

I like the simplicity of the inline helper, especially towards 
backports. May suggest to name it sdhci_and_cqhci_reset() to illustrate 
that it does both, and does not apply specifically CQHCI that would be 
"embedded" into SDHCI, but your call here.
-- 
Florian

