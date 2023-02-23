Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB1F6A13DB
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 00:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjBWXjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 18:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBWXjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 18:39:04 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A8016ACD
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 15:39:03 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id h10so2042270ila.11
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 15:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lsTG0FwmjQUr8gaZ4XIHrpahplxKBBfScZGNbgfy4VI=;
        b=Lg29eO1NWuiVzLsytUG/ShQCC92533DRbmqFrEX1/DPQgBCcuPm7seh/KNeZSi3Qqx
         szhm3z0jWm44HU9SJscqSzlAhbVX0uxKA6g8NWWSevpovZKyfNbOOiOMSw3wv6JAgvmt
         xx2HlzfxNGb2YFuNj8XiJEtXZEDb9d32nUm6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lsTG0FwmjQUr8gaZ4XIHrpahplxKBBfScZGNbgfy4VI=;
        b=MLqMMnhZO5AcwMDLYHK782XU10Oenygs75YIbykFiKqOdNE1fxOB/l8aJVDeaX3dEh
         WZIlfmR9QDGPHTFf4mBa5DYVOl0LRBozjMBFmMjxeqy+aSP2cAYKjgzJWK2F2Hw8TN/I
         fv/JTIhBYRZuOzS3BHPkmRmpk40L/nt2YDAOyNlin3sonj8McVFEBGKzrqJDL3ZWh6/C
         jxhGAeeoopu5TaPg/OWF1ZJqy1bvR3li4LaDyRhyuIJps5yv7Qy8Hk20yiGG3L2HRPCM
         Jc9vyo5hmNsRIskwpSaINQBxd4q8FdNLMqmEbuVfHZqTR9+g82qxeiaJBskDR3tcB+OS
         5n/w==
X-Gm-Message-State: AO0yUKWhVVFEmPV+PwN6TzbvsHn/E36jFSUnPRU4BegkYKC3e0gfg0xj
        mhvVSeTYGWMFz+H7GofATv48nA==
X-Google-Smtp-Source: AK7set996W7EQ94N8uwtK4I40yH1eBvB/ADZjQyUwT3eY3/TCJvmTfXR0icA5PWKybCohDe9y/Pu7g==
X-Received: by 2002:a92:c706:0:b0:316:ef1e:5e1f with SMTP id a6-20020a92c706000000b00316ef1e5e1fmr3771399ilp.1.1677195542501;
        Thu, 23 Feb 2023 15:39:02 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k6-20020a02a706000000b003c505bdf305sm2424635jam.141.2023.02.23.15.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 15:39:01 -0800 (PST)
Message-ID: <12776196-f79c-03c0-eab2-1a69945be8bd@linuxfoundation.org>
Date:   Thu, 23 Feb 2023 16:39:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230223141539.591151658@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.233-rc2.gz
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
