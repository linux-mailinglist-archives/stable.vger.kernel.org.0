Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B8448A33C
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 23:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345532AbiAJW4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 17:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241701AbiAJW4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 17:56:23 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D92C061748
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 14:56:22 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id o20so6356193ill.0
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 14:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bTttcHXOnkvSY07PRTWa34Cn+F9J8tjVeXVX5DcSxF0=;
        b=Ctc/0JzdBgxFMpqCWUenXAGI24wvzW4jluyB8g3u//AvcUMVkZ4DlzLbaONzVRRBfK
         OGp+Gnf1u7jioUdjPJWIgjS0Kb7QV7MZMFxfKG1Vy8pSBiFuu4SHpiZ6B44tve7wGbRb
         mHePbrzF62K/TwKitzyydUzvbB0zngLC4Est8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bTttcHXOnkvSY07PRTWa34Cn+F9J8tjVeXVX5DcSxF0=;
        b=f/Zod28fUVHYm4N72LDKiMcjP+GxAWUy5AK8NtTZDPgIe83DvCVBsGHyinFkKawTBP
         HJwleqT6gpVlOoA3UzmR1Vt1wGeiXlML7ze+50bDXnoe0rayol47uWHDQsSThvymAnOh
         76HwYZ1MEzkJz/2zJjI1/AiNRK28ZktiwHwOeP5/F+2Vcta6vryzHpWAzHxCVtjAEtS9
         47/IyLosn075eVa5Ux1fT6ubq82Ak5WcxctJ1TwvWsKAa3jLpSr57v/dWWfVjp2gl4fP
         M47BFI/e47lD/xoyKkaRIrWkCt1n9WkbhSbS3GpQrdgdqCJ26xYCYhsYp9KWYW7fhSm7
         havQ==
X-Gm-Message-State: AOAM532mmogOMviBNaddYVtyPRrndXB9P3FomNCEK+seL6QykJiycR2w
        gAxu8Pr+iETDYeaT+3k8Q6jfwg==
X-Google-Smtp-Source: ABdhPJy/xjJ9SDzforAA/m2lp86qBo8vsnc4XNGWr8PpAeAWyjUDRDlKYT9eAdv8kelP3CJ4ZWVIXA==
X-Received: by 2002:a05:6e02:d4c:: with SMTP id h12mr989065ilj.238.1641855382051;
        Mon, 10 Jan 2022 14:56:22 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y15sm4865335ill.15.2022.01.10.14.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 14:56:21 -0800 (PST)
Subject: Re: [PATCH 5.10 00/43] 5.10.91-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <efd52fa9-74f1-9ec1-0dfd-2c47e856e7a4@linuxfoundation.org>
Date:   Mon, 10 Jan 2022 15:56:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/22 12:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.91 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.91-rc1.gz
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
