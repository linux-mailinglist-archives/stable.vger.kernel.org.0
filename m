Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC45D427162
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 21:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241357AbhJHTZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 15:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhJHTZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 15:25:05 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914D5C061570;
        Fri,  8 Oct 2021 12:23:09 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s11so4006282pgr.11;
        Fri, 08 Oct 2021 12:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=043THLPv8UOPgKhXnr0xoz3+6YR3rwqfvnfA7k2NPic=;
        b=ZhzWitbGTWOV1AavCMHtw6rAMmHkudUuM8S8mv/wSoue2sPpGbb104kJ9J/wimKIvL
         2LswtlzZ7TAfRplEX3ykN2v/2+1HJ/A6Pe8pGsfg6yk6uMibzAv76cZaeV0woCVUKzDv
         teutejTeQYLRX61DeEjd8yQ38vQ6CQwD49AUi3qrgroFIYDkmMa/FdYWos29F4mn5M6p
         Jiffe2e93WL6UBYRaadEHi0v8NNbzFX8Y451GtVSoEVfqmYyJPtPahRerUKCWQ80qMM+
         8glWsGsWbOY2DpR9Rw/GIH5gOXugfz4Be/x+B0LxScwJx6ndduLWc6MiE4gUKsJ0VNpD
         cIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=043THLPv8UOPgKhXnr0xoz3+6YR3rwqfvnfA7k2NPic=;
        b=Mpz/KVMQIl+0iM60IhtR6jgBslbhrjkuJwDGLbGcdUCy0SNOTgOCFKZqnZex7xaTvS
         b+8r7ze2VJvEJSe2pZYVeLP3hGcmPU5mKhOBblB587pyFDhhlRUcAB/8p4BqYs1gHfvD
         bSv3DxMNUGfd6eFM39/R2WbHdwn0t75O1YRc/lOlCCgOlo+wGVpTaScgyG/iYZAjPFr8
         QxVEmClhz4lth10xEkqXiSRI3qjak2YQUpk6AbJ2dlr5hLqePdhgXDnP82wA2wd0o7P/
         J3S9l9ZStj0nGGtDTHT5JQhd26Y5wf4mN1q/KjH93TXBwxupL3D95sMYRF5CQU/bZLJl
         y7JA==
X-Gm-Message-State: AOAM530AfDKzG9wgPQ14p6TWrrxNGdRBgRu/HOHPTBXpZ8VgMq7t3Lc2
        +73mJac7LSPhh2OZTb3vqdYDiw7VZec=
X-Google-Smtp-Source: ABdhPJwPG51FERBiF6Ayafem88hZQzuCD5NtaByciu/LaQoyuQlVTLVkYZBnoKaUbGb7yJzdXYGGTA==
X-Received: by 2002:a05:6a00:c88:b0:44c:27d4:5cd4 with SMTP id a8-20020a056a000c8800b0044c27d45cd4mr11897364pfv.32.1633720988602;
        Fri, 08 Oct 2021 12:23:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id nl18sm55599pjb.3.2021.10.08.12.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 12:23:07 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/16] 5.4.152-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211008112715.444305067@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a8ea9c24-77e3-8681-3b43-9110d07e065d@gmail.com>
Date:   Fri, 8 Oct 2021 12:23:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 4:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.152 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.152-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
