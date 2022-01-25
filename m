Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E714049AA03
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323966AbiAYDaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415607AbiAYBsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 20:48:45 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10F8C0617A3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:48:44 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id d3so15542088ilr.10
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q9VJjI6H4h+WeNXh2VNKuFtBfB1oHhQ2xdGJcI2xGio=;
        b=dmSe0XVf+T75xclmwBuFI89izOQgkxas86wobTVsVgK7OA00EwBQPUm8W0nQmhPwLP
         8djssHJhCBJaFW2lMQdx8OBB63Ffb/J5Lceg1YtSLOVdlsLObs6y6GF2HGftILNcTR/y
         5cx1hJL/4gzdYkD5FlQ8DtrYlA+oS877hy6fw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q9VJjI6H4h+WeNXh2VNKuFtBfB1oHhQ2xdGJcI2xGio=;
        b=cEt4d2aNng+p2SP2iHzbcXU5A8gPMLpVGvRaTv0kUROQCwS+u+Am2H51ce4hw4lYU/
         osx5rmAjNNNWSEuUsVdE0rXtwjE2i0jTQQBrnuBokahL9RsHFg2W5cw9O7a8rhXVdHzt
         MG6os21O7ZFzwuB8horMttOzmiBUuqG2+VHTPgdk2IpJhSU42twqduAZVqCJBlWedTA7
         OqghSl238hQeB/sJU1+gpFOeStIdT9bYA8SCVmCfekCcd7+PHZgzTkGXp0de/TkZUTDB
         5oqS2VElTsNsbirLR62yBXOknxucVpytaqpVDx0tY/qBLs+j8ZqgOzVDhnXQMl9hNDpI
         R8NA==
X-Gm-Message-State: AOAM532qXD9Vgh7T2WMYqpK7yVmDRbXpwd3klV83480RCeB7uUEsp4td
        3LIqXUFwwcVcUZlJKCPdEOykig==
X-Google-Smtp-Source: ABdhPJw7/k/N7gbGfq6I5X3wQKgQOfaWo3hb6K7oBlGkRwb+QgSp/K6F1LfaHhf7gE7Hjv6jD70Z8g==
X-Received: by 2002:a05:6e02:1587:: with SMTP id m7mr9923108ilu.84.1643075324406;
        Mon, 24 Jan 2022 17:48:44 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:b48b:eb27:e282:37fe? ([2601:282:8200:4c:b48b:eb27:e282:37fe])
        by smtp.gmail.com with ESMTPSA id g10sm8235527ile.34.2022.01.24.17.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 17:48:44 -0800 (PST)
Subject: Re: [PATCH 5.10 000/563] 5.10.94-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8472db87-cde3-5c16-6c11-e9092b949605@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 18:48:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 11:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.94 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.94-rc1.gz
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
