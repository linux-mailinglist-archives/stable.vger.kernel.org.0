Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F265B8556
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiINJmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiINJm1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:42:27 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AE31B792;
        Wed, 14 Sep 2022 02:42:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c2-20020a1c3502000000b003b2973dafb7so15091217wma.2;
        Wed, 14 Sep 2022 02:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=J0LC+Huazpj9YGje83L6Ih16ffsvRXN1EA4iW9igUKk=;
        b=RQWliQxiog6x7JAou5Dp5ryYMEQPtDx5gNS5F4sLRFg81RCvUQiVfwUNu6i7QT97UI
         tSt5k7QtApaQ49XecKqtm5pDc1PZE0lu1oa+bOI1e+L2ZE5WOfAC6e/VsM2eAyCuZg5/
         QxTInx+cfyCJ+2GLdboHg8c6Eza+2lQlSqM/7+32BySyhc3YECXe8zzlCJcGYpxGrO1C
         fSo0bviasEQjnn4Xm9E3itHLlJCqf7BJrTgmeFT5qy+fhN/xvOBTEozjOUBeIaFjq8L3
         tg/hGtKGe1UNqiJiz3m7mGkqgthYMc/lqlJtaOIdR/4UQBrvb/q+Ft29gSqV+bC88snx
         X4yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=J0LC+Huazpj9YGje83L6Ih16ffsvRXN1EA4iW9igUKk=;
        b=Q3fg4vIVQ9CYAfEFimvOdoM21ixrSSJX6S61y5r+F3D9/jpw4Xd2sYpdZOPyFHjANu
         hc4Hx6bU6Y2pqYiuM1SfQrG0BRfxXUe0jgaK3OGVKqp/jsJery9DLb9bkB9InmHGQDG4
         uX0jZUIceGRZuKdBhPjW21RoeFJN/JEsJRlFONbV/DP9/0mYaWztkw/1FI51/Omi9q8L
         B+mZCprIr3HQ5vwbIpBZH96CqjHgvFbT2oF9SJ+YrmP26tRPA2fWvVPMlXe4o4dPBs3l
         ewJN8oeNN8XL+ZZivNs/hcDOYHQcizF3MnLN0hLga3qEvQ2G3KDiSv8W9CAyKnsZ9m25
         lP3g==
X-Gm-Message-State: ACgBeo0eHJIuv11Pvxts/Wwl3QXKB6EwOwYpgbkXdgLND+aqS9jXcD4Z
        MEHOdzCo58ei4rGzmT6cOVc=
X-Google-Smtp-Source: AA6agR4V+VTaO1TPY9VQQXvLfuqnMiOFq4PVE8jYus+mOXgoM0EYlNOw2+8htjLJn69RJrpUdxY2YQ==
X-Received: by 2002:a7b:c2a9:0:b0:3a6:2400:722c with SMTP id c9-20020a7bc2a9000000b003a62400722cmr2353042wmk.108.1663148522165;
        Wed, 14 Sep 2022 02:42:02 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id r9-20020a5d52c9000000b00229e0def760sm13154403wrv.88.2022.09.14.02.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 02:42:01 -0700 (PDT)
Date:   Wed, 14 Sep 2022 10:41:59 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Message-ID: <YyGh51eRAO+grbhk@debian>
References: <20220913140410.043243217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
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

On Tue, Sep 13, 2022 at 04:01:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.9 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220819):
mips: 59 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1821
[2]. https://openqa.qa.codethink.co.uk/tests/1826
[3]. https://openqa.qa.codethink.co.uk/tests/1828

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
