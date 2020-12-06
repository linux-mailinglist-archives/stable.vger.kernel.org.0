Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0662D05F1
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 17:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgLFQ32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 11:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgLFQ31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 11:29:27 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17F1C0613D2
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 08:28:46 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o5so6779511pgm.10
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 08:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ud7/c6J0K4lvMVI4EYBR6VCNETsnymrzFOicnv4hCQg=;
        b=l4Exejcc4WLZR5/ibCGLCrKVc/RsNaNSl6xWMjtNUrc/gHTYaezUS2sO/XVpuuMRCV
         yT2sYqeZyPn09OVszNBuqGN+qI8i0CskVM5XHA1/H+aorVIOmPsffzWJZZ+mB8GYpLJr
         q4EKGs5DYSk6TEYdkK5bEVXd2n1NHPOBgBggA7awNC/nC08FIktYHhxxbXXEshzH88pY
         9kcDuJEZlzOA9NFU2/wZ5xmg+XiPTqeNXPhKxfT66OjunF6NSalqjc8tioiULBQ8zZmW
         8T0khBZy2pt7QAUXerD3oDZDZKoLbKY4lUEYQBfOi66VEsdx9FOY+vpvtCJqcrlnJmN9
         i5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ud7/c6J0K4lvMVI4EYBR6VCNETsnymrzFOicnv4hCQg=;
        b=OpfnrbZ84W+7XyztWlRhAYtnPFY4QUpHP1LupyDePywX6xFTPz7hc8Yz6UfEE6ZaCf
         G0khl9J4fL0o+bOuVm0F9hsSyBIaaOGauIDP1GmJ+5i3UStdzPp3ZFyACmm9k+fjY6sm
         cd2kDoL0oYSFjDxBDA1EI2+l/CETyh358JSQQn+15jvF6y20DD2oL0cPMtGfjXr73SxR
         UfGeh5JI/gWDIrpzXKzzMezwS/zw7b4fdfpPCNFR2oyBYfi8tjpxvaqyOLszcSADv1Xv
         naGiv32Za7dgGDQtM/ZPuold7Tvo2pQ3JUqmH7/HgPYFwz+STHPlyhP84q/yq+3Os1vk
         KIDA==
X-Gm-Message-State: AOAM532gwbuEAWd9vUF+mFWlkylJssUkxKD07pod8dtVs6UXhayWNYHn
        gnMyzFr9P8ZDeoM+IyR/bMSFXwc7WA6Xzg==
X-Google-Smtp-Source: ABdhPJyMGdneTF7JinHtuVLDEq+KaSTBb3mq6ZPPozKs9tHbGQiiBrOmVRP+4SUX/IPLZpCn1r7XLA==
X-Received: by 2002:aa7:9633:0:b029:19d:d05f:4964 with SMTP id r19-20020aa796330000b029019dd05f4964mr6666347pfg.23.1607272126047;
        Sun, 06 Dec 2020 08:28:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f92sm8708612pjk.54.2020.12.06.08.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 08:28:45 -0800 (PST)
Message-ID: <5fcd06bd.1c69fb81.33e64.3f4b@mx.google.com>
Date:   Sun, 06 Dec 2020 08:28:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.81-39-g99db1ab959b5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 198 runs,
 8 regressions (v5.4.81-39-g99db1ab959b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 198 runs, 8 regressions (v5.4.81-39-g99db1ab9=
59b5)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

bcm2837-rpi-3-b-32    | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfi=
g   | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

meson-gxm-q200        | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.81-39-g99db1ab959b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.81-39-g99db1ab959b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99db1ab959b586a1e6a228cc95f859c2596e39e1 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccd4161ad683ce9bc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccd4161ad683ce9bc94=
cba
        failing since 38 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
bcm2837-rpi-3-b-32    | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccd21f99b5936f6cc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccd21f99b5936f6cc94=
cba
        new failure (last pass: v5.4.81-34-gefcfcd5689e6) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccd23799b5936f6cc94d32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccd23799b5936f6cc94=
d33
        failing since 16 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-q200        | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccd4181ad683ce9bc94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccd4181ad683ce9bc94=
cc4
        new failure (last pass: v5.4.81-34-gefcfcd5689e6) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccd3335346b2e5ecc94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccd3335346b2e5ecc94=
ccc
        failing since 22 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccd34be29c1a889cc94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccd34be29c1a889cc94=
cd7
        failing since 22 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccd33bda77bf57dac94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccd33bda77bf57dac94=
cc4
        failing since 22 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccd2fe91198e06a6c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-39=
-g99db1ab959b5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccd2fe91198e06a6c94=
cbe
        failing since 22 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
