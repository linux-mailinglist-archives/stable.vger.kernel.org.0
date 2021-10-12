Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0105442AB84
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 20:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhJLSFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 14:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbhJLSFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 14:05:18 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E27C061766
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 11:03:16 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id r134so13497119iod.11
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 11:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GOQ7BI06TuQFnWKE95urhuyEQmkXfr9xNZ1rfiCFcV0=;
        b=RwSdJqOuePUATzmfdatP6ktUs3JxP9wNWjs16CRFzEqdd/xXGIfNM8t4F3czA4anrL
         hQhHFVhqd48gQEYx7HSjSfObDYkCahUVRP4o54R77tnBk7psm8UbSWgvk2yijzgxCYWN
         0HAqgKpsQWRXPYf2cs8//o0mv8Cajvitl3KrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GOQ7BI06TuQFnWKE95urhuyEQmkXfr9xNZ1rfiCFcV0=;
        b=AscOF8MMbJ1wezLPmuUMUWLKEd5kT9X+IzhEVrZusgu7OfrqIIDYDl/e8rljyWv2Qf
         79iJGPrCL5Kl9/YP0KOiMuWk5cVpgdwtOyFX/VR06NqNbt0E2VnqHAyp3nP7zFhGcJ2G
         jZcuPiTIxt7MpA+q8eWsPsSMz8z0HMmr37KSN0cphEZjvlECIeQSgRgcJ2jnD/CWH2Xs
         eVS4W3FTk3jte+By3K0O6kD38xR0MB5/Z03pNACDa++sgptRZz/XjTCUdCCOlyd+lMYe
         kUaUDbB/iaQeg1VeaZAYVuoc3HKqfHeT0EgBImaurLsUlhcDHb2My8IbADTmQ04pmUKy
         4/9A==
X-Gm-Message-State: AOAM532dMvKfCK7HLOEJ8TzYgLUDHvtlTkzzyn7cXl3i3mRx4/6S6g+4
        q+m7pmAgFeDqXLDlvOanIIe8lA==
X-Google-Smtp-Source: ABdhPJyQFE9NIO88ezFrovRwy7kSPNRlvvwTcWfbwkaLqGp8m0iruwe9NgNW5K+thX1EzJeLzEWNtw==
X-Received: by 2002:a6b:cd87:: with SMTP id d129mr24158588iog.28.1634061794661;
        Tue, 12 Oct 2021 11:03:14 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l12sm6065944ilh.19.2021.10.12.11.03.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 11:03:14 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/27] 4.19.211-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211012093340.313468813@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <55ceb757-9aba-4f48-8d2f-5f42cb1a7858@linuxfoundation.org>
Date:   Tue, 12 Oct 2021 12:03:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211012093340.313468813@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/21 3:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.211 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.211-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
