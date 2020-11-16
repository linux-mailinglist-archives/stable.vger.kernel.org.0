Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517C42B5517
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 00:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgKPXeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 18:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730459AbgKPXeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 18:34:18 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150B9C0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 15:34:17 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id a18so15672919pfl.3
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 15:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z6Jofs59n2zYJpbcFvzrHnbWmF+ASJP9uTQBLPNWhFk=;
        b=EnjOOnP+6lFF1X4nnF7e+WM9ckWXjQUCi2QQby+Vujw+Br7V+KGFBToAp611du7H6u
         2QQpzC8yQOtdOcZsfOuaTZkNwxDbigEegi2EJ2eARf1Xgfmlupbxve/Ip+5k2VLB+MPc
         QqsRPhoccpp2hfXpWePa/eGJUwFO8PA1glLp58EGJXT0DSl0f/iSFDYhulqfxdBdd3oO
         J6+Wrl9ecDAvsNT+mLLp2JW1vsTQ1FXsBeeoKmFsosnjPt3CvHY5Y6ife23c9eTLwXvF
         RDHqGW9/OruyBpCec294ex/eyhgSOgAKR+7jZxWdy03w9kHoxiIGxkqldU107iMzI4zc
         HrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z6Jofs59n2zYJpbcFvzrHnbWmF+ASJP9uTQBLPNWhFk=;
        b=W/JgSJaUchO4ziUkMOZRsrAwq/GLoioZARsLNXy50+c05xg0mKU+iXc0RvGG4wij+S
         U2SBzcmVX+tUKQ4+6Iu5VRY/3ZCRWxdCDV5B3uAhJ80y3G/TAljerfIEYbsNPCCiWyQu
         tmJvRx2KHwXvD1Um5QU91kZ87N1uu0Ds5saTHXVEP8QdsXJyWdftvOoDZItJlNLA2dNa
         wn7YLzO1BOnfKoTmOkbqpcmhoh89T8DMqkpTMJ99SwY6acQ1ia6dFevmAIiNCE84fT1Y
         AgK22oSycdQSzRKiwIv3OX8wmGJmyuCJXahvjIv0icmLIRe0fVb5dLuGYHCZbp584K+y
         U6kw==
X-Gm-Message-State: AOAM531lddC7KxZB/nDOfbq1wGsEsGnGxDcHKYnii5cisnARfpoWGbm7
        0HZzNOsRWBOGdbPnQYHWSvxJmnIPTvNFGQ==
X-Google-Smtp-Source: ABdhPJwXsOgVnLBJ59dofLe/0lLVyFfzL7rhg+5WRU7HqnR7Ev5/1lFum8YM5EDOtPnL5ZwRbpnkdA==
X-Received: by 2002:a17:90b:94f:: with SMTP id dw15mr1393233pjb.125.1605569656243;
        Mon, 16 Nov 2020 15:34:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9sm558464pjo.4.2020.11.16.15.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:34:15 -0800 (PST)
Message-ID: <5fb30c77.1c69fb81.11aaa.1c1c@mx.google.com>
Date:   Mon, 16 Nov 2020 15:34:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.19.157-62-gdee36feaf4bf
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 build: 10 builds: 0 failed, 10 passed,
 4 warnings (v4.19.157-62-gdee36feaf4bf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 build: 10 builds: 0 failed, 10 passed, 4 warnings (v4.=
19.157-62-gdee36feaf4bf)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
9/kernel/v4.19.157-62-gdee36feaf4bf/

Tree: stable-rc
Branch: queue/4.19
Git Describe: v4.19.157-62-gdee36feaf4bf
Git Commit: dee36feaf4bf77a52f6cb2cda611492f7b5049b3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 2 unique architectures

Warnings Detected:

arm:
    colibri_pxa300_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    tct_hammer_defconfig (gcc-8): 1 warning

mips:
    gcw0_defconfig (gcc-8): 1 warning


Warnings summary:

    4    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_l=
ist=E2=80=99 defined but not used [-Wunused-variable]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---
For more info write to <info@kernelci.org>
