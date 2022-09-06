Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB65AF3DB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiIFSm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIFSm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:42:56 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B69585FA1;
        Tue,  6 Sep 2022 11:42:56 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id c20so8737247qtw.8;
        Tue, 06 Sep 2022 11:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=HSmNDt3pWucMuaM7bnQVVQ8/hQCBDEbY+InuFb9RZNY=;
        b=f6H7k1vKQjEX7WqJufOffbvac8qjVZtO+6xHDkJKiK9UtjK4eTAq/7DCt9NRZkBgiA
         ZFKyv6o3lDx0nghEajPp6itaLs2u59E430Q9UBI74z6s17n94RuD1pemZdWSunBofRH2
         sblZwtKYhJXG12O6fkDgWq3aCkjCYotvdgBpQDJbCVKU01X5y+xhlAZxMe77hlJlJ071
         YF+x6pLbxmlaB+wLQYgrcb9Rs44qbZobY3Sp38VQJVxztRQ2dK1L1tOCQ8H8LJQUHK0Y
         rstVKPBV83/yxliAlp6NXNI82sckv8LTsy6uesmH7C/2Tzdb3iluv9TQNfBA789pt4mx
         4ATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HSmNDt3pWucMuaM7bnQVVQ8/hQCBDEbY+InuFb9RZNY=;
        b=OaxsCrPsO5SsYgB+wuFHNkZvHzL5VfCdJyLUHvqIxrzcJKzEFfyHFqK6B2q8u6LMH5
         wK2tsmSCuO+Gomc0SP9ztywqYkXzXmTLnfHE37tqu9EhaDXfesSH/dBUM4VcEXN8Ana4
         tOKoxCYp/aXIsILY/AWdC5QZsnCpo90tGm2bLQtmlbvamNoqU4FZpHXnqTfweMKm+p8Y
         nzIn8g0T9E2uV/bmpQJym2VvG+cFJUf2ekmOL/juVKPIVUMhDUG0KbjjwN2b7I4up5UX
         ec4vnxC8f8Od1Di9c3Ho5S2HdoLjnSA8H3KFlZtevPcRHLVW7u+Lp4ae1EvhcmdD8FHS
         reEA==
X-Gm-Message-State: ACgBeo2mm9IhalpwsQl0k1r5kzLlgKhP3AprPmAhxiDxTw5K74XDpECM
        /a+NpqcRhK8TpeekmuhSe/yD94dfKwQ=
X-Google-Smtp-Source: AA6agR7pxMHruEnOWWvULNVkAg6bl2zc/r76WgQ06rSHqlAcy0ZI3dtCQHFZ3NE/V2yTBbkzo3+cJg==
X-Received: by 2002:ac8:58c6:0:b0:343:292:5980 with SMTP id u6-20020ac858c6000000b0034302925980mr45631544qta.319.1662489775165;
        Tue, 06 Sep 2022 11:42:55 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u16-20020a05622a199000b0031f0485aee0sm10707426qtc.88.2022.09.06.11.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 11:42:53 -0700 (PDT)
Message-ID: <814a334f-c2dc-3880-8d57-8267ee4911a1@gmail.com>
Date:   Tue, 6 Sep 2022 11:42:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220906132821.713989422@linuxfoundation.org>
 <d3679191-f6e2-7195-fc9b-c210fb8fd18b@gmail.com>
In-Reply-To: <d3679191-f6e2-7195-fc9b-c210fb8fd18b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/6/2022 11:33 AM, Florian Fainelli wrote:
> 
> 
> On 9/6/2022 6:29 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.66 release.
>> There are 107 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.66-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
> BMIPS_GENERIC:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

There is an issue with the lack of executable permission on 
scripts/pahole-flags.sh that I will be responding to in the appropriate 
patch.
-- 
Florian
