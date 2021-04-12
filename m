Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6E635D0A8
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 20:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbhDLS5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 14:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhDLS5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 14:57:32 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAABC061574;
        Mon, 12 Apr 2021 11:57:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id d10so10101237pgf.12;
        Mon, 12 Apr 2021 11:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WvQ8/2cvCNCRZTjrEJ79uU7ElNDTU7PZw3Y8x2dt3mI=;
        b=F7IerN3SmgIiQvd5hFdFvVUTMMyQMc01Ik6A00G8/5ENQ1pkK2zMtG4vPT3RHUVoOV
         PAOyozwbk1k8LC0+wBkciifQtTQuLYj8JUsY4Wvf6tlHLNzlB4YLkj9dTP1eaxyoQfIU
         OMjPVAG3gnCt+ZbcjtxUvuBORuiKkZcVnU3+thXh1l7ucVNfNyCRUNZhca8TOfko0Bjr
         86XD35sbNDsfz1+aw2sQCyWruMbixyO52KnL64xRNf8MbGFdwMj6DFZn2Hc8j2a93tv/
         l3l15N1Shgx8oXN1KCE8DpX7Yb+QYj2jUwFiP5XTJlCSTcNm8FK4fiwQaeBLuVnuYviV
         QHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WvQ8/2cvCNCRZTjrEJ79uU7ElNDTU7PZw3Y8x2dt3mI=;
        b=V3MBNVv4Cl2tEFoY5KqXVdlIP5lkqLNccdUGVzBRBuVQsyvSDViqukSCCHEB3/qof2
         5ezO7dxYdABr9S+s2v85ATx/cz8FI76JnU1o7oZUB/H5BR1Z8brPJi/VWDbuglhgOsNc
         JSBE8RUmI7T9a2uC1HPExfSFLJmzjaWMVx6Iul0fJzuCOnclC9By1TpA4leSNSm519xE
         In2Mh93UO9lp7S5KCc4RZe4SEqpLy6Lfo4c5xq6BZiVchCSblS1oppiuQhDi5YMqPcdl
         CvcMGNLrOhHDBB5WA4vf8PaK3CVw2ArRFhkDWLD5mpHPxwo32mSenUg0o1TGrPdwWWqp
         0Caw==
X-Gm-Message-State: AOAM533UIy4RuLFU8fnw3lnFdXJYqjOkmBcLbcM3mDQWPCX5t6CiuZei
        c+Uu/QjTQD2KthBaLXKLktPIcbIH01E=
X-Google-Smtp-Source: ABdhPJzoxjCm+aJ/APp32CFT2IcpxfGfzOTBECr0Wkq4AycOVMxTH0vapkkKsGmkAFbcolgG8tXgAg==
X-Received: by 2002:a63:3e4b:: with SMTP id l72mr27806692pga.203.1618253833239;
        Mon, 12 Apr 2021 11:57:13 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w67sm12671190pgb.87.2021.04.12.11.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 11:57:12 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/111] 5.4.112-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210412084004.200986670@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5d4c3dad-166a-207b-fd62-6e4977558adb@gmail.com>
Date:   Mon, 12 Apr 2021 11:57:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/12/2021 1:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.112 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.112-rc1.gz
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
