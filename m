Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9C13DB70B
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 12:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238375AbhG3KTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 06:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbhG3KTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 06:19:21 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC61C061765;
        Fri, 30 Jul 2021 03:19:16 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r2so10678620wrl.1;
        Fri, 30 Jul 2021 03:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6cu1j5kMK2bLHBJWu2lsik3zogAys0l24xOWZb+THxY=;
        b=jDYjdhOMR5j7fXd2JqphzRt+q/M+tsRotrByjqbdig8sCXyFtnBXI/ndnur+nHQOIG
         +PUpGOJgF2evkASyYakUd4dWvkk8PAdDiLyADNiWepUjzR7Ufe42oo5qhf4I0kOYpI3a
         rLml2OmdpAdRkOjqwq7daC7yFGOospCQFCuEnijB1bvHZMqshxb1O9smPuRUOBpxdU6h
         z54YF+E78OG2ZW/g/d7TXN9TMAnK+6XbVuvmWEXPTMHB0ulcujp6pyMrWSNmV+1bRrYo
         2wjrnYe1JT8J4dqJWSyyT/wMvA11/NXZ/f9oLG+/Z6DRIuBEdQ2uSNtLD4diPXRf+LkP
         qHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6cu1j5kMK2bLHBJWu2lsik3zogAys0l24xOWZb+THxY=;
        b=S46Uv4kJSRPsEXbAvQDtMMflbKJLs1GF2N8BZltUZ2JKgqLFuuqL/dqxk7onGIzBux
         pFi4QRGeXyhFcvJEDl0Aitt7AN9Uz6UUzeEeo335bYTALyJHlUECt9SUYLj+kma2engP
         EvDA8mVVE+Z5srzRYeXGGXmb4W6u7fPIPIn/O8wjXr64NLSBKib04R9jf0Fi3XVP1dXy
         0ev29T4pOc4jkV5d3iTGabB8iAakyuC6y6AeKCHvFQ6hqmlW/LvT53mFFxF40I88IO7C
         ZX8KGPE9f8uadQctZabxQ3bP9IZYN61LQceAValxTVylDtEt9d5jTnSGAeh1Zpkugd/P
         mK4w==
X-Gm-Message-State: AOAM531v7FvGgSW7T6VVLK5K03nSracsXiuVcrhDzXtCRIeZOPyz4DyL
        YZPbDR5O9X3wfDrheOPb2G8=
X-Google-Smtp-Source: ABdhPJzmob8JJuaNPlp7p5Jm7UMWP5ZkVz43udecY+yScKmKchEV0o+Rvw3kUgE5L2J3VuhhxAwtsQ==
X-Received: by 2002:a5d:64c8:: with SMTP id f8mr2224197wri.290.1627640354906;
        Fri, 30 Jul 2021 03:19:14 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id h15sm1178235wrq.88.2021.07.30.03.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 03:19:14 -0700 (PDT)
Date:   Fri, 30 Jul 2021 11:19:12 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/21] 5.4.137-rc1 review
Message-ID: <YQPSILlMjB+v2njR@debian>
References: <20210729135142.920143237@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jul 29, 2021 at 03:54:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.137 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 65 configs -> no failure
arm (gcc version 11.1.1 20210723): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
