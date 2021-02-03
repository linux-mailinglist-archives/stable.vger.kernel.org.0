Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018E330DE81
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 16:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhBCPoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 10:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbhBCPnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 10:43:52 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A138BC061573
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 07:43:12 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id f8so5201331ion.4
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 07:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H9QtEYwbeG6TB7tbzcyX1SBQ8q6hSGSzJ38AuQx4mn8=;
        b=dvcig4AoYqWYqajCSuzmMDuk6fwIDf5wXZsupbQIdbuF0NKmlEXaD7f6b4xrTcAZrQ
         s/sBcLeVNEeYokbquvJGPMN6pEuqBQbRNzbvhhPScvXv2rllfwKZwPFL6U2am3S5sBrJ
         W7FaABrgBqkhVKCoUABllxxsiuIS/XlfnSY/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H9QtEYwbeG6TB7tbzcyX1SBQ8q6hSGSzJ38AuQx4mn8=;
        b=ExYlSjB2r6w1kKXLLdLCnSBKrqLeZji2Wg+7G4mYB9mx9LYxji+s0xmjsJKRVdRvlS
         6MPuPOd3WEG97dJyNxltNCr8L+BNwg5G2fq1pH+8LG8zgDqTiGccFbRtoT8yx0z4+9ts
         0PQeM+7cxN5RQeUwXocD0mS1qlqulWu3M3YDNMnSGTmAXWgl7qoUiV83IIO+aGnxGvDQ
         s6XQ8NdIDCqKZl1ZkkhgsYKdeEooHxQjAjf0la5QPfSjSdlhW6yGdKC1nCweoIMiniuE
         tdZidpJ2PmlnyEhvUdKedLBeq6khBY0gpaQAwQllo+1Z4xY1ZIOu5fxKTs+9V1yrq1TZ
         +M4g==
X-Gm-Message-State: AOAM5321yqoOYf8CjsFb+II1pALX0gpRTc2zTt79d3yGHs6uJg7AQ+MP
        5g4fexREoclmhG05tUDhesPNwg==
X-Google-Smtp-Source: ABdhPJx+oC5wgZhSWHWGL2CHRQ8s5rdFfZcG4QRK9O5aEsqZUkQf7oyJ7h1jUNpsqyB5/rrkM+v3xg==
X-Received: by 2002:a05:6638:35a3:: with SMTP id v35mr3609382jal.36.1612366992180;
        Wed, 03 Feb 2021 07:43:12 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id e15sm1241842iog.24.2021.02.03.07.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 07:43:11 -0800 (PST)
Subject: Re: [PATCH 4.4 00/28] 4.4.255-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210202132941.180062901@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2a54aab2-80b3-5834-9854-a98fd48ac80f@linuxfoundation.org>
Date:   Wed, 3 Feb 2021 08:43:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/2/21 6:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.255 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.255-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
