Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5D95EB47F
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 00:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiIZWY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 18:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiIZWY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 18:24:26 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8CB82843;
        Mon, 26 Sep 2022 15:24:24 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id y2so5042171qtv.5;
        Mon, 26 Sep 2022 15:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Aj4jqdmP8uv2Ki8x1BJ2NHjQAOOmHG/qfBojsX6rDVs=;
        b=mG8L5gdZLrVm1RDRA3OAiu2LDMtIYLjZiEjlmChYl3BDoqbJwV/ZVaYHLTPEuKf3Ck
         Yrj7o25khNkwWJCqG6XN1uKigTy6lqpDWIQExDl/YYwJEbkRFRutjA5NJAypNq6QSlZ/
         Ncyu8/LzYRk3npGqHwnZxPemhQhBA9d2Tj1KlGN2+GJ0+KkVg7zki7JP5wamHgeUHBqh
         EHrblY3xTZOXfM/WcgHivsSFRU2t5Awk9IF+lXl84bB3Q6L4a1EycsCM9Vs1jE/QQW3H
         3BFRgxdd/ak3FUbIhIp8ZROLVdN502PzhmHf8OGCRGcUh+M61f+bk7EZKJj0fKAbS58j
         LD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Aj4jqdmP8uv2Ki8x1BJ2NHjQAOOmHG/qfBojsX6rDVs=;
        b=LtwM/rii+kBqlPLHKn6fnuFigx2FrmvvrUH17+uBMt7VGs0czRxjl1AzABWCxlNZIm
         PHQ3nKFgx3b9g5F1+yvOj4YUBNOJJqCw65GPiGNxcFeiWII7gVwmDMAm+gQ1o5fyjDhE
         s66DJ+7LKptIMyxDELL9zjVy4ci4jmJsmZuJaTPPu7En9BUsgXjOp3W8Q/yzs3exc3Kf
         Dd5EqWNRN1wdqWwci8stD4snlHgDQMtxK2vrz5bvu2RCC6oMQprVAgEzntPsniM/+6Wr
         XpmLWvgwedkG4wCjx051beWXv3afbI+nTSTl0ldDAjSO8mrX3CEkpAtJjTbWwMAu+sLy
         TkAw==
X-Gm-Message-State: ACrzQf0l3op9NDLqyuV4FPUKt97hgE7DjSaDbCgJwf9BvMlKSTnyEjDH
        gbZozUuHnOYjYIiA+L7Mny4=
X-Google-Smtp-Source: AMsMyM6bzaXiRjKSwc61FLkmjhJTbneD3ttU2gcy6/umZqi5005k6zYaKiyebUQWITyVRXAkdet35A==
X-Received: by 2002:a05:622a:448:b0:35d:448f:d2aa with SMTP id o8-20020a05622a044800b0035d448fd2aamr3691327qtx.680.1664231064044;
        Mon, 26 Sep 2022 15:24:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u4-20020a05620a430400b006bb2bca5741sm12224046qko.93.2022.09.26.15.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 15:24:23 -0700 (PDT)
Message-ID: <54484545-db32-1717-c161-9cd267ff06fd@gmail.com>
Date:   Mon, 26 Sep 2022 15:24:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220926100806.522017616@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 03:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.12 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
