Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AD5383A4B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242036AbhEQQry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242214AbhEQQrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:47:49 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA465C0494FF;
        Mon, 17 May 2021 09:15:11 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id v13so3417895ple.9;
        Mon, 17 May 2021 09:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LlV1Ll+QQbUKRKwz/tVBMFCcvNLhli/v1vB7R2Id8zQ=;
        b=pUJr8otnrSWcK8A1zZu7Bzk60GjF73STrrfVIOnSCuAL8KeJVL+22esj1OHltf+rL1
         sduzR/3jeY9990q+fSNVJ8/JKAbIEQ8mxMkuHZTrZRGarmwbVFUTogMEHvBukllcBU9q
         vyCwS9bnERuZ9VxRKurWtV7mjNVFzCBebHRLdwrMPymqdt0/KCA1UbBYHWfr3aO4Q2Gu
         5ut8gEis/SkOLhgcLtE4wX8I5Ev+QE5FibqYZa+WYwmS0yi1fgFqWA8YGrIwavqcLyxL
         kgtFo8fJRer0ji6Lj3OrLdh5hJ7AJYhhykmUerW0MNaTV0c+Err0fyvUshvYr8AgCOxN
         GbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LlV1Ll+QQbUKRKwz/tVBMFCcvNLhli/v1vB7R2Id8zQ=;
        b=shQ08Spg21jfUlwVSDR9lNhBq4Qzw3n9nTN/vmvv2+Dd4WHR+uTxq6aILD9ozknsiN
         shXvdoTBuECHE81uYWwGduarzoJa7sXAKs0earzWy9WLS4Efj9Fqi2qG9wY7s/cqgUwi
         OpUhv8WL9c/fRslNdSOpII0duv9VGWf3GYaI3HaobaHYDogTXMC6KIpZna0lBtbviqDr
         T+8Sa7wCVQK0Ey3aeQ89NUL1d7pKovIUaqMEbLj+/jRUKXszo6YjjBU6upSVmv9xQoZM
         cHRMLpsvtHWZXCimZzqYLo2MoXz7A1R4P7+ATCEtbhjWwBJ2aE099EoLEuTgS3A5chVi
         1Pbg==
X-Gm-Message-State: AOAM533E0twq5o8+QZVqjTStkVT9SJ7RzfzMDfIQQ+x+JemTYvRGzG4k
        hr4YGlDdskxQz+7gq0QAXuYeuCt3SG0=
X-Google-Smtp-Source: ABdhPJxR6QS1AvxNKjeXamQHVTrOVeAv6A7Z+CSPqWRjXVpFuFB7ppCBqbeG0XysI0V8ztVNHrrEdA==
X-Received: by 2002:a17:902:ee8b:b029:ef:ab33:b835 with SMTP id a11-20020a170902ee8bb02900efab33b835mr788174pld.27.1621268110931;
        Mon, 17 May 2021 09:15:10 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y64sm10033490pfy.204.2021.05.17.09.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 09:15:10 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/363] 5.12.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210517140302.508966430@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <19a16055-1757-5476-2437-7ef9118aa5da@gmail.com>
Date:   Mon, 17 May 2021 09:15:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/17/2021 6:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.5 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
