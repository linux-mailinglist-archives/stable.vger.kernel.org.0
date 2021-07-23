Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D6B3D30A0
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 02:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbhGVXXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 19:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbhGVXXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 19:23:15 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067C7C061575
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 17:03:50 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso1521482pjs.2
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 17:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qnNaUE6a9CqBGLpW2YtHuVlAez62KpHCAHUObG9Z7hU=;
        b=WhiSnLL8Xc/sRWD98Qn830BL0S7kPOjAS91tHrawUWUnxUCVau7Xn3f3uIN4UL89LZ
         9eBWCHyt3Scr8OIXfox5Yv4E4st+FGxHUlwCd0jlFjXzw+R/iLosgoWqxZZbj/0EpYw9
         DfdJGIRvbrr0wD38OdnPdFRPLzr+7T2xeF2mR8k1SpfNkvfI1Mue2JNQQ3la4cBicLb0
         VSzMLKaI0b34qBfDye3C4ynNuQ2GYZZGQOLxkM1upDPce4RUj0YaBPAjIJwT2+SAIZi8
         R+JVwR+jeSOiIPJZKToEx2l04OAtIJynt1RdiNWTfW6S3Xtpr+gB/8AGl0NuBoT0tBec
         Fv2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qnNaUE6a9CqBGLpW2YtHuVlAez62KpHCAHUObG9Z7hU=;
        b=mjnUnuw7NpZWPUAHcxKDJtOiXEd8H5y4vy1hVIFUZcqW/PStnzZPxByvV7afULOMzE
         3ZcvYBJkH0H+j7KEZ9zGeEey2+EsAuShWOsqAT/ki/IY506/Uov1zvPM5sFTXky1vShl
         jwSvpTv+Sjk4Kbj0bsD/fDyrdNyBvku9PDRGRkpyKEhK57sYkaTQ2SAiyudSivP/U1WK
         o/eUeQHIKY5c4KcRrQkQXdcozUcC8bQvr++clQNTwiZxH51GnfQ0snoYiy1AEuWo7vA/
         6EI/v9b8yhYfa5EjOgL+CWtrd4YdwG1nMk6mJCxNzx2nDMVHXxa0QaxuuR5GMj3ZpAly
         McLw==
X-Gm-Message-State: AOAM5316fSKv1/z7nf7WF4jHfds784w+5dqEEcDahspxeh2TJLtI1tSy
        nm21uryZ4bJrNTU3oKhHPCAfRzKThfM+1M6a
X-Google-Smtp-Source: ABdhPJzg/4l+1949Sq3RBWdcPsi7teAYxZpguZz66Tb4CkOTYOJKaGsp+NVmtarZuujjD472oeAsKg==
X-Received: by 2002:a63:5802:: with SMTP id m2mr2317729pgb.171.1626998629341;
        Thu, 22 Jul 2021 17:03:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z12sm25688855pjd.39.2021.07.22.17.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 17:03:49 -0700 (PDT)
Message-ID: <60fa0765.1c69fb81.86201.03f5@mx.google.com>
Date:   Thu, 22 Jul 2021 17:03:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.3-507-g9f06663c91b85
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 158 runs,
 5 regressions (v5.13.3-507-g9f06663c91b85)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 158 runs, 5 regressions (v5.13.3-507-g9f0666=
3c91b85)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig   =
| 2          =

beagle-xm          | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

beagle-xm          | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig           =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.3-507-g9f06663c91b85/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.3-507-g9f06663c91b85
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f06663c91b8574eac4934200821e0b7af02254d =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig   =
| 2          =


  Details:     https://kernelci.org/test/plan/id/60f9c9c719c9cf2f6485c283

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-g9f06663c91b85/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-g9f06663c91b85/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60f9c9c719c9cf2=
f6485c28a
        new failure (last pass: v5.13.2-253-g45582c2691e0)
        17 lines

    2021-07-22T19:40:32.241675  kern  :alert : 8<--- cut here ---
    2021-07-22T19:40:32.284800  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 3c9e024c
    2021-07-22T19:40:32.285575  ke<8>[   13.568412] <LAVA_SIGNAL_TESTCASE T=
EST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D17>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60f9c9c719c9cf2=
f6485c28b
        new failure (last pass: v5.13.2-253-g45582c2691e0)
        28 lines

    2021-07-22T19:40:32.289106  rn  :alert : pgd =3D 23e14c87
    2021-07-22T19:40:32.289844  kern  :alert : [3c9e024c] *pgd=3D00000000
    2021-07-22T19:40:32.290503  kern  :alert : Register r0 information: sla=
b shmem_inode_cache start c3572e10 pointer offset 172
    2021-07-22T19:40:32.291156  kern  :alert : Register r1 information: non=
-paged memory
    2021-07-22T19:40:32.291804  kern  :alert : Register r2 information: NUL=
L pointer
    2021-07-22T19:40:32.328085  kern  :alert : Register r3 information: NUL=
L pointer
    2021-07-22T19:40:32.329342  kern  :alert : Register r4 information: non=
-slab/vmalloc m<8>[   13.611765] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg=
 RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D28>
    2021-07-22T19:40:32.330069  emory
    2021-07-22T19:40:32.330724  kern  :alert : Re<8>[   13.622980] <LAVA_SI=
GNAL_ENDRUN 0_dmesg 583988_1.5.2.4.1>   =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
beagle-xm          | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f9d40608b4f8407285c25c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-g9f06663c91b85/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-g9f06663c91b85/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9d40608b4f8407285c=
25d
        failing since 1 day (last pass: v5.13.3-349-g948be23c1d3d3, first f=
ail: v5.13.3-350-g04f08469f404) =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
beagle-xm          | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f9d095d5d30fae7485c273

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-g9f06663c91b85/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-g9f06663c91b85/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9d095d5d30fae7485c=
274
        failing since 8 days (last pass: v5.13.1-804-gbeca113be88f, first f=
ail: v5.13.1-802-gbf2d96d8a7b0) =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f9d40208b4f8407285c256

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-g9f06663c91b85/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-g9f06663c91b85/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9d40208b4f8407285c=
257
        new failure (last pass: v5.13.3-349-g948be23c1d3d3) =

 =20
