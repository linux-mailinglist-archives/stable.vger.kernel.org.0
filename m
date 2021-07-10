Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A7D3C3427
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 12:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhGJKjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 06:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhGJKjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 06:39:22 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97C3C0613DD;
        Sat, 10 Jul 2021 03:36:36 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a13so15949893wrf.10;
        Sat, 10 Jul 2021 03:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=itOJ7O12UQ4+QcCm0WXEdDa2mbI4OnBUi9EAwuNKT/g=;
        b=Hqac/T5MlYlCR3oeZI98vTy9YbRMB7Dj23ZnizlV9ZpevGKYDn08SXIJwzqSF958QF
         alHu4TCyYz6LN/+2lP7HyLroj+GRjQeVesgHw2B/IfnysUHwR275sk3GieUCGevqMZsr
         USOB/Pp1aGhSBYnTsF1X3Lc038b7i/IHD7h7cZDcrEa1PxnLVxhBg174uPvyVGhh8F29
         Wcj7NFOoCpFybsRfTz9TMOny2GOiTGmfgIFSpL3rHQwKhZkx8233glP8HqQYxe2LIX86
         p1jH8o+VZDVbkpCwDRVgFDzhREpVmhe7j2cyDEUQwH7yvdpLK79mAsMt2MxDDnVd4Aqp
         Kn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=itOJ7O12UQ4+QcCm0WXEdDa2mbI4OnBUi9EAwuNKT/g=;
        b=lDJCwOm0T1oacTX+zi/36TryVY+Hyd3lxfH9Ptd5garuKNUATxBRP9PgnjldQbOobc
         /ipWkie3MPj9pfysnhBNeTWVmufkqUqhn+WSIjGEtteuSblRbJeRUKJC2I2CJoGSLn6O
         2X3wstoG1v29COYrAuk7tiHkn+jadWBBcaewbDT8+0IYpFOr5dZIVXkFG+BwPuioiQ3Z
         SrS+z4R3CUs5GxWAq0vtWavRYu5paCbZ8j4eK81cqWIGHk/RZx4CMMp0jyYZ/obrIjod
         rmidoc8TiIbX9Q2cun6c4N/tfrLYaSW8hieCj/iezKNsFt9kcZZlrsOaWCSUHCEzk17m
         pUsg==
X-Gm-Message-State: AOAM533d1JiOHrVuTIuDQFrbOcMX8ua4JnMqN2Bz0DoIlF4UqpIAJe6j
        9AtHqvVkF/NtLyQ9VQ3AZnA=
X-Google-Smtp-Source: ABdhPJzMtriJQqSQKQheTUSG/1RgN25DsXSHC6FDRXTfESTVR8GdB5H2NRQ2cpW2AIY9uc1KorZGyg==
X-Received: by 2002:a5d:5642:: with SMTP id j2mr47213188wrw.194.1625913395447;
        Sat, 10 Jul 2021 03:36:35 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id g3sm8109053wrv.64.2021.07.10.03.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 03:36:35 -0700 (PDT)
Date:   Sat, 10 Jul 2021 11:36:33 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/34] 4.19.197-rc1 review
Message-ID: <YOl4MTSLcz0imv6M@debian>
References: <20210709131644.969303901@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jul 09, 2021 at 03:20:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.197 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 63 configs -> no failure
arm (gcc version 11.1.1 20210702): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
