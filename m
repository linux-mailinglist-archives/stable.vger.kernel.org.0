Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3780A484C5B
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 03:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbiAECQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 21:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbiAECQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 21:16:22 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7659DC061784
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 18:16:22 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id v10so29854172ilj.3
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 18:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q+0nAn2fljOXYCTKaU8psQRY15h8t4XyJCVyYbQvxv8=;
        b=fALgnvL9LH+efjxqnMKpe5rEH7SwzFfCSGvL0zzZWjFPSQQw1vH0wd6F9ZR5DeD6vY
         baRJiF5ZgqNKhgLYlRS2azvCMQBhC71ZhrXL2sOPprT0CpB0oY2Lc5NWFyPubK8kV6RV
         ZweeC2eNqw8l8j36QJtdvRghSI8L0S06Fa/hY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q+0nAn2fljOXYCTKaU8psQRY15h8t4XyJCVyYbQvxv8=;
        b=Dla0oI/u/ebvvZ4j/H4j2DsPddhIVvWLZPtcmw7VGwElZKAwLiWkVxeXT4GJbdKSXg
         /ZPPFym1TM7dXEVdyLsHL89GmzuhWzA35V2XKXRIFE91LxgEZOUkOVyYoas9VxXlnsys
         POIi/z1Y8i4j/5tL9Av0iGoF23roz4d1dlOxQYLxRgG9Y6Lpe6Nk3LoV+tB6vE4U37NL
         1qX4XPlsjBbQamiHhfil5DWauFvfJICx6AbL/O3pDN4JE3OcnpsalMHAmaq9h5N7YtW7
         CczMwKFeuXkRu8WF9e0ad6+nMjG1BTOFte+i2QU8ZYp/BZ8wGF7QMcb/TRFsvMGnnOL4
         y6PQ==
X-Gm-Message-State: AOAM5312LMemaU++dAHmZ42cpNGEga3N75cqt5/JRlgLO687I743eK/F
        UPcjr0ZUhxhWXn6Wd0pErE5v0A==
X-Google-Smtp-Source: ABdhPJwUAZH74PPDfkpDwMQQG3TK3yggt0UxeSfDFKfqGmps3b78HueSXIMXNlhvBz69w2OKRUVxbg==
X-Received: by 2002:a05:6e02:92d:: with SMTP id o13mr23933931ilt.49.1641348981724;
        Tue, 04 Jan 2022 18:16:21 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g20sm29205998iov.35.2022.01.04.18.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 18:16:21 -0800 (PST)
Subject: Re: [PATCH 5.15 00/72] 5.15.13-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220104073845.629257314@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <21de8f0a-bba2-c376-756a-a2b21f66b8b9@linuxfoundation.org>
Date:   Tue, 4 Jan 2022 19:16:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220104073845.629257314@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/22 12:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.13-rc2.gz
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
