Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0923C46D0FD
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 11:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhLHKbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 05:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbhLHKbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 05:31:33 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD9CC061746;
        Wed,  8 Dec 2021 02:28:01 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m25-20020a7bcb99000000b0033aa12cdd33so3107034wmi.1;
        Wed, 08 Dec 2021 02:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BKcPPW7IsO/x+f5xXO+3Ai5akR8LBUqm+pPaSHNiqaw=;
        b=MzZSPR2GDhhUjRAxxpQMYD4DkRH2UE3izAKhExIbSvn1R4xOSY2ok6I6b3otoR8c+m
         zrRpt98koiCmcyljitl9pkzUjjSXmDYBu1O+GLN6M5kemdlzLj0aHwVVWSUwL9vKgXja
         q0hkJJ5FNPGAaFDAV20Hy0F0XZyawehPNIpnQ1ejAg0AX8dR/rQG79FDlGYigjd1tp04
         /arhwAdKxVpu6bsCSp1RcyF4I7u+IDpLcgQ8dX0k19Fo0aAWUUdd1zCtffsKDRjyQ20s
         vB2jpYcTBxSwMtpAdeTLovR9Eklq4Pg8Ja+58dDMo+iswVKkFMKvAZ3QysUlpXEss+Uu
         rCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BKcPPW7IsO/x+f5xXO+3Ai5akR8LBUqm+pPaSHNiqaw=;
        b=4S9pLNZEY5UFgwrkO+tuJv7sA1Y7FkJ0Sfk0s0bYlxpPoRL3HWDQN+97KGER/9sI+g
         PAGuFCc2fDyCY8Ml5ETo1cW1JthKx4+MtUDd8UHZVsUHKFaIFsV5bWA9yvG6W5fFTZSC
         fhQO/LPKyV4LtOBTp7Pzq/wQT0mKzOEbjqIx5nOGVSQQ7MqHIx/d5JWvjQssTqxw7EQA
         8CKEkCXnCmSE7L+C8hQmcHJV86nJfd7TWkdIxc8kHTLMf4K212Y9EHUTFMZ4Cly8opUN
         Is9Q2jJH5N6lwSwC6PAW1Nx6yN86e7H16/A7ncm6gmwcQydaKAqlX4pAyvpEebyJjzWz
         ln+A==
X-Gm-Message-State: AOAM533IIeH2LZ8t9ZP8H5bvTheezGn7TPOluSDytwBGVTHIh7UjEYc0
        8IYpoprW3Kee5NS3co3Ncjo=
X-Google-Smtp-Source: ABdhPJyDeI/u0LWzyfKmvhYFK+LLNKNBrQ8e7khN/yblE4VoDyn4UG9mQIQM69ocettJz66wCkShtA==
X-Received: by 2002:a1c:287:: with SMTP id 129mr15022905wmc.49.1638959279788;
        Wed, 08 Dec 2021 02:27:59 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id m1sm2185332wme.39.2021.12.08.02.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 02:27:59 -0800 (PST)
Date:   Wed, 8 Dec 2021 10:27:57 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/48] 4.19.220-rc1 review
Message-ID: <YbCIrRKo8YhhEk7u@debian>
References: <20211206145548.859182340@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 06, 2021 at 03:56:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.220 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no failure
arm (gcc version 11.2.1 20211112): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/481


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

