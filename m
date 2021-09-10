Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E11407218
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 21:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhIJToo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 15:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhIJTom (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 15:44:42 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CE0C061574;
        Fri, 10 Sep 2021 12:43:31 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j2so1826951pll.1;
        Fri, 10 Sep 2021 12:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zP4/nffKr4bI3HwAdVBpCEeNB3Dia7SwYemgZ8xo4zw=;
        b=nnYPByhtFas8eCAsV0OToYAzYFFqU5hriDks7pkqBVSkB2bvYaWmkZTAo3DxkjSn3g
         lx4uw5I7yRQ8Kti2WOw49SguvR7THzU6zMOustoQcyLpSLyaphv+sYLhU5eDXX3oOjTp
         utoKG8U5hte51JqnLbchOn3IUYQ2pD5WzL4VSI+YTCcs25YocfsgZCQ4kMrPoeMJC9O5
         sxPk0jMjBGef0yQXsryqfVQK//FVNt7wAZykRSlpb4NZJDsJKGCk5bqTiXVU25NievOk
         QEz+dtVAlA+xvc5H+m/YscFmpmlGGcN3up9WrpLLiz2Dr9oWFQpZq6yYrhuR5WIpyFXj
         FdOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zP4/nffKr4bI3HwAdVBpCEeNB3Dia7SwYemgZ8xo4zw=;
        b=aftPKmNJAFFD2Cf5JdhSgmFUekWfjoIs4PTgkssWkTIxtMFvHqDVXPdMs4U7VMf+Ez
         i6wXc5d7FxGoUFsn4WQ3bD/VrIZMRX3i1VWS6WmJnH2hcLuuQ3IpQKhL9ilXq7v7k6Qn
         uxP+h0ogRAQr0g3dXWxTc0W7LVq2CnZ6kIasshgKM8Y8Ud+X9qTmDnE3pkfO1HShFdlh
         D7Nqaol4mMSJmqe5AV0J4Q7jCkwOTfdh8jZWgGlZ1bDkl/t4zVzqu976yo1sjR7j9Nlj
         Z7deritah/SYUll1aueI8kx7HLFWIJNdFLOKARggA/526fH5ffGW9eZ2iYVLfQJ9QP0a
         Nbsg==
X-Gm-Message-State: AOAM533NU9UcLqkzyr8ohbEY0dlXITXm+3Y+ue+NohBlzzp5TPDw82vi
        /UfI5Wb2pTPCxevp+POOrh0=
X-Google-Smtp-Source: ABdhPJz9LZKW904HHVRbLAq0sFpG2cZqClkGUXRXkRsgm8vb++oB89kwKb+RguehtMBSzk7BJYoa+g==
X-Received: by 2002:a17:90b:3e84:: with SMTP id rj4mr11442560pjb.211.1631303011034;
        Fri, 10 Sep 2021 12:43:31 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id 192sm5966040pfz.140.2021.09.10.12.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 12:43:30 -0700 (PDT)
Message-ID: <d919813e-582f-08c9-0c3f-f6712d23f0d1@gmail.com>
Date:   Fri, 10 Sep 2021 12:43:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 5.13 00/22] 5.13.16-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210910122915.942645251@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/10/2021 5:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.16 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
