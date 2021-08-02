Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DF73DDE39
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 19:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhHBRMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 13:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhHBRMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 13:12:34 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA712C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 10:12:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id k4-20020a17090a5144b02901731c776526so32636058pjm.4
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 10:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BTOrmKzkF0RxNezqdOlehQtmhyxTnyjPuI4e+I5P/SY=;
        b=l72xraTYN7dUO66MT6vuxHQJut/OluVxsyD3yGfzpWpHemF4hT8VyylGdo7GdvC4QP
         didZg572SlL9F1ucTe32OyJNQkX1QlYEgm5m+zSQUHl/yfpkQ4gfDLZXcmUYAO7mHac7
         ac7D2LM3yr4VmtQNOIOGiQ6eoiIQhyNJA6CxGaFyliE8ivgwwkss1Py3PrDUIfti6dXz
         ZW2+H0t5bhvj46fkMu7xDbVnsJxpY+lezrX5onLHyh+9dAH65PdCINFkvLr6dcM8oclW
         DiyqKO38ysiLz4DQVFIhyTLJgGpERzwnB3AWfwkZeM9BI9N3wikGxDlyeOLBCEKMM51d
         9m/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BTOrmKzkF0RxNezqdOlehQtmhyxTnyjPuI4e+I5P/SY=;
        b=jSVshfE1ohdZ9VEsk5o/WutNouDSXBP+Swi8zS1PQlnf0lc+/Yt0ierPLm1UO4KacL
         D5DUxdBNoHzeBAtYdKgaS+44Pvw3uAaUODbrTHtfVSq73pHXsZ94Uw0ybhRB8qvyPwLd
         LicScXIULH7+E0nhwQbXn/pIF9ZtyS3YB1AE/6NqSDHV23CfP34DahKS5TvV6eQuB1pj
         tfm+G34R6xznwmQOtgMZeDzZfCMKw+v0bF4D6hSgb6NrNBs07G1LPPGJsO0uQDCx0/l0
         6EGGr3VVZJ0mMvD+puvkTxRs3UVQWx5NhN/d7I3MJqIx3UV4rTuWx7TS28vbDuivVeLU
         LdQw==
X-Gm-Message-State: AOAM531G/B6RP6Um79RIB37O5VLpWJuacL2dzcmyJJ3TwW4gbyZ2COv3
        SE9/ZVuW8Xa3fKX77bN2xsOxAcsxXCwXVEtb
X-Google-Smtp-Source: ABdhPJx8h4WnAiOqM8Pvx0EEAqQXisPZ1UAwnTVTVA2hzfolnM2maUblrx0Rv4hYfVUemPx2s9T6qQ==
X-Received: by 2002:a17:902:b084:b029:12b:6caa:7d9e with SMTP id p4-20020a170902b084b029012b6caa7d9emr14788183plr.57.1627924343159;
        Mon, 02 Aug 2021 10:12:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pi14sm5269633pjb.38.2021.08.02.10.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 10:12:22 -0700 (PDT)
Message-ID: <61082776.1c69fb81.8bf5a.f695@mx.google.com>
Date:   Mon, 02 Aug 2021 10:12:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.7-104-g192e974dc8be
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 181 runs,
 7 regressions (v5.13.7-104-g192e974dc8be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 181 runs, 7 regressions (v5.13.7-104-g192e97=
4dc8be)

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

imx6ul-14x14-evk        | arm   | lab-nxp      | gcc-8    | multi_v7_defcon=
fig  | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.7-104-g192e974dc8be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.7-104-g192e974dc8be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      192e974dc8be6fc1c093047934e0fbb562bae36d =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig   | 2          =


  Details:     https://kernelci.org/test/plan/id/6107edd3d438e73943b13662

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6107edd3d438e73=
943b13666
        failing since 1 day (last pass: v5.13.7-34-g59fb97ea0e16, first fai=
l: v5.13.7-90-gc013d5cf65f6)
        13 lines

    2021-08-02T13:06:14.333724  kern  :alert : Register r0 information: non=
-paged memory
    2021-08-02T13:06:14.335247  kern  :alert : Register r1 information: NUL=
L pointer
    2021-08-02T13:06:14.336012  kern  :a<8>[   42.595205] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D13>
    2021-08-02T13:06:14.337098  lert : Register r2 information: non-paged m=
emory
    2021-08-02T13:06:14.337872  kern  :alert : Register r3 information: non=
-slab/vmalloc memory   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6107edd3d438e73=
943b13667
        failing since 1 day (last pass: v5.13.7-34-g59fb97ea0e16, first fai=
l: v5.13.7-90-gc013d5cf65f6)
        29 lines

    2021-08-02T13:06:14.341416  kern  :alert : Register r4 information: non=
-paged memory
    2021-08-02T13:06:14.342140  kern  :alert : Register r5 information: NUL=
L pointer
    2021-08-02T13:06:14.342796  kern  :alert : Register r6 information: non=
-slab/vmalloc memory
    2021-08-02T13:06:14.377522  kern  :alert : Register r7 information: non=
-paged memory
    2021-08-02T13:06:14.378876  kern  :alert : Register r8 information: no<=
8>[   42.638442] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D29>   =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6107f1451a7dfe93f2b1368e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107f1451a7dfe93f2b13=
68f
        new failure (last pass: v5.13.7-92-gf0aae5f0b8ef) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6107ef663834474fcdb136b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107ef663834474fcdb13=
6b2
        failing since 4 days (last pass: v5.13.5-224-g078d5e3a85db, first f=
ail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx6ul-14x14-evk        | arm   | lab-nxp      | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6107f7e872c3a3d323b13681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107f7e872c3a3d323b13=
682
        new failure (last pass: v5.13.7-92-gf0aae5f0b8ef) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6107f4328264fe41f5b1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107f4328264fe41f5b13=
66e
        failing since 6 days (last pass: v5.13.3-506-geae05e2c64ef, first f=
ail: v5.13.5-224-g6b468383e8ba) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6107f36734c7872127b13690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.7-1=
04-g192e974dc8be/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107f36734c7872127b13=
691
        failing since 3 days (last pass: v5.13.5-223-g3a7649e5ffb5, first f=
ail: v5.13.6-22-g42e97d352a41) =

 =20
