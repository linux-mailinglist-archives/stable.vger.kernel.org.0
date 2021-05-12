Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D569637EDA1
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387873AbhELUk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381016AbhELTdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 15:33:12 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DA8C061374;
        Wed, 12 May 2021 12:24:54 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t193so6411893pgb.4;
        Wed, 12 May 2021 12:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6Sm0tlDzDYGI8SetZLYGafgnhr+P2zJ6LJDeo4pSrGc=;
        b=W3Ka0EnP6nk9NWThSJEDnC32NbOsw6HwZRxS9FxCao6dGRR8Ifo0/4QtqTzGrBGYDm
         NayDsiz+p3oC7l5majf0yLxp1kX9SEq0tsgP6dWTlBFnWzaOinh4C/wZf9D24+V97Q5B
         xfkcbsUJdSmr4YE94M1ln9B7SFJgLdtSQC+93Up1n22BobdPWRvHJuHQTYadIChvHPa2
         wCyngXrT34iuNKe3mWOxhoEbz0g8dkGz0UCWJwioQanPeDhZlx5z2Xcbplh0opPNB7hw
         Tlu1FbC1FOU7P09e1IaqJYGutRAFO6iTXM/1cL6LlcqydZ7ZbxBCerMa0z0tS7z8GUjj
         qkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Sm0tlDzDYGI8SetZLYGafgnhr+P2zJ6LJDeo4pSrGc=;
        b=Jhg+XQumOamxx8vJsjQlllxQ96yG9fg3t/bRS8kJZATrKyErYttPLHBK4VnqX+It7J
         Etw8RoW4zc2/L2wEt0cnOrTTs2nqAnmb/iDRgpoU2jd3cSN4a6VFpw2DUzSZs1l1zGPA
         bTDeBd9O/wGuzZa4vGIL1Q2lsP/LBwf+LbeST8m0MKWsC2vCnYgxOpz2LkYAdX4VfXGj
         bG/5TnFDWq9n+KfNTkZkanGyfJFbL1NySEq0RqXOo79iAAXq/TF9Utam59cRCH57xzkg
         NhiXLzJok2HRiNGBOrgKCKp7vHKSbZQ23Q7jjI08rcfsPaEON1iJTV1Sh0ULsryFx8+j
         uMog==
X-Gm-Message-State: AOAM5324hDqvA/ekDKrBDbFzVU31wT88npDQ59/yczsZIqORWqpQqsv/
        K1ykq5j0DhUfBDFC2VfT/h14fpiLJC8=
X-Google-Smtp-Source: ABdhPJxT+RsAbSyMt7Vx8ONS0PRPKC7fjwoJHM5zS+H66DyP6j64NIkKWD/4UssgWMyMYDSybLV2BQ==
X-Received: by 2002:aa7:9a41:0:b029:28e:761b:4bb7 with SMTP id x1-20020aa79a410000b029028e761b4bb7mr37507534pfj.48.1620847493271;
        Wed, 12 May 2021 12:24:53 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h1sm459447pfo.200.2021.05.12.12.24.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 12:24:52 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210512144743.039977287@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <46013820-0114-790a-d453-f12f2203230e@gmail.com>
Date:   Wed, 12 May 2021 12:24:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/12/2021 7:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.119 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
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
