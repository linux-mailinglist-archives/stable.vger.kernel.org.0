Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE8F2B3ADC
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 01:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgKPA4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Nov 2020 19:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKPA43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Nov 2020 19:56:29 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB2CC0613CF
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 16:56:29 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 131so1569625pfb.9
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 16:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BMKfEko0NWhrBgvBijWK8rRDhIcVsYZ2bjeIFkgZbso=;
        b=kCCNaAdvFRu5wpJtHZiCIsUgtS2B8HM+L5/WAcV/n+CipJiUGD/NuY8+IS1sHlSqTo
         xi2NLKWw8XSjdmTycIwBBVXsHn71py+nr432X9YhNxn+KvAkszlf/r5kw9lezPDPOZKl
         9l9F1JEcofrd8MIlyMI69ScahTEGJ4UoiaU7xguzvNuMtiGWqKn2T1voib4gSbhxKaLV
         Cdn61DHRKPpZ1WBFSQG9LK8TgPJQRrEOU5zUZn98ETfr5ANiipQEO8c6HwSjxF0fwtbH
         mbT64e3HKK2H3bwmrvM5OG7FkRJ7iDkVqtmIkxBthl1Zmep8kOrRIsa0oflZkFs9GlWU
         LGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BMKfEko0NWhrBgvBijWK8rRDhIcVsYZ2bjeIFkgZbso=;
        b=b/A7+A+5wMQsvi0y4FWV3lW1u41nLaSrG0xsqGY46xAlN1v8X58R1GD2WyHbbIH5Bz
         snFyoHSuk9G2UdPFgAuk4iMvmj8j4ZsEDobNl4o5jlFc4G53wiMEpDrB9WLEemtqetgA
         /4vLJ2vWwUhHz6a1IVh7LraQhuHjAGFtrW4JUgEsyC/PNxBS9BpAuop69u+05FmNtBiL
         6OTV+UhRBq0Pq7JJh0Kg+XYL3APBBRPRRyiSL3YKAu67Hc/McyE5AfMC0+KlNaLzlLw3
         c0Mo5V92L+J2rXHcsRgSm/GknIxRxy/0OC1juo1VzY+EOY8aRpqY1qJi8EBRWDShaVn0
         NH6A==
X-Gm-Message-State: AOAM531+5Z8/myj9dIyOfRKb5jVlFAH1a2fIDSsvgZvcI4Qr9r86wAri
        6MOXjKL4xgfcmmIVGe23wdfdULRRGDeppA==
X-Google-Smtp-Source: ABdhPJy1HnT7h4Qz3M8FQeJfjgwKghvCt4CXzNrrnSYa9I6u71cSM539NmJrmHUMb/oWcgUffUe34w==
X-Received: by 2002:a63:9d8d:: with SMTP id i135mr11263313pgd.213.1605488187462;
        Sun, 15 Nov 2020 16:56:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8sm15159960pfa.132.2020.11.15.16.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 16:56:26 -0800 (PST)
Message-ID: <5fb1ce3a.1c69fb81.34633.0c26@mx.google.com>
Date:   Sun, 15 Nov 2020 16:56:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.243-35-g15e4bcbc078b
X-Kernelci-Report-Type: build
Subject: stable-rc/queue/4.9 build: 22 builds: 1 failed, 21 passed,
 1 warning (v4.9.243-35-g15e4bcbc078b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 build: 22 builds: 1 failed, 21 passed, 1 warning (v4.9.=
243-35-g15e4bcbc078b)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.9=
/kernel/v4.9.243-35-g15e4bcbc078b/

Tree: stable-rc
Branch: queue/4.9
Git Describe: v4.9.243-35-g15e4bcbc078b
Git Commit: 15e4bcbc078b39c7ea4bb7cc1ea8a3a612d557c9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 3 unique architectures

Build Failure Detected:

mips:
    32r2el_defconfig: (gcc-8) FAIL

Warnings Detected:

arc:

arm:
    at91_dt_defconfig (gcc-8): 1 warning

mips:


Warnings summary:

    1    /scratch/linux/drivers/mtd/nand/atmel_nand.c:2337:19: warning: unu=
sed variable =E2=80=98mtd=E2=80=99 [-Wunused-variable]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/mtd/nand/atmel_nand.c:2337:19: warning: unused v=
ariable =E2=80=98mtd=E2=80=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---
For more info write to <info@kernelci.org>
