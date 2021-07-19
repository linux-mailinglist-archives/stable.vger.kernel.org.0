Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB5B3CE9DC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 19:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348805AbhGSRCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 13:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359782AbhGSRBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 13:01:47 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259CCC09CE7D;
        Mon, 19 Jul 2021 10:20:28 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id y17so19693894pgf.12;
        Mon, 19 Jul 2021 10:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z4goUSDiNXNUovyb7udx8l8uy4sxEgjoc6vUDMc1ybc=;
        b=VlQSfr3W51AolZZ4Na80TpeaKGcZ6ZgD0Gp+wJuhcCxTW6GvNEK+n5axRndXEH+Xh7
         JmX81QKPjcn+pIiN64tfpTTFZshh0zvwjwUwIQCBU4ixQtMTEnw34k7sgp1s3dc9eJ43
         mCGwQNAJnDjAYAz21IeTGQHkljZSSfq7K1u2hFZU2dvBVNDgop9MsbhK9DxWqFvjrmB0
         gS8KKCTMokU2jV8pfs6ylrFxjDj3UEVpTSfz6gQJPjZ8BViUMFa8EJ9G8aW19/VDpfPm
         5yMJiulayn9dsxJyMPdp5j4Y/aVUlJRwdFr9tZCT4C2CLKmAJ141fB8J3mnUTjp5AH0Y
         jbOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z4goUSDiNXNUovyb7udx8l8uy4sxEgjoc6vUDMc1ybc=;
        b=XRJixz6S8k8oPvJQ3d+Fgt9TlU8jBM8MxBKs6CHq17lI/XDOrVnt5Og7phdXJ4WdI0
         O0Se1KzyVYrQlO46QwPfRrS2e6dHOf4hxDYv4PRWbdCRlvKtd8z+RhGQNcGmQHzz/FAg
         y7/iEQXc8LRIUMQls0Pl9iIWNLXLlxjfudabOLlEW2VKqdtEeVSqCnq6GwG29a48spZY
         DDFeNt9rEGDARl7GsS0XPOssEhoBChSoXRSLu4oTPljc6YUR0z8qmGr8xswLNfCiy/V7
         VbPEPqq4AfIYzQeitjl1Iruc3RLMxTDQHox9z8H1AZ1lHFlF5Ln+2wkaVwwzmYgh51Pm
         vCrw==
X-Gm-Message-State: AOAM531uHRYhOInyzphxRPN7Krx8jr2MG9XPL+Yxckyvsvy9inunsdbz
        CV3aWwtXgv7OUoA0YH9ZhahPmclJFSzYbA==
X-Google-Smtp-Source: ABdhPJwj7jw3ncyb/vlR0b/mjdnZGtJJwK7vbXSZz1aLycpRB4K6FkGqNHOPuvn6UmE/8fLhh5GfjA==
X-Received: by 2002:aa7:947c:0:b029:32e:ba1c:173c with SMTP id t28-20020aa7947c0000b029032eba1c173cmr27204810pfq.28.1626716299626;
        Mon, 19 Jul 2021 10:38:19 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gm7sm17248100pjb.28.2021.07.19.10.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 10:38:19 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/245] 4.9.276-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210719144940.288257948@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3a0c6d00-415f-91b2-08c7-d9ef4fddf2a0@gmail.com>
Date:   Mon, 19 Jul 2021 10:38:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 7:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.276 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.276-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
