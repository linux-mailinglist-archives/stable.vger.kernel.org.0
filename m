Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5B61F5674
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 16:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgFJODW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 10:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgFJODW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 10:03:22 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34580C03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 07:03:21 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id t25so2130417oij.7
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 07:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pdw90hnvM5VkRq8PPTPgpbDRpCg5mWZbFW6n0mIUA5o=;
        b=h7aCFKTThqYTJWpGrDz/oLADlgfZzrg+dH/UYEn7I/iJeYenhsf3CjXeQU/mrU3UNT
         BJ4aTf/BvNQ/+lh1HnRuN/Ovlonz69LrNwwXszAu4jWEl9mZUVqj0adLPlU6wL2R/OTX
         BqahRLGg1JZRYqWe41+3jnrTtbpqgdh+z/w14=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pdw90hnvM5VkRq8PPTPgpbDRpCg5mWZbFW6n0mIUA5o=;
        b=HE8OKFCCJ8/wZy4RefZTG9KtELLGq5LSUO+oXVuqVpP52vuJPlUj/UB9P9IEI+PHpW
         lO2ZAU007WaGBACVg6HodjXkLqJCXi/5xURK/82Aze3ENGyp1ge1LmBuPo4QR16yKc2W
         +rYxZLlS66LD5rZKHxCLR/ZmrKfQWTC9yVk7prUdSu4rODdQ/vf2tM6I1KqAkZem50/R
         eQi8CUZf5rtKClETIBv3tKX3PFLg8uP0y1VOqhO2ksLLr4IXO8mX5IHHMrDVXB7sefrq
         Nwui2/BXGEXjW95xa3Ukay5Plj5JsxpI+N35cbMz35ePpuWD8hrqXSQQdFhOOltZrkVu
         PVAQ==
X-Gm-Message-State: AOAM531YRcLJkswnAt9K8oAIofVRSbhZRmM5vmuWXNGO7patFcBhzKta
        eE1hH2i78I1kE7hZuQNARYQifA==
X-Google-Smtp-Source: ABdhPJwfL+uzw9PhiKOiTCEqVNkoHNohe0UEh37apdS8YNoLjVTNu66Demw0rCHHJAl87TXI230VXA==
X-Received: by 2002:aca:88c:: with SMTP id 134mr2391878oii.99.1591797800648;
        Wed, 10 Jun 2020 07:03:20 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id p9sm17621ota.24.2020.06.10.07.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 07:03:20 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/46] 4.14.184-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200609190050.275446645@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dea7a253-ba09-07d5-f52b-1419b5b68559@linuxfoundation.org>
Date:   Wed, 10 Jun 2020 08:03:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609190050.275446645@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/20 1:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.184 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 19:00:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.184-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
