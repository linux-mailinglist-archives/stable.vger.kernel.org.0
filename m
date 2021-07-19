Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702903CEF97
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 01:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350522AbhGSWRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 18:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386598AbhGSUBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 16:01:22 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9550DC061793;
        Mon, 19 Jul 2021 13:38:36 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id h1so10273285plf.6;
        Mon, 19 Jul 2021 13:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zvfOqj/iMzW/3x/SbdOXWZwmaxEQDrg9zGqsRun+4Sg=;
        b=WqFWK0DFwQpzTBjxf3DGrKohdVsvTJ82kxfY5W/I8bMGX8RxgDZTq79CqtyaWfLKR4
         JgIwLyFlJpAC7GQ7Mc29kQAvvjUnUI+s0cezuRGR5XbALxHLyK7XhK9dEHchbTEQJ0BW
         ZXVT6Hvvwmn86G+P3Ajo8Enm55JBAX4o0VYPkfz1xsPXJNv2o8MzI5ijHnLz9Oly4oSF
         j6wZDK6eZnCGAfSp/JZ1dBb9kS9GEzV1N3j1RAylLjaJBnsh7x2It9RLZorMj8rDdMz3
         l4Gg4EcbH56C3qo1EZkFxLznzT8V8QzHX/K74q45XJpcyBVvQyllKVB4Gc/qgNUrni8V
         7GdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zvfOqj/iMzW/3x/SbdOXWZwmaxEQDrg9zGqsRun+4Sg=;
        b=EIywLHPqosuqHIkN0ch6t8rHXJC+9j8gB+W18hkMXwqK4uXcwa+ZwBpD9x7vsy+l2N
         gL35tkXyeR/CmCbis2AzZuD2ruMJrTM/88FPRdGctZQYEMOXL7GN/In5UVEBSroJ4y5n
         Rs98azd4tGljUXPqlkyjGYKMs94ygaDuGd/TLkK1o5VW/fl9ZEOPNTow6SkJACCLZCMX
         hOO+B9Vcnrdr03RoWDoN9O/s7r/dWGhWwzW8UPMqBW1P6CZBM89jsek8K33/ftwdoFI6
         aKuJCclARMj8DTHcE5xg5f4AqFsB8k9qM0sEzOGnEfOAw9vIGfreo/VEix7pGQ2pZSRt
         Hypg==
X-Gm-Message-State: AOAM533wHPZ0GTj7pwzvzuwdg5eYxcCWHX18Iww46QdW53ahDYOjtVZM
        5r21wwsP2uDdJfB3ApLYXCD4u5pIUC3Cbg==
X-Google-Smtp-Source: ABdhPJwtOUY5nSNJvNTz6jwKgEXYabugLV9X2U27ABnAuu0i20xM7T96igGk5CS4Z/7TWMSA3OghJg==
X-Received: by 2002:a17:902:bc44:b029:12b:415:57bf with SMTP id t4-20020a170902bc44b029012b041557bfmr20557092plz.33.1626727273844;
        Mon, 19 Jul 2021 13:41:13 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i14sm3239478pgh.79.2021.07.19.13.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 13:41:13 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/148] 5.4.134-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210719184316.974243081@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <10fe2a87-bc0b-f3b4-50bb-1c35f8016f75@gmail.com>
Date:   Mon, 19 Jul 2021 13:41:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210719184316.974243081@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 11:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.134 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.134-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
