Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5922548443B
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 16:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiADPIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 10:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbiADPIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 10:08:17 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD4AC061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 07:08:16 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso41167979pjc.4
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 07:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6pRP3oGdme7/pHXNEuOTRxO9j57nEEYPQil8CV3FgwE=;
        b=OpDCa0R+6wM8P8ocNM3/VC93tYOc4BwbC8TGlSPWvSh5wipwI/qmOue2o2NEbl5hhI
         8eH/DiEAVmseyLwZwrX3NtJTN8E2uNJ+/yTPGLYpfjGXpntUNZ8jGKojYd78t9s85Cr7
         iL+eOs/CqeUD/cbSWw8j7et/1B/D+yI4UPnQgwY9QogLn88ay9bWDmswUv3TDt8vaFaw
         uEXJw280PnkgSU//EFaa1T+3V7fex/AUwIZUZyxee5bzImzuG/vFCTVwZ8tOx0Gu4Iz+
         xPCok0EM4NTsXlk8n98hJsgqOYFnklaLzYEtN8Z4vYjjBgwwuoHGU7wzPkkpH3x4aVOE
         XXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6pRP3oGdme7/pHXNEuOTRxO9j57nEEYPQil8CV3FgwE=;
        b=5BYcIe7C6mO0gjGqeWEk28GNM9SVmjIUJ/5xX1Pn5sT88SAjGud6vdKmTOYDRofT9H
         F0MKGnm4RgpbjqTqytdEbCg47KW3ZSdOo9bM+ff3yWiTAygv/HHl/s+Ho/0/YyuL/Pmi
         Do0dN+hRSIYdBnyEW4XKfttNuQmDyx/KiXrQgU9k4hI8dXS4RzX5mCrg5aR8js8Dod+l
         gA1lSoYvFbJOrIMcTSq94NXKMEb1mCpOc3KCMFRX3loAuFhIAfW9bEvZKxxHAIC9Xv8h
         i95atFPjKlAHL6V90wzbuZvnEmeemotEcn2kpmZ2hr6QeEOQxHNCFApkzD+F77P+Sfad
         cnXQ==
X-Gm-Message-State: AOAM533mrumXASqx63lYZrQBGr2zzWhrIOCUUKQDBdCcHRHmjTmuzQun
        pFmBs4tCOtFbXxUnsJKhtPWtPAoVN3jyUoju
X-Google-Smtp-Source: ABdhPJxZTHvQTo/rP2VOOlSBRsPD/14vOw74JREy/HZu8OU3MdveQC4kgSzO5XENRAeM6XT3c89CGw==
X-Received: by 2002:a17:902:c94b:b0:149:22af:ed1c with SMTP id i11-20020a170902c94b00b0014922afed1cmr48661264pla.78.1641308896178;
        Tue, 04 Jan 2022 07:08:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g21sm42437063pfc.75.2022.01.04.07.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 07:08:15 -0800 (PST)
Message-ID: <61d462df.1c69fb81.92e9d.f6dd@mx.google.com>
Date:   Tue, 04 Jan 2022 07:08:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.169-37-g80ddcc564ae9
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 111 runs,
 4 regressions (v5.4.169-37-g80ddcc564ae9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 111 runs, 4 regressions (v5.4.169-37-g80ddc=
c564ae9)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.169-37-g80ddcc564ae9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.169-37-g80ddcc564ae9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      80ddcc564ae91afb9de54b43ffb4b2167a7306a3 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d42805bb035eb64eef6749

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-37-g80ddcc564ae9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-37-g80ddcc564ae9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d42805bb035eb64eef6=
74a
        failing since 19 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d4281bbb035eb64eef6761

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-37-g80ddcc564ae9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-37-g80ddcc564ae9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d4281bbb035eb64eef6=
762
        failing since 19 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d42806bb035eb64eef674f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-37-g80ddcc564ae9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-37-g80ddcc564ae9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d42806bb035eb64eef6=
750
        failing since 19 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d4282d3e985cf762ef674a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-37-g80ddcc564ae9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-37-g80ddcc564ae9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d4282d3e985cf762ef6=
74b
        failing since 19 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
