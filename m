Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2012E2AC94E
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 00:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbgKIX0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 18:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKIX0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 18:26:03 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61ADC0613D3
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 15:26:02 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id s24so11625341ioj.13
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 15:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WL7+YqDlKTcklSMUg90KwsETHJVl7wRfFGlIXBK/35M=;
        b=fuJt+MdoiBGzQEhIy085EXvAlsYj774Vevr9MMpc/gaqe/Btd5XX3INohGx3S15JcZ
         88qu4XNPtFPCmgNT/sXKdZ/WJ454kYQw3HyYrV6cafda9uHeauQhzAEGLaJ5+LoZcDZH
         00dMG4+5FKrDdZ+nbH/Zl/+FZmlZArJCHlQ2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WL7+YqDlKTcklSMUg90KwsETHJVl7wRfFGlIXBK/35M=;
        b=SQqEX3a3/9wpiQaymlb4XAXdY0jGv1ozErNxpdTyaHkQBPVOHBv8H+c7/YU/bIMGbQ
         UZBUvpQBbuh9vqUv6m/9WpMcvgTakQevWDmyYxcJbZK1gKPgIQzstnJmCqvidAOu8PI4
         Tj+tqbDaHZD8M/snWkGxAW6i6M3Kl/hZTqPaBEW/IlRBIsYVCV4LU4rWjFpZSTuSJNRd
         q1WI6tj58tGihnn2Q2cMOAO8e+2kzGcOJx0zHt6DkdoE5XCr8169L0c4wBi7aIidsQJ8
         mx1edbJlPrHvGypvMiOdS/g8fr1/dQ2fuQXaFz4TE9DIREo/O5BHvP2LeGELRf/GTuxb
         RT9A==
X-Gm-Message-State: AOAM532P/uuTSaAd5nAZKaNpHDPU2aIuwXfDyaZpyBsCrLpnbsOgseLV
        /zL4h7gkqH8QB84xhcs5B+K5mQ==
X-Google-Smtp-Source: ABdhPJz2ckT+ICLYlnMORo2X58V8rbLejqvFvefF/PqJclRveF/zm6Eak9IYC4Td8EFED/suCzhPqQ==
X-Received: by 2002:a02:7112:: with SMTP id n18mr13059341jac.34.1604964362264;
        Mon, 09 Nov 2020 15:26:02 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t12sm6597093ios.12.2020.11.09.15.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 15:26:01 -0800 (PST)
Subject: Re: [PATCH 4.14 00/48] 4.14.205-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <49034ba4-e6b0-f382-9cd6-aa075a60f19e@linuxfoundation.org>
Date:   Mon, 9 Nov 2020 16:26:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/9/20 5:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.205 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.205-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my new AMD Ryzen 7 4700G test system. No major
errors/warns to report. This is the baseline for this release.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
