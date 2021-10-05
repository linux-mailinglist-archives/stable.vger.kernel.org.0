Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8564E422FDE
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 20:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhJESYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 14:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbhJESX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 14:23:58 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B29C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 11:22:08 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id w10so285213ilc.13
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 11:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I47a5XccqHp5WPXXGZRiu/Dv9EaAb779josJA9Tm25k=;
        b=GgEENsyRJse1UKNMWZ7YlywFDIqEjVcJgfei15P1UAelcvA7xU2Uw2/LWg/GSmz3Jy
         MFZFcTQyCdFjrMzUkAahASerFJO8ZpjiDuarxkj52wl8wFsCWC89Cuhky0Kx+f0NgMMp
         m5dWny2Um81MvO/xgA50pvHGMR8mjEDYmUUoM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I47a5XccqHp5WPXXGZRiu/Dv9EaAb779josJA9Tm25k=;
        b=S52XXdXT/ZBdQZTrZASWejGjQHCqo2a96ViF16VZX+x6hKst3LzZo6JsEu0mZpKi6r
         Oxbu8UV1eyMxPNjh4n1QSaAk1P1uRhHFGtl2NqHoP+DHzNSFkOqfd5/ZV9od6Kl/AGLA
         GJazB4z3dxHMjJwTu4DKLh3Tr4TBAg7HzrjxS9Hh3ahBWQe7CPyW+bPBtPpR0I5o9sQC
         cfvF+DAEyYqcCprrTGT/1QzoU5EaTEnfRAZUKLDq5F7puqm+qiIKLboA9U99kRO3fDFM
         YCp6AJ4U34e16oTRKTacfzwqVCxNMJwBRNdD1bH9ntuDNVGb1rCBWbFs89bXRVm0Qefk
         S1dQ==
X-Gm-Message-State: AOAM533puos+Rjjq+gthQ4dHA0zLunF/Vs01iKT+LEejn5cSI+Zr2iqI
        exhhBJL8mnFMdkES/p84ZQ9fsg==
X-Google-Smtp-Source: ABdhPJz4PpMrr1g8z2vRvxFzmWL2d1fST6ujt99eWe/5P4Vt4L1zoBcyptW2NP5Qch960Y92mgQkuQ==
X-Received: by 2002:a05:6e02:14c8:: with SMTP id o8mr3883399ilk.125.1633458127515;
        Tue, 05 Oct 2021 11:22:07 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m5sm6510972ild.45.2021.10.05.11.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 11:22:07 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/92] 5.10.71-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211005083301.812942169@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e318ff19-ad8c-6d68-e7b5-585cd0f11a72@linuxfoundation.org>
Date:   Tue, 5 Oct 2021 12:22:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211005083301.812942169@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/21 2:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.71-rc2.gz
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
