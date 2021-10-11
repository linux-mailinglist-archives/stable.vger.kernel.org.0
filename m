Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F7E42945B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 18:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhJKQTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 12:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhJKQTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 12:19:01 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E1BC061570;
        Mon, 11 Oct 2021 09:17:01 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so260131pjq.0;
        Mon, 11 Oct 2021 09:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mb8w3q2A8nkdp+MGOeQ+B6p2YNct3eAfsBbWqmtIirA=;
        b=T0xE32+aQ4ooop9mZzTolBwvMBnEYtSskd1QQB74YlI0v7wsfEwKMpLbdPCjYcF2aJ
         40HtGzvUT2CprowZkyYSQomKCi/3vCr6qDnGeZfVbEP32pL9CL8u8uaql3k2NtedYv8T
         olfri+8Ra5VzT0S4cuQcDJq/rBNX+n2sqmJciEbB0JIvQdrXMeMHpa5GUf9eVKYVmGX3
         mnJ4EVmrYZsbG6URg96WUKjVbz33hIciO9GZdU28wC+R/DHqqDdol7prsW1cgJ0iBZYA
         ivmrDrU5FwWan5cwKSCv/59lJCgoxzKzlTNkzKahAlUgEJGVcwTEapdAR3U/7OgJe7Z/
         GCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mb8w3q2A8nkdp+MGOeQ+B6p2YNct3eAfsBbWqmtIirA=;
        b=7SKUhOjG7cs9Ay+mLwYjNyCh3EwzeFxFI6vTSceqxc5ww0gEvuzSXShn9XUkYM68I4
         +2Rj+t3GBqx8Rw4onv4f3tPAJ64UFfK6i93bRnfObsWyimcQyM1db7ImpuhIDuKSjvSe
         mjtV7AVRgzayhweKhd1PCzrJtz1IcpxCS6pgwMOyZJMIjl3j5LFHvv1qt8DS/6YE4hnl
         tVLTl6u5rSfsxMgJIrxgsFfi8uzDMx7BdKKhZxJgZ9ZzUoK9hNHUZTv9JV70Xa8j0vEJ
         RiabI228c5zBiXwWAIrp3O5Jh9u0BO0YmYiVnqWXAmAe1T1NPuFTGQ4IMGMKAVebKCLy
         l+aQ==
X-Gm-Message-State: AOAM530iHFVBi4f7+80GKFagGFtnhOsBVFjJ4vK4A/7TzCIVBl9oK23H
        vemyJSIAkQcYWAt9+UdrKD6zVHqFm2o=
X-Google-Smtp-Source: ABdhPJxC0l1iBqw9flQ5Wfg2m4/577PC4ozEMQiZkPF8eM0wZIqMrmsnN2FxUR7ZahVqy4w3lhrxUg==
X-Received: by 2002:a17:90a:430e:: with SMTP id q14mr31615696pjg.55.1633969020880;
        Mon, 11 Oct 2021 09:17:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j20sm9116182pgb.2.2021.10.11.09.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 09:17:00 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/83] 5.10.73-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211011134508.362906295@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9dcca651-3056-eb53-2e91-18aa01abed20@gmail.com>
Date:   Mon, 11 Oct 2021 09:16:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/21 6:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.73-rc1.gz
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
