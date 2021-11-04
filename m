Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE001445CC5
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 00:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhKDXvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 19:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhKDXve (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 19:51:34 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4E9C061203
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 16:48:55 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id n128so8864809iod.9
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 16:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bcnEBFz1hK0obtNGxaCFExjRU4xV+CgJNPNoGOL31/w=;
        b=a+lWXi6K+YoHyH7U95Bk5j7GiMDvwOVIQ+nkx9SZCR1MQsdzr/umfIHwVSgltb+CaF
         TqS70odmsM5DuXvzhMuvrz3RBAjF+ozFx5VgH87K0lG5T9nKEdtkErI0Uz5emKeZ860k
         FSYEqLhi0nFKSn1HBVnRWVuiUqewCMJ7Vks0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bcnEBFz1hK0obtNGxaCFExjRU4xV+CgJNPNoGOL31/w=;
        b=6+PsLEjnNGtqNf+nYq3FhX8CUvc5lc47NiDtrtrgOZmX4FWh7AOSYvAYxm04ZCXvdg
         O6m8H+2/GYYPpyBI4dpJIvcxXNMYEQhi0byn2wT/ZXvkipbzHDvnWuznZfs+/QTY7+Ua
         CYHqaeBbrmNo5ue+ZmyzbKsuJGIEtCJjal/7VQI5Apkr3WUBKoqCeF+kjFXimk1xg93Q
         odGdOctBgPXmWBkLnoG+iARVaieveFMiv9ospPnSK5STIrPOR2LEU/Eb3I3QVWxtoPa8
         3POSJv2FpboMhbrEDgf3EkjI6NI7rNF+hCyyc9qzbquxtnocE5Yq6Mq1ciM0nnUj+/5x
         oTGA==
X-Gm-Message-State: AOAM531dgKvhJQcDjT8kVv5HrzqDxt5miBIx5ZgsMn6oT7scnqM7pUtb
        h0Tr8N1friy2Nm+Hg7jaLN1mTA==
X-Google-Smtp-Source: ABdhPJwHwqtHeWGGjGjsNWuBszoPzIBcuh55cOm99a3WtGU4o+nHHn+Gjm/l50qXUjkU7Ris6lt4UQ==
X-Received: by 2002:a05:6638:358e:: with SMTP id v14mr6366170jal.95.1636069734673;
        Thu, 04 Nov 2021 16:48:54 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t14sm4382160ilu.63.2021.11.04.16.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 16:48:54 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/16] 5.10.78-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211104141159.561284732@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <86a63789-f16d-6f9e-00cd-f32f0e20901c@linuxfoundation.org>
Date:   Thu, 4 Nov 2021 17:48:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211104141159.561284732@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.78 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Boot hang during journal check on my system. I am building rc2
now and will let you know what happens.

thanks,
-- Shuah
