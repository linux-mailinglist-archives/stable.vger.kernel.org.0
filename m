Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1431532F881
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 06:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhCFF0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 00:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhCFFZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 00:25:48 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C81C06175F;
        Fri,  5 Mar 2021 21:25:48 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id o38so2763243pgm.9;
        Fri, 05 Mar 2021 21:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o941qDUR8770hveVTPYtkikKABAI/Oqk+9amFQU1gMI=;
        b=miP46TqiuptRFSig4jMEjkwXS/jxMBtXBzq0Ew+pjBssvhmddi/12K09LLTGnmM/+/
         pL+rYfZCRYyh5AQ8jJ91EGzjp443E3GcUWoRN9klzJA/fN3olScF6iky5DhAkI1ZWIpX
         n33ypS+SM3jvWYmjjFt+uC/gsnvhMhanpc8SzeSL/MvOlBQdfLhJUd3EVmR9J5xDpjs4
         WsmLOlKzLhIQfqNRniJhCXl2jVtS4AdoeWC3c5NKQX/9N5TOxgVdppSzSTIYjlOpMtIi
         UorUBvDi9xjFkpWcWiMErkASrpM9aYiJ7qdAtVvok6ZwZdXnO9eqG6OC196M3mw7eotK
         Byow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o941qDUR8770hveVTPYtkikKABAI/Oqk+9amFQU1gMI=;
        b=YkJ6gCkPSpZMPK+f+9xwsQBAsWSkfbTaas9f6FK5sNcCacpXFMCDxUXGG+t9vA/K2z
         jec3w7XEdRPbBcMkJDoksB+yeNC0zjW+bIM+5EcKz7nWlHnHFd4D7J3rgF8+ipV9pMtY
         /E1z9LnmoIyJOD+XGJKNYStwVw5t8gZcukuhVqdByYQXPQvxKChkOgEpi0Og2t+Elemy
         1wMZnV8rdOsoNvOB5pq/vCoVXcYS8wgCVep5FVZTL00nL2+uBdp+TGZLEJSmmkUAWcZk
         fdBjogkk9JM3n3kZz3gU0U7akhWm/t36JDTEPn3Fo7mLyHgGTq89kOcNG3Flpiy36VjG
         +EuQ==
X-Gm-Message-State: AOAM533ZMqF4c/ZIYqrhhmQ2wIQ9Q4vnzQWc1DnBqtiSCUHKdmk0SdhR
        wB45gcKWcHS8cTMb36VU9VZNa+hnSi0=
X-Google-Smtp-Source: ABdhPJwmGD703Q2jQtGPs0sS64M76AXbdN2BZQnpTuIcJE7VOsJzkf/4L3Mnz7wO1GjjL71AR3dndw==
X-Received: by 2002:a65:4942:: with SMTP id q2mr11422342pgs.34.1615008347538;
        Fri, 05 Mar 2021 21:25:47 -0800 (PST)
Received: from [10.230.70.25] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id q95sm3824723pjq.20.2021.03.05.21.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 21:25:47 -0800 (PST)
Subject: Re: [PATCH 5.4 00/72] 5.4.103-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210305120857.341630346@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <43d90161-3537-0767-7935-2bc4cd5862ac@gmail.com>
Date:   Fri, 5 Mar 2021 21:25:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/5/2021 4:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.103 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.103-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
