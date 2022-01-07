Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EBB486E59
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 01:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343507AbiAGAL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 19:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbiAGAL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 19:11:56 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76AAC061245
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 16:11:55 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso4824627pjb.1
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 16:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1Cs3M6QDvbqCFZWupIEvmCVa7bGxI3r58jdxCjY9/jw=;
        b=s/rUWkoVkasOt+jaug8UZW0nbXCIOfC7Oi2JyommW/jsPkjeDp124iaOtk0FDkm7Ui
         aC36tcQsKxGor2Kbt+f14PdheW3pjSQRfe9PlUww/U603uIAe0Xo28BvtPjbKk182r2L
         K/sP64Ljj/8Tez+kCmOPvLx0NXMWYZ1Q5QHqJMz8FbnmSwAM62BKv3WFb873vikaye/G
         VWs03vMJaYqyETrokvZT5p8d1ng91nAleguUL/oLFQR7YCQnm/j6GrUR5hWt4FF9z96a
         T4ZNHR95fovrubcAsj9V/KaW4azk/6HQ6W0nQCXXKCpRiXE2GQOneVOI/ioX6oIQC7p3
         f8Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1Cs3M6QDvbqCFZWupIEvmCVa7bGxI3r58jdxCjY9/jw=;
        b=If2nWB40Xxy1h25nZg9tYeTsTshrniwfZDBNHO9Yp4Lh3c+kjzWaTJEVgh2EykBMCe
         Ji6irrJ4iPULQ163MyTl3vx50fj7SFnj6zh9ubpydLuLHOi2oc+7EfaEYNttTDZERHFV
         k/XbsWf9yZT83BmfHaN4rd0AvmB6RprRlOKb2UgtPJij0rO0XwZNIctvGf9G36eZs2Cn
         LTWDn/Vc1Pqe3A+jryU6PJMPLtwMqt1kHKbAvKmxlR9tzfB4o0YMt6IivT/yCKt2vnLK
         Kv4Gj+L7CtHLhOzzJ0bwpPPZmANiz9gJpjSOltNYuyoTK5DQYkrrQB65tRMO5nWS4Vic
         i4IA==
X-Gm-Message-State: AOAM532+tUHYllFIE3XU4P69ygaJyPbNKQnwo/66/1aXbdXVgY8gErgc
        +zErwl6kg1YvEoWvxmUlmDkmM3d/mhrY39AB
X-Google-Smtp-Source: ABdhPJxakvY18ucyK+vFMg9Sen2fU833+eAeYuA1VZE9aOECdoV0+CWb9IsMZnr3CR9//P8OHLZecQ==
X-Received: by 2002:a17:90b:4b83:: with SMTP id lr3mr4222189pjb.169.1641514314998;
        Thu, 06 Jan 2022 16:11:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y32sm3817207pfa.92.2022.01.06.16.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 16:11:54 -0800 (PST)
Message-ID: <61d7854a.1c69fb81.ced99.a1d9@mx.google.com>
Date:   Thu, 06 Jan 2022 16:11:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.170-3-g717562f21405
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 169 runs,
 4 regressions (v5.4.170-3-g717562f21405)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 169 runs, 4 regressions (v5.4.170-3-g717562f2=
1405)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.170-3-g717562f21405/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.170-3-g717562f21405
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      717562f21405c9dbc42327c20252c69440267d3e =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d7545def229bc97fef674a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-g717562f21405/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-g717562f21405/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d7545def229bc97fef6=
74b
        failing since 21 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d75477ef229bc97fef6772

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-g717562f21405/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-g717562f21405/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d75477ef229bc97fef6=
773
        failing since 21 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d75447e4d846e92fef675c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-g717562f21405/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-g717562f21405/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d75447e4d846e92fef6=
75d
        failing since 21 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d75476ef229bc97fef6764

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-g717562f21405/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
-g717562f21405/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d75476ef229bc97fef6=
765
        failing since 21 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
