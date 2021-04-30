Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1863937041B
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 01:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhD3Xar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 19:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbhD3Xar (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 19:30:47 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865C4C06174A;
        Fri, 30 Apr 2021 16:29:57 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so138617pja.5;
        Fri, 30 Apr 2021 16:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LJfespKOV8EcdHi0bNMCGGznRrQpjhS0/lq88pDhCjI=;
        b=nqbEgoB9dsGytX7N7HSVmhAwgdOq5NT7ZFnBR4+NPVB5prWXJPFEyvxFbM0Bbpe376
         X5FRm87Ne8+ePs/iYfCB6XQiLHnz1SAMYDMsBelShajJ9cA78hE8T4RyflJDWGWD1/1z
         QpCGSW3zPlznWDqmok12b1jvSS2k0WI8AExzToGTfAdBkhSZWc7yk3TGW4aqc16sTh0+
         EKa8Q3RtgezBKGUbpcZkqSeBWvSPYqEhkC9+9DlUikUBNbDGxEXPHjys4q4oN9RX//ub
         EpOOQNlDNOsJQWoRZsrX6yTr87NQutqGf5vU5rEf2r75SH1HAm5033Ur4pJNlxnfSKcV
         i81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LJfespKOV8EcdHi0bNMCGGznRrQpjhS0/lq88pDhCjI=;
        b=tpWGynP49KkNiB/DOfU4tE1rSFaIRkQ1KM7DbLVJLEEbc6ane0/AqmjT8i1mnKcMVQ
         McJ5Ga3AuVi2HGd82dsXlI9ySBuwy1+IZrfH0z4PvrgX12bdR6tK3ZB1BIFWqJ6/yV7p
         aGvgI59Lh5OLxXkx45F2UZOZEzkw3ED+t06IbMFSeMiwcxkf4g6EShmuAk+Lg3nETqUH
         Jeox3qIhdlu+/TcR2hevScV3iKJjHTIih/jfddg8wEqy3+ZumGkF5wIgeOYMF7NGcLCU
         4al3UcpqQyQ1rxG+prQhdIJfx7in6xfJJ2Y1Xhk3TW1zD64tgEPGiHF6VgqID8TZi2pi
         g8MA==
X-Gm-Message-State: AOAM531AIIBfoH6jaIa3eom+cplY84EXiKUAMuug7ctVDCxr7U4YPzo1
        d7u4kgXcSer5OViWqPcL3bpMAWSYWus=
X-Google-Smtp-Source: ABdhPJw3aUEqgFiSOYdCozCsGHygve6o3nDDRIE7RE4xixkm3VBUUe4/cIQ0N+r6MPQXpIUn+5YAjQ==
X-Received: by 2002:a17:902:b095:b029:ed:46af:e33f with SMTP id p21-20020a170902b095b02900ed46afe33fmr7660346plr.23.1619825396671;
        Fri, 30 Apr 2021 16:29:56 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id pc17sm2883626pjb.19.2021.04.30.16.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 16:29:56 -0700 (PDT)
Subject: Re: [PATCH 5.10 0/2] 5.10.34-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210430141910.473289618@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <93b3cb4b-596d-f209-850b-2113145805ba@gmail.com>
Date:   Fri, 30 Apr 2021 16:29:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210430141910.473289618@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/30/2021 7:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.34 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
