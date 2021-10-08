Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95953427293
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 22:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243281AbhJHUuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 16:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243275AbhJHUun (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 16:50:43 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FD0C061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 13:48:48 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id k3so2723247ilu.2
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 13:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lCL9jSct4nyfW//yULffOegzEzj9w/CKx/mnCG/UyTw=;
        b=YcydB3lP5aSnSJPEAG4Lvz+hoHU//f6BwHWKnQFgEGtADpqreToiEdtWOkIHQnghql
         cwiC8FV2P5aBPijUW2MVEC+y1EmN2+n5Qu0zZZJQMbqx3W0TbTUP9EfXSr0RK3AWxqIG
         CnZ2QAJZZR2W2GGPO9vZFGYJybOIHeo7yEHAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lCL9jSct4nyfW//yULffOegzEzj9w/CKx/mnCG/UyTw=;
        b=QzdrL9wf4rzywvJkUSPUxXlBNG4EOK3/Y5tXLPX/cpNwGBvChGlPbpofZbgvyfywWg
         Nq0tkGSueqoHV7MThdfYrXQ77I/2LjoN1HVPetp46sCLAGR1AY4ZFG07xeHkugNruPJ+
         zgbR/+BjdcdnGkr3bGWuKADJ+ZtIiKDlIkUcJBOXGNeMNNlfgpDiDxaKw7NDoLsXIsk9
         WMviDCWiHkylmFXCI+kNpMnoJGz1rHKyqME+1l1vHdBmSe5b6G09lKxrBs2p4vuKVtJb
         HItYrelypmp4sXOVKCVtGjapwXtOXi+kvpfRFV/VcBNWcbvDU7cP/HkQFfL+iaEBIwmf
         Zy1g==
X-Gm-Message-State: AOAM533CuHIjpRWz1/0+gBiaxHPNeM5DEvtOhHx2olZFHTcBFDuq1Aag
        YGslaqbjzD3TFYk6OAmApFVIC45oKoRx0A==
X-Google-Smtp-Source: ABdhPJyZ/jm6uxkz9yes6Os3Qu4WgsDdFzQUFl/1fT5Rfv50To7N59cStQNB8Z8tqitmoP7jnGdz6w==
X-Received: by 2002:a05:6e02:102d:: with SMTP id o13mr9623287ilj.239.1633726127536;
        Fri, 08 Oct 2021 13:48:47 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i18sm164412ila.32.2021.10.08.13.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 13:48:47 -0700 (PDT)
Subject: Re: [PATCH 4.9 0/8] 4.9.286-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211008112713.941269121@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <13cc7eaf-d34b-409c-dfe7-43c53815f6d1@linuxfoundation.org>
Date:   Fri, 8 Oct 2021 14:48:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211008112713.941269121@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.286 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.286-rc1.gz
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

