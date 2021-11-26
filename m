Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDE145F501
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 20:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhKZTIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 14:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhKZTGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 14:06:47 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90A1C07E5ED;
        Fri, 26 Nov 2021 10:28:38 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r5so8874911pgi.6;
        Fri, 26 Nov 2021 10:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=E+dMA1iECTp5/2ca3sGCrH/unKsv0u0VZpUy2oqv8pg=;
        b=pNiI8pByuEyWHxOU1df4HUvGEMfDRtS1L3ne7JYKZcRVmfe54rjMG/FbMBqeHbBB2M
         dQ1a0GHS8Er1qy9gq452/fhocXXTP4AomIn+CHwqQdK2WCLxYM8tbh+fWUpL9z3AUPJP
         3tSFbScKjukt4yZzLOUIzgiMS2z2GsLiKhf4uho4sSR3ooQCwb40wkLRzuwCw1bNlb5L
         Z6Iqgy/5yXk0s0yfTWw7CmjSSc826c344SvJG1X9mw27nyPuOy5f4kCm4d/ulishu9+0
         HPRfk2a+IdmXd+dFjon+mnpVMiOxRF5BpFGQRPeWUNV6T3MwoPoNLAZGddDwder8ZKw1
         UlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=E+dMA1iECTp5/2ca3sGCrH/unKsv0u0VZpUy2oqv8pg=;
        b=Bes2rm/QRzQF3G5MldhrFezUnBZiqhGEFk5jz54X2LfSvffZgddvTY4j2f1Eh0yYhE
         yuQvGlYk73OCY4WQjcThcRwUx0BjdVKozQCrxeKC4fFCkvOmOr+KWkS7K4Q/MXigQKGR
         2r4eiE1+UpdmUMxJaheYZ5mGXx3xv2ZKVd3UE7YZ1VGd3LbjTGsrZC0gJIpX1rs05LeL
         PMiW/KLk/+2vJczES9eNxulCb+9YzpOdpUIc+MPdB7Wd10oFj30L1oy2FoEZx+44ns6A
         pXIaAQWVXq7x1S9oegwohG/eBZ2cYIOj4wBMe6rsa6SqcP6OAvuH0dWoRbKyLT959FRP
         hV9g==
X-Gm-Message-State: AOAM533maTiSjoKXgt2krhcRHOw1doZYKDUVPtJqMbjt+92AJC3v9R0s
        T0z6FBSuOv5extfit4MGm5U=
X-Google-Smtp-Source: ABdhPJx4HiLqWiRSg8B+5GAqkgKARdnb1eWHqBx8H5FdreatOzLUPRMSabwD5kyTImzYasDtQ5ipgQ==
X-Received: by 2002:a63:ee53:: with SMTP id n19mr8711878pgk.593.1637951318391;
        Fri, 26 Nov 2021 10:28:38 -0800 (PST)
Received: from [10.230.1.174] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id z4sm8620973pfh.15.2021.11.26.10.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 10:28:37 -0800 (PST)
Message-ID: <516de9b9-685d-ba65-a284-4dda155be9c2@gmail.com>
Date:   Fri, 26 Nov 2021 10:28:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/153] 5.10.82-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211125092029.973858485@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20211125092029.973858485@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/25/2021 1:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.82 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 09:20:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.82-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

