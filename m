Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55693480D5C
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 22:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbhL1V2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 16:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhL1V2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 16:28:11 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE27C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 13:28:10 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id u8so15216577ilk.0
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 13:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U0i6C6jhiuFeYmVsA5V9mjRrKbGLhLeQXQni6u0OplQ=;
        b=NJIwQvTiQ/RXehGSKYLEHqwVjzoLZoO4GgcwuiDXwocXwLyO4ZAG5tFfmeiLNbPNyz
         m2vUgtAKK/aemuiWgmGzACXnuhhRYcYTDvveKOeB4sEEGHGwgF1kn7DfZGAMF24NKTZC
         VFkVNWXmWNI8VtZi0RErX6kVvxjhnDnqVAuYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U0i6C6jhiuFeYmVsA5V9mjRrKbGLhLeQXQni6u0OplQ=;
        b=biMqAzjjRFeaO5iPC18MjDIfMC8SJGIdLO5xeYWQ6ZxQ9ph5EJvg96G2jIIEV4OjVK
         ULiSHWJwNx0xAc4rSuGkWIAuiTaBZ0Ta2Fe1/QxqTaonIpOjneoGMeD3kI7Grk1V4IPC
         z0xug8ToxycHvETlrQ3gffTVTTLIbM5a82KZsFmEG2MNq/ZH1YCcKaLOrzDxXZqEWKE2
         ii9Uue16BsHMZBECejqEMI2U0qrll3HV8/fuCGUbgDzOZiAEAyHCC64mBOYdvye7M5j7
         IENWhaV+So/zrCHHykgVFu9zdxE8R1GTn6g40s3rXBdy8+bQzMydrmdXt33wZIV4kE7/
         ATjA==
X-Gm-Message-State: AOAM533rB4RFWI0+C3aX5+sN7+52PVPaueQxcCoYzyqh1CteGzyvY9xl
        SpMddplAoOBj2wVgi57sqEsxsQ==
X-Google-Smtp-Source: ABdhPJz3UlnP7RVN+Kr/D4ZUsgFkHwdJK0FDS/+9GpkNncrTQNu+YyJc4COOAgEHkzehy9BM55SKcg==
X-Received: by 2002:a05:6e02:1949:: with SMTP id x9mr10817058ilu.63.1640726890224;
        Tue, 28 Dec 2021 13:28:10 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j23sm10913696ila.29.2021.12.28.13.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 13:28:10 -0800 (PST)
Subject: Re: [PATCH 5.4 00/47] 5.4.169-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e60d1a68-2c3b-50ea-e232-0aef52f4555f@linuxfoundation.org>
Date:   Tue, 28 Dec 2021 14:28:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/27/21 8:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.169 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.169-rc1.gz
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
