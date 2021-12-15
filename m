Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643D34764ED
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 22:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhLOVwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 16:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhLOVwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 16:52:00 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7E6C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:52:00 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id c3so32399129iob.6
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=16f82q5b47k1gdpLHEW3eH/SnI2SpnjFCnwxm0Vn8wU=;
        b=WtiEqTnsceW8JqiTrXgwz26B91YQU6PJtiR65L8BRnrruRMdDBf7+C+2c8GXMrU8jj
         UJ4H3do01B7FObyVgEfJYzpiUIOpXUUYLVaeJwCv32OaNqjf9iSdmUDBD+C0ZFtfkLF+
         7mUsBl4MElHQzckJdN4bofOEFpG4Bi33SUPhw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=16f82q5b47k1gdpLHEW3eH/SnI2SpnjFCnwxm0Vn8wU=;
        b=JiRnxwxzUO1JL9zKGp5EcgdFo41eBUfPUGRYFe2q2qMARb9hrcoHIiK+1d3+YuR2S3
         z79cJ96xYFMt7BtxA3ftKOlMIJKzBSv8XqQb6uOi4rJUV6b8VOjc5os/bFsmtPpnJYpr
         /1kheczkafUoP0kXUN0MJPw3GDFrIZP+NeesUnFiq/PWwrmhFoQAP1uPME3VK6Lhkcug
         hJfdjQ3cfpSh4Sm+weWPB2tScx45+JlW9mpqvSZoBo1FVIkYaqkqSiT5LCNVGXqB0Xm0
         Spsr1o365GiGNoMBhRtUxhwnorsx/kHq7nbasNXX25JOrUneXBX7DFEVXCEdKyH6zgdv
         mFzQ==
X-Gm-Message-State: AOAM533vc9K1QhNw7WffWrZ09c04IQPHkOGh8Ime1a+ZAWc4zTe1BJOD
        N+0L3fiEQXRrQxVKlz6CcL+ERA==
X-Google-Smtp-Source: ABdhPJyoQ3Gre/iwqpR5ibF8cIRZwZNJcr6fFVJyr/836gc/3PBZjh28Bc5FXtgFK+9faqRpsdqeMQ==
X-Received: by 2002:a05:6638:3a4:: with SMTP id z4mr7345226jap.76.1639605119775;
        Wed, 15 Dec 2021 13:51:59 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s21sm1576479ioj.11.2021.12.15.13.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 13:51:59 -0800 (PST)
Subject: Re: [PATCH 5.15 00/42] 5.15.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c594b2e9-2a5a-f687-7e6f-db9997ac24eb@linuxfoundation.org>
Date:   Wed, 15 Dec 2021 14:51:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/21 10:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.9 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.9-rc1.gz
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

