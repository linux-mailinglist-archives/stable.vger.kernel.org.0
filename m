Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20605567DB7
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 07:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiGFF0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 01:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiGFF02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 01:26:28 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF320222B1
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 22:26:26 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so10199353pjf.2
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 22:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hP+5e6BJjGxsrWwI/5zL3nqFGNLpsl95mDdw7Xn6bVk=;
        b=mgzrZE+oWeXXCqaeNi9PyEckM1LX3i/WHfSueK3eRQzCDrws5YyGgJgyJ8T2th6sae
         zkFfaN0ww39baK+Qcv3FqK5UyCr7GCLowpQCe/9c0pNsds1beTcE3oOSdOzT+LLDG7Ga
         aO3t7puGk/5oZsljoWNqRJIHWgYFAuzhAaNxmY/1WSzgO8GmX44wEUadkMwmHjdzn5jL
         fcd1LWBLsV+yHWIlchkpv6riRT/djtY0Ovw2lUFEi3NaY4LFL7gAIPH4A2t2o170zjjS
         qG4DXfoiJH/3ONBgDGcR1roDjkSrVwgz5lx7i8UdWfDhxuSFQ70R5kTpNy4G7KODCKfw
         5FVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hP+5e6BJjGxsrWwI/5zL3nqFGNLpsl95mDdw7Xn6bVk=;
        b=oM1jwcUYDR3pRH4kcIfb1GwDzKfdcLRR0eFTenbpCL6lr6vU3N+VEshCR8Y+Gi90v9
         p4dWo9Jt3RRgy+EbwAv//+aTp3VDofUsCL7zy9Esxf1jZCZ/dP3tI1q8BHA5SqE0Cj7F
         /9rU3jBA1kw0e4/QdgLm+NBqNHb7CnsQ+X5wIANSt4nL5ZBtiwB1oaYXL92pkjXm96B6
         L+HdkAqr1O7q4D77WwSI+4zenw05Nds5Iku7Px3zAOHJ1n+z2whqdAZ2fT7AkbkKEn8w
         H1p3K4sNQoWwmSVsmAVBaIFPndVYWFASvpnuXiDTffyfWwpNsbdE7P3b37YzeSve4weB
         uDAg==
X-Gm-Message-State: AJIora9g0loooCxdctrl+4L5rvLzcFmVf0DukSwLx5ce+aulf76c5z4C
        ghmm594bjZAB0o6vlfSlOADRN/UpuRWm/XYP
X-Google-Smtp-Source: AGRyM1s1QfUDtMLS05QRoqt9Bkzv0YZXcfaowBUgS0Ar3kbT/4u/LahWsLc0C4WnGn4LDqaYDTML0Q==
X-Received: by 2002:a17:90b:e95:b0:1ef:825f:cb40 with SMTP id fv21-20020a17090b0e9500b001ef825fcb40mr20584673pjb.29.1657085186119;
        Tue, 05 Jul 2022 22:26:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x188-20020a6263c5000000b0052513c1c4bbsm23873275pfb.38.2022.07.05.22.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 22:26:25 -0700 (PDT)
Message-ID: <62c51d01.1c69fb81.41c21.1fdf@mx.google.com>
Date:   Tue, 05 Jul 2022 22:26:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.128-78-gcb2d435b0ae4
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 109 runs,
 9 regressions (v5.10.128-78-gcb2d435b0ae4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 109 runs, 9 regressions (v5.10.128-78-gcb2d4=
35b0ae4)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | tegra_defcon=
fig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.128-78-gcb2d435b0ae4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.128-78-gcb2d435b0ae4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb2d435b0ae47f0c44ecdc01e82f88b3288512d6 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | tegra_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4e5ed9a36af910aa39bf9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4e5ed9a36af910aa39=
bfa
        failing since 17 days (last pass: v5.10.123-4-gc586992bf6805, first=
 fail: v5.10.123-34-g2f9d93aa50b2b) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4e525ad1c297f65a39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4e525ad1c297f65a39=
bd4
        failing since 56 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4e5043b6c5d8907a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4e5043b6c5d8907a39=
bce
        failing since 56 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4e539a237427f18a39c17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4e539a237427f18a39=
c18
        failing since 56 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4e52c11b851e5e8a39bd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4e52c11b851e5e8a39=
bd9
        failing since 56 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4e538a237427f18a39c09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4e538a237427f18a39=
c0a
        failing since 56 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4e52b3b6c5d8907a39bfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4e52b3b6c5d8907a39=
bfb
        failing since 56 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4e536a237427f18a39c03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4e536a237427f18a39=
c04
        failing since 56 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4e503b873d83c6ca39bea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.128=
-78-gcb2d435b0ae4/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4e503b873d83c6ca39=
beb
        failing since 56 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =20
