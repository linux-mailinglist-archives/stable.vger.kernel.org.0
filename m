Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B2447BEC7
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 12:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbhLULUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 06:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhLULUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 06:20:43 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD488C061574;
        Tue, 21 Dec 2021 03:20:42 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id a203-20020a1c7fd4000000b003457874263aso1438417wmd.2;
        Tue, 21 Dec 2021 03:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A5VmHeK4a1YbrsJfhZ9m+7CzigXVHiNjupNeCq7BdgA=;
        b=adKXF+uU9R2/GLmLmvrIRm6GfGmjGGpbIboCM1X2LGnprMQIROvAygtZO3H3CTvEh3
         w4m21LIDQG0LoUNmNp8WJ4g9B3hNsaN8Ry6mTwhVAwXsWJaasnJE0pZDG5U25B2i1BkN
         isecd5PxUOUvdhYtrVM7j/2hxjoAH14LkiiJxd7e06XXXrpTNYh1RfXGioJJhsXlkbNa
         GsC5DAzMwni5MaRoNbYsjzvUroTGC0gDKypGmDBT4rStU4ZjNJ8DsL6xJDhrcoZTVpX3
         v7hKDsjjCbo8oWbPsaHwWUNGRo9E0/UGPpDrok7zdd2xa8LRs0/XKUUYzLTjogUJwm2+
         2AcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A5VmHeK4a1YbrsJfhZ9m+7CzigXVHiNjupNeCq7BdgA=;
        b=F4U6Ugs9uODojyQkfgZIcgjcjySGN3B3wEq9zThVp65xJGnedrU8FttKp7Auatlcbw
         ATlWXVCCx/AVKp5xEeTvZc/KjMWEWKPGYdgrkiSXAFEtMna7Ly39zPfvWT65ypxv8m7e
         4/FQ82tP4t/LL4VI+sDxa/HdWPioJEAgCMh40QAbjVQV53eGWG58cwmOjGqrYy4kxf1z
         q2zXJX1QPDrWn7fmfPymSgis68xgKmcPPygzk/qWfPQf+EnGyF98lGLtPEZfZ6YXzLvd
         15tg1yfsCOoOhom9LZ6zrO65c2e7frcpmu3fm8E7EA2xsLzS3Fd5Skfu48SSLWYH89xN
         RWtw==
X-Gm-Message-State: AOAM530yEc2gbOofnf2pk0+lg12NRGFAxRDQT2mNXge0/+jUbheAT/Cg
        0MJd3G2+yIrzqrrFdcqHEg8=
X-Google-Smtp-Source: ABdhPJwr9w2UUZrBvUeIB+mRDvojgbMcazHUP8KlAU7k8Q0CvZ/p8j+dR78N4jywxn0tn3xPNBOqUg==
X-Received: by 2002:a05:600c:3c8a:: with SMTP id bg10mr2358826wmb.106.1640085641346;
        Tue, 21 Dec 2021 03:20:41 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id b197sm2086906wmb.24.2021.12.21.03.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 03:20:40 -0800 (PST)
Date:   Tue, 21 Dec 2021 11:20:39 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/71] 5.4.168-rc1 review
Message-ID: <YcG4h+QGy40HYiwj@debian>
References: <20211220143025.683747691@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 20, 2021 at 03:33:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.168 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211214): 65 configs -> no new failure
arm (gcc version 11.2.1 20211214): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211214): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211214): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/534


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

