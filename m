Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6A030EB5C
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 05:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBDEBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 23:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbhBDEBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 23:01:09 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE47C061573
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 20:00:29 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id s24so933314pjp.5
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 20:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IZMXN5bUC+X///i80UaUUQmazI8XgAMz7UGqukXWuJI=;
        b=sGHuxMU7EkdwrE+ltQKA1Fq2q3R4FqLUBuTIsXewS/UkTRyAX2/xItmsvTYPcXgj9q
         Q9jPHf510S3v6I8EElfIdap1jvN86v128pVuCd/aP8IvM4AdzOwuWt78xWoXrnAOyiZV
         7s4aOSpL1dHv0F/99ogae0nrRKm+eULgoC4eOiviRsAnF4FoGwfsZN9pmmq6qMEgxTW/
         y/aBOc9UayvZNddCiCkNlElp872WzWPFzhDlFYH8jVhJgBRym++03vfldKRKSlUrgNpi
         VSWSa+iA0gz9CVRlVbAFXMivKVBjGhl34L2R8hz6IBy99ZmURZ46Ct0qSjNqW141udFe
         E5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IZMXN5bUC+X///i80UaUUQmazI8XgAMz7UGqukXWuJI=;
        b=o0jRltXIa+L3NkPVcog7I9tx02+QK8526z8W8WMDy/ZIcIaiSnypr9CyJrxkYBteI3
         MXawGOCbq6OsRXWnWKLe5UtV993/Wbu9HJp844h38Az4mOtmqmFmlPLu80lYGezd5jc7
         qIxM5hhaqDQoFHvllv+eV4rvRSTRCu5H2loNM6b6faxHHXbkLg10qH78sd93yh8oDbnH
         zA0YtVac104203Q5dshEkd5Xt12LXlD3cFOMqpMUsdFxIeO9+oxOT2KFaC/Oii5H1exO
         3BPeTCoYKWSpnK1Xh4oOlHo3RQ3/dlTOBLzVslJczk+oUjwsLkXIgxk2gNPR/Obk2b9c
         YLHg==
X-Gm-Message-State: AOAM532zOCY5NNIhUtE1pymMfJS5eC3g2CD+PhtXBc0MDisQdDhjRS8D
        MSe6gy02fiRdwWm7N7bCI3zMwjHt/unuSQ==
X-Google-Smtp-Source: ABdhPJykKYbE2kvoqaCxFPfo3xmLwoAS+YR8ra4ggm9yGKE4A+CH2IXmUBpNvPS/SMitWpLWSqHVuQ==
X-Received: by 2002:a17:90b:4a0b:: with SMTP id kk11mr6424132pjb.95.1612411228645;
        Wed, 03 Feb 2021 20:00:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r21sm4392030pgg.34.2021.02.03.20.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 20:00:27 -0800 (PST)
Message-ID: <601b715b.1c69fb81.273cc.aa9c@mx.google.com>
Date:   Wed, 03 Feb 2021 20:00:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.172-37-g60e641c2bf83
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 142 runs,
 5 regressions (v4.19.172-37-g60e641c2bf83)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 142 runs, 5 regressions (v4.19.172-37-g60e64=
1c2bf83)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.172-37-g60e641c2bf83/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.172-37-g60e641c2bf83
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      60e641c2bf839d50879f9740d2e621babcc84290 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601b402527b2185b713abe7a

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g60e641c2bf83/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g60e641c2bf83/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601b402527b2185=
b713abe81
        new failure (last pass: v4.19.172-37-g4afd0e1db22a)
        2 lines

    2021-02-04 00:30:24.420000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601b3c0b658f744caa3abee2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g60e641c2bf83/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g60e641c2bf83/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b3c0b658f744caa3ab=
ee3
        failing since 82 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601b3c06e20437dced3abe7f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g60e641c2bf83/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g60e641c2bf83/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b3c06e20437dced3ab=
e80
        failing since 82 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601b3c08658f744caa3abedf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g60e641c2bf83/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g60e641c2bf83/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b3c08658f744caa3ab=
ee0
        failing since 82 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601b3bba34016055273abe88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g60e641c2bf83/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.172=
-37-g60e641c2bf83/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b3bba34016055273ab=
e89
        failing since 82 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
