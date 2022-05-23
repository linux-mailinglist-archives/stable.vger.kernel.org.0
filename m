Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F42531A4B
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiEWTDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 15:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbiEWTAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 15:00:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13239CF30;
        Mon, 23 May 2022 11:42:31 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b135so2710223pfb.12;
        Mon, 23 May 2022 11:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fgKolKo2W9u+egkoBMmdYH2ux7YY09TR3IB+igLpG2c=;
        b=STOsn+K+LqaIbQ3/N7nJeBjk7q/pHMyxd7sghc0rywCfK5W+38c9HtqLZ3V85YQTIf
         D79CtNFN6LDGzlQcTwBLhbTM9EJN5n28lgkzQEwgV924qEhDtpRMZKayCPQT51T8a+DB
         AYrHmdKgH3CR9Al9K+F4I8YCkUMQfkoH4XoDPXB6TSAPJWEMeCsgqhSKH2mXUAPfyqL/
         FKr3DDQ3g2RjpqGEh2h0lPnUvys2MQWHpCdciEwN2h9f7Fz1gypXfnG+T+5v/QTmiabK
         tmYYsgfJAkqQDjHb/LIYRx+tTutaFzcT9dyVoLDnRfnWEd1hV845cYeYwR2tV7VuJDzh
         jvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fgKolKo2W9u+egkoBMmdYH2ux7YY09TR3IB+igLpG2c=;
        b=zxjaZiQWYJFRKlBGC+BdcH40AMufpN3DbGo4tg3weRxt6LT9HlPVvATR4h3yKl7NcS
         +lDlXzMQVZ9emzip9++IQF0WF3ij9i6SF96JYUEjGa4M6SlF77EUr86lK/XniPL8XhuT
         +h9WTqFcJ1jbbRzTSPJg0wjo4YtPyahWh1MNLGf4d07ZP0c+WyYMXd2YB/y+SW6i9NLB
         v8NV45IEycLjJygQNVfrJ3JpMge4cnV3O/cuulNWiSb2iRHYGnJo0jGAe92nOIgqRaFC
         xgckokmSKahgoT3Ka7jwiSH20sAHWKPyDTsAstueH+2iZ/C9EWiK2fRudN7k6HJj5gfv
         TWxA==
X-Gm-Message-State: AOAM530T/HiCyi2VduCSa+gyxYOi7yQNbJqIM9Tf6BhcJe9NFnF8vv3b
        0VQH7OY+BX+jiSa2L0xJKJ4=
X-Google-Smtp-Source: ABdhPJyk2Lrb1HpWnHNXReRUG4aDAML6PzDtEzBBJNXMSgc2YbMWr5FvOEpBFlmY2HIqlhhCltFztw==
X-Received: by 2002:a63:1543:0:b0:3fa:8e73:d7a5 with SMTP id 3-20020a631543000000b003fa8e73d7a5mr2120735pgv.160.1653331351416;
        Mon, 23 May 2022 11:42:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f9-20020a170902ab8900b00161ccdc172dsm5490546plr.300.2022.05.23.11.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:42:30 -0700 (PDT)
Message-ID: <ac6ae3f6-1e04-7f7d-cc3a-d5b04c9dbd61@gmail.com>
Date:   Mon, 23 May 2022 11:42:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.15 000/132] 5.15.42-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220523165823.492309987@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/22 10:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.42 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.42-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
