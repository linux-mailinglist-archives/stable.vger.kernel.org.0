Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E76562961B
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 11:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiKOKkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 05:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiKOKkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 05:40:09 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB048BCAB;
        Tue, 15 Nov 2022 02:40:08 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so9960477wmb.0;
        Tue, 15 Nov 2022 02:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3WMQbkosnl9z7yXTDnS2EVl5UPXC0Gu253HYTa4GcJE=;
        b=A+j8/L+A7kozJHAxLA+l738i3z12lDvhttAvsxsKzb3fA4aGFc1DZGjvJEuGZgMtLr
         VKOMnEnYZFDa0mKGp8mNk6OSSMTtQf+prWY59O5C26iQC3QXgygcFHYq2058ZINeyQio
         6Z9fgIlj4sr/VCPVcACsNsxf6ZiEN7sOcs96nV29YPEzvWW1G4gjpDUKzQptQFyOYuFp
         ViHlWGgX8wKBfEaWvIS+T1iw7F57ul5C88wS9m67nZsGmbcPnNKKaGis9e9uJrz+S7U7
         3j8kKAKvpZvUFVd5X8WhNkL0Qoju0YeO5qwCabMrQzoF1inh2DHHtEtAhT+lyKzYVR+m
         faIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WMQbkosnl9z7yXTDnS2EVl5UPXC0Gu253HYTa4GcJE=;
        b=fAPSFvZeAowFS/ChZZ1fnwxxAFkXF58Y6x/DBe1QSGztZQrHrRFJ23yn1roCyhj8tN
         LclhGqLaWB2clbgjif/9YfhgwexRp9v7z1qxud3UX8fYzjIl3Ypgf2le62NFKcofsCk8
         y8gqFJSqwCBtYp+vTg6yZorfdoXAeIIVJa0JufyZVripLd6IMs+263ZjQf2P3brYHhcd
         WqTzj50tLR2c3SVk3WnxPXaZBk3hbAG73mn2a6C+6a2eqJ7S23Tsy6U/eMv8JjyibTvd
         dGJQ9gdP4KPszImW4xG14IXJmG0o2In6MsL4yhekKEsIwtB6V5dgF1+oFkTSaDqiugBY
         7gKA==
X-Gm-Message-State: ANoB5pnRhAPhWpcZRxzRl0fBSA3E4roLOa0w/3mN4Ed8JE8k3MLzJSM+
        N3RA9DaHdxbnsLOheKXABek=
X-Google-Smtp-Source: AA0mqf4/dNTp2hR9OB70zETvsMmVoOKlshqJqzaWzKau67cx59GbzlyOleBhUBWJPBEsBkDme8rS6w==
X-Received: by 2002:a05:600c:689a:b0:3c6:6f2c:64ef with SMTP id fn26-20020a05600c689a00b003c66f2c64efmr973532wmb.91.1668508807141;
        Tue, 15 Nov 2022 02:40:07 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id p10-20020a5d48ca000000b00236705daefesm12102281wrs.39.2022.11.15.02.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 02:40:06 -0800 (PST)
Date:   Tue, 15 Nov 2022 10:40:05 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Message-ID: <Y3NshYevwCyl7OlA@debian>
References: <20221114124458.806324402@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
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

On Mon, Nov 14, 2022 at 01:43:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2159
[2]. https://openqa.qa.codethink.co.uk/tests/2165

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
