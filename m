Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1893D68A02B
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 18:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjBCRTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 12:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbjBCRTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 12:19:39 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20108B7DE;
        Fri,  3 Feb 2023 09:19:36 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id r28so4715096oiw.3;
        Fri, 03 Feb 2023 09:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pu2wfn5AzYDI159ZTO1HeyKu7qZk0yfyx7W3jgIeOVE=;
        b=ifDarwp18RTVOspWsBnP5kAFI0WnULAQScqkMjBdAYUUqR8InNRZ69yKSLSWJjHPOv
         SUaXFBkDIMMwb+gEAAKJ/NQYtupXgX9m4iuNsnQLum1auumtZvTK44wqRupmw/7e7Yck
         mEufxBirD60NTMtPHKBTDfCM8MUdl3k0bPVCxqv4xoHX7Q+ZoPeHjn3tLkAoVyUSNjaU
         VJBMfMHGxWngyOJXTbU2d+bUHOzE4ptkBx0Xw81Tcq4TCAKqfuwYXhRHT1ptsGHED3Qy
         mxY8bQ3QCUV2TTdmdkC0drWXLeJUbFY0XU35YZt/fZxLtGpnOVMxlC1PIWYL1UdD4RUJ
         CSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pu2wfn5AzYDI159ZTO1HeyKu7qZk0yfyx7W3jgIeOVE=;
        b=B4gCuL2pzIqRISdfyKdbQAOHVVISGPgoIDeUfQ/rTrRE/+O1oM/b5cDcMCmTlyrR2h
         10v4bdjoVF/ajxX/8+zp50kOw7+bF1ZHs3mo8Q1LgDmR1pVZeindZxK/prg+pWEtMn0l
         bs3IzB96YCFCUsprB/OZtsMZ/Am55MiZrS31z0sF9juKhbNMADWi7lZr0HMzE6oPRgOM
         FzBzhossbll1qD7DqPf138LXH/xXTzabe2lx+LQNgIbj2/g3JQsX3EZGUB7A5ZRaQu9L
         QMNGOoa62fnxoefcAEs/UccnsAp87Q7iupnM42JMy9ma9L+mKU3ichjFiBJQEgjJxtcN
         OW+Q==
X-Gm-Message-State: AO0yUKXyDiI6CxtHsHYYwyALj1BSmu+xVJtTcFG/qUFlk+YyKdt0n43y
        yNI0K+jG8w/O/vQJt2Ry2qI=
X-Google-Smtp-Source: AK7set+D5X0wa02/3cQ0ZCwH/NMpIDZvtogU0AmhrvIURoSxcPLDl5X+ZoTLCkV6+iz5Xr1ZFoliRQ==
X-Received: by 2002:aca:5a86:0:b0:364:e913:3a9 with SMTP id o128-20020aca5a86000000b00364e91303a9mr4598760oib.49.1675444775728;
        Fri, 03 Feb 2023 09:19:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b3-20020aca6743000000b0037854b52db4sm967724oiy.55.2023.02.03.09.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:19:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 3 Feb 2023 09:19:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Gaosheng Cui <cuigaosheng1@huawei.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
Message-ID: <20230203171934.GB1500930@roeck-us.net>
References: <20230203101015.263854890@linuxfoundation.org>
 <CA+G9fYvd8D3LfxPg2afZXKFC3WNHrhyE7c3fFLViaG4WhJeHVg@mail.gmail.com>
 <Y907af0mqs6RbgjI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y907af0mqs6RbgjI@kroah.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 05:50:49PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 03, 2023 at 04:34:40PM +0530, Naresh Kamboju wrote:
> > On Fri, 3 Feb 2023 at 15:48, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.19.272 release.
> > > There are 80 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > 
> > Following patch caused build error on arm,
> > 
> > > Gaosheng Cui <cuigaosheng1@huawei.com>
> > >     memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
> > 
> > drivers/memory/mvebu-devbus.c: In function 'mvebu_devbus_probe':
> > drivers/memory/mvebu-devbus.c:297:8: error: implicit declaration of
> > function 'devm_clk_get_enabled'
> > [-Werror=implicit-function-declaration]
> >   297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
> >       |        ^~~~~~~~~~~~~~~~~~~~
> > drivers/memory/mvebu-devbus.c:297:6: warning: assignment to 'struct
> > clk *' from 'int' makes pointer from integer without a cast
> > [-Wint-conversion]
> >   297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
> >       |      ^
> > cc1: some warnings being treated as errors
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Build link, https://storage.tuxsuite.com/public/linaro/lkft/builds/2LDxPVbsGpzKKtYLew33pC6wCSc/
> 
> Ick, sorry about that, I'll go drop the offending patch now and push out
> a -rc2.

Wait a minute, you have more issues to fix.

Guenter
