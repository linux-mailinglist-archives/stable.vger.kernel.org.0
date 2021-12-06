Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA9546A1BA
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 17:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbhLFQuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 11:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238407AbhLFQue (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 11:50:34 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A27C061D7F;
        Mon,  6 Dec 2021 08:47:02 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso14411052otj.1;
        Mon, 06 Dec 2021 08:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UfMvdtz7TetuUq58w7Z6QC2WTUyddtJHcjVCTWEKWuI=;
        b=Hw9skppLMOky7VXGvOK9BNwNpBMi2pOHR1Tq4Hl1/Y093PHKAAIb8dSK3gEQy48xbS
         5Nh0GhWkPbLF6sbOP55hkdWH8ecHdX7OS/ISyrAGF0xXHYxoHoDp5dbvNuw29Clz+yGs
         VjewNKjYHIEb6Mr8Qk+5x8271iIwqq+N2JbCmFWXUpONdKbxOVvVeS+A2YQhStpN4qo2
         q7bq85T2JJu4KMw0dWGfjwaMjaa0J+Pqt5oNaEh9SskJsGEEPn8e4egeMSB1FlO+DHde
         Ay1FQfDupbWoVRl3d63J79IR9nW7EkCTGY2EMXjjeecUTl/LgQBcSwgTg6cRvYDHzFLi
         n+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UfMvdtz7TetuUq58w7Z6QC2WTUyddtJHcjVCTWEKWuI=;
        b=v0CCLMZTw1cOC1ENEty5Xt79vD6WwM7LAJRw79OAMVuWG7B53FEJnR1wD5fEJwC3V2
         pUCq4bptJbNt3Jzt4Lt4olKiYYc/iETeoo71nCb3c/IaD93rpCaOsRlrT3c09cnw3fVV
         m+DKUtl1NwvQ/aQqA1WNBC7eIbWnjf/Y77rIe/i89FTwNezh7vuabqnX5WQO5XmFZRkA
         CcHtStxe5dIlavawy7BiIdl/AQO8aLpbIQJWonS0wfIH5Tn4lLQ6NQfViJqt2sR6rB5l
         BhOmqW110FLGwDq2CvgJUc9XaBOoacPjLGLzyYlc1DJKG5Fi4SgL0BeuvgsjFAGTl5ay
         dK7Q==
X-Gm-Message-State: AOAM530ijItgJ1Egv5xtsA74/42nV00WXnCVMMeDfHEA+3xefNOCM9Vc
        UuLHbHYKaDgCjFK90ggvhK3pB1lofJo=
X-Google-Smtp-Source: ABdhPJw4A2p8Ik+52sJ93aDNnTLR1Y9iP+AK3OrrJlpsKy3aDgDarDw3HKXe1DNxJy8lN3E9SHUJ0Q==
X-Received: by 2002:a9d:4a8:: with SMTP id 37mr31067133otm.83.1638809221868;
        Mon, 06 Dec 2021 08:47:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m22sm2438251ooj.8.2021.12.06.08.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 08:47:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211206145559.607158688@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/130] 5.10.84-rc1 review
Message-ID: <4a881261-ba90-2095-58df-13dcffe6bcf2@roeck-us.net>
Date:   Mon, 6 Dec 2021 08:46:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 6:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.84 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 

Building i386:allyesconfig ... failed
--------------
Error log:
x86_64-linux-ld: drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.o: in function `amdgpu_amdkfd_resume_iommu':
amdgpu_amdkfd.c:(.text+0x2b3): undefined reference to `kgd2kfd_resume_iommu'

Building i386:allmodconfig ... failed
--------------
Error log:
ERROR: modpost: "kgd2kfd_resume_iommu" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!

The same error is seen for alpha:allmodconfig, arm:allmodconfig,
mips:allmodconfig, parisc:allmodconfig, riscv32:allmodconfig,
riscv64:allmodconfig, s390:allmodconfig, sparc64:allmodconfig,
and xtensa:allmodconfig.

Guenter
