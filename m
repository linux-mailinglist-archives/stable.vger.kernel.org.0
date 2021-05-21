Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3460638CB4B
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 18:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbhEUQxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 12:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhEUQxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 12:53:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47111C061574;
        Fri, 21 May 2021 09:52:12 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t193so14694734pgb.4;
        Fri, 21 May 2021 09:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sBR5xoUghjI5pD1q2DU/lEgViJjimIWIoSDnpDdw488=;
        b=HaGKUJ5ct2kaBr6w/8eKHKVo0NaC21UQWNXI+qKmIgPCQk+Arf4RxosNS4mIcdABpK
         tg089PKhMqvhgvFq0JRbtBsLQy/FhKBmuNgBADqEup9JDesXULILmp7TIFjUOHHMNz5S
         8MwM1ZtiQHKOe9w/CelHw16NdB0AQOVNa/jKgdw9ao0KeJo2AhqSOgIfZCWkBFfPpvT/
         lKJ8beglGfmC516NYW68fwth1DhLJy7nofZArPDs0m2RsV9cByQUG4Sh/hItXoVHS0mt
         0hIb+j/BR/o9DVjXMVJJW4QxZ4lenUYeQkSm7E3YnTjrpHh9PH3dcrFu9hj+sqevf+kA
         wTkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sBR5xoUghjI5pD1q2DU/lEgViJjimIWIoSDnpDdw488=;
        b=Zi7ID3ZedQOARP0sf3W7rk8jCpuIjzWnqXOCZPbUOVaO9BCbQFFF+TXBGT8mjruqWl
         atD2Cdsmg9HF6VeQgkbppgUy6ExrSI5y6AMUIrali3vOK1BsdgeC7WxaBAZCsMnbNaHb
         4E9uxqTt6z8IftXa101rJSdAYoKGaRRyHJPWEokMPukRqRLjmRYwtlVh5JTZ5b2CfHv8
         pS9++8RabH/vzxyFaPgVQUYMJqCBrwhYSffDMmd4DBRAh5OE7j5mZm8miJToN7k7POvk
         mQw15i3jc5q8XZH5bbeIL0Mt8P2lzdZ6vAqC0n/RrTELyxm+AdYhwqhh3bPWrwY7Li6c
         WM2g==
X-Gm-Message-State: AOAM530iEqFOd3PImcdYA/ETRtSeRrSbXB97smZH6deW8wFJonFCrx4s
        8LfryY7yu83JAB7I6pTIQCEWtzZ9fJs=
X-Google-Smtp-Source: ABdhPJxFIE/gxP9Zp2jI7ThaahrO8JoHFr/5qw+Bb+IX6RYSrUI0lOnS95VMkhNxV7UvfQkUgLOjSw==
X-Received: by 2002:aa7:8202:0:b029:2d8:c24d:841d with SMTP id k2-20020aa782020000b02902d8c24d841dmr11305315pfi.57.1621615931482;
        Fri, 21 May 2021 09:52:11 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o4sm4732721pfk.15.2021.05.21.09.52.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 09:52:10 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/240] 4.9.269-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210520092108.587553970@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a91b4e3d-0485-38e9-92e8-7d4f1c599b51@gmail.com>
Date:   Fri, 21 May 2021 09:52:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/20/2021 2:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.269 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.269-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
