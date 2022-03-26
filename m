Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C584E7BC1
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiCZACm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 20:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiCZACW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 20:02:22 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3151758E53;
        Fri, 25 Mar 2022 17:00:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id z16so7855905pfh.3;
        Fri, 25 Mar 2022 17:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=0gYW297i4YGJtgXJCND6FmvYCMSz855BOblyGZzfcjc=;
        b=GLeiIEL6UnSvsXT7tIJ6WEqNG+QnmNn2J+0goG3qj8oJIthED+Pfa8esN22eBTkwXl
         PExK5R6iYecdzLWmIoizjacVkyZoEwTpwH84gL36TLKMqMsqRFhLjCD8qLKph+WkTn4V
         TpOxN17v7WmLiXr9SBZoNYXGqQupb5HzjjelyLthlM15IzxaAo5G74A0Tv9Agz4Myd1p
         mSy8dqfaDPqtYOBR+7cVx/JcohkIICgrcx9FOLXARNiPlrsYQU6+RonZULOTlt61djD4
         nGkt3lVUS0Mql0N+UBUwTxACTWmo70jkTBIEokj70re7Noon6UGP1HpDEL6liDiFBj1/
         jaew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=0gYW297i4YGJtgXJCND6FmvYCMSz855BOblyGZzfcjc=;
        b=hFwDbmcwaylMoW3MJwXD2G5TdvpYxk7I4nttErZKMGVcEqHSI4kIWjCvthHDQCrot8
         ErEvt2ot9jdDPAC31lhfGWc+8cgyI68EzayzcfOqBn7NWmIsyYdB18ZD1jLHu5MrXr22
         BHmUcNMzuxOoAhxLSvy6htbpk3zPa+FCbw6XmHBmD07Lu0cIUmMXFTOfmMiqOttQVO0P
         6mXKJy2sI1U/cBAXwVhYAIgydvKyZls2GoMhz6kaZ7vep+c3cpSpbNY+XfRMzcUxtVht
         nwiRSnlY6P6bZWhXGGNbNtRSRCYQYw5/QX4vc/2bwSoj3zgiMGiOmDh+Pgb9eV3EATFD
         MtHg==
X-Gm-Message-State: AOAM533pykukskrW97bNPYs+sBuhzklnBGDn50OYsT/f7oQ/LTBgwSuz
        /xmTJmCYUSymf/Bs3WZjP9M=
X-Google-Smtp-Source: ABdhPJxXCSVMz9VsONSGkrGtZkijXZeRJlQ0AuK7sJXTvUuzAT2lmpuROtaM7LP3sYQdl4HHJ9ABgg==
X-Received: by 2002:a05:6a00:887:b0:4f2:6d3f:5b53 with SMTP id q7-20020a056a00088700b004f26d3f5b53mr12616728pfj.21.1648252847660;
        Fri, 25 Mar 2022 17:00:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o65-20020a17090a0a4700b001bef5cffea7sm9861966pjo.0.2022.03.25.17.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 17:00:47 -0700 (PDT)
Message-ID: <bc8caeac-ea75-f91a-5bb0-9195eb263914@gmail.com>
Date:   Fri, 25 Mar 2022 17:00:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4.9 00/14] 4.9.309-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220325150415.694544076@linuxfoundation.org>
 <15268a27-5386-45d8-5c55-1095251331f7@gmail.com>
Content-Language: en-US
In-Reply-To: <15268a27-5386-45d8-5c55-1095251331f7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/22 14:31, Florian Fainelli wrote:
> On 3/25/22 08:04, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.9.309 release.
>> There are 14 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.309-rc1.gz 
>>
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-4.9.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> PS: is there any reason why the Spectre BHB patches from here are not 
> part of linux-stable/linux-4.9.y?

Meant to provide this link, from here:

https://gitlab.arm.com/linux-arm/linux-jm/-/tree/bhb/v3/v4.9.302
-- 
Florian
