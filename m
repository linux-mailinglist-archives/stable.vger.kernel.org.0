Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F12480D5A
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 22:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhL1V1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 16:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbhL1V1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 16:27:11 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63CAC06173E
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 13:27:10 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id p65so24017779iof.3
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 13:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JgdMlwa0nw+2thxoTWVkRyHK/QKXQ6g7B93m9FmuVtw=;
        b=aRVlVpkk2Txv6EKynVgK9qE/oUZKXmgqZqxbwNosrwe6hdA4w8TBw94ayBrH8MGpdm
         fdssUdmFU89R+3r65Qe5cEMhmZ0iQTKooyKW1ENRbjrcCdAONUJaBmNFYGxh5UJtshIa
         IFjDHtzK9IY+MoLny+71lBgDRiKuEVOKRNshk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JgdMlwa0nw+2thxoTWVkRyHK/QKXQ6g7B93m9FmuVtw=;
        b=J2lAeqE8WADkZufkH9Te3slCJDqOf3iwDsXNxCgNmTZVtC7fIn1EP8q+qgx+fLqPCR
         gSr6uBIg2S7DOPEeEol5f9VLPTAZ+2bDT+PWm3/KbTnMSsS+iPEdGgyivPF5FPV1ZTcD
         AL0ZWwyCKkpuOM+xviDaCOpjybib43spk6Uh+SdCsm0T8FP7NL4xIpJWI9nzd9nJHBuU
         jAU0wE0RkKndaR8I2BHE2atZHRtQAVbnJbDmS5nfE25oEpT/z1ydAhT3DwT1CmPICrqk
         JMhKgPTng9nrwuMRH/tizxnomRjmg8QB6o8GkUJ5GZ9/NdFxBGfLdLVFRLiqDJsU7IfB
         ZGIA==
X-Gm-Message-State: AOAM5313i7Fr80cdcL2fw5mdAj+eksHOOAj0C4tL+f97rAmU1tqjFDxy
        TnVR1SFhgOp+MmYGL5ghO54BMiz2r+48wA==
X-Google-Smtp-Source: ABdhPJydjTKENoyq5b+Amg0pk6F147Mc8/cGrR8shA3NbbYtQnwH/cRjE0vFBL0aWIHuYAt9KLz5YA==
X-Received: by 2002:a6b:e70d:: with SMTP id b13mr10331535ioh.5.1640726830175;
        Tue, 28 Dec 2021 13:27:10 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g11sm11992978ile.78.2021.12.28.13.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 13:27:09 -0800 (PST)
Subject: Re: [PATCH 5.10 00/76] 5.10.89-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e939ba7f-8d13-aa88-02fd-c2cc9e70e93c@linuxfoundation.org>
Date:   Tue, 28 Dec 2021 14:27:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/27/21 8:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.89 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.89-rc1.gz
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
