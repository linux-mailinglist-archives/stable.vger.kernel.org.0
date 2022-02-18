Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D384BB5E9
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 10:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiBRJqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 04:46:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbiBRJqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 04:46:36 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0425EDCF
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 01:46:19 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id i14so13520436wrc.10
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 01:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TNPs3XUIKSJGHFJT31aKb5KrR4RIhs82BSGaW6p5+r8=;
        b=aMnVyUqa2iZNrnxcPBcAiBODjipAWB0m4PbyPEvAMm+dWL6d9x5uyTW2u76utu6bLk
         Ac0vPLp8pDxRVjmI1e+T8dQ6LmVsJSOnsSXvLXWVcz8kbZr+eNbQfdQ0dfzNcQWp7N/k
         mN9n/YgIb4eu+SY76EihV15a2Qm7HwADUzWPQ9cwJ/Bj8dAxBq0hbFCl66YLxWOOG+jj
         D3NLR5KJ4hYzhc//UhA0kqw8PSzm4TBFJVe5iqhk+d/t8L5l4nJqxEcb/ZG+W9uU13jI
         oUKolYaAoX4iTb1eCrmV1sAhc3KMqKNauyUiNbVxufjW2XOKe1cL8xOlMKEUrvZdCUcC
         7uLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TNPs3XUIKSJGHFJT31aKb5KrR4RIhs82BSGaW6p5+r8=;
        b=bWdgOFw5VVuUNXSir5q40iaWIrcGyQqhL5QcWvj8rjkjGvxCx10Yx3kE8FDFFoBxr7
         avVrZa0Axee3lbj24JEyXDmRBcBKwVVtq/F8RCMyYquKW0PaL3c0QxjnpQ35oo7Sqe8S
         tD51ypZoM9b/wNeQBB/DGUO2cENRd6/GG02VWWzVyHbSszllv/LgTXD5TU3HPnuisQr1
         rklGpolgfJs9PjKABpVeMOfxmzKTPMTBbMUzuE3LcWILEoTols9OnOjCeRqzIRTaeAEz
         U2fSAYcH1li5mOwqr7lyJmOMuMpAdglnp+pOVpCw8HUqKJGfRFHs1eOccMqxzXJrFkIK
         DG+Q==
X-Gm-Message-State: AOAM531jwnxePl42xZN90jWj/CGN30TqWyKCxbD54tvsqe2lFsQG0aso
        PZb6L6i/2Gh+CDWRdeZss1MfVQ==
X-Google-Smtp-Source: ABdhPJz+D9bmvjgoT8qq45YSNK+QUrJSJSkPVo+OcczsyGu5pCnQnNkzQok/8IEwR4pVbDWeRIo2Og==
X-Received: by 2002:a5d:42ca:0:b0:1e6:2bf3:5c17 with SMTP id t10-20020a5d42ca000000b001e62bf35c17mr5254344wrr.621.1645177577821;
        Fri, 18 Feb 2022 01:46:17 -0800 (PST)
Received: from [192.168.86.34] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id g22sm3649606wmh.12.2022.02.18.01.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 01:46:17 -0800 (PST)
Message-ID: <f44ae992-5408-6f4c-2d03-6c0c64336fb1@linaro.org>
Date:   Fri, 18 Feb 2022 09:46:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 4/4] mtd: core: Fix a conflict between MTD and NVMEM on
 wp-gpios property
Content-Language: en-US
To:     Christophe Kerello <christophe.kerello@foss.st.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        robh+dt@kernel.org, p.yadav@ti.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org, chenshumin86@sina.com,
        stable@vger.kernel.org
References: <20220217144755.270679-1-christophe.kerello@foss.st.com>
 <20220217144755.270679-5-christophe.kerello@foss.st.com>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220217144755.270679-5-christophe.kerello@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Miquel,


On 17/02/2022 14:47, Christophe Kerello wrote:
> Wp-gpios property can be used on NVMEM nodes and the same property can
> be also used on MTD NAND nodes. In case of the wp-gpios property is
> defined at NAND level node, the GPIO management is done at NAND driver
> level. Write protect is disabled when the driver is probed or resumed
> and is enabled when the driver is released or suspended.
> 
> When no partitions are defined in the NAND DT node, then the NAND DT node
> will be passed to NVMEM framework. If wp-gpios property is defined in
> this node, the GPIO resource is taken twice and the NAND controller
> driver fails to probe.
> 
> A new Boolean flag named ignore_wp has been added in nvmem_config.
> In case ignore_wp is set, it means that the GPIO is handled by the
> provider. Lets set this flag in MTD layer to avoid the conflict on
> wp_gpios property.
> 
> Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
> Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
> Cc: stable@vger.kernel.org
> ---


There seems to be already an mtd core patch [1] that is planned to go 
via nvmem tree, do you want me to take 3/4 and 4/4 via nvmem tree as well?
Or
you can pick up both the series via mtd tree?

Am okay either way.



[1] 
https://patchwork.kernel.org/project/linux-usb/patch/20220104133843.44272-4-andriy.shevchenko@linux.intel.com/

--srini


> Changes in v3:
>   - add a fixes tag
>   - rename skip_wp_gpio by ignore_wp in nvmen_config.
> 
>   drivers/mtd/mtdcore.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 70f492dce158..eef87b28d6c8 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -546,6 +546,7 @@ static int mtd_nvmem_add(struct mtd_info *mtd)
>   	config.stride = 1;
>   	config.read_only = true;
>   	config.root_only = true;
> +	config.ignore_wp = true;
>   	config.no_of_node = !of_device_is_compatible(node, "nvmem-cells");
>   	config.priv = mtd;
>   
> @@ -833,6 +834,7 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
>   	config.owner = THIS_MODULE;
>   	config.type = NVMEM_TYPE_OTP;
>   	config.root_only = true;
> +	config.ignore_wp = true;
>   	config.reg_read = reg_read;
>   	config.size = size;
>   	config.of_node = np;
