Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFCD5F38A1
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 00:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJCWMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 18:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJCWMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 18:12:21 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8222C32B87
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 15:12:17 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id y189so7380606iof.5
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 15:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=8YJiIw36R1a/rSnVRxmNjX57bbd/DVZvsAMc9ztbHS4=;
        b=K/RrEieHGT+8Jp4NjmKrEzW2nSFicOIr9qRFmxSoxpsHMO4+rnSE2Z1KfZpHvm9LDR
         lT+lt912IV4p3QV1rqx8iv5hdB9aGOwP30sKrOQ7lEtLnsWKIx8NW03ANy3DYBLEZ+rB
         ul+QSx+kLu+UXNOZWwA8JBogRDVZcJFRmmWRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8YJiIw36R1a/rSnVRxmNjX57bbd/DVZvsAMc9ztbHS4=;
        b=oL1NkfqPBs+X3JPaSN92kDarNbV7An6rZTAcVWFKgyLq5hlLcbpCPRPtqF+NAb7agI
         kphWO+blXP+EXmurRoK1ewefHxiLAWRFsHYi8OnxnLhfq5N18MOaeiemV8QwYkloYmmY
         fmNFYtOo3FvDvGoW7JTf84UTNB6HGBANuaddI7X4RFGG67HyntWmtNJU4ji4CWqK8KYx
         Rn0xq8DALIWAWicYCPT+a/rjTC4MLXwrGxeirq7PwQzE+2SvmFpyJ4pmBzKxo8aPPbxO
         AYC248EElEaI1fEawN9jzBSFMXx/HnYlemKSFC+tH5R6XgzTMuB0y3FT3ybn2c+il4tU
         /7JA==
X-Gm-Message-State: ACrzQf3Ypdtrh31bBG/ef8Fc4zfzbs1GlQkio51QjD6+tBPBtwEIBegU
        xR5UkSeOOf6VXWxo5CljCJGTDQ==
X-Google-Smtp-Source: AMsMyM41DefSuhh5kc5fun8oy+/Lzxmn6CwgpwJfB9Q7CUiTWr/TNm74F1sYzMkpmbj64KsYZ493Rw==
X-Received: by 2002:a05:6638:3d09:b0:357:34bc:7ec8 with SMTP id cl9-20020a0566383d0900b0035734bc7ec8mr11307416jab.238.1664835136669;
        Mon, 03 Oct 2022 15:12:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i3-20020a056e02054300b002f68a98e1c2sm4282038ils.50.2022.10.03.15.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 15:12:15 -0700 (PDT)
Message-ID: <d73eb14c-0acf-dfff-5dfb-1c0817485109@linuxfoundation.org>
Date:   Mon, 3 Oct 2022 16:12:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
 <4e95484a-2d47-b3c1-52bf-f3b9a27884e2@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <4e95484a-2d47-b3c1-52bf-f3b9a27884e2@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/22 15:30, Shuah Khan wrote:
> On 10/3/22 01:10, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.72 release.
>> There are 83 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.72-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
> Compiled and booted on my test system. I am still seeing the drm related
> regression and didn't get a chance to isolate. Will try to do it this week.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> 

Sorry for the confusion. This 5.15.72 is just fine. The drm issue I am seeing
is on 5.10.147 and started in 5.10.146. I isolated it in 5.4 and testing the
same on 5.10 - will send responses to those threads.

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
