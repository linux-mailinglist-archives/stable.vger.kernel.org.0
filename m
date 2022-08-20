Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558C259AD13
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 12:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344474AbiHTKDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 06:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiHTKDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 06:03:37 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E7810540;
        Sat, 20 Aug 2022 03:03:35 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k16so7691525wrx.11;
        Sat, 20 Aug 2022 03:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=IEFyuql4t0Mloq1f8hVGfU3SaU6SO9FULltIE9rtGzM=;
        b=lHmUg3v2CoasFj36IHnKiQnOaowZ9PpMb/qBVit6zOxznUMN7ObPBBwc/A6x/tVhBW
         ZSUhhzwmKFoceD6TAzIYX1T/aU4KeLaJZPXqcm0QGCFOOpbnwhlK/K6LulU9oW+Vj32Y
         gMZtw0Lx9/CjbMLmCE9juu2oYIRfYvdIExthXeOq7wi3KjwdVc8z7l9VyZAZaSdo3rhi
         lQegY6p6h2+5lwqaKriT9IKWCso5fNj3vXEONK07OlU00iRS3uaB64T0ooye2SfJArMp
         IwFy9K2rFREDeHxpXR81gxIxyNKwYhC+pLE8WSbeVhHfHJuSGNv96+ma5sXqkwitpnKE
         KwjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=IEFyuql4t0Mloq1f8hVGfU3SaU6SO9FULltIE9rtGzM=;
        b=GpAJH3Zz0OVoBxkjLUIOlkHVMPJQJOy53LS6giUPRqfVOPJkTqiVARdc2beWNJVVx3
         l2Y+TMrKQ1R5F3MdOOCVXWbGh6iC7WGk8lEuYCe4KVRYzPla5PrNqtSvnTiKJuj3vZY4
         FVIkWCUaftnIfHFUw7knwmzTAh7hI7v/Bd2aBVynRui5g2QyEmcPSCIoqYHV8FNqGr6t
         V3QrO7koV+nU+jb/yyfoeIY7rLBpWgcugXkxwj5K99KNg1TBOtBWgs5YjkYnF3532xaz
         qrGlSJQ9C9AD3z6tg6evKKPXbzufgZgqIr7BQYlWq8k8eCpBwEwK8u8yV3xP42omsSnT
         mX4Q==
X-Gm-Message-State: ACgBeo1bl8swNngeYwqv9JBVptr5iorNVXYTQ36iruWNWXJKWrdw83m0
        k0UnO2ZaXu65YTovSm1lBK8=
X-Google-Smtp-Source: AA6agR41CrOgKN/bu+9Nn6scQjo0I4kNapeQUfiaYno/dzdsltQsQm8yDknZYQhcBoW3Nant61wi5w==
X-Received: by 2002:adf:db45:0:b0:225:2ef4:210f with SMTP id f5-20020adfdb45000000b002252ef4210fmr6208209wrj.680.1660989814397;
        Sat, 20 Aug 2022 03:03:34 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id n7-20020a5d4207000000b002253fd19a6asm3697641wrq.18.2022.08.20.03.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 03:03:33 -0700 (PDT)
Date:   Sat, 20 Aug 2022 11:03:31 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0/6] 5.18.19-rc1 review
Message-ID: <YwCxc5gwpmGRBUL1@debian>
References: <20220819153710.430046927@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819153710.430046927@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Aug 19, 2022 at 05:40:12PM +0200, Greg Kroah-Hartman wrote:
> -------------------
> NOTE, this is the LAST 5.18.y stable release.  This tree will be
> end-of-life after this one.  Please move to 5.19.y at this point in time
> or let us know why that is not possible.
> -------------------
> 
> This is the start of the stable review cycle for the 5.18.19 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220819):
mips: 59 configs -> 1 failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> fails
powerpc allmodconfig -> fais
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
csky and mips allmodconfig fails with gcc-12, passes with gcc-11.
Already reported for mainline.

powerpc failure is not seen in mainline. Same error as csky and mips.

In function 'memcmp',
    inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:302:9,
    inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2002:15:
./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
   44 | #define __underlying_memcmp     __builtin_memcmp
      |                                 ^
./include/linux/fortify-string.h:404:16: note: in expansion of macro '__underlying_memcmp'
  404 |         return __underlying_memcmp(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~
In function 'memcmp',
    inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:302:9,
    inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2003:15:
./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
   44 | #define __underlying_memcmp     __builtin_memcmp
      |                                 ^
./include/linux/fortify-string.h:404:16: note: in expansion of macro '__underlying_memcmp'
  404 |         return __underlying_memcmp(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~

I am bisecting now to find out what caused it.

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1660
[2]. https://openqa.qa.codethink.co.uk/tests/1667

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
