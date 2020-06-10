Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B738B1F557F
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 15:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgFJNN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 09:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbgFJNN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 09:13:58 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1543C03E96F
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 06:13:57 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id n6so1671171otl.0
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 06:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=njgzj9HQCEKqgSx9E2K8l281h/MJdRNifxNxBU5g88I=;
        b=a8Zlx9OYBts380NOVCALgu02QeDq+X3BIpM9/p+70QnVNofe1BBU22C+vn2CTeKFWq
         hlrZxtNxXNN9Hq5+f/unaBA98b4O75CegDo+VLzqMEXGDLKgWNrdnnbsF08hVtmrsxz2
         pp2qxVlvt/awq3w6CTDAx97EdNRT4uwa9KpPs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=njgzj9HQCEKqgSx9E2K8l281h/MJdRNifxNxBU5g88I=;
        b=XG6/EVJ3uv5P1nVbyOjYle9eubApx+3cnisZXOY+JER06E8bAQpIAf2qLH4YUee8Xr
         2OOo7qv9uiW1zC1cXhg/CM7TCxeXmDZOqud1FE2kt+1Uo/oth9xwN5wY/EuH9nM9I7z8
         iTP6OoG84QBhB0qmds1Xoh5HsQokVEvqFMvTQZXJ80OOLrtKoAEsBl1JyUVSUURPpTlm
         DP2Y3EE7iw4jnN507TYbLpGS5DUwSmHh5xFH4XSfxLF+SHHrjRpBP01liLvOAPBDfxOO
         a/CJrXc2VYRht05CaCxN8vvRcH4mX0Ov9wfzdKdeWxS8vnf5jhm5ecC4KiVENIkwNco+
         Hiqg==
X-Gm-Message-State: AOAM530lG3mCGgboom3jzLKJtccuZ1E6GQBuKK8+WLoqqOTXZ2kAN/c8
        dZoeBiM0nrPjLPYG+VHp6K8g/g==
X-Google-Smtp-Source: ABdhPJy0acUQrvKR0gU7PJ780BA5BZUqpa60MVgJ7NmqHt48tGw1j8iQ0jdUfoBz2/PlWbKgUbdASg==
X-Received: by 2002:a9d:145:: with SMTP id 63mr2444915otu.141.1591794836904;
        Wed, 10 Jun 2020 06:13:56 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x32sm2841859ota.50.2020.06.10.06.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 06:13:56 -0700 (PDT)
Subject: Re: [PATCH 5.7 00/24] 5.7.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200609174149.255223112@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1c3f7784-3d9c-4b40-7e96-99f230f251fb@linuxfoundation.org>
Date:   Wed, 10 Jun 2020 07:13:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609174149.255223112@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/20 11:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.2 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 17:41:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
