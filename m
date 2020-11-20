Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2352BB8F4
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 23:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgKTW1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 17:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgKTW1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 17:27:30 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D19C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 14:27:30 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id i18so11576564ioa.3
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 14:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aV+pNIDXkddGU9iTUO7Ob/ljgy2kOSHyirUCMlXt0Cs=;
        b=NQZ51caNtaapeMQ18LePmkANnb94TcvnctzX68qJmaj48JJh2wFfHaQnYOl2s1hUs/
         TTxZ9qqW1GYbN7+BDHrPldtizuNhe6Oc7G4Ddz3txAtECCojnZX8GHtbDqGs/tpbYZR/
         ROAQjwuijXNaCCf6yds6UhAdV6Hij4wxc5zQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aV+pNIDXkddGU9iTUO7Ob/ljgy2kOSHyirUCMlXt0Cs=;
        b=uLLTTTNU3GTJusrmMt95Ln0Qbg3J4+x4b7/QkyKOXdr10Pezh4WKspcVBGgd0Mq8pf
         CVEv9LyOlnry/UEby4TuaD65TMOC3BIuftih5Dmv7qDLFYWXV+5VHmmgTJx9cyo6a3sJ
         psW0DTh4p1FdteyMwiiJODVuGSegr/vHa2irUw7YSWx4FRXrOG1pDpr4RxO0Qfx1gbuH
         o6Hd1MyuSEAIfzeElJs2hFaGGo2FQy0xb9FSaQxZpt7XiZ39c++rVHx14PNT+1AkQQrJ
         +Gb37F4CB6/iF6RxA+lm1ODqeFA/NW5x3lGLH0DnrSjs2LMYryY/uENfIN2IApJ4C+WE
         M4ug==
X-Gm-Message-State: AOAM531k8fH9nIf8/swm+0oV+a7VDEooMMyyNjzVobKHS1c5YuMz3AMb
        TW0cb8q+pq3M/hOpnJvJOxprbQ==
X-Google-Smtp-Source: ABdhPJwWrjmM5TELLCLoNtR0GnchdN5LthPlINsrCfAsb63t6qE0pfMuAC6Ee7u3cHKDLsXEp6bbGA==
X-Received: by 2002:a02:d85:: with SMTP id 127mr20602386jax.13.1605911249749;
        Fri, 20 Nov 2020 14:27:29 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x13sm2620553ilo.54.2020.11.20.14.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 14:27:29 -0800 (PST)
Subject: Re: [PATCH 5.9 00/14] 5.9.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20201120104541.168007611@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f59b0645-cb2d-ba84-c2fa-ce02b7b520bf@linuxfoundation.org>
Date:   Fri, 20 Nov 2020 15:27:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/20/20 4:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.10 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
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

