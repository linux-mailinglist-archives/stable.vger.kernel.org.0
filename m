Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8F760E972
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 21:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbiJZTpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 15:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbiJZTp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 15:45:27 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591BABDF;
        Wed, 26 Oct 2022 12:44:25 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id o2so11459413qkk.10;
        Wed, 26 Oct 2022 12:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dnvZiw2WHlbiV6rtq4uxOyMMllagNobakugUz2ZgehE=;
        b=o6Lyliz+cHj5CwoPEbDKB5//UBUnW5mETMUBebJXJiEcENviQqX8xprlIJpOuseBo9
         LphgGvnhNQazWO44sHY++gjF94Q8D9BXhaNnAkmY8Sx6bpY6QVrVWKXBUN6wIuM+O8MY
         GOnFjyZIMSt2rVHxTdSMxwtmvEN/r0PDfrNEaRmXZYNZ4QVuEJ53mZSm+8yvLT3mORcT
         zeJ3dJvaT428pxmoAIUG1ezkc5JvCIfhk49d03KtTW3IQikeIGjhy97IHtR2m8wJnz7i
         LLjhwEd/bhc6ygcI0B8PZNCSACzBDyLfO6BWGqbvbylrqcllSBF0hQGtHkN8sehDYsqR
         NsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dnvZiw2WHlbiV6rtq4uxOyMMllagNobakugUz2ZgehE=;
        b=DKAriCawDZ0odVcemslwxRZZ97OVEcgfdI7Tv6TkVI0BdPRg4tXnITX/3ov5WDmwz0
         WLL0L9RSJJElh9YL0RwnjBRm+D78Wqf/R8JoCxFZlvCJtze0gqnerCvMKVB4v1ZQMMRl
         orH71RIc6JWxEHMuZ242/yk/bHAXjejps/QQdGzEaCF478qwIKL4zWda4HnIUfsHQWIS
         pVM6nYcV8RqA4erC9v1OxFLGVJNsdo33U+OsrYJK9CPoHstE0kbsyGH0+SGO47Gu3AZr
         wpbkAIGowj3DtDIPV9oLhT7u04OHBh7QOOXKO1MPO6ymTd5J1ZR2Ek1o6zXnyYvi+IL/
         p+7w==
X-Gm-Message-State: ACrzQf1docAmf1fAttxT9y7ts7tCVyNe1WkWSTGZXGs0DFo/q72SyV+W
        wp31QxoVgS3EwLekE+5XcAw=
X-Google-Smtp-Source: AMsMyM5mlLuhBFfErgRaoGdE6r5zGqEHLx9kZ0sXPdssBtYw01bbc46PqQnsEQZBs+w+E3qFai3HGg==
X-Received: by 2002:a05:620a:1367:b0:6ee:c35c:fa46 with SMTP id d7-20020a05620a136700b006eec35cfa46mr31727298qkl.169.1666813464393;
        Wed, 26 Oct 2022 12:44:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05620a288f00b006f9c2be0b4bsm661541qkp.135.2022.10.26.12.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 12:44:23 -0700 (PDT)
Message-ID: <84028e30-22c1-10bf-f444-d3ac8429a003@gmail.com>
Date:   Wed, 26 Oct 2022 12:44:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v4 1/7] mmc: cqhci: Provide helper for resetting both
 SDHCI and CQHCI
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Shawn Guo <shawnguo@kernel.org>, linux-mmc@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Bjorn Andersson <andersson@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Andy Gross <agross@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Al Cooper <alcooperx@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        stable@vger.kernel.org
References: <20221026194209.3758834-1-briannorris@chromium.org>
 <20221026124150.v4.1.Ie85faa09432bfe1b0890d8c24ff95e17f3097317@changeid>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221026124150.v4.1.Ie85faa09432bfe1b0890d8c24ff95e17f3097317@changeid>
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

On 10/26/22 12:42, Brian Norris wrote:
> Several SDHCI drivers need to deactivate command queueing in their reset
> hook (see sdhci_cqhci_reset() / sdhci-pci-core.c, for example), and
> several more are coming.
> 
> Those reset implementations have some small subtleties (e.g., ordering
> of initialization of SDHCI vs. CQHCI might leave us resetting with a
> NULL ->cqe_private), and are often identical across different host
> drivers.
> 
> We also don't want to force a dependency between SDHCI and CQHCI, or
> vice versa; non-SDHCI drivers use CQHCI, and SDHCI drivers might support
> command queueing through some other means.
> 
> So, implement a small helper, to avoid repeating the same mistakes in
> different drivers. Simply stick it in a header, because it's so small it
> doesn't deserve its own module right now, and inlining to each driver is
> pretty reasonable.
> 
> This is marked for -stable, as it is an important prerequisite patch for
> several SDHCI controller bugfixes that follow.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

