Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0F35521C3
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 18:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbiFTQCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 12:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiFTQC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 12:02:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B6E1C128
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 09:02:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id hv24-20020a17090ae41800b001e33eebdb5dso12344234pjb.0
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 09:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0DckKtixgYxI4ulrvjbKl6iMmYtH6RYNv1fmbPLq6KE=;
        b=enm2ORY2W+3LJlM2G+RpaZu/k1vHOtvNC6I0xix4S0LBQwTSWrZqQxZgI82uheUlA5
         FJ7s2UjCGmo1ODFuNEVxKTuac4dgkzR5NXCgmxLvHXgRsxri7jxT/fMJwIXbjvYzJ73d
         obu1FK1daw26lwDlOk5XKRtvY7XXeLh7UbfqKL5oO4oBOaTRyb0oA1lKBUpNyY0+SPNr
         78lZMeVHyB9vqfRpFjDBsAZrpw46j7vGk8jN8bloyhuU7AnllqZ6Tb6qhn/8vfHuVId6
         RP9ux82dLTLmRecvbGv+HOWc5sQWUalaQExbpdpSu4cM3TwxUht0dlfL2xv7/9sY9PNU
         ShiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0DckKtixgYxI4ulrvjbKl6iMmYtH6RYNv1fmbPLq6KE=;
        b=Rld00Da/hChnhR1jlisIRB6UA/XJ+dxXYz+3rTcxDTkR6p3nbq2Ar0bvzii7T0/9tj
         YMrRgSJIkgele+RTqwXNBM4Khd72ZyFWJ0tVK4MKES4JGyeVg4CuRxiSKVoFMKGASJCU
         N3e75DMkVNvMnH/r9QUURnZbvllOdMnx89cQ/9U7cuhhXRVgoMCsgj6uIhazGq6pnSAG
         j62mMoNB2q2SpAoOAIRH9nxbvi9wcDBLEBbDAI3/Pv8Mjji4HtuLIdsDpxpF+8rA8mL0
         y3LzoC3BDvlWj/HKhWZB0JnsUrabA+7vZ4h6yf5rzqDcJFCKr7Vq+ENF5Aun5a622VbB
         Jc9Q==
X-Gm-Message-State: AJIora9cpYyQuWCl5aAAhMFVptDX3afa9iFeSkmq1WN01WtuFOt4vVRf
        RuV5aobUi64yEXW1Pn3vdC+RZ8a5udHkrGhJGQc=
X-Google-Smtp-Source: AGRyM1uqPXBu5ZF1p2z4q6+xHMtmsgxVkymPKBRMg0sHP7PPotfheFOZVSQ2XYLQgSKXDYGs4ClnLQ==
X-Received: by 2002:a17:90a:191a:b0:1dc:a3d3:f579 with SMTP id 26-20020a17090a191a00b001dca3d3f579mr39106837pjg.30.1655740948222;
        Mon, 20 Jun 2022 09:02:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m70-20020a633f49000000b00408b966228csm9413293pga.49.2022.06.20.09.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 09:02:28 -0700 (PDT)
Message-ID: <62b09a14.1c69fb81.2b726.d410@mx.google.com>
Date:   Mon, 20 Jun 2022 09:02:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.48-105-g5a76cfd990a6a
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 195 runs,
 7 regressions (v5.15.48-105-g5a76cfd990a6a)
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

stable-rc/queue/5.15 baseline: 195 runs, 7 regressions (v5.15.48-105-g5a76c=
fd990a6a)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =

meson-gxbb-p200   | arm64 | lab-baylibre  | gcc-10   | defconfig           =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.48-105-g5a76cfd990a6a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.48-105-g5a76cfd990a6a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a76cfd990a6a22b9b10690861cd91619dd41ce3 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0663ec2c5f7511aa39c00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0663ec2c5f7511aa39=
c01
        failing since 81 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06f53bdeeef8c07a39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06f53bdeeef8c07a39=
be3
        failing since 9 days (last pass: v5.15.45-667-g99a55c4a9ecc0, first=
 fail: v5.15.45-798-g69fa874c62551) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06d9b8b5932adb6a39bf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06d9b8b5932adb6a39=
bf6
        failing since 7 days (last pass: v5.15.45-833-g04983d84c84ee, first=
 fail: v5.15.45-880-g694575c32c9b2) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
meson-gxbb-p200   | arm64 | lab-baylibre  | gcc-10   | defconfig           =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06bdfd466d9e89ca39bee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06bdfd466d9e89ca39=
bef
        new failure (last pass: v5.15.48-44-gaa2f7b1f36db5) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06a8be6da4d8598a39c18

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62b06a8be6da4d8598a39c3a
        failing since 104 days (last pass: v5.15.26-42-gc89c0807b943, first=
 fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-20T12:39:28.961127  /lava-6651813/1/../bin/lava-test-case
    2022-06-20T12:39:28.971942  <8>[   33.566502] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62b093c0c1f2b85b61a39bea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b093c0c1f2b85b61a39=
beb
        failing since 12 days (last pass: v5.15.45-652-g938d073d082af, firs=
t fail: v5.15.45-667-g6f48aa0f6b54d) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0910c47e31858efa39d35

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g5a76cfd990a6a/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0910c47e31858efa39=
d36
        failing since 1 day (last pass: v5.15.45-915-gfe83bcae3c626, first =
fail: v5.15.48-44-gaa2f7b1f36db5) =

 =20
