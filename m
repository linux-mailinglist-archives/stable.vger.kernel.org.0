Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA78584DC2
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 11:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbiG2JE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 05:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbiG2JE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 05:04:26 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D0E1FCC7;
        Fri, 29 Jul 2022 02:04:25 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id i10-20020a1c3b0a000000b003a2fa488efdso1578917wma.4;
        Fri, 29 Jul 2022 02:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=V9YvS0U8zBOpjE7jeCbrs1bSoTWQYmMFxXfUMtMFnk0=;
        b=B6mRX/2k6mLyS9Gj3gvRTyuczdHjU/idph6678DPS2ovfF3mPZWoSa2SUuNmWzmGJ4
         zTD9PlKCY687SR9gIdftuVWzk0hw1K3dQ0PR+/edxsG1RIQKggSijeFnioIjcZUFFAI2
         aO56gxy6KxdpYhipiwOQjIf4aq8YoxQBrSO3xGUMOaQWAOA67kJRu5NHQaxpx8+ywE6o
         JX6kwLQNaQ6YZas0NYZKfHD7kid63W61jwrpk+oJShdW53Ds4aRsdMoGldFz7kOh0aLm
         XN/Dwos/pAt9rqobKkWCAax5iFqtCmjxG+bUvUEzjHD6ukYnum0TPABKieaDNoiUB3Gd
         Usmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=V9YvS0U8zBOpjE7jeCbrs1bSoTWQYmMFxXfUMtMFnk0=;
        b=tKxGEnAP3cTvkGLcwbpyQ329RrmMg0rTx+04Qtt1FqTtOf1y7oabWWcyiY/CgwwOly
         D+QT7vmyPmJDALPiNzZs2lMDiLiaBGwY5a+qzVJ49czGQzMpdu1agVkRZJGyQs9tJIfU
         p+PQ422NMetP/jbduYCV8muZa+kLfSa5zj21EOUb9pw4KgI8nCWtKajCmfKF/VYq8b9L
         OSuhyyhMbV2FMQ6+Oi9ckiIXHu3bsMol04QcY0nDXIzORWXQYkN9IymshBeKVwND18DE
         JY50lA0ycdvK5lZoC5mS7Qcf3vrjYdolh6SKlYvxqePrljxZo3sKW/SB/UP5BHIEXBjv
         yyDQ==
X-Gm-Message-State: AJIora9S3m6mBbXJz/iLgrlC7tRKL+MvIjn39Co3q+KqfUvUvpWVm97L
        iGYI6T64TYrsY2ARabzQYRw=
X-Google-Smtp-Source: AGRyM1t5ZQIcjk3n4DtRLniG1F6Ns7x3AJvK9mv5Li1/vtx+ojm9rPVvdLrpUPzHuXaElwRfoEVfhg==
X-Received: by 2002:a05:600c:501e:b0:3a3:4a04:fdb5 with SMTP id n30-20020a05600c501e00b003a34a04fdb5mr2151519wmr.168.1659085463537;
        Fri, 29 Jul 2022 02:04:23 -0700 (PDT)
Received: from debian ([2402:3a80:1968:2207:9bad:2dcb:1b0c:a3b7])
        by smtp.gmail.com with ESMTPSA id p6-20020a1c5446000000b003a2f96935c0sm9543523wmi.9.2022.07.29.02.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 02:04:23 -0700 (PDT)
Date:   Fri, 29 Jul 2022 10:04:08 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/202] 5.15.58-rc2 review
Message-ID: <YuOiiB0VpxYoWDnd@debian>
References: <20220728133327.660846209@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728133327.660846209@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jul 28, 2022 at 03:33:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 Jul 2022 13:32:45 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220724):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1585
[2]. https://openqa.qa.codethink.co.uk/tests/1588
[3]. https://openqa.qa.codethink.co.uk/tests/1589

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
