Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47354442E81
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 13:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhKBMyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 08:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhKBMyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 08:54:43 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D0BC061714;
        Tue,  2 Nov 2021 05:52:06 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id o14so33027696wra.12;
        Tue, 02 Nov 2021 05:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R3A8LIIbM2vtwig8ZzXQR1e+Ts9cr0GJUB7k8MXTY30=;
        b=iZopbB0ib46WdY2iZ9PiIiDIGggXdLjW8+6XKEKvBzmRuZSqbdRrnnOId5VlWxT2YV
         QJYuj88Gc3vPJhOW1StqqcxDwaUoqsnRm8T5hI1orHg4Xk6Klipb6zX8Sa3CqeOrfotm
         Rv6TNbrPgRvSxAqEOg0C08o+SDr0nVrRDKxYbqSZ3Dvp67fis/VfbfQIrkcohSza9X1T
         ManCN/WWaY0jNsTqbpS+LLgdfweiQEcDciC8LT1xp2lnJs/Hc7jUXvKJhm36n37+dHu1
         uHDL0mUhbxrL1DaGCOE9rVtYPHXPAtd0kqi3EcODPbS7kld3nf/RAOGd59JbWX15MKWZ
         wM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R3A8LIIbM2vtwig8ZzXQR1e+Ts9cr0GJUB7k8MXTY30=;
        b=2rYN8xzOLIv/kMMwsY1+npYLUz6LmPgUP3G2wt8ZFwFgeK79zJyXSKenkMG9uQPmz2
         PCGwXAf8UJEqiVJ3dEVhc1lQ7+7EUz+/7Y1qGlZpZPoNCeWMdG7aBNsU4RZ7ZVRxnh/l
         Mloucclj5zI5RlcA4CKZQQbOkuZStvDxWbGWLEWIsA8AMCX2iBmKfaDADwALOjARa3iL
         v+LfibcOD7jcfg7bGwZ5sX4tDb3kscnZRjPZRzAebhR1ejmYxQuSAyiwc0BZ5DAD36x9
         fr5XVy7sIbgdVeju2B6P6Cj7UftjH7wuh4iexBIyiy4CpToqi+0B7gRjj12qcq91wRrP
         JWaw==
X-Gm-Message-State: AOAM531KmdN9Zm0dgrzi7aFybyJZCWKQgJXCVK5p9H1+Qagf00fzVIyK
        kcJjzCqLHq2vwe+TclyAd5U=
X-Google-Smtp-Source: ABdhPJy1JUIQaVESYR1YY4OYC0+4ISTVS+V9+NHXV7CvuGAcpnZNXAVX2udYaaBtIkDgP93ExYQweA==
X-Received: by 2002:adf:ce0e:: with SMTP id p14mr25701587wrn.423.1635857525597;
        Tue, 02 Nov 2021 05:52:05 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id q84sm3424819wme.3.2021.11.02.05.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 05:52:05 -0700 (PDT)
Date:   Tue, 2 Nov 2021 12:52:03 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/77] 5.10.77-rc1 review
Message-ID: <YYE0c8KtXM54AwrU@debian>
References: <20211101082511.254155853@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Nov 01, 2021 at 10:16:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.77 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 63 configs -> no new failure
arm (gcc version 11.2.1 20211012): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/329
[2]. https://openqa.qa.codethink.co.uk/tests/326


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

