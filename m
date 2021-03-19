Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8D63426A4
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 21:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhCSUHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 16:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhCSUGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 16:06:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A562C06175F;
        Fri, 19 Mar 2021 13:06:42 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h20so3464185plr.4;
        Fri, 19 Mar 2021 13:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JXGKh4T+yc6l+Z0BHrIiKoDAlXQtyCpXhoY0lCCmLOI=;
        b=Kojq/eREMsKMDTPqwXZDbNdoxYVgFH77gF2v9wfPU4yvp5h/Nz1reEZR4cKFpGAwR9
         o8IP8ucEkSeuk9vrRoq0azn/6prGqHGBIDKyz4elAt1CoQwBMK3RCF3ZZbGdjaPH51Yw
         YQdoyqIyaF+piUjMI1lYxnOIcuwofUGwALiuySgyRQjEhRlNr4R/337oN9SPqTbryAGE
         1MMyjQFOT2QHOhJsaC7bMAbDBiIJBJUKEeuodkAaUcmfeodXDVm+XbgAmNnpMKZiOItM
         6DD0muJe1hUB/YLE23aDJwqlRypTlz5zQyxXNW+7pQeYzpKlyi4+qbdMhd+Gs4Zz2Jxa
         3IOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JXGKh4T+yc6l+Z0BHrIiKoDAlXQtyCpXhoY0lCCmLOI=;
        b=IW55rdKoOXXHUT+Rv4viawVHX9jVa2cT8sFbqOMF4zlKDCUOiduoLluJVMs7KcSq8S
         XavSMHZFkMJkt+UR/BiPJM5nwQflQGkUreVFR9WxDCj7/DEOdU14jcW0XJRw3v7dIOWs
         5RuN3Jz1UAaOYUbTfD4xaL50mov23nIa8wK6An5pxJawLOoRg/O7SWB+eL3TUIxDHZ24
         c2BNuWNQORWLp2DoXMsDJ/8r7fYYol1iQTmguzNrssV9vARVO/nz7/dtx9ygMHC7cXDP
         MwPVlOCSvXcqmzdNDPsLau9tdn+IlQyn1X78OJvnZCJtbFyNk6wV2jRu4vEeq5ZubCo2
         M2uw==
X-Gm-Message-State: AOAM530fYgiplFUdyN1YSX6Z4HU3pNFD9HKvaYw+smQaC+CzxIdH7QBc
        Ao1HeQOFgTL8c+3f+z7XyX78q2/Zuxw=
X-Google-Smtp-Source: ABdhPJzFvvJIm8DFM46X24tkaP+vda9rsiFnL9/2SoekE9F2YSTCgSwtrLhbI88NzrleLwV1U1wBOg==
X-Received: by 2002:a17:90b:ecf:: with SMTP id gz15mr182694pjb.85.1616184401258;
        Fri, 19 Mar 2021 13:06:41 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y20sm6423666pfo.210.2021.03.19.13.06.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 13:06:40 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/13] 5.10.25-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210319121745.112612545@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7761fa50-3964-1d96-c478-9c65fc4aca11@gmail.com>
Date:   Fri, 19 Mar 2021 13:06:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210319121745.112612545@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/19/2021 5:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.25 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.25-rc1.gz
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
