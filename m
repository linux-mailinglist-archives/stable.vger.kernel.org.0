Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510BD64EBEC
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 14:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiLPNLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 08:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLPNLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 08:11:16 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E472DA91;
        Fri, 16 Dec 2022 05:11:14 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id ja17so1826169wmb.3;
        Fri, 16 Dec 2022 05:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zATequ/mwmonfG64bUqQyd1X7tC746Mmt3aX2pV/efU=;
        b=cnr3D4KYC9xbOBqrz6evjwfdGLm6LNRh1nNvK7iRmdHNOEAQDzHqQRQjJ+RTUnW1yV
         9M+Z2GUPARuXXPFTulNKJxGTulLWWfGuzAp4qw+ZPWfRoXchq6UjwQ9lTjmqwpphf+6R
         mjUWKaxNvXP90d0z1J3UpVZVsv7s2dVRY9Sg8k6VOx0vt6GRyLtNmxQ3tM3G8mSU7Fz5
         mP2Cb4J2WgNM5ctAykaeoptE66DWjuu8ATLJ+M+7sV4K38V1Kt0+4+AhzLc3Pb+x6T8Z
         3ayc98PuglG6VoATd+jxeBhwYU+V94427ItIWWHDFQqLx+0jyUt4wzh+Dv2anq+9qpqW
         65Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zATequ/mwmonfG64bUqQyd1X7tC746Mmt3aX2pV/efU=;
        b=xR8czvt2OT7eQYoMEBAIxU0O/3witieYfCgjJtPJppvxAYknVtcdZlSw6dz+BqGzjH
         VOfq6jBoUa6WSBC+E907C+c+JX8VdCwx0w49oWbfzKSadAiU3UyNVeEBmflrRQpp/E9P
         ccHa03XwfS0NpuyzQFu1ObDamUCabDmtzB/keipYpLRDBkVwCQz8lfg8leWRk0o1W5JO
         vdt2VDopyLqp3O+42mPA7DhPTCdr25Y29Qrs3R1hrHljtEjx2SOGErRClAPJwOeyE3jF
         RRIBxYnFRWaWA+3ONXd6KSI8otTEOS6YoaHo5mwaMbYEdrmElxNGnu1cAdcy5g7vcIGz
         sgUw==
X-Gm-Message-State: ANoB5plJx8IhjU/cXzgiilih+PHm5I3aaCoVzvmP4CRp+xzbIHv2VwvG
        TxaShgvrzUixKXo30rGFan4=
X-Google-Smtp-Source: AA0mqf5k281z8UJtBhUW+9e1XQsZSnWIKmXhrEWjl4ZqIneSYpsc/fQguq2DhmimPbPQUxoO9Buvqw==
X-Received: by 2002:a05:600c:1d91:b0:3d0:274a:3171 with SMTP id p17-20020a05600c1d9100b003d0274a3171mr16573641wms.0.1671196272788;
        Fri, 16 Dec 2022 05:11:12 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id p16-20020a1c5450000000b003d07de1698asm9562837wmi.46.2022.12.16.05.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 05:11:12 -0800 (PST)
Date:   Fri, 16 Dec 2022 13:11:10 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 0/9] 5.4.228-rc1 review
Message-ID: <Y5xubgkE7EG4bPaR@debian>
References: <20221215172905.468656378@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
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

On Thu, Dec 15, 2022 at 07:10:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.228 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2361


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
