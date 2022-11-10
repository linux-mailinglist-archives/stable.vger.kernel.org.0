Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4939624059
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 11:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiKJKvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 05:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiKJKuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 05:50:55 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961EC5E9DA;
        Thu, 10 Nov 2022 02:50:54 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id o4so1663569wrq.6;
        Thu, 10 Nov 2022 02:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EPZ1n8jGtqN7fSofdtx5HaESZFL2zLNxb+y38ml7+qg=;
        b=AzgRerKTxJ5i5yr/x6HptNqdQOnFUq8LAinGAEsUKx7LbdFu+WHM44/s+gjYROE9ZU
         e8sf581AQW60dEJvyq9kOgQQu04dMv6D4baMOpMFcyKiFpSEGo2Une016198GdDxea0d
         dC1oC+uixLPtTqn9BLyKc5aIRd6NiTZLhQelYoNc8smIyWQTOvPcL+asMmjKuUXseSSI
         REVxAeeoDlxtjhYVuc3SvUX3sRK+imEq/kMg8bsCzDaA9KSJtzw1X6FapDwhw3o41LgK
         YpBLEMosRUZprWjeqvWY/W5WhxKLDYgez3tT+PgGuHVGMU0OL4kocSneq4hlsdP14iRf
         onRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EPZ1n8jGtqN7fSofdtx5HaESZFL2zLNxb+y38ml7+qg=;
        b=RdEG1+wa/NaL16ltCFuppvu2+x7mjSHQSJvgxkqzH5ApWAQnKge+YYRoMF4/UXUOqR
         1BUp1KmgyCiqA1RLcJ4EptAZTB4t6qMHVM1j8ALSCEYN6THJ4c/NVsTR221cpUd7vfBx
         hNovTbXJa3aoLDgvlvjsCrOAx84LQfUla7M49MCEoSH4a/0sNhD/MMakdEvrolmTJjFM
         ZDfjMCT6Ng5P4qFA6ACemZo891uFKx5+20548xIMSHWlZHxKHOLa+v2Lvea4xM00ZnlS
         HWwnCmdh+CZFFTfJx9bsNwSwiTIRI08fMJ52K0Av9nLsyZTcMmzk2soqUut/whUUUJGC
         wbVQ==
X-Gm-Message-State: ACrzQf1lpQK1AaQMCh27iqKpHn4rMnkTLHukLcDY0MFaYISl8BAV8S5v
        055tEcUhl5JKHQ7e2IA0rLk=
X-Google-Smtp-Source: AMsMyM78GqrPDUIMyGcHP56jkGP/O8l8M/tvgVpjiSsFKyKK9Yl8JXCzY/MNfIedbX7n0QLHsbPa5w==
X-Received: by 2002:adf:d1e6:0:b0:236:5ead:eac0 with SMTP id g6-20020adfd1e6000000b002365eadeac0mr40985279wrd.629.1668077453060;
        Thu, 10 Nov 2022 02:50:53 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id q189-20020a1c43c6000000b003cf483ee8e0sm4835398wma.24.2022.11.10.02.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 02:50:52 -0800 (PST)
Date:   Thu, 10 Nov 2022 10:50:51 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
Message-ID: <Y2zXi9WZsbpNntJv@debian>
References: <20221109082223.141145957@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>
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

On Wed, Nov 09, 2022 at 09:26:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2127
[2]. https://openqa.qa.codethink.co.uk/tests/2133


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
