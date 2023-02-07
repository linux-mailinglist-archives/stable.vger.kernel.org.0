Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABBD568E2ED
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 22:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjBGVZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 16:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBGVZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 16:25:02 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646F030189
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:24:29 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id b9so209177ilh.12
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 13:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CwNrp0wPjawkXQ4pgo3vF34Zz65SWl2SKe6RPVCwp40=;
        b=JnfWNI9WF1Og9HwYdC10DMIJ/Ubmxm8HFyfL9slftQIAv4nGypDARzTTUqvwkXYu6w
         W1DSBjnMSDr/ZIKXhvY1iLX50rH7rxP02a+Jq6vEfKJnlrguwmyjgTLPm7iqHpBJR2Gb
         KjGIZfUzn5KUC2cWDU2DVP5/FNaa31RJIH2aM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwNrp0wPjawkXQ4pgo3vF34Zz65SWl2SKe6RPVCwp40=;
        b=BSaFYNmWK2q5GPVzVrY298jtVvkIZGxl/bONIhaIC8Qdktet9VrayfkD1mjGHXuGQz
         UhXpvl/kRLWDDVdGK04528uuD1UlQZXtPUsOMqP2TbQUbGu+pOkDrh/3MPwnSfe0FiEJ
         PUxNEX954f8nE/gXnYLYlGro9J6AP3FDWp7DaDODFUklwSIFHz3mR5+d2DQvV/N+TNcI
         A0HohabD6SAa2bZh8VR5bncHt1xIw5fPGCSvO+D03v7w7uUU55tJHPiQLQCXca8ypwGt
         uUkedOc30M+HL2IBWRXi+1J5VVdXjfq3MDMblb4OWCkOANuni+2XcMacFfrIpwx5McR2
         vobA==
X-Gm-Message-State: AO0yUKVh5oJj6yjTwHb7eXpLNZLDPf0AQnDCX0ev4Sv7kH94C5XGSDlg
        pSOmcNq/XuOoF+4/6wELWi7n8A==
X-Google-Smtp-Source: AK7set+kLYg29Y8Ds31MGdldXvAFpoUCi1y5hm7b3AqFWhM1L9Q/UeH2A1i6HoKOTpUCJIEDG0lHWA==
X-Received: by 2002:a05:6e02:216e:b0:310:cc70:a152 with SMTP id s14-20020a056e02216e00b00310cc70a152mr4700440ilv.2.1675805067511;
        Tue, 07 Feb 2023 13:24:27 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n4-20020a92d9c4000000b00310a40e669esm1715750ilq.11.2023.02.07.13.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 13:24:26 -0800 (PST)
Message-ID: <1b7d164f-8e91-c178-9d83-98ef1987b3c9@linuxfoundation.org>
Date:   Tue, 7 Feb 2023 14:24:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
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
References: <20230207125618.699726054@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/23 05:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
