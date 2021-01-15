Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962EA2F875E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbhAOVQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbhAOVQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:16:20 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E526BC0613C1
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:15:39 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id i18so2563438ooh.5
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FJvt87fhgEiBCFCQ/ZE0Ql8XUrXOJbKlo5Bx7IAY4Vk=;
        b=UhqAo4Tvta1Ul515oEwg78zsX4mjwggzj2IhwuLqrmaQwS+anbjuTsEs7k/dR2ZH5g
         /C5WcG2Zb97Q26ZYKSwJUzebM86sWs+T/dgRpFoyCOk33kxRQmHjos//20Dtaqm4iWrL
         vjbZG3zLCehdCCjPyUDQG1JoYH03Y7RlIV4Xk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FJvt87fhgEiBCFCQ/ZE0Ql8XUrXOJbKlo5Bx7IAY4Vk=;
        b=boUgztP/f/9R48zG3HvDZA2r9FKFpREop43OheeJf2pZcoFh1c8bMO3gTepOiNt78+
         FLWRzj4q1sPOIvFrYwyxLWrv912e4Z1SGe/FC1UrFOD1CoLIlNU9WReDha88xGwuHL/h
         6jdRetouuh1NvZjRfHdD+Q2FswhWYLWUyG3BTgFdT4zoQ6T+OFjr/72xXChssHbvI2RB
         X7zjtkT3IFmmUqmXeZTHmAW22RyZc43X+0HIBf6qt1K6fqq0uMLY9a0CN0fdM8s0kf3H
         JuJoRTr9JAyxxlGQ30nezIT4SqhCU0AGgeuxd+rJKTz5ln8g2wPdRPJDV1MkPEXaqkxf
         6XhA==
X-Gm-Message-State: AOAM532OAIrE+L9WahEB5kKUqO+818w/iSc+hBwiO3MQt9DMXNY5l9BF
        ZRBaBtDWq+iucTP0+kzV5+LFeg==
X-Google-Smtp-Source: ABdhPJzp2H7VXn6ag9LxB3FOgxV0VL2f0oLddf6BC78/FbMdLTuuT29O/gtwg+Z5WepwSz1DL6qoDQ==
X-Received: by 2002:a4a:c503:: with SMTP id i3mr9764905ooq.6.1610745339338;
        Fri, 15 Jan 2021 13:15:39 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f18sm2047781otf.55.2021.01.15.13.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 13:15:38 -0800 (PST)
Subject: Re: [PATCH 4.4 00/18] 4.4.252-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210115121955.112329537@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0077f798-5d5b-8a67-dec4-a2fd13e58b92@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 14:15:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/21 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.252 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.252-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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

