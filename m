Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A354F53D781
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 17:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236865AbiFDPfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 11:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbiFDPfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 11:35:50 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD7EDF07
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 08:35:49 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v5-20020a17090a7c0500b001df84fa82f8so9248501pjf.5
        for <stable@vger.kernel.org>; Sat, 04 Jun 2022 08:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PYNljZeZBmlic67fx2P9u1n/xvON6e/mqimN6CzgXpQ=;
        b=Z0eqt5oAFRX9QHLHCNc8vZ7vrztV3r1jKO/nCRNkOFL8CaqhCnvQjVAWYANgCgd1Cz
         81ZFhab+wlusMe4QvvzVMGq3fImKqEMgjG2R8kaWlkOtui/tw7fek3A595cLgaYEUiXR
         Clu19QKPGp0okK7J8kdatnoEor4rHybm02MuLTx9mm227l4tSNk0x7M1cHqIa895JGUW
         3r5mJzP7GHcjxAm1rkjYFjsiAY+PKRqSaIyjYvsRCv7XI8Zwof9gNl+eYMAbOpoaKepK
         cF2SPI3UCuSX3zUCmX+Ovi1PTyyF5wMpo/5t9pSoK6p+bq3OBdTp9TedpdF4BwS41rCe
         stDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PYNljZeZBmlic67fx2P9u1n/xvON6e/mqimN6CzgXpQ=;
        b=u8M++tqv+zcdHECP6IZ3zOEKRgPUR4WtyLK2qU6QvA0CLdFHxUvTA5aD+VvBIi9cVP
         oSErwobRrbIxuy9xwMub5OMqDgDSxgO5pYYeJw4Rp2hptorG9IDtBO1OZcZZbB5Z7/x9
         Unx3rI/q0DDLFROpU0Iw3j3M7eDzdzgn2PMuSuw93Q7mScjN3gEFrYTCa+gc/vpzXYez
         dq04Y8gXlA8N4kNVrOqg5WKbLutQ0PwQ3NNdesWXy3BjwQ0yrwrK0vdebXn+/3KDAXnF
         JTyeAR0b5mXFJgkycLjWJPIPPse7Oteod+bPWqZvXS3cI6TG8Zjev3SRTAraRjYE7h+g
         uSPw==
X-Gm-Message-State: AOAM533sztFXWynCOgjpzAWIamBmHKVqanNygShKrY55vvov7QUWSXW0
        dTPbQIa1Wb2nfi5qhoGpuzUFhEhzCXMPku1j
X-Google-Smtp-Source: ABdhPJyM8KQcdZy+yXszRSJzP62utwtNNNNq+k2eSflo1Gl+IJRigTZbwQRy3uNRQtuheTjzd76KEA==
X-Received: by 2002:a17:902:8698:b0:158:99d4:6256 with SMTP id g24-20020a170902869800b0015899d46256mr15548348plo.104.1654356948877;
        Sat, 04 Jun 2022 08:35:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s21-20020a056a00195500b00517d5e42297sm6044829pfk.95.2022.06.04.08.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 08:35:48 -0700 (PDT)
Message-ID: <629b7bd4.1c69fb81.c96ff.c810@mx.google.com>
Date:   Sat, 04 Jun 2022 08:35:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43-211-g6191b29f716d7
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 125 runs,
 5 regressions (v5.15.43-211-g6191b29f716d7)
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

stable-rc/queue/5.15 baseline: 125 runs, 5 regressions (v5.15.43-211-g6191b=
29f716d7)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.43-211-g6191b29f716d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.43-211-g6191b29f716d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6191b29f716d779b8ee072bc3dd2a7126ed511bf =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/629b466d07f7a5dc66a39c31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
211-g6191b29f716d7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
211-g6191b29f716d7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629b466d07f7a5dc66a39=
c32
        failing since 11 days (last pass: v5.15.40-98-g6e388a6f5046, first =
fail: v5.15.41-132-gede7034a09d1) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/629b42bfc905a4dd6fa39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
211-g6191b29f716d7/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
211-g6191b29f716d7/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629b42bfc905a4dd6fa39=
bd5
        failing since 11 days (last pass: v5.15.40-98-g6e388a6f5046, first =
fail: v5.15.41-132-gede7034a09d1) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629b48881a9aac523fa39c0a

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
211-g6191b29f716d7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
211-g6191b29f716d7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/629b48881a9aac523fa39c2c
        failing since 88 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-04T11:56:40.822529  /lava-6539974/1/../bin/lava-test-case
    2022-06-04T11:56:40.834295  <8>[   60.856252] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/629b623423bb76ae1ba39bf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
211-g6191b29f716d7/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
211-g6191b29f716d7/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629b623423bb76ae1ba39=
bf9
        failing since 7 days (last pass: v5.15.43-3-ga16def6cd632, first fa=
il: v5.15.43-144-g375b1504fe930) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/629b503622417d89e8a39bf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
211-g6191b29f716d7/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
211-g6191b29f716d7/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629b503622417d89e8a39=
bf6
        failing since 11 days (last pass: v5.15.40-102-g526a14d366391, firs=
t fail: v5.15.41-132-gede7034a09d1) =

 =20
