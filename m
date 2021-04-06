Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E89354994
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 02:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241639AbhDFAKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 20:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbhDFAKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 20:10:21 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06C8C06174A
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 17:10:13 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id z9so11557828ilb.4
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 17:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KXGS7yTaUQBJT4Nfmy+uYfhmAKXYH/lgE75qyGxzTOQ=;
        b=GSN775B9XLMNK5cxkMFNDCTbZ030rg5E3XRkfcRhV6WvtUaj4s8YzymiZGU0gxb+oM
         8Jlva301uuyAucahEGrMX9M1dXuPfdRD9+ny7Pv3IY343zf0AG8K4Nm6+abmQbDNSr+C
         bYq08uq/uxH/C8peUxz/OqHV+MOMPHNoWmPcw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KXGS7yTaUQBJT4Nfmy+uYfhmAKXYH/lgE75qyGxzTOQ=;
        b=WS2q4IVJc0Uule0bS7++uwOQ3IJH+MdjN75zUc0egAzzRcNd40coiKSNQ6p+gitLZv
         +vxT4jXeDQRagffeaebdwsjqGdTq25UPcvi7B3LKfEMldFmJuxBY7396oDUfy466KF5D
         gUTFwlikvjCEvPAsskvII2o9vW9fQXZqcd+MJuMbuOnb91uDkJUeKI5ZPiKLjGNHxBfr
         MEyaj+62ZmjQ6pT+ZXfXYWsfVxjBQ18Oe44N/WdhNtLu/T7x5joJaGMC96pLznCGq9kk
         v+le/ucD3w3pUnRcNJ2lXSBiLDJf0wp1rMxX6+GOAXwh9v9VX9vshm5WM/LFdWlggGRy
         ar1A==
X-Gm-Message-State: AOAM530oenZyiwvJmBY0pMG3G1QBhFSmBixCnUJFZ0yOnFGH1uVPGXIe
        ZJfXTSv1gfREZHIAfnt8B+k8dw==
X-Google-Smtp-Source: ABdhPJxNr8CvnyAK/aekRq3rxVmP2zHZKM0GsGqp73ji15JoLwDcxIec9/6LyB30wpA1PdeRYcxEpg==
X-Received: by 2002:a92:cd0d:: with SMTP id z13mr12408126iln.250.1617667813468;
        Mon, 05 Apr 2021 17:10:13 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a7sm11467390ilj.64.2021.04.05.17.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 17:10:13 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/126] 5.10.28-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <440c2a61-5921-d46f-a3a5-717a2da5e0ff@linuxfoundation.org>
Date:   Mon, 5 Apr 2021 18:10:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/21 2:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.28 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.28-rc1.gz
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

