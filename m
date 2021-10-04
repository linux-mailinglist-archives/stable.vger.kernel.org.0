Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E8542189F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 22:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhJDUvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 16:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhJDUvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 16:51:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2B9C061745;
        Mon,  4 Oct 2021 13:49:13 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so340399pjc.3;
        Mon, 04 Oct 2021 13:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lUSgOjX07V5C2VptmfcV2gNkX9WDBsPP3BRqImw10VU=;
        b=l39A9EzuILx65jBxr2xjnx90Cusr1u/cJILH0RF0gaCdd1FWyzmbzYuxNSBqLyA7gj
         QOWLWFfpPuEJRurTWdFojvMrol3X/baG+M2ivdcfsDkKHjh+Y/C3cG9zf/rR0soEHurw
         wL5NiGeYsLTXL8znTLWliy2aYhph9meE1DwicC162/REACr+cQmCOa42PyeHBFJPnj5Y
         gXhoOf7aRf0PG/8Hr6owczgkKkt92TrvHS8XP+r3bfwmayIu36EnCDndr2yqlQ7wz8jv
         jRcv7IJSQ8LzRNdMZ1cYOa368a65oKyWbg8Um7UlUgHbvv99211AGWfiJkYLqZKWLOfw
         F8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lUSgOjX07V5C2VptmfcV2gNkX9WDBsPP3BRqImw10VU=;
        b=fj4VXOLoc5JxUOEeVE5MBk3PsRCI/3u6nTFPH6d9xEaUDnX70P/259ankvmLxycxc2
         f06wdLj/Ow+xZ8WIHiUMOgngQ3Fxey5cTw4lLogG1Ox6LkWzLjDw2beYFB/IAwx/eeSb
         xGq9w3mlKQpm0EjIUEz3pGskBQ58LXxTTO4vd+o3OTWsAJ7quxCtYSHhAFVbE0UUXJan
         k1ojcjfxmrMSMf7advGsHTNbQCk8/v0IYz8pG6CGwaYiFxtQ4nxwnqfK4t65L2ow7V5x
         Llm81AKe9QxzaRjYIm3zsnI5Ibc8piAWIZv/R856LbTqJ0CGwXBgPXFQe9MfGbJLq2Ns
         sJWQ==
X-Gm-Message-State: AOAM533N++Ao30LTcoxfZX09zqyEPKGa75Nl0cg7wGXD96dzLPqGGLqO
        BEN4gF6VhZyX0TihpJK3Aj5A9fi3V1A=
X-Google-Smtp-Source: ABdhPJz7t8nCLL+p5xVLjmVVtjlVb2oE2PskvIyM0+e91oyhWNlhGSywyjgd3SX3Y6GdEcVNevSdyQ==
X-Received: by 2002:a17:90b:1258:: with SMTP id gx24mr22772842pjb.205.1633380552265;
        Mon, 04 Oct 2021 13:49:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 11sm14757508pfl.41.2021.10.04.13.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 13:49:11 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/93] 5.10.71-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211004125034.579439135@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2c14d264-bd66-e113-f658-86fe98913f37@gmail.com>
Date:   Mon, 4 Oct 2021 13:48:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 5:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.71-rc1.gz
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
