Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DF7409DEA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 22:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbhIMUJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 16:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbhIMUJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 16:09:01 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69486C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:07:45 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id a22so13768117iok.12
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xrSjRouShDxh+cd6XLeGxO72TkXUz58vPuKNHHgsT2M=;
        b=fkVD1OVQBqE5rue2HNLdLXb2O6GomcPIbu1yCsbf4XiAXGO3u38T+b1ZDzyivogyhn
         mihR2Z4w8F/zgPdtvITK14y65ok/se+sstNSG+IjuHK3KO+QTvvYWN8+is/gvkzCvb0U
         zBBabR/npj1jzXSu/EAXo0FJTpZs3VAnDVCp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xrSjRouShDxh+cd6XLeGxO72TkXUz58vPuKNHHgsT2M=;
        b=Q8EvJx3UsDyscFPren8MWhNtNzFmB5kiwWtBNLAR33EVu/gKSkINQkHrhn2vVEozD8
         VDwkpPpTe87Du263uvNCSjRIT3ercE7aM4fFlaOPjFqxYV8x+fUexDJsbFvehjRIEO94
         V6jvgzAz+0CBOOFpMpw0X3Ky+/MYt2YZfmgk/wl4r0YfgvzEbF5MLOygS2fMvcmNhDh/
         jBfdjKbcqNxKQSvFTykmTAeOJiMPcvg+d+QyXhbwwD2W2E1Az/Ny7OQewmQAJESxesp+
         7dYhRWAHVTftIC0TS1/SEv4kS1Obf3sf1LMjg43wWrRVF3IojYaJ13Zjdv4UeTDqv9aC
         1FlA==
X-Gm-Message-State: AOAM533lFXF+xm4bWtpo7ZiZGHeSD9rxzrWQ0U4rswb+4oortP9VVFTj
        yNStO5NHfmkH1ypo3Dkg6MBa/g==
X-Google-Smtp-Source: ABdhPJwA1tbFlbu7nAMGCFjmH4dJumFGRQZext6NRWKa5WClpGED3Ez/93YY45oGsKjMnQ/lqc1TFw==
X-Received: by 2002:a05:6638:2191:: with SMTP id s17mr11386371jaj.87.1631563664862;
        Mon, 13 Sep 2021 13:07:44 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y15sm3938706ilc.32.2021.09.13.13.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 13:07:44 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/236] 5.10.65-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9c65bb97-7996-f018-60fb-8112c871ed39@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 14:07:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/21 7:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.65 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.65-rc1.gz
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
