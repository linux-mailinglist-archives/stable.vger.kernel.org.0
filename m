Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30214445CD9
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 01:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhKEADP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 20:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbhKEADO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 20:03:14 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6D5C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 17:00:35 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id f9so8785066ioo.11
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 17:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1D5yxs0xfIhYm8/B96+PNye8oOeNX0Jp5t6vnzcyLgE=;
        b=CVwqxTLA3nbfUKUtCv4y9LikeiI5iYtVGe8JWfYVyqwGr2eqQCYpT0cJHW06X0+Pk9
         2e6bbJb6XIS1h2wr51KxbqTbMNhKcL/pcZ9ZQco5JLnTwzFOmtQtBfnUbydQOB0uETle
         8g0kTLUx5hcHRzRkaTYfgYkf550SChau3ro+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1D5yxs0xfIhYm8/B96+PNye8oOeNX0Jp5t6vnzcyLgE=;
        b=fs8deeSTguWxd4SDhgwJB2B52r9Fj3A2B1wFThfzIB4VVsXowoopOkIcAZOpQoIlhX
         oC+2s6NKXOpJEO2ovTCL6Rq+2v5rILEiB6abpEmOyp1RONMKOtGe4q1mR6+6SPgSTWZ7
         +UMRISzd0u1iIldGvrfAhjzlAWwdGU/LkGda2VnAx/uCtycW8oV9JZEg0AijVNuhiY/j
         LitBRWsO5oilNZKjOl2kprktZLagVfvBL7q2/QTh/lagMDRfqMYJixd1K8YXMl/oTcSn
         lpwgyuAmjDb3MYHzyDnuiAiPXpg2gMcqOpQxY9Sr1LnymCtWWqNNqHTy0cepHOAA3wZH
         KGtg==
X-Gm-Message-State: AOAM53147YUZk6I+1u+q5DYpzVNZzkHzNihEiwRtaz7JCl1CSqPvAqPa
        ADVPhCbtgirhhax8aWB5RMSg6xmr535gFw==
X-Google-Smtp-Source: ABdhPJyZdOga1I3lbD3EU5Iof7Kix71f51gHO95Qu+5/LRvc2oi8ND0sV6Eu4WPte0hMPjfH4Y2ZSg==
X-Received: by 2002:a05:6602:1250:: with SMTP id o16mr8881897iou.15.1636070435438;
        Thu, 04 Nov 2021 17:00:35 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t6sm3897731iov.39.2021.11.04.17.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 17:00:34 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/14] 5.10.78-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211104170112.899181800@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <907ada00-59f3-6276-f394-7236dc41c29f@linuxfoundation.org>
Date:   Thu, 4 Nov 2021 18:00:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211104170112.899181800@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 11:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.78 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 17:01:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

rc2 is good.

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
