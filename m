Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D069E5873DD
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 00:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbiHAWWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 18:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbiHAWWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 18:22:15 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62D830565
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 15:22:14 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id j20so4770358ila.6
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 15:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pBK/Zf0lgEwmQCyP2kjQOOFSWsDbib9HeyBn7MqJNZM=;
        b=MF7yfeVd7MawTl2MshTqFrbkSMcDEBBjmTdHNWvCMYZTvHlKG9/zkdxj5curmX77pH
         i7+q8xPS/JkHi9hZQCqMOiY+Xn3A7iox56RRuLlPxod7WhEfXYyRowN3kuv55XPdX0Ly
         8SLOyR/8kIWnpZ0ydGkXAABQltdL46I2+jIv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pBK/Zf0lgEwmQCyP2kjQOOFSWsDbib9HeyBn7MqJNZM=;
        b=CKiqG11WYY58gkkH7pGEUx7LxtHNBjGFxC9qaSioUQyh2aM7kLdvd/gR2z4X+hwPVk
         xhbGaDEkUY3lLAhqWAIaAXDLEWZc5mePliwOjz3bulVpxQkUJMZ+TWqko/FHz+M5SIgN
         UJdv4FgV1DPZtpUlLgj6W31z5xjqqGHckRwZAKpFP3556E9AICioE14Yt0lM9C/e7ksG
         ZLwuZukZoGpu4vF52uMHx4CzZYZ6fnY1+Ve2o3ml2XzKKmkLVy8A81ebr6uVd/yqueI/
         zW+BlkoyeR3PsvTQIBfrTz+eiCMBwBZb4xJDYzvGAV/ylF72g/xd4E9/dWmt9CTngtjE
         daYA==
X-Gm-Message-State: ACgBeo3oC/YCTdekcdJrUJ8JAeTcpw/hTt46malC2CX0XdEtMm8k18qQ
        vHWW9jchQQQN4HP/XrK1EhiErQ==
X-Google-Smtp-Source: AA6agR5CYKU0jz3M1J0x/y1wYEL75eJVfHPmxvZRwjGd3VfN5zh+uBXldH6iin0xHzjuWepiScYG5A==
X-Received: by 2002:a92:d304:0:b0:2de:e328:942f with SMTP id x4-20020a92d304000000b002dee328942fmr376965ila.175.1659392534310;
        Mon, 01 Aug 2022 15:22:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x19-20020a056602161300b0067beb49f801sm6043838iow.2.2022.08.01.15.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 15:22:13 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/34] 5.4.209-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220801114128.025615151@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0cf3cb5f-7244-77da-f2a6-fa7a07e01a83@linuxfoundation.org>
Date:   Mon, 1 Aug 2022 16:22:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/1/22 5:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.209 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.209-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
