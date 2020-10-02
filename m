Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BD9280CA7
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 06:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgJBEYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 00:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJBEYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Oct 2020 00:24:16 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C38C0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 21:24:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gm14so99570pjb.2
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 21:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4hIApfUbQePhParnomY00NhHzm9xJHxG+Fbenqq2Dkg=;
        b=iw+rWXR0B11iDAtd3khL8yiW0ybAe0nu0KaAP6+d+VZgI2NiwuVbJsCZH5ITrPWMPC
         tP/hEcf0KOoDhlRfwJIBCnHErTg2Ke/8SspdnNQss8VQAYvRPtRq0afxpoysP2oU10if
         EtdFuRaUn0BzxVGrvf7cza1Dy3mhqiSu7Tr/BvtuuQ+EdYpTgtpjiu2k0z2LkcNbdf+M
         6jZl4OJqabHOOqAnQ1Gd7VQ79VdZoPjFtYOLt8nMX0XrdIzUA5QmWG+06C62N58tSU6y
         MiMAa/nHH6ndU7iLFNG12zgDfKv8Y9pbnc8yt1JtZ8rG5hJAE98GucX1p3x82cppM6z3
         I13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4hIApfUbQePhParnomY00NhHzm9xJHxG+Fbenqq2Dkg=;
        b=DTbr06T+lbqb1c1njMbymxR4Ilv19t0yV16pPkTIowmZKtyAtTGTUmxikjzFnZh9iL
         NySZD8uXDRt2HP6TL7ln29wZSHYrmxDC4WYtjp3q2Aj6p655A3e2u0M7ippMcoM/E1kE
         I/eULYrMVgDWszwhjliareDo3QD3nAziixOtd7Cklni+ZQYIH/h6z++kQSWCSP4nhDUL
         BNlfH2tMHW1B9htnj+7AEGkLzhet/ZlgLpbs+UnONAFOYXbzUj54usj99/hB+Gi8RlgO
         BqTBTGk2pWXDwQjMwkkyrCXl1Hi9NAl0ko++x/SnlOmmnswNIHZZqEXUZBz8pa1kN9oE
         4S7A==
X-Gm-Message-State: AOAM532Xmcxgt6K0lg7Hw04giO9afciDFK8Y+z1VemQ/rrpmytFk2H+f
        hcaDebl6KWv2+lgPMlFa6UvXWNWIaG7t6Q==
X-Google-Smtp-Source: ABdhPJwXFw9/O8odnHhM8rWodjUc0VOmZYQXLKFCHw+MchaqFpw5q9oeoWNjkv9rhvy7h92Jvgm5Kg==
X-Received: by 2002:a17:90a:7f8c:: with SMTP id m12mr767680pjl.22.1601612653866;
        Thu, 01 Oct 2020 21:24:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l12sm221117pgs.1.2020.10.01.21.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 21:24:13 -0700 (PDT)
Message-ID: <5f76ab6d.1c69fb81.3f69c.0a52@mx.google.com>
Date:   Thu, 01 Oct 2020 21:24:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 151 runs, 5 regressions (v5.4.69)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 151 runs, 5 regressions (v5.4.69)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
| 3/4    =

rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.69/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a9518c1aec5b6a8e1a04bbd54e6ba9725ef0db4c =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f767873a6d56c882b877186

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.69/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.69/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f767873a6d56c882b877=
187
      failing since 173 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
| 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f76752f0babec641087718a

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.69/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.69/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f76752f0babec64=
1087718e
      new failure (last pass: v5.4.68-389-g256bdd45e196)
      1 lines

    2020-10-02 00:30:48.109000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-02 00:30:48.110000  (user:khilman) is already connected
    2020-10-02 00:31:03.590000  =00
    2020-10-02 00:31:03.590000  =

    2020-10-02 00:31:03.590000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-02 00:31:03.590000  =

    2020-10-02 00:31:03.606000  DRAM:  948 MiB
    2020-10-02 00:31:03.622000  RPI 3 Model B (0xa02082)
    2020-10-02 00:31:03.710000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-02 00:31:03.741000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (376 line(s) more)
      =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f76756bda307f467d87716c

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.69/=
arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.69/=
arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f76756bda307f467d877180
      failing since 2 days (last pass: v5.4.68-388-g8a579883a490, first fai=
l: v5.4.68-389-g256bdd45e196)

    2020-10-02 00:33:38.645000  /lava-2679008/1/../bin/lava-test-case
    2020-10-02 00:33:38.655000  <8>[   22.971685] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f76756bda307f467d877181
      failing since 2 days (last pass: v5.4.68-388-g8a579883a490, first fai=
l: v5.4.68-389-g256bdd45e196)

    2020-10-02 00:33:39.677000  <8>[   23.993359] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f76756bda307f467d877182
      failing since 2 days (last pass: v5.4.68-388-g8a579883a490, first fai=
l: v5.4.68-389-g256bdd45e196)

    2020-10-02 00:33:40.699000  <8>[   25.015024] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
