Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1783F10DA
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 04:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbhHSC7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 22:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbhHSC7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 22:59:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B94C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 19:58:49 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y11so4135849pfl.13
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 19:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XXmPuzhqmxBJ6JSX4VUIBHROudCpkm+VrzRa8G7fLqw=;
        b=MbuX24cTdHL7zPM0rpPpitWBLbpI+mq/B3Z1IhBSBQZvdxL5s6Mw8wG3vkA/ZqCZuj
         U0Tz+Xa26bkF/klRq0n8ZDmTs/ZsxwF7EVJgWmLJFI4Nbv7cL6hP5ef+4hl4a4RykF3P
         5igvni/jSVe7ikQXyUNFqtYtVrY5ns4yJyq7IeW2OoZ84/yN1RHcR/SFSPwYfF2KVfuS
         aULJY3GdKz4nOHJG0fYLJoGE0EkLL5uO4B6guRJuzRle+e4mosPDcQAOE0pPqbvdnKrq
         6HNPBBAFSAknmS4buRrDHmOBW40KeR9dw8AGSrAWD7Ixpz0Dps9EIBCue9LPN73e6mjF
         VADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XXmPuzhqmxBJ6JSX4VUIBHROudCpkm+VrzRa8G7fLqw=;
        b=UKGFX3OH6YZG3QwGD7hmtnYDKayiXDPLlwLTCaiH/So+N4Jh6QTV1jE0OOtjsgviLU
         em31SalepNcZ+KP6u2qGLSYTuVFyx3xk/49b7awvjXsCF9Mj0DubpHcnOP3vzoPNRFHr
         4FSndQqAubEW2M5q6+ThRSuScj1UrY7oVr79yZlt4yRUBo41kN1J+dhAQNQ7jT+1K0W9
         M2vWryUCJw7nzMJT6+RLtJryGYvmh0yZBWuNamY23Hfdy6ZCJJbKsifgMdZbWPZ6Jliz
         YEVj0AMCnqSn6vNGP2aNHNPbk9zaBclwy9oizOIrO+ZK88/fKn91FnBE/7u0adVtY+kF
         2NWg==
X-Gm-Message-State: AOAM531HqOlCEPwlTIoX5vVedv0G3k2r4bPRQc4Qxbm6e+2Djnq1fSy1
        XTdixHiT3oOrdv1KkeSZ8GrHJwDNkpZjJClH
X-Google-Smtp-Source: ABdhPJyha5cBEDFEuGyFF8F1wNdx2m92Rv5M/y+St2c70p1LAXL0p/dF6YTFzzhuZaE2z89+8qUL0w==
X-Received: by 2002:a65:67c6:: with SMTP id b6mr11767812pgs.332.1629341928829;
        Wed, 18 Aug 2021 19:58:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z24sm6432116pjq.43.2021.08.18.19.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 19:58:48 -0700 (PDT)
Message-ID: <611dc8e8.1c69fb81.6b4a.37bd@mx.google.com>
Date:   Wed, 18 Aug 2021 19:58:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.60-6-gd64177941ad6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 149 runs,
 7 regressions (v5.10.60-6-gd64177941ad6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 149 runs, 7 regressions (v5.10.60-6-gd641779=
41ad6)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =

rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =

sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.60-6-gd64177941ad6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.60-6-gd64177941ad6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d64177941ad642601723cd7e8eaa7deeaef39ff7 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/611da3566effb1262ab13679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
6-gd64177941ad6/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
6-gd64177941ad6/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611da3566effb1262ab13=
67a
        failing since 48 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/611d9540201cb3d865b1366d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
6-gd64177941ad6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-va=
r-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
6-gd64177941ad6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-va=
r-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/611d9540201cb3d=
865b13671
        new failure (last pass: v5.10.59-96-g07687e3e26bf)
        4 lines

    2021-08-18T23:18:01.955375  kern  :alert : 8<--- cut here ---
    2021-08-18T23:18:01.986625  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 752f7389
    2021-08-18T23:18:01.986888  kern  :alert : pgd =3D (ptrval)
    2021-08-18T23:18:01.987882  kern  :a<8>[   47.966100] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2021-08-18T23:18:01.988148  lert : [752f7389] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/611d9540201cb3d=
865b13672
        new failure (last pass: v5.10.59-96-g07687e3e26bf)
        60 lines

    2021-08-18T23:18:02.045376  kern  :emerg : Internal error: Oops: 5 [#1]=
 SMP ARM
    2021-08-18T23:18:02.045901  kern  :emerg : Process udevd (pid: 126, sta=
ck limit =3D 0x(ptrval))
    2021-08-18T23:18:02.046143  kern  :emerg : Stack: (0xc39bbbf8 to 0xc39b=
c000)
    2021-08-18T23:18:02.046394  kern  :emerg : bbe0:                       =
                                c3afddb0 c3afddb4
    2021-08-18T23:18:02.046633  kern  :emerg : bc00: c3afdc00 c3afdc14 c144=
ab50 c09c6d8c c39ba000 ef86d3e0 8020001a c3afdc00
    2021-08-18T23:18:02.047116  kern  :emerg : bc20: 752f7369 122e8fd8 c19c=
7874 c2001d80 c3aa0a80 ef86d400 c09d44e4 c144ab50
    2021-08-18T23:18:02.088396  kern  :emerg : bc40: c19c7858 122e8fd8 c19c=
7874 c3a9fbc0 c3a9ab00 c3afdc00 c3afdc14 c144ab50
    2021-08-18T23:18:02.088931  kern  :emerg : bc60: c19c7858 0000000c c19c=
7874 c09d44b4 c1448878 00000000 c3afdc0c c3afdc00
    2021-08-18T23:18:02.089188  kern  :emerg : bc80: fffffdfb c2298c10 c3ad=
fc00 c09aa3d4 c3afdc00 bf048000 fffffdfb bf044138
    2021-08-18T23:18:02.089444  kern  :emerg : bca0: c3a9f1c0 c30b9b08 0000=
0120 c30884c0 c3adfc00 c0a04030 c3a9f1c0 c3a9f1c0 =

    ... (34 line(s) more)  =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/611da266ccb7cf403cb13662

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
6-gd64177941ad6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
6-gd64177941ad6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611da266ccb7cf403cb1367a
        failing since 64 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T00:14:24.235088  /lava-4381159/1/../bin/lava-test-case<8>[  =
 13.212784] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-19T00:14:24.235453  =

    2021-08-19T00:14:24.235707  /lava-4381159/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611da266ccb7cf403cb13692
        failing since 64 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T00:14:22.791003  /lava-4381159/1/../bin/lava-test-case
    2021-08-19T00:14:22.808809  <8>[   11.786331] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611da266ccb7cf403cb13693
        failing since 64 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T00:14:21.778190  /lava-4381159/1/../bin/lava-test-case<8>[  =
 10.766872] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-19T00:14:21.778662     =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/611d9544201cb3d865b1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
6-gd64177941ad6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
6-gd64177941ad6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d9544201cb3d865b13=
67c
        failing since 2 days (last pass: v5.10.59-96-ge4ba0182192d, first f=
ail: v5.10.59-96-g07687e3e26bf) =

 =20
