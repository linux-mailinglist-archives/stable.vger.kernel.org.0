Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C2E45EB4D
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 11:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234900AbhKZK1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 05:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbhKZKZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 05:25:19 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95367C0613DD;
        Fri, 26 Nov 2021 02:13:08 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n33-20020a05600c502100b0032fb900951eso10302002wmr.4;
        Fri, 26 Nov 2021 02:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vzTvyouU61sKV6UzmShEtlrYxuTMTHNu/9QphS5zFwg=;
        b=CA+l1ddK5dRyH7g6WXUpBj5rQUWA36Zt+kQd5TwUxvWAki/Aos5rrMHPbmYoB/3zpu
         3lm01616YP/X468ypBCirFNBXW5DAbFUUPUm2LjnuXWBkuYs0BdixqFJQ131a/kyOx01
         geDDoGTIT9Xy8l448JFIDpML7ehm4KxOFwmkFSdnPmTG5LphQlyybaZYiUgT59iuruZ9
         Qn++J+Excp717sUjaIVWMn0OqR9haODMVkZHcoeeTeRTx9yGJrN8wXUxu3Y+AXQhJQGD
         ctiZe4XDfvnMfzneILJpPTwH3RHIP0Sj7Cgp7qhixpFN29c7zd+ML3PaNjKvgsESWOsk
         fIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vzTvyouU61sKV6UzmShEtlrYxuTMTHNu/9QphS5zFwg=;
        b=HSDfhC3nr0SwAnSAYWxF6PG6M+cBM9LbooCbf8U5aL5UVJQDGv3SRhajAMsocsQ3GV
         0AFnIiPSKAM3Bp3Afx1XZlC4zd2QuomDrp8HF2fgXUpK5IsHlzQGZrWrlsgRp5nditgV
         Kt0h56F/rS/5xHng9m7TGAqACjjvXjN8rotH7dw7WccMXu8mIxdyOI9IiS16sBY9i81C
         FJF9MY/xmWpJZ9ei2HMtxrv4aH/jHzHyHw7ishVuM/MMmHNwx05WzZHKE9TATP+tazpp
         h7EeZJlqsbvnJ6xyUW6yl4V1Y8kD3lXN9ufCX4ULOOEcGO2r8b7pg/HQjtLnRVnLLqRk
         aesg==
X-Gm-Message-State: AOAM530SP+YEVdE+nibLS3mSrmBNKZNtrxRw+IoqOCH4/Wl3AUa4WTPS
        A4Q7TMlQJWp8ySmpfuumOlw=
X-Google-Smtp-Source: ABdhPJy07wkm4qHiUPv/8ZeN3H3PnrJfwyPrsh1mfgL1zsVglJtQrn8cTeowgxRDTn1sEdQ5Xj6uaA==
X-Received: by 2002:a05:600c:a08:: with SMTP id z8mr14498433wmp.52.1637921587186;
        Fri, 26 Nov 2021 02:13:07 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id g124sm10244008wme.28.2021.11.26.02.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 02:13:06 -0800 (PST)
Date:   Fri, 26 Nov 2021 10:13:04 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/320] 4.19.218-rc3 review
Message-ID: <YaCzMLDa3/JyZklf@debian>
References: <20211125160544.661624121@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125160544.661624121@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Nov 25, 2021 at 05:07:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.218 release.
> There are 320 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 16:05:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no failure
arm (gcc version 11.2.1 20211112): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/435


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

