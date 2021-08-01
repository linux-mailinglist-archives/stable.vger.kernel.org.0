Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48333DCB0B
	for <lists+stable@lfdr.de>; Sun,  1 Aug 2021 12:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhHAKLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Aug 2021 06:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbhHAKLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Aug 2021 06:11:33 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C092C06175F
        for <stable@vger.kernel.org>; Sun,  1 Aug 2021 03:11:25 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so27310582pja.5
        for <stable@vger.kernel.org>; Sun, 01 Aug 2021 03:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PEyG+/9kkXCiqIPni1VqQ4c64bgUPfCeOHsevvt40mY=;
        b=s4YwJ4fS8Z4aVQ6Mc+6fyLs+chLKNpjazoOXO7BJ5YerV5i/Mi+jHiUrtNXYjjn0P+
         tfWzXosoCuPS7wtKhIV8fAUp0TEU+GmFFBNltcaVRxqQAWs/e6sPM0TS0Wcl0wF2EmMo
         pldc/qnlMA/la1AaaKORa42uJva9nZiXrrbbnVBJPRIttjYMA8vyCmsHb12Lw/aFHYjZ
         AZoyw3Jn0jw5weA2mCAheEWJ3p7l/lMVW+4QCOWowfcSF+5sTlginlAZi5JK4blIM8DA
         Jy+4O3myvpLU47pWabQexHSb+hQAfJJDUlZyZ4f9TXYpQNy7y92JsOnD25AhiaJTR5Ci
         6gIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PEyG+/9kkXCiqIPni1VqQ4c64bgUPfCeOHsevvt40mY=;
        b=JDcecowL+FkXWHmyiiTwfJTKerSxBv13J6oNjqFuVbEVtpYWItdBAu4YN4enZyvcra
         jCRlQuNroC9YCPBKa3kG/xBwM2KEEFmPCuNShEFE3N3YyJuZ5tuaQ+kf5N20gTgT9Yhp
         QbnU5eu7WOXqbEePj6sC/s2xpP8/9Oz075ugs0SoOAynfAivLAH1fLrwTQML8Y6k9cBP
         Tsnws+6oVaLP62hl0QXoh0MJkO44WR+b7SAN4hdTifD4xYdt8/Umdjr3LjaUUB0uG/ZN
         ebQAZ3yqeasvFHI6eTJpplWxfclGrk98meHQC+5BT0BpNpDn0I4tgoYn9/R9hEXcXQBx
         NSHw==
X-Gm-Message-State: AOAM532l+KKxa0jFLFSFc1VJ9DZZgH/qW4xgJQYPAv/B5YTfYiAYuh51
        c4+yLjPWSqT/GynlvdBJKO6ijlknXyYxWTGR
X-Google-Smtp-Source: ABdhPJwIH/KOX8kGYDkojHJrbDEqN0lQJUV3lQvKG6AXljC9bTpiNHIYKXqSgW8G6EsLTCPIPKLVlQ==
X-Received: by 2002:a17:90a:530e:: with SMTP id x14mr12326045pjh.128.1627812684851;
        Sun, 01 Aug 2021 03:11:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x189sm9300497pfx.99.2021.08.01.03.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Aug 2021 03:11:24 -0700 (PDT)
Message-ID: <6106734c.1c69fb81.f9469.8d5a@mx.google.com>
Date:   Sun, 01 Aug 2021 03:11:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.7-90-gc013d5cf65f6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 194 runs,
 8 regressions (v5.13.7-90-gc013d5cf65f6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 194 runs, 8 regressions (v5.13.7-90-gc013d5c=
f65f6)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig   | 2          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx6sx-sdb              | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defco=
nfig | 1          =

imx7d-sdb               | arm   | lab-nxp      | gcc-8    | multi_v7_defcon=
fig  | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.7-90-gc013d5cf65f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.7-90-gc013d5cf65f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c013d5cf65f6f3c5d0c65ec06a45d09fdd42ada4 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig   | 2          =


  Details:     https://kernelci.org/test/plan/id/6106390002086d2c1e85f461

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6106390002086d2=
c1e85f468
        new failure (last pass: v5.13.7-34-g59fb97ea0e16)
        34 lines

    2021-08-01T06:02:18.098226  kern  :alert : 8<--- cut here ---
    2021-08-01T06:02:18.099388  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address efcf64d8
    2021-08-01T06:02:18.100073  kern  :ale<8>[   14.242619] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D34>
    2021-08-01T06:02:18.100783  rt : pgd =3D 452cb159
    2021-08-01T06:02:18.101445  kern  :alert : [efcf64d8] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6106390002086d2=
c1e85f469
        new failure (last pass: v5.13.7-34-g59fb97ea0e16)
        90 lines

    2021-08-01T06:02:18.104868  kern  :alert : Register r0 information: non=
-paged memory
    2021-08-01T06:02:18.105592  kern  :alert : Register r1 information: non=
-paged memory
    2021-08-01T06:02:18.106247  kern  :alert : Register r2 information: non=
-paged memory
    2021-08-01T06:02:18.106893  kern  :alert : Register r3 information: non=
-paged memory
    2021-08-01T06:02:18.142059  kern  :alert : Register r4 information: 62-=
page vmalloc region starting at 0xef8c8000 allocated at kernel_read_file+0x=
148/0x260
    2021-08-01T06:02:18.142821  kern  :alert : Register r5 information: non=
-paged memory
    2021-08-01T06:02:18.143888  kern  :alert : Register r6 information: 62-=
page vmalloc region starting at 0xef8c8000 allocated at kernel_read_file+0x=
148/0x260
    2021-08-01T06:02:18.144590  kern  :alert : Register r7 information: non=
-paged memory
    2021-08-01T06:02:18.185132  kern  :alert : Register r8 information: 62-=
page vmalloc region starting at 0xef8c8000 allocated at kernel_read_file+0x=
148/0x260
    2021-08-01T06:02:18.185827  kern  :alert : Register r9 information: non=
-paged memory =

    ... (92 line(s) more)  =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61063c1813324aeff185f47f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61063c1813324aeff185f=
480
        new failure (last pass: v5.13.7-34-g59fb97ea0e16) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61063ce131c5ae8d3185f46b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61063ce131c5ae8d3185f=
46c
        failing since 3 days (last pass: v5.13.5-224-g078d5e3a85db, first f=
ail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx6sx-sdb              | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6106400169c769caa385f473

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6106400169c769caa385f=
474
        new failure (last pass: v5.13.7-34-g59fb97ea0e16) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx7d-sdb               | arm   | lab-nxp      | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61063d59f57c9d9cf485f47e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61063d59f57c9d9cf485f=
47f
        new failure (last pass: v5.13.7-34-g59fb97ea0e16) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61063fa485b7c54d1285f49e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61063fa485b7c54d1285f=
49f
        failing since 5 days (last pass: v5.13.3-506-geae05e2c64ef, first f=
ail: v5.13.5-224-g6b468383e8ba) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61063f24009cf11b8d85f480

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-9=
0-gc013d5cf65f6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61063f24009cf11b8d85f=
481
        failing since 2 days (last pass: v5.13.5-223-g3a7649e5ffb5, first f=
ail: v5.13.6-22-g42e97d352a41) =

 =20
