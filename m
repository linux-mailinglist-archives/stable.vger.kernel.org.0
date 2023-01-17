Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D782B670B61
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 23:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjAQWLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 17:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjAQWJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 17:09:17 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECC156889;
        Tue, 17 Jan 2023 12:12:02 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id v23so29780659plo.1;
        Tue, 17 Jan 2023 12:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eUVREAeuxi0yYQ0P2vbR9fitxXN9smQF7SNOFKwNoSM=;
        b=cMYFMH8GXe3w9/s8TthwcET4E/yGDk6e9TCH9M/cZzIY0nl0cevHVq9dmclhbdFZJg
         riP708G5VdFkPgdSJbKeRsEf5kuLphuGICN9KIWUoQ4EyNmF5XVHAp9cjO1XA9gpMyIf
         2nOjPihV7Sz9S/SoE18NQceO+KCDHHPTxfTzqJsN3gIq3imPOMTvWqKEcoPrAlNRYfQw
         jWboUf8nRmXwTW+qDClvxJlHUetoalQeCh6FQGpR/SUdOs+aVxHvBx05ygTXxffJb6EB
         +PyptjY77DHrsTwJOkfceh0AKeHYjzC+PP+LInvJ6jMMwA8/ZBGaqmgFZvGZObYg+G1n
         0tww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eUVREAeuxi0yYQ0P2vbR9fitxXN9smQF7SNOFKwNoSM=;
        b=tdvCaKpaQDE5bwjSnw4r0lkIeO2xKlqBhxDks71B3QIIQ739Mvic7pxquwn8u8t3XS
         QtiAlmQsG2PxmaA6SddbpMMw0Ebu4DAmG65AM8DPDUv0FkYa3J1XKh/YO9j7vrFf9fRH
         6FL8beulLuaV+lHXN4F6Auk66DS7PptzXe7fGGBAMoWY3zCiMzCrcYWFT5mRmB9FeTtx
         Y1ZRlr8MFKxnYywSrQ6GYuEgn7qGiEDuFrxIfjgCeAnid5ItnqK/bWGb6MIRBWInfzma
         XC9BLeLSq7uyilDsExZb7eMVuonxoPykWBuMw1HWE2XbJf9+KCUMSF6sZ/s+Pi6/LIqo
         Eyew==
X-Gm-Message-State: AFqh2ko5mmFKcUW+/0yZ6x0ycb3up1KQimMYtr1PDilZB0cZ+kQr0PsM
        0uZIENoewlqXA2HL28jrtAg=
X-Google-Smtp-Source: AMrXdXuJWsG5EbhUVDSXvJVtmwFi5ddTzDmkbmib3gPrkId1EwHxnBH76KIciaxn81Mil/yTa//s5A==
X-Received: by 2002:a17:90a:a402:b0:229:5e73:78ec with SMTP id y2-20020a17090aa40200b002295e7378ecmr4830694pjp.34.1673986322059;
        Tue, 17 Jan 2023 12:12:02 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 4-20020a631844000000b00497c1399b38sm17636994pgy.78.2023.01.17.12.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 12:12:01 -0800 (PST)
Message-ID: <3584ba9e-9c15-977f-7e00-ec89ddf2a0f4@gmail.com>
Date:   Tue, 17 Jan 2023 12:11:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230117124526.766388541@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230117124526.766388541@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/17/2023 4:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.164-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
