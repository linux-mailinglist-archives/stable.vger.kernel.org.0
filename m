Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F373F7575
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 14:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbhHYM6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 08:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240078AbhHYM55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 08:57:57 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCC2C061757;
        Wed, 25 Aug 2021 05:57:11 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j14-20020a1c230e000000b002e748b9a48bso3627100wmj.0;
        Wed, 25 Aug 2021 05:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QmVDDYgRM3rmT7pBD0Z2AcNxKTq+p7zdTiT/aiEkjp8=;
        b=rqp5tdwa7EhPna3M48xW5ek6aaNBvlZDKNrGhAcBgfQl00z8p0l8qP4Sbi+HpD+COp
         vGWUOK8n+Tpj0bUiZ1SmGwLOC9bX0t8RSuqDc8M5bPoofejjyNkulxxf4CosvWM+N3Xt
         SgGQgE/odZz2G6vvmq3sW21RGgrixThh7u0INK5r2ExaBvwxSH5H4T+XwVDWpiDN4+Nb
         YeO+8Q7Ud/iIH5zujg4c0dpE7p+SQwgAYXgr34yCrAw9yg8s8lJrfO2+MkS/FtkK/AeV
         Kd0bxWMax9vsKvCt4zZMXs7hNkEYD/P8M4wOCqTPITruPse9Jz/Y65J/iz184eJ44cb8
         sYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QmVDDYgRM3rmT7pBD0Z2AcNxKTq+p7zdTiT/aiEkjp8=;
        b=LODHn5mQ68QCQrtPKEqWBaOzR2YkEmRbD/iQbRjH/PFCgdShTFvWt7MCIoAbYtS31F
         bq1LCDEziis/0kLv+S93R0DL1/OkBF4GuWxAnIzgcpmQpqXhYpkrX/M0hjpeY3JooENz
         olwknNEAF12kgRSBT/qfccSJohkq0W2jr7s0gJnTtGP9NlqfSGTdJpQ/2Yf1D4XEo/eb
         M4V1XkTdKcPfhMmIfrSvTvmtzVS7xUJ+WM6oEIE57jDMwCeCIGtt1AxaPn6H/2kx+nT5
         iOgSrDFKq7lpIOrNKQsngJq6kq3xv1QzCFfS7wNFcw7DE8NS3UuBlaDsUPcTrBCrfBwF
         +B0Q==
X-Gm-Message-State: AOAM532C7kioDr5grxJf28qJ4dvSofFcTpliGzx72EMRFPJtdibOV4jO
        d3u0HGnnfFbsBIGPJ0BvZNhoV9R3naacDg==
X-Google-Smtp-Source: ABdhPJxhnfzPU9DYg8h8Gf4TdxcVDsry3xEUttXwCG/KFH98QTQOFQBh7F7DJHYMkM3Ij5nwZUOkHQ==
X-Received: by 2002:a7b:cb89:: with SMTP id m9mr9201607wmi.123.1629896229647;
        Wed, 25 Aug 2021 05:57:09 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id r25sm906747wra.12.2021.08.25.05.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:57:09 -0700 (PDT)
Date:   Wed, 25 Aug 2021 13:57:07 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 4.19 00/84] 4.19.205-rc1 review
Message-ID: <YSY+I4cSO6ESRSF0@debian>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, Aug 24, 2021 at 01:01:26PM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.19.205 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:02:47 PM UTC.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 63 configs -> no failure
arm (gcc version 11.1.1 20210816): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/53


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

