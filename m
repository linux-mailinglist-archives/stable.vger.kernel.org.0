Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DF53EEE5F
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 16:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237812AbhHQOXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 10:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbhHQOXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 10:23:00 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027A0C0613CF;
        Tue, 17 Aug 2021 07:22:25 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id f5so28851641wrm.13;
        Tue, 17 Aug 2021 07:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c5gzsKQOFoHapv+OCGDgMTwgfe1u1dMVihuAw4nlFpM=;
        b=RGcWzNc8fbR5YwrG/z0iKmNV8ZYzKncNEn3ImW8H7y19cxcE1eEfQB/I0wDnlernly
         J2qbFGUQNPE9wzS0zkbqV1EaWrh8OdvyBXJhKKdK4xe0HzDIPC6kI26FSq5gGIp2R73r
         LZpE18raaoc/kNxd200DXoTcTzPYV1fTXVILg2Y3Z0EIrKEgCHh3u7oz1E6BmXbOCb5q
         khe2TNtlAZPLmD906/HCX7pHtmTDs1kHmUPq7py6yYfROUF2hbYrjw9lIrBWlONsH1FN
         P4xTRMLqa2nU8miYp16p0tk4XKbP+It0TOY2eNlboVqyOmzi2VpYPmH4etKw5CRqusmM
         hyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c5gzsKQOFoHapv+OCGDgMTwgfe1u1dMVihuAw4nlFpM=;
        b=YC+4YY0IjZqA8194XW/K3eaZHzaVbqDAe7aheGeuvl1Fl2svgRcYqdGH4WNRlsgMOV
         W3U23FWW5MoySDmwYH+3uz8H0Zysk+lZhXA1Qti1Vd0KQbGlB9AlgcodpK8zoU5uyyHm
         d6a+CrDF5tyhyYLpOk2iUCedDQurXpEl33l6UBnKGdagU83aMOZJfY11WHszK2Ky5pLg
         U5lmBmzIzBbly5eYhXm7BWDtVNPWZwCjJ/W8ULkmRWfoNdDFjGsld3AXpau260iZAA1y
         eB9xfMxjg/gefOfqkuqTsog+7fZre2b4niWKpjvDTAxRXJ8Nl04PiHWparDIbGp60Al1
         tbkA==
X-Gm-Message-State: AOAM530+7fV2LP96BWUhzBgTpN5Yxg2kreDvkRLmLJvoBT5aC6dzgHKf
        Ln7xPCOn/ePVDEvsM3HZicc=
X-Google-Smtp-Source: ABdhPJwp62WqcmMk/lT7ZnVot8LNsnCCr5y3aMPnZmeXsMPoh6JDsESC7GHDK40tCv+Ip9RnW2z/TQ==
X-Received: by 2002:adf:f141:: with SMTP id y1mr4458904wro.173.1629210143624;
        Tue, 17 Aug 2021 07:22:23 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id a133sm2346869wme.5.2021.08.17.07.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 07:22:23 -0700 (PDT)
Date:   Tue, 17 Aug 2021 15:22:21 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/64] 5.4.142-rc2 review
Message-ID: <YRvGHVsOapD8wOCF@debian>
References: <20210816171405.410986560@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816171405.410986560@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Aug 16, 2021 at 07:14:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.142 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 17:13:49 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 65 configs -> 1 failed
  decstation_r4k_defconfig build failed due to new binutils. Reported at:
  https://lore.kernel.org/stable/YRujeISiIjKF5eAi@debian/

arm (gcc version 11.1.1 20210816): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/37


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

