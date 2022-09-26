Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73C55EA9A6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbiIZPHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbiIZPGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:06:40 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7818F34CC;
        Mon, 26 Sep 2022 06:38:42 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f23so6264231plr.6;
        Mon, 26 Sep 2022 06:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=38NRyEXFCz+zmiXgCs91cwXCifzoqDHpCjFS2+6RdnM=;
        b=qF8165ifOJxsV5d1YJ5OkzKYGZY6Hel1iyEWgjMPBKCg4H+IM6jkdfCBLVB8XURBHb
         n3Q9y+/Alauuwwu4zezLOQmRVDOgBY4LoFCt0EnvIflPxQndCyviRW9aoRNy24FGKWMi
         3FZ5Z1cfGLFUOqhyRNIcoixaoRRKvCukB94C6yOBVd0j7HR8ByL0W6ESXb2omby7Gf0z
         lJtTTZynCRx8ZyHlf9494JxcxJiaPDZSuyvULZvS+f1nHpKjdBUEMUfVXPyV+knjlKTR
         9ic/d2Th4adWpTog5d+vieH/L20kK1TXjpaZg0GQAU/cff+MG0GFDzeP55WD/wuP9GyI
         1+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=38NRyEXFCz+zmiXgCs91cwXCifzoqDHpCjFS2+6RdnM=;
        b=TDbl8KH+BMon++qePcaGuvxSmrlQIh24bmscRMhZQasZ+CP0q7+nLo2sTYrh5ynz64
         eU6bLSAAkuHhLrNMbw+LFa8PRe3xn4muExVmih2D3DSxxB9BLNoVGIjF0xwbnMBmo6Ok
         5wySw2Zq9A6ri/GzLBjWyhU20Dq7tCkuecgJ+of6NNI2LS+3vVGgn2JBhx/n3qtYQbv2
         TyXUZ+cSLJFGZPPBG+/hAo0j65SXsFyPKzXoULAlBdf24agINdgAjXZ1VOb3/2b4YcOO
         rY8pJxv8xsD4ke6PgyHDp6Iv6b2Jk+8RMo160UBvzMY7gjdNF/N9AVRoNESsGcCbq+Zu
         1Z6w==
X-Gm-Message-State: ACrzQf16UZn7FbZ5lJsUufCxqHhNzcA5DpospQgTvUB7aN0HWT96toxy
        87RHJRRNnMIKsW4m6ZzR83c=
X-Google-Smtp-Source: AMsMyM4n7G4hchEGQEzL+UJoofI1TOivNW11hSOlHK5ijlJqW5uFkAkighsVjXlNMxKTAXl+KDxipg==
X-Received: by 2002:a17:90b:5096:b0:202:df4f:89a with SMTP id rt22-20020a17090b509600b00202df4f089amr25308487pjb.25.1664199522278;
        Mon, 26 Sep 2022 06:38:42 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j10-20020a170902da8a00b0016ef87334aesm11406522plx.162.2022.09.26.06.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 06:38:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <39503234-9c35-cdd8-bd8c-d5c3d7d3af1e@roeck-us.net>
Date:   Mon, 26 Sep 2022 06:38:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 000/120] 5.4.215-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220926100750.519221159@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.4.215 release.
> There are 120 patches in this series, all will be posted as a response
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
