Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26B7370392
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 00:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhD3Whh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 18:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbhD3Whg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 18:37:36 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2974C06174A;
        Fri, 30 Apr 2021 15:36:47 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i21-20020a05600c3555b029012eae2af5d4so2425399wmq.4;
        Fri, 30 Apr 2021 15:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xV2TyfqNfpvMDLuKyUFGZXgiGO95qoCXzch2s3MNOXc=;
        b=n+UrfSN5UqRSGV4sjIEPSIaoC82Q9+aH0Jwcz7+3NyC4M8bey9ixewMGMefdWY6aMi
         gYmOFpMGCrJrk8KQ5qn4CsuKQTz213o439yb+euPgIyq4LowVJ2MannDopZCo4cSYIvF
         gPyAfPM/WeFq/A56iEiaVOhh9lsv8vVhe/ZQduz6N1yUygGhfwI4u3Cel4q3Vb5ivcU7
         CR2NNkMyWXTAZ/SRKL37MELewHvM/13qFCAyHcKwRKgzX4RhidjYtg60hvYeIRyM5z8M
         YY/6J17fLJyYSj5GV7ZuOc7nJ9evp2r4cvf1y2zcaezJ+ayJeEQrT3Hl3PM+CjUWi2YW
         YxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xV2TyfqNfpvMDLuKyUFGZXgiGO95qoCXzch2s3MNOXc=;
        b=q3u8SbxMQJ5jQa15ERRaftu30wNHI0OrdcQvAV7winTyp+H82QdqnilGt4UEIVxvcC
         p8U4Aw2+yHSU9VH3OPSIhTa2x11GaDIwRFlqvxESZ76wbGzd6fKPffZee0e2l8qkY1qw
         bewsiQD+ryuNFA6BhF3RY02GH7ImjIWQ8DA5jzeVY0en2kHTt5FLGzc27LRt9llEyrej
         bY7LtndiSClAynCrdSeSE4JWK4uXfovFNnj/kdi9Bm9aPiGbqR0CxCgByYemGQU2oXHd
         /YNZp20HVQhUZ2NZ4VpFEZY71GN05iotPQk8xrANyWTBF50i5edzI3KjsMetIITHqdyx
         W2Zw==
X-Gm-Message-State: AOAM531yvKgekxNWUrzWFE/fpDfiEzKUpCX3Syqycnbpu5beCpJ6dB5Z
        R5YG2WUEh0NC9GzVQUmB0lQ=
X-Google-Smtp-Source: ABdhPJxeXRSqcbeiXlOUay+I7rpPBGGPhthTDHgcijpMgwj/myVEuNV8ndDUkt7Eo/uwy1D56IIxGQ==
X-Received: by 2002:a7b:ce19:: with SMTP id m25mr8392577wmc.137.1619822206496;
        Fri, 30 Apr 2021 15:36:46 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id s6sm16473025wms.0.2021.04.30.15.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 15:36:46 -0700 (PDT)
Date:   Fri, 30 Apr 2021 23:36:44 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/8] 5.4.116-rc1 review
Message-ID: <YIyGfJw4z3fVQF32@debian>
References: <20210430141911.137473863@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430141911.137473863@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Apr 30, 2021 at 04:20:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.116 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 65 configs -> no new failure
arm (gcc version 11.1.1 20210430): 107 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm: Booted on rpi3b. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
