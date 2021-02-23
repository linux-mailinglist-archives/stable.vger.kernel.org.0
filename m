Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33A83232D0
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 22:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhBWVGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 16:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhBWVGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 16:06:03 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17CFC061797
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:05:22 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id k2so7504511ili.4
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c3RehyzuH44BmPSKBGtGVp5L8IieBhou8Wpndl5FIew=;
        b=BZxyZaQs1wlH7DrP3DUSGpkMxZtbLuGnG9p9Hqdov6+BUiM+54gDEALDsGgjsIrmNu
         XKObTH4fMf86DHa5/SuHVaFGuGY/gQw6t/lOlVa2psrsnOWRT+hsc9nYa/dePP6DxOf3
         IFIhVT/8VCqXpOhL1VJBeRQCn9FI+wnAjShhI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c3RehyzuH44BmPSKBGtGVp5L8IieBhou8Wpndl5FIew=;
        b=TpewL/Bmil/o9dGv6i2cGFM6sJZm1jwIPtyxDiRdkn2t9UYgqa/BK+p6Rh3gpzhDfq
         VhMItgrY0OXeAAe+ZUIfeHaJER7x+Vp+MnNiG3lbeGID/hBbSuAPWQcfFkHcuGId4sRU
         /ePLsu/5Ku+WuAt3i5KKpYnmmDu9qancDv0MDwIR1TknVGXkSgL5ZL5lYK4W65J0ncXR
         Csovy3GA/ZGjRgN91uP41fVH7hyyZ0k43d5htzip4DBKFhwfJJZrl7/TGQtBYLwcm9BD
         OsWsLNr6x4QJxxglzdNMjBZiLe5njc893kKFzwyk5/qH5kAE/9lIO9aQmc3xH949a9KW
         oJ+g==
X-Gm-Message-State: AOAM532Ecsb4e7QHfELakXdtz6whwA0rBa41M2Hf35dKtpymNmxa0JH4
        lZlKPTebIYCfrt3fVED+IzSWd+9ektX1cw==
X-Google-Smtp-Source: ABdhPJy5tMS4KoDPNcJmKap+niX22+vDspCA8t3shIXr3UP7jbvVpqggYPf6IC1V4N9OTlxBZ93vqg==
X-Received: by 2002:a92:cccb:: with SMTP id u11mr20842578ilq.44.1614114322364;
        Tue, 23 Feb 2021 13:05:22 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q16sm15526176iod.34.2021.02.23.13.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 13:05:21 -0800 (PST)
Subject: Re: [PATCH 5.11 00/12] 5.11.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210222121013.586597942@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9edd3b90-aa95-379f-01b1-ccbb3afec6ce@linuxfoundation.org>
Date:   Tue, 23 Feb 2021 14:05:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210222121013.586597942@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/21 5:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

I made some progress on the drm/amdgpu display and kepboard
problem.

My system has
  amdgpu: ATOM BIOS: 113-RENOIR-026

I narrowed it down to the following as a possible lead to
start looking:
amdgpu 0000:0b:00.0: [drm] Cannot find any crtc or sizes

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
