Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF965696AA
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 01:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbiGFX5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 19:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbiGFX5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 19:57:37 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782A22D1F7
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 16:57:36 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id k15so15446719iok.5
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 16:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xdrY1HBmw/MICn3+xu7Hnd8nOajm8oQjEACzng3uuRk=;
        b=IjHyfj39tLHK7HUvWyqRFi6sTwlm//BjjcKBkuC9pEJ4bgmTG57e3A7Pu1wtuGGS3Q
         If9orHRHy5cYon2QdJ+A8A6dfIgRGttx0KPpq/sVBrJB2AZcCJ5DEJ79I3YMynKgzdaS
         dgD8y1KLDTbIIkMDSFKRJswYf3yYOm93ZLyEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xdrY1HBmw/MICn3+xu7Hnd8nOajm8oQjEACzng3uuRk=;
        b=gd0Jhr1vV9C8ogtJmZglIEuz/Du7BNFQ8SkOFYqd6yMi8rz44oQxFzUxiXSfuylTlI
         XWW2NiGLCq2XclT8xZrAq6AmvdpjENmyYUgrH9N7MfztgqDDN91T62O5S43Rwb35CSbT
         5HV2Eh1zVmBjmvokhb5TwXH0PiuluPuwJznqGjMBP/r8IoUQIFk9JTAOqhcZt9pZMpKN
         r7AcnBLYwnNKYYjgw1knaqZB5JKN9jzWiPfUbURvd+yvbJP0mSUvkYUjkILwkVv1QTKy
         eNAKqXemKKfaxFhrehcMQUJ8GRCBXxvyW2iwIal5A+gd7AAzx049uV6vWDeHl711fz7t
         UwEg==
X-Gm-Message-State: AJIora8I9zvGd9JNuwCQHNrntJClp7MrU3Bb+zoo+DAg4hB2c8v4LHYe
        151RiGRv24yeDtOxrH/0HORkCGt9/NVsfA==
X-Google-Smtp-Source: AGRyM1vQO4SVFLXk/m3bskM8Lje/RONMaeBzxxA0vfK/2I/CoxEzJjfspr5wEw83RndEmaOUwPfLqg==
X-Received: by 2002:a05:6638:d96:b0:33c:d6f8:4a8c with SMTP id l22-20020a0566380d9600b0033cd6f84a8cmr25792989jaj.146.1657151855895;
        Wed, 06 Jul 2022 16:57:35 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r16-20020a02b110000000b0032e271a558csm16360378jah.168.2022.07.06.16.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 16:57:35 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/84] 5.10.129-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f3719800-5794-3e66-2ff4-f6723da1b231@linuxfoundation.org>
Date:   Wed, 6 Jul 2022 17:57:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/5/22 5:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.129 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.129-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
