Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FC364E1BC
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 20:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiLOT1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 14:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiLOT1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 14:27:03 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34065240AA
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 11:27:03 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso3806044pjt.0
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 11:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FHaQklMVAJz7M23bPJYcupv3T90tuM2zBNdbqvLFMII=;
        b=UU9aqvzkbk899K346Wv2pI0ZniXTz73FjrsdwcjnvObyIdv0IoX0MEoIvocpC5bcvI
         q0u9k4bErWcMHDu+78WkPXYeQAfAVtuMlQQ9aUOvhMRP1e9YdEG68f2noBpQL9oBCzeZ
         sk3B51Zkk4NGDIRVlab3FJzWR7xcJMi29xqEHAUhcGTBnyrsDia9XIb8KKHTPnjDvZQV
         +PQwpJ9Zd7ru6B/wqgHwfoBKelVtBka+ygAfjmwtDMoBN2P4Ev/BrTm52gsH083u4mPR
         S45dzBrteN5MCbSDco4OexafkuwhuJ+pkGvynLZeXk6QP8bPy9r4q8pUdL6Dlm3VAivs
         RQ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FHaQklMVAJz7M23bPJYcupv3T90tuM2zBNdbqvLFMII=;
        b=7iaZHwIBpsXjWguxxJpz2qBwq2OIRHoGa4rGz1lGU6kS7v2Pu/Ek/AKE0yiDS458+Z
         N8IfB4ByoI/P4gIEkEbYWg70QZ0iIxvgXyNXul8WGSDt7AFHCregYKq0Ufhbk7/qwvoN
         1g3y7YHAUepPO9HqNS/5csrzgH6+xgiQyFoE8ktvojAc/GrRMX5S3acUYTgwDVvm8dC5
         xApL+Rh0/S5a8zMei82FxmhnjV2LrWJl2OrWe/xm16xszgMtJ9WF4OiVAYI7v3XZHWcT
         PIHvnO8LXWRO0Onys4YIaL19KCCmrFdjC11aCbfW2RkJB9vCVbCjExNyCQLEv/6G3pg6
         YKfQ==
X-Gm-Message-State: ANoB5pmvXzZH0Q26egXBHj8H/vDB7Y1KyKhB7UisVLxlNQsLY752uiGc
        LDNuNbTjPSVvCj1CoNVi5kdkHd1S+1DJ1fuuP2rfBw==
X-Google-Smtp-Source: AA0mqf6t+5RmDyTXTmMnW87/GSLgY65NTZPfjC27wvVG+bv9O0lqbRUCxB5FLnPCDvUfCrEuydqbzQ==
X-Received: by 2002:a17:902:b284:b0:189:c62e:ac34 with SMTP id u4-20020a170902b28400b00189c62eac34mr35196693plr.47.1671132422386;
        Thu, 15 Dec 2022 11:27:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902710700b00177f25f8ab3sm16584pll.89.2022.12.15.11.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 11:27:01 -0800 (PST)
Message-ID: <639b7505.170a0220.e5f00.016d@mx.google.com>
Date:   Thu, 15 Dec 2022 11:27:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.302-9-g564c8959c2af
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 build: 17 builds: 0 failed, 17 passed,
 1 warning (v4.14.302-9-g564c8959c2af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 build: 17 builds: 0 failed, 17 passed, 1 warning (v4.1=
4.302-9-g564c8959c2af)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
4/kernel/v4.14.302-9-g564c8959c2af/

Tree: stable-rc
Branch: queue/4.14
Git Describe: v4.14.302-9-g564c8959c2af
Git Commit: 564c8959c2af7cfe8f20acc20859870d64c9bffb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 3 unique architectures

Warnings Detected:

arc:

arm:
    lpc18xx_defconfig (gcc-10): 1 warning

mips:


Warnings summary:

    1    arch/arm/mm/nommu.c:382:12: warning: assignment to =E2=80=98void *=
=E2=80=99 from =E2=80=98phys_addr_t=E2=80=99 {aka =E2=80=98unsigned int=E2=
=80=99} makes pointer from integer without a cast [-Wint-conversion]

Section mismatches summary:

    2    WARNING: modpost: Found 1 section mismatch(es).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/mm/nommu.c:382:12: warning: assignment to =E2=80=98void *=E2=
=80=99 from =E2=80=98phys_addr_t=E2=80=99 {aka =E2=80=98unsigned int=E2=80=
=99} makes pointer from integer without a cast [-Wint-conversion]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---
For more info write to <info@kernelci.org>
