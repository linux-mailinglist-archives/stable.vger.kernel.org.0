Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9345EA9AD
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbiIZPIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235642AbiIZPHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:07:32 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B7795524;
        Mon, 26 Sep 2022 06:39:28 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b75so6726046pfb.7;
        Mon, 26 Sep 2022 06:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=QV3Ez08ZIMLRpGnEaYKhqau+YDsQLecYXVfJmi1zhxk=;
        b=LsGsIG7iQQ1Cx5BmTCgiqCHXqhlaMCtiguS6LY+7DIratbetBZy0UMljvYqCTvb46v
         deKnd7wSpxb2mOoiRb2li5HoSS8CllLTjmfWVeytvpDEK15RwRLzxP95CrYq0UWL9JMP
         z5xGYaasf/5KFCsJfOSwnza+c3SmpeeRzn7fszJroZXiKhdBIA43oM83K+HMICRyGC6i
         qg4JJmiSdVDMx5KWfMVFsQFq5qxLR97S132oTWtguDRWJJi2o/ZPD1QlKXXEpeK0XKpg
         P9uQW1JNcxyMfN+bZmhlQJkwkmRoMnJvdoa4CNaTDfD2f6T29SkjBGtj6RgjcTe5uB/k
         mgmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=QV3Ez08ZIMLRpGnEaYKhqau+YDsQLecYXVfJmi1zhxk=;
        b=zblwQh3gSFhquiw7TqrqhTEXfyjxDvZNHXluxQnp1yVscq/hl6PTj76Oxx72Pwh55n
         3V1dHDu7HEKcgRoDkZhVtTnOJpsetA2iCv+vD2gEXqkF4umB8Y7Mkg7bOglMzzOBTzDz
         7H9+Ge2UJ3t1HwgpLyzHgwvJ7CdEVuO63x4VXmol1vqgBCnhDb0mHhkrlKqCKlHmiZGi
         hGRtiDKkJYQiQ02M1aWbxrMpTNNwt7PawyJiAPegTpnGYCOtPesuJa+fBokqCmmoMW67
         H5/odluclTKg2Zu6FF2Ydo2EXZqj9H4SZt8vJUio+1m5H/SQpAm1wOR87/Pyw15kLNgA
         4w/g==
X-Gm-Message-State: ACrzQf1WbrLvTxvP4rBfrc7kq2g6rW1/Mh0eOzyD1iq8TcHvtys5L1wE
        kWYg1DwcEWsPaMdIg9ZfOZQ=
X-Google-Smtp-Source: AMsMyM5sPmhd23q6+6uaJWzeWQWPzLZKdSj9KesaLVy6DOxA1WCqHR9PkyvWnzcDJ4tK4uX0lP+UXw==
X-Received: by 2002:a05:6a00:16c8:b0:53b:3b9f:7283 with SMTP id l8-20020a056a0016c800b0053b3b9f7283mr23992809pfc.46.1664199568154;
        Mon, 26 Sep 2022 06:39:28 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p4-20020a622904000000b0054d1a2ee8cfsm12145383pfp.103.2022.09.26.06.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 06:39:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <1d7f82a0-b75f-d305-328e-8e84605149f6@roeck-us.net>
Date:   Mon, 26 Sep 2022 06:39:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 000/148] 5.15.71-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220926100756.074519146@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 03:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.71 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
> 


Building arm:ixp4xx_defconfig ... failed
--------------
Error log:
drivers/gpio/gpio-ixp4xx.c:171:18: error: 'IRQCHIP_IMMUTABLE' undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
   171 |         .flags = IRQCHIP_IMMUTABLE,
       |                  ^~~~~~~~~~~~~~~~~
       |                  IS_IMMUTABLE
drivers/gpio/gpio-ixp4xx.c:172:9: error: 'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
   172 |         GPIOCHIP_IRQ_RESOURCE_HELPERS,
       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpio/gpio-ixp4xx.c:172:9: warning: excess elements in struct initializer
drivers/gpio/gpio-ixp4xx.c:172:9: note: (near initialization for 'ixp4xx_gpio_irqchip')
drivers/gpio/gpio-ixp4xx.c: In function 'ixp4xx_gpio_probe':
drivers/gpio/gpio-ixp4xx.c:296:9: error: implicit declaration of function 'gpio_irq_chip_set_chip' [-Werror=implicit-function-declaration]
   296 |         gpio_irq_chip_set_chip(girq, &ixp4xx_gpio_irqchip);
       |         ^~~~~~~~~~~~~~~~~~~~~~
