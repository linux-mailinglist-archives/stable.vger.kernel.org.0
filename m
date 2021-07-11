Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040363C3F9E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 00:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhGKWS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 18:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKWS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 18:18:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135C3C0613DD;
        Sun, 11 Jul 2021 15:15:42 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h1-20020a17090a3d01b0290172d33bb8bcso11613971pjc.0;
        Sun, 11 Jul 2021 15:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nq59ToYXSD9i8ohn7aO9JyTTZl+bKE1lWpCXzP92kcg=;
        b=NSgHqoPb3Px/5h+Nu0ZzhhqK8NZZk37Puzkm3bLSctxKb03+Z4HMwlHILuIEnLdq1x
         zDppDwB/lb3RoeoYufWBXhppEelYU/nRRJfLp6xL+3oaBtd6ZKh4XfJbhwztp0h/Ee02
         Bd6WOdCXHWmdfNXDHdVt5Sld/f7M2oxOiZE4rCXDxtGfGlT+u1Ntlh1gH+XSgIEPSWk7
         hPRqBnaOEagP5iBfQ1U7fkiBlIc1ioOnUj8Fo4YJeQ1YeQ5xqgDDULn0513O1EB1c9zg
         sXulhTgO2Z7E3hJhN69EqzkQX7z1qEMGTtR5hGfzzzg0GRcNmMSt9ZuHUOFsT+RHm7z8
         Aj9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nq59ToYXSD9i8ohn7aO9JyTTZl+bKE1lWpCXzP92kcg=;
        b=HLx4N+bvBc+yNIEJ2WrO8vBHQNFKqmCOmrAzxRGrSvyKNdWJFLBnJI50/i8JC76Uiu
         BKU97btFsVN+lOgrIabjB3CSQfCWRiEi7uyTESP5j9aCrMetEB6qZJ8n25ZPdu7OYNm1
         SgM3k7P8ka3hY7lEs0MzQ1XABXoMhj7MzHD2CJ2Ckh5MjYAlcuB3m74/tIBMa474g7+2
         ipzdWTS826i3cXGn+7vVyuT4+IOzRSQKEWv1QuLywBo2+cZR/9Bpuid5oNdqCfATh52/
         ZJPKCwrSkEFtKZ+YpOM+KKxEBt7ndnEWLS3GiRUZqEwQ0YfLcM34LbsNHCWDc77xID+R
         VgLg==
X-Gm-Message-State: AOAM530spVsvNpJTWllf4AJYcL39vN9JpKdyUxoiZVi8GJnFwmZk8KsN
        uWxMfIrWtZoxErZZGtGXXIXittT+sewK2A==
X-Google-Smtp-Source: ABdhPJzbb2Oeg8htG5X8U76kBTBX1T9M6t1RkWyQ897AbmPTTBsGbc9D+57cDIHU7ktCmLgvqDS8Ag==
X-Received: by 2002:a17:90a:62ca:: with SMTP id k10mr16299895pjs.133.1626041741135;
        Sun, 11 Jul 2021 15:15:41 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j13sm10454351pjl.1.2021.07.11.15.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jul 2021 15:15:40 -0700 (PDT)
Subject: Re: [PATCH 5.10 0/6] 5.10.49-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210709131537.035851348@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <23623902-5f7f-e53c-874a-2c737e9876a5@gmail.com>
Date:   Sun, 11 Jul 2021 15:15:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/9/2021 6:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.49 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.49-rc1.gz
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
