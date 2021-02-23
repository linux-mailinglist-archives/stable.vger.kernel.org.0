Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5C33232F0
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 22:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhBWVGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 16:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhBWVGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 16:06:51 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C20FC06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:06:36 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id d5so6590110iln.6
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eeEW/+JYydf9hEDgIE++Orpq/X/ywEX1TbaWFku344Q=;
        b=IC30LGCHC2J2nTITANkNVrVxJX1oUwcuSbdFPYksHXaG/KNoB5ceLXRb++zWAhjwiQ
         Bbc/XrWgF6rFFnQClYtfEhBYm5I7NzDiRLzOtthjvY0rtpr/pvnIHWoEc5/qcd2jr+yh
         G9F7A+A8KtOaNAG79Z0l2dSM3p3Z6wD/mJnyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eeEW/+JYydf9hEDgIE++Orpq/X/ywEX1TbaWFku344Q=;
        b=B00LbZambZFXNDMvNlBzYbtZOSo/awA/6dXPYbKKUFH2ajmt5Qim0Tnv3KzCcHmyAS
         xi4JVAmCBAj/6MM4l53a45YrYbFaJz4dXmFmrz4ivxHMDguOWIZk4VsE8tI6gONmFOED
         ujG3ChcxhemXMraCrTHs4GwM3aRzU9QC3aEB6qSOGGlzrcmxPlKC0vv/tsoqn9FLv5YO
         1YomV4QEdAVNPho5PQWayhgF8pR4uMB7coOYBCYWApLOXgzFeKaXrZCkugaGpLfoLSBm
         hfxfVHRVJHXKX/bW6YCyMam/SikzBpTKp7RXlqYOf+E3gL8Xc4CHNloDaf500P9PcaTE
         QmdQ==
X-Gm-Message-State: AOAM532B+4PY9ZT+uKRYQ8NKXqixI6EuO6RoGOqlbkyNhbplLkZeKzrf
        SiQyB2updFxyeBKflPvrRLRj0w==
X-Google-Smtp-Source: ABdhPJzNMZAatq37tmQ4MHpGRGOBOw6mvHO0h90AGlOhbOPgP6EBOAFilsB1gpUrcacCjjws0f00/Q==
X-Received: by 2002:a05:6e02:1845:: with SMTP id b5mr21602157ilv.11.1614114395577;
        Tue, 23 Feb 2021 13:06:35 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 11sm15893003ilq.88.2021.02.23.13.06.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 13:06:35 -0800 (PST)
Subject: Re: [PATCH 5.10 00/29] 5.10.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <eaefc325-9d1e-c86e-f67b-146729739d49@linuxfoundation.org>
Date:   Tue, 23 Feb 2021 14:06:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/21 5:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.18 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.18-rc1.gz
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
