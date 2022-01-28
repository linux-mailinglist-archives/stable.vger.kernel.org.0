Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A2749FBA0
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 15:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243052AbiA1O0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 09:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiA1O0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 09:26:03 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39100C061714;
        Fri, 28 Jan 2022 06:26:03 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id i187-20020a1c3bc4000000b0034d2ed1be2aso8335482wma.1;
        Fri, 28 Jan 2022 06:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OVxo/AS9SvfQcIxqV4VR1wy4OR2PTsuuas1ogg3w9rA=;
        b=QUCVFIqzdMgMgA2FmCDOerCJKhAkmva9esxAp2Vy72fGndaCwYEUy4W8A19l/7Vtay
         poMU6Eg3VZ+9A9NUf8oMH4PFgM2rbchTVBsg8kAqCiIcUK/TfhRjmrfS7tmr5Zl+siYx
         groMZOvMq90wKHHwYKvaMdZGXlE2ru9WOrgT6pEmT71PMFBj8oCYMroOTd0PtDG7j77X
         UO/GF4p1RAGHFKSqZ8L7yx428X0FyoyKNW6z22H4gF8rutS9wrAkKdjic6B6EG3HSzxg
         nyTg1WNNGzeCH1LyRBGeCPvHaGWI9BtI4mfl+JeZzQWr7iElBMXF+bLW6EqJwxJvIsO8
         IWnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OVxo/AS9SvfQcIxqV4VR1wy4OR2PTsuuas1ogg3w9rA=;
        b=4bgOdBHpRGQbUga1xWCbx8C/8N56hfmEqsq8PnPsszMkclK5/OBD9fIbfRagBOfMyw
         P4LEfGROip3Uw5yK3OFCnj8nxHOcYGLZ+scM9LWnHrc/cQ3zAWuPB71UAfKkLL9xemNz
         jUlkX3PuVdpa3FE4MjIVvDrlGEyMmurQHKe8+51JBZodEIa91/PSsVX/HtL2uzpws1PL
         b+kGMlN4pljNWCBmd1ndWBqgyDK/AxLaI3qm5lpRKSz3GTCtNZJMat7s58LAK/7AUkuZ
         h1jUBrM2xYdwIs+XUAcxmCrUWdmZ1RVs9l6bbOif/t+qITX5Z7ymPQZ9IyUMw6vL+XYA
         G89A==
X-Gm-Message-State: AOAM532/KLCWvqojYzEUNLu5OKigx6tyMY5TAnqm4zkeN1mSXSsq3f8x
        Q3vQv1o9xH1NtqohphL3dQo=
X-Google-Smtp-Source: ABdhPJzQftVSC191BVmIsuajtzGLZQk0W+nQtRgRhBritgzFEO+GfRXITo4ulT7ZdoPA7pK/zy9cxw==
X-Received: by 2002:a05:600c:22d4:: with SMTP id 20mr16501235wmg.41.1643379961844;
        Fri, 28 Jan 2022 06:26:01 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id f16sm682694wmg.28.2022.01.28.06.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 06:25:59 -0800 (PST)
Date:   Fri, 28 Jan 2022 14:25:57 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH 5.10 0/6] 5.10.95-rc1 review
Message-ID: <YfP89Y3iJcJ37n0o@debian>
References: <20220127180258.131170405@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180258.131170405@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jan 27, 2022 at 07:09:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.95 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 63 configs -> no new failure
arm (gcc version 11.2.1 20220121): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/666
[2]. https://openqa.qa.codethink.co.uk/tests/670


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

