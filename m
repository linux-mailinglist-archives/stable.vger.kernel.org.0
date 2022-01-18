Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480A049309F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbiARWWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbiARWWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:22:49 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA11C06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:22:49 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id p7so490393iod.2
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tqPTY0+w7l18UxosSWPFZC/ECaKZzCLyZ2Q4h8NAaVY=;
        b=ZV78F7C9+rtZhoWimPJDH0o39iF3oESDU5P/Y+gOkRV0iOWZdLaSj5YGVi0c7vgF82
         WN8UP+Yihmk00DbysztNEHsE/3Xb9i/5UblWYMGyPL/1zYeD+gRjUGwCJZZQvky3Xo0W
         8FV+NA3dguebX9tvCpcwVgKt7WrpO/Mkwaw9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tqPTY0+w7l18UxosSWPFZC/ECaKZzCLyZ2Q4h8NAaVY=;
        b=EZzk1MUIwQt4nIIC5ISf3Ab0gjOuj3Bg9oXxJwl95LoXbrrCFEO9LPoYTmXOGsNyH9
         ztjWM6N+zFa/b6WJb18039rKVdnnCVzgK2whIfF3zZxaInQkrR3GmuJ7QkWLsF6XR2Pt
         Tt4L1vu+zfApKndNeUzKvDFGmuo0fo6Y48fLFUfFRkkeP1UNGByafle2sGjjAyw/uZ8C
         jLumQc7d8tMh7DTAmjfxq64G0ur2ZvzJpQNgxAMy3XyR4P6n3WsH+yLfxQpjE6fqQT2e
         UKeopUfzkpJ5WKdxVjBvEhIWtxnumWx/wgbmKjZ/jdqHl8Z8tH7ra/oQl0w27WmInx3t
         OhRg==
X-Gm-Message-State: AOAM5314PeQ9PL7uFFvLL/dIlbjXfeeZyLc6Jm7rlMUdLHYgic5HELKO
        jRUeWqy6Cgu2broEA0cEc09fuA==
X-Google-Smtp-Source: ABdhPJxvVROfmc1csv2eOZTiQEOh6FzTaZAWa2EqzNjR2faArUPjnvmEXNW3LXhpTLNQyUKfW7f9oA==
X-Received: by 2002:a05:6602:208c:: with SMTP id a12mr2180338ioa.43.1642544568782;
        Tue, 18 Jan 2022 14:22:48 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id n20sm11550846ile.45.2022.01.18.14.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 14:22:48 -0800 (PST)
Subject: Re: [PATCH 5.15 00/28] 5.15.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2f4fdad1-6e19-b1b4-5d65-49f2c53a6e07@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 15:22:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 9:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
