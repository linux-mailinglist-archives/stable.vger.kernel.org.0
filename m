Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FE230DE6A
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 16:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbhBCPlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 10:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbhBCPiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 10:38:52 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABC9C0613ED
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 07:38:11 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id q7so11748031iob.0
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 07:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3bZZmEPvNTfU0BVG+jBmAm8JPmiQFYSTc32EUjaMFKg=;
        b=ZsBdY0nR3PYMB25vo6O9ApIlBqSa1wM5meBOVTDYHTkZPAJaOBKrZEh7RNwP56Th9D
         eyWtqt6ndPGRew9ZJPu9zZONUEMPIz95zcxU/fSDKPagiupZdesh9rtrOijOFM0+iVZP
         aNhCyiWTWgMKZ+rMyGVTaStM1bY6g0wtXdzpM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3bZZmEPvNTfU0BVG+jBmAm8JPmiQFYSTc32EUjaMFKg=;
        b=laoixluSaNUmQs3VfXCzfZ7FR09uBP2osgOq/offNJ04nyci97vVh34aEwFkAr8F+4
         RfrnYY7vJNPmUPSCdkjsHqQnkQneqQkC80lwF4XPA27oT8pKBHwdDdVGfI+SBghrCymE
         4+JMF/HY2YHM0CKaRhkEIdfT4PUoCitB2J0vOm3CsJT6dC+7EZyrycbUpp5LqUWL9h8E
         y9bYuaIBkwRFeEQO7AqA/CvC+4adoTcTh+vpoKBB9YE+rGpkjjzF99tyD3InMxg2w6W+
         nEvTOKEQCiQOR+Iv9bdexFZOLz9tj94XCTDxMoYDl3XFBK9C0jhlXbQiwH4F8uWa1h5h
         9O8A==
X-Gm-Message-State: AOAM532ZJ4G6jgj0YDn6GAfnLOY3C02Rw70yPGDJZWK5c5AQzY76LvgS
        sWR8SHGhCxFlgab43FY4dP4xQQ==
X-Google-Smtp-Source: ABdhPJwoPbCxedwOlwGyc514eM7uCPDE5LnkMLsJSkybhZC/z0KF09qlB/cnMexhDuLwYDbjBYFIqg==
X-Received: by 2002:a5d:8ac8:: with SMTP id e8mr2959345iot.163.1612366691241;
        Wed, 03 Feb 2021 07:38:11 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i5sm1125074ilk.85.2021.02.03.07.38.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 07:38:10 -0800 (PST)
Subject: Re: [PATCH 5.10 000/142] 5.10.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d4f37799-496c-1571-d4c4-86daf34c24b5@linuxfoundation.org>
Date:   Wed, 3 Feb 2021 08:38:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/2/21 6:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.13 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

