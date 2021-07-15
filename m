Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0682D3CAF04
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 00:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhGOWQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 18:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhGOWQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 18:16:10 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400F4C06175F;
        Thu, 15 Jul 2021 15:13:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso5544369pjp.5;
        Thu, 15 Jul 2021 15:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j4RQ4cqe6boeDQu8MH47CCEJwmPxlvOW8sENDevC29Q=;
        b=WAfyCklf7Lm/1z3vFeKdM0PkSIKfqqWJc93M6a0iKIqNlwcw138/iuMpPQuPadVjoK
         Ifq14gQk8i3Sknnslh6QjbFGkBoS1mNuPYLoIZDGwt+TAKIxJ83ymtKQ3AMoBpbohzxM
         +3wFLOjZN+X4+gyA8JvITFJh57qUyUJuB9HkppeEdyoq9+qBQrqYvssUgE2fWlViDjVi
         QyB8wijS709vbq6QBiZ2SFWL1sKvKIBoWLgP3Qq/N/fY4f53i64LxrpdCHRtOZiFkSrM
         zsWIWsQMXItbkjBT33AVVBTNdZ8xvS5fkC/ZwV2mQ/Wusw7NRN9oTl6iBDcdKIF+ZxM2
         zMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j4RQ4cqe6boeDQu8MH47CCEJwmPxlvOW8sENDevC29Q=;
        b=Zj1h4WkyLnNT6iOORebNT/ceOV896TvdotVXHh9Q2cs05lsJimh/DhPkp2amRsEqZc
         d0sRV4+LTatuIn3u8Xot4Ton8jj4EspltRY/Kh9O3X0tzmejg/6Bs0RTNQvpkcuKKa6S
         /Jl9BgHZTDzcXL8tUN54bKcjvMIol9m52Zih+MDbfx9ZhSY0lSJTz8e3P/EDkZ+YJ6qk
         DWFDkrg+579soY64TbPKEBhZC5wICbR0YkQSTly9eqH8FifDq7HLdeiFSrZdxI9II7Fz
         GCpxLBMALhs5S48JPcs9PEzCo8hi5QV6HU5QmKIoFDmbl27S45LoyzeEdVG1RgiwQGDI
         v94A==
X-Gm-Message-State: AOAM5304GPJb8PhAZgSkgQ92F2EAMygAfOq8PHudQLz/5/l4WhKsyYN7
        oO5zPBQBH3DGJmMb4jP6r2v229g0R7JMHQ==
X-Google-Smtp-Source: ABdhPJxY84RWMXAQWGU7FaW/M7r9unBecVwqt3Tlvm2H5YgKed79/TbAzXQyMPSw0cYxIIRQM33JzQ==
X-Received: by 2002:a17:90b:3b4c:: with SMTP id ot12mr6474284pjb.218.1626387196374;
        Thu, 15 Jul 2021 15:13:16 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w18sm7057618pjg.50.2021.07.15.15.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 15:13:15 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/215] 5.10.51-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210715182558.381078833@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f5b15db4-210a-a5dc-cf5c-899737c3365d@gmail.com>
Date:   Thu, 15 Jul 2021 15:13:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/21 11:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.51 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
