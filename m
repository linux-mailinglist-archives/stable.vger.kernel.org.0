Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD885ABAC7
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 00:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiIBWVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 18:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiIBWVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 18:21:09 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3AED6BA4
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 15:21:08 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id y17so1904245ilb.4
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 15:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=qIAlHU7UuDNsvYof5G3npT5LqPagIegpmcaq0Vhy7+w=;
        b=DYK+5B+cN0ObC5xaauwjZqcGeH5iV9NRTNw1Osz3MaafJGtJQdks+XtvONqk76trZD
         qjU1cbWYsLY0PXD7WCEW3ZTg6Cbggs5OqfUt5ujDak1SV/BpNMC/mnkAuns7rLEXagjr
         b4mdlq1ijjLnPa9IPnZLyI+9TMFKYQq0c26DE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qIAlHU7UuDNsvYof5G3npT5LqPagIegpmcaq0Vhy7+w=;
        b=YUEHte8oJzZL7bwGjexrnxWuGs104bGVWvu1gL7yoYGK7GEuVpsqVeh8nqvwmSFqeL
         lGaYmfBK3AHbp4gboCeUuq33yWRcbVedgkU/qqvzin9oTxa5zbjJjH9K9XWviEwQV4kE
         0cmxaNM77NlhYd0l6bKoZdjKe3Cie3cvdl89+LVe8seM51Mhrciz/iKldUsGIOx+qINB
         WleefVESXwX5uBl30+u7OuauoO88KTF5kAOT0qddPsHH4vZ6NGgEgpKgXNw6XneeYzGv
         ujRR8YQBHaTbrL2tR9GXOVmMLnWa8BWUQ+DMcoUcm+TOTfbUDFhg6QZ0/HEMTTMZX1YV
         RxDg==
X-Gm-Message-State: ACgBeo2UQkYeQ27Too8Dl4RbSM/eb5JAHmnAzajOGkbvL2IMGmkN6sf1
        Wbugpe9ALMZGUdURnN87DnxnKQ==
X-Google-Smtp-Source: AA6agR5m9kKUsLHkbDajIjT+8X6Ma84xV7FEJUUe1QSVZNfffESTec/g9kwHWmwhYPU8JRbUhSbW9w==
X-Received: by 2002:a92:dcc2:0:b0:2e4:38f2:a9f6 with SMTP id b2-20020a92dcc2000000b002e438f2a9f6mr20655159ilr.130.1662157268015;
        Fri, 02 Sep 2022 15:21:08 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q11-20020a056e02096b00b002e78e954dedsm1241592ilt.83.2022.09.02.15.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 15:21:07 -0700 (PDT)
Message-ID: <84bd38c7-328b-473f-24e9-2edb2ebfaa33@linuxfoundation.org>
Date:   Fri, 2 Sep 2022 16:21:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.9 00/31] 4.9.327-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220902121356.732130937@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/22 06:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.327 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.327-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
