Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5E834D78D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhC2Spp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhC2Spg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 14:45:36 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A4BC061574;
        Mon, 29 Mar 2021 11:45:35 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s21so6454295pjq.1;
        Mon, 29 Mar 2021 11:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9zPFzNv0edS8p5RMF07T1H1eOs0z4CTd8BF8diVxZFU=;
        b=U7RBCBBCgMte8Sem7mxyAN/Uspoanb8GPWqfOc7eT8lDTgqqDPpkvqFKLfUKwJ9MTO
         hBvVisSrS4L4qyLp4Jd2HyagWQe4hM8HiRTWhabuAR/upMIpGNkLDqW8HvtmWP4Zcs14
         ogss1xDBajEucYTEzV0Yq/33WnIRWlKKbDZqPLzjHHmmQA7U+KEzxk9B+j8HLPsjXVdF
         ZkygvswkYXtJB9j2pj7euWvUJ0M5iS6posC9Sit+MXWvFPcNayViTfbK6jc6lRHY5o3N
         6YZjQxRXm0t8LeNq5njZHybDdh3EGBkRjghmJ4DGi4NsfQKV+5VpeEg5+qO2N9qVYDI4
         w7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9zPFzNv0edS8p5RMF07T1H1eOs0z4CTd8BF8diVxZFU=;
        b=k8NWsVq6ZG0qdrNWI3dfooiaSBJKJDCvitLlcr2TVTsswqqhf3sVJKCUIkEih/LIjt
         ChwIIXyj3bY5YbImHz38CPsnXdnSJCbaUX/IVHx66mM92/4ie2zi5Djj58dSX7JHu+UH
         rom26SHAe1rVmYs/OEyEceOk/butp1sk9ns895C7XzkkRPKIKHSByEM8x8YvSB+fMwRs
         X4mEKNhoaRijwEyBgA+eghu+FjjoHL0UdtL+rhsj6zqp+PWudQNG5RAdgdYtQoVXee8H
         XZvbHyOXFbgv9xb5Mlw0jiCDoaxOkE+Pm2vagkrQ4uo1WJ+ZHRBiOW0Br/pS5IGE/Ytx
         ZM/g==
X-Gm-Message-State: AOAM530pZqTPHmVI/lVZLGrjZBt8U+t9GLrfzTpvJL2yKiD9324TddXe
        wmN9pqHPxwnueaF2nEG7/MRsnYExIeA=
X-Google-Smtp-Source: ABdhPJw03xSpq+k575bTR4Xqbp2HxnY+G3LHqRAqJAxKBbqLlEkPQwwWhabSSUeXEenQIjf9DDOM+g==
X-Received: by 2002:a17:902:c084:b029:e7:3266:180c with SMTP id j4-20020a170902c084b02900e73266180cmr17666190pld.7.1617043535167;
        Mon, 29 Mar 2021 11:45:35 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i10sm1424005pjm.1.2021.03.29.11.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 11:45:34 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/53] 4.9.264-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210329075607.561619583@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <654bd7de-aebb-be9a-cf57-4f15459d72e2@gmail.com>
Date:   Mon, 29 Mar 2021 11:45:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/21 12:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.264 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.264-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
>
On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

and thanks to Ben's latest back ports, no longer seeing the do_futex
warning that I was seeing, thanks a lot Ben!
-- 
Florian
