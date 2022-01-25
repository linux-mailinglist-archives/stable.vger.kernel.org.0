Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A1849BF9B
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 00:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbiAYXfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 18:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiAYXfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 18:35:44 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05476C06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:35:44 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id h23so25568529iol.11
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HKz6SoOWU7zS0eThqikinEoRWUgnvsP0lz39rPvJds4=;
        b=NWpSjSNwypIFNiiRAMyTtGZIxSLf7TuhT+NtTDXcAGhPF5gkyfxjJ+0TuJnT33498E
         4BLUrjX4y8H6L2wpgW7buP3+uM64D2q10Ku5pQTiR0d6alaYRnMm2EWDhlW6CY0X/Ygi
         aSRgDkT/7WRby7sV01WTk6eWa8kOZp9UFEIjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HKz6SoOWU7zS0eThqikinEoRWUgnvsP0lz39rPvJds4=;
        b=5USS7zjb1x5hyocO7Oxhgr4av5W5qPcusizJfV4AFjA0Ige49Kly5bgPHKMmzHRdC0
         AwBT4NRvUjd9KOZVwGCxqN7XfsK8DbSxi1elh2dwA6H97b+xLgNUpRhGeHIKenBdpHB4
         Lf62iOw5Iq3dRr2crrymWC4kQVwx8YDp9HzkQsZZhbtTpK/aFOHgl8mp/BnT5/vnJvd6
         thEyED0M6X5+2cBHHWMvy9Q7OBqjExgBqJdmsmKAFBRaXOs5E8/Ndu+gxwjiFiF1ehuP
         BrNnaTFzflOHjTzPPfqWEwv46JLTVeseoztLXtgUSegDG91MeRqta95BaW2iiOWTmytB
         z8lA==
X-Gm-Message-State: AOAM5301EVaolSXkz3PHI5OtR4bFM1xQtj28h5/HDJxdwFflMdXKqYq2
        vinwZO46LWpi5lNmiG2nQquHbQ==
X-Google-Smtp-Source: ABdhPJw5mu/8RTfxZtznZBkLtjiT7UfdMdsxwtw0HDMkwW5idGSIl6UyD8trswmKYizrDpA79wDj1w==
X-Received: by 2002:a5d:9f44:: with SMTP id u4mr11861662iot.163.1643153743435;
        Tue, 25 Jan 2022 15:35:43 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:4ef8:d404:554b:9671? ([2601:282:8200:4c:4ef8:d404:554b:9671])
        by smtp.gmail.com with ESMTPSA id f13sm8486400ion.18.2022.01.25.15.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 15:35:43 -0800 (PST)
Subject: Re: [PATCH 4.9 000/155] 4.9.298-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220125155253.051565866@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8a4c8598-1aee-7ab5-192e-56f210c9eb29@linuxfoundation.org>
Date:   Tue, 25 Jan 2022 16:35:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220125155253.051565866@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/22 9:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.298 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.298-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
