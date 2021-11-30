Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D180E46359B
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 14:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhK3Nk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 08:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhK3Nk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 08:40:59 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3DEC061574;
        Tue, 30 Nov 2021 05:37:39 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p27-20020a05600c1d9b00b0033bf8532855so14792311wms.3;
        Tue, 30 Nov 2021 05:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2f/CoC8F40xPU2kB5i64kIu4TSPw53l3XErKyynRf7U=;
        b=QUbHlRCyoWOcJMyQA3FYma//46hXwnejoj4YZNrezkNcXiu+YyjEYs1Hu3T5TzNJqZ
         Mu7VT7wgtBXLIVtRO8Ppe80pf5eS57fcItC1kW3XfU3MtcxShqjMAhY4PntK5QfcZD86
         BZjZZaMz48g2EErP85lpBvyFmtZF76JgHEPz7u+RahOl0Mbl2dJIGW/wR4hCjKD8rJEU
         77ZU3BCCWeUMRhN1tqAomwNnxzIpaFtMxUY8zgvRLlrF9rmCiKofMzTZxqT0XJHJBeNE
         Z/PHyC3YE4Gb8Ku9mT/gbmaAeYeG9svWgf6dJU5v9Mt0n/l5RPMNOfnCaGVW+E1XNMCx
         QH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2f/CoC8F40xPU2kB5i64kIu4TSPw53l3XErKyynRf7U=;
        b=lyjuWbniHoOM0F+vWGrO14iThaDW9e5gSis2Yai9EWHrKkTFmgBDqXuHHUZVVPqiki
         DuL6De/KOgxjxyafgR2boGW8GxB934QIuIwEyOF1umtlAL1ZLkBVWlFV7FM9Mf1lte/S
         Ts0YX8FH9T1iULbW0vNWEaMUmEayEy4BudzhRR5K1ZFaCJSAKtODxdBWlCIEYG+cPrDm
         oA2CQf1KZpYFkbOv1tRW5ii0sVZPl5hJ9rkecnKsRgV4Lr5ael3YPu/ZgZ5xHrq08+jQ
         d+RGVg5k9RP7+WM0K25HJUXo+qmVEeEI3sOvjAe+UlqQj+CISM4e2K0CnnG20nWVyyNo
         7edQ==
X-Gm-Message-State: AOAM531U8cW9Dz6DWnmnJlDfOB9PuwaX1jkTDhAIgtCDQGFMibcZO4b8
        fdpRIyi20faj11uoyOfKP2c=
X-Google-Smtp-Source: ABdhPJyPjivuqhgyIwjsU0sOiQ5DjuT2MJT7Fn4IoCvMht7gVkDCQR/XomnErwghZ3/8jJ9iO28hMg==
X-Received: by 2002:a05:600c:5101:: with SMTP id o1mr5078541wms.81.1638279458559;
        Tue, 30 Nov 2021 05:37:38 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id s63sm2581288wme.22.2021.11.30.05.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 05:37:37 -0800 (PST)
Date:   Tue, 30 Nov 2021 13:37:35 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/92] 5.4.163-rc1 review
Message-ID: <YaYpH4LCWmWdLOHe@debian>
References: <20211129181707.392764191@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Nov 29, 2021 at 07:17:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.163 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 65 configs -> no new failure
arm (gcc version 11.2.1 20211112): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/453


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

