Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8887B47D631
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 19:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbhLVSCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 13:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhLVSCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 13:02:43 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6F6C061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 10:02:43 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o63-20020a17090a0a4500b001b1c2db8145so6572391pjo.5
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 10:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sE/W7Powf6Lpqp7SlPf8ou+FnFQw+H3iZPUuDRj0Fjo=;
        b=3aSgwfW+EKbGYWGJfaBEL1jVONeQ8jNnIqoZ8JEn3QNWaqMXq6Dg7mz+MrNxfsKOnj
         eN2j+L2yZC6zLazQaHSdtN60HsrrdNVUtxFVMDm0T8pbEYar47UneHjadjPRko+djklz
         g9S5hB2E55mrMQP6vVz7xpsts7AikKkpz5R02StPBjctLHJzVuMi6MCgPM/IRIdJqwHo
         SQDRnifXK2uwAo36gZ8dNm7xm1bKKtCh4r3Rqws2iVfEoeZxU3t2ha7uIQkP+uOgnQ3+
         djA9Aqqc7x8Fkag0kcmfd+PQQ2fJ3GJ0RWJsDCaFbakSUVUyaj1ReKw0Lf+Y4eskYL8g
         941g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sE/W7Powf6Lpqp7SlPf8ou+FnFQw+H3iZPUuDRj0Fjo=;
        b=1ScAdsWT+jI5ao3BB+c4UhD74ziCkbkogf5oE/WK/A8d0dd5Siq9NUXQ27J4ZVwDQu
         HCsrugcWKhhVLlWnzzH9grAqdUdreXDBcwdf/hXaOowUve99tP6gissFXJmC2sZWuwyz
         XGCC/y+9QymK5AH4UOeK8bQc0J5vc/Eyqu3zaKxtVFii3fNN5QA2R0D0wjPN6aKLi/6+
         JUTlBWVQzL26pUZrnUDrAoIncWTX89UdPQ6v1rzghC4lmxOYg5d1Fb2ifIflcNbxdhbu
         mk0HgAgeDBdVwgtDxg+LwYfxcNM/D9L0vqXWdhaijUKbRT1Q/bDpcHBf46QE6HTKbSSC
         t4hQ==
X-Gm-Message-State: AOAM533crFPfMNkzy/71arsvubRLLU30xG6r9wSGZlcuePbEqQ6M8+CI
        cmpZqkSWDQZy9kEyjzxPzCPjXD7o8hyVPr91O7E=
X-Google-Smtp-Source: ABdhPJz+KYGrSVREAhbHrDwJrB8GRLhYWPSHXBgwBd4CRVYNiMYsHi0SKOLgFf7YjohDkDmwB4999g==
X-Received: by 2002:a17:903:41c5:b0:148:a658:8d33 with SMTP id u5-20020a17090341c500b00148a6588d33mr3789296ple.153.1640196162339;
        Wed, 22 Dec 2021 10:02:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b22sm3764746pfv.107.2021.12.22.10.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:02:42 -0800 (PST)
Message-ID: <61c36842.1c69fb81.25b05.9980@mx.google.com>
Date:   Wed, 22 Dec 2021 10:02:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.168-3-gdaadb12775fc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 186 runs,
 4 regressions (v5.4.168-3-gdaadb12775fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 186 runs, 4 regressions (v5.4.168-3-gdaadb127=
75fc)

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
el/v5.4.168-3-gdaadb12775fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.168-3-gdaadb12775fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      daadb12775fcf95e7c85b6ad145bfe00dddd8efd =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c331481378770df2397157

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-3=
-gdaadb12775fc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-3=
-gdaadb12775fc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c331481378770df2397=
158
        failing since 6 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c331566864b110ce39714d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-3=
-gdaadb12775fc/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-3=
-gdaadb12775fc/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c331566864b110ce397=
14e
        failing since 6 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c331496864b110ce397147

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-3=
-gdaadb12775fc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-3=
-gdaadb12775fc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c331496864b110ce397=
148
        failing since 6 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c331596864b110ce39715a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-3=
-gdaadb12775fc/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-3=
-gdaadb12775fc/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c331596864b110ce397=
15b
        failing since 6 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =20
