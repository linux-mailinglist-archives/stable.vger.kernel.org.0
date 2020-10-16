Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3F629095A
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 18:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409245AbgJPQJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 12:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409107AbgJPQJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 12:09:03 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFCFC061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 09:09:03 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id j18so1779086pfa.0
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 09:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RzPVIxQfHpkrumEqbxoPa8xmovsgo+vdYVaI4UAUofQ=;
        b=IH9WKGLk8aDRqB6DRloC5bEPdMbfwLKRLCesHYYXVJd35JNLz+/teEIEqKZVHfPARi
         4R/HsbuBnengjLYhJDI7wL3q8M3fK6iUeIUI4XV3m2yJVJmottlDeLnPVpOqzXLXmtkS
         UOms9+1vqF2+RKDHcyArXBlKuLuJQtBmR3SdcDnTJVOtF8rNJw/hl6rbB2arESM8CNnt
         1y7PAOpi56gbKFpdl6FIEIYlRYEeFLkTKWBM6gPDVLb+uzXb4SpQjx9h9bi0jrv6DgI8
         kU8C6Hl6ugTQXAMGhuSCv5QbwMvqNcFLU0NZ0fCkbil4RkeVyoTOCeVU2sRm57kDH2tp
         z4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RzPVIxQfHpkrumEqbxoPa8xmovsgo+vdYVaI4UAUofQ=;
        b=O/7rS5KplS0xTqWTydyzqdCQZm+wtSPaQtsI40JrfSnV1eNaiIjuE8XjsgL1uGBtJh
         ifGbx3WDNyU3MkA4lMGoY/tdT4WEjVn/Iu5RgLp1BsFL/mTIZuKJt9n5XLESzY19vSzC
         nGISUYiUZfFnZJQ3xOr/1uAeRXjUuZv8aY+txA2RnFkel7kp10URpAWO0vPYL6P9JmlC
         BpAToCP53lsaa4l5IStzSCLGTbeQiNp9W6/cIjwouiyQaYppw26UedXaPQTHZHiTb8Yg
         oglWW0mcZgRmvw+T4mwjGFuDDXlDogmcgDLT5y0CVip55EcvN/SU6W2z6s4ZMbnDA3Sv
         NTSQ==
X-Gm-Message-State: AOAM530B6Emtq5sjiwzz+Lv1VW7IKIbTBkX3PYzy8UNIDfRSEGW38vXf
        tRtX3+Sb+BDFLsrZeIPalGtYb7t7F9q0KQ==
X-Google-Smtp-Source: ABdhPJwGDlouJK5ack63fcPLQKHS/K9D95V68pMuKLdZuOE6g45tauGUS3mar1KGQTRWtyCIwvtiiw==
X-Received: by 2002:a63:f741:: with SMTP id f1mr3587008pgk.38.1602864542067;
        Fri, 16 Oct 2020 09:09:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m3sm3199980pfk.23.2020.10.16.09.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:09:01 -0700 (PDT)
Message-ID: <5f89c59d.1c69fb81.721e5.667e@mx.google.com>
Date:   Fri, 16 Oct 2020 09:09:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.71-23-ga3f8c7f24ee0
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 191 runs,
 5 regressions (v5.4.71-23-ga3f8c7f24ee0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 191 runs, 5 regressions (v5.4.71-23-ga3f8c7=
f24ee0)

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
el/v5.4.71-23-ga3f8c7f24ee0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.71-23-ga3f8c7f24ee0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3f8c7f24ee00462a09758774aee840317650b51 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f898b3ab57b38a76d4ff3e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.71-=
23-ga3f8c7f24ee0/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.71-=
23-ga3f8c7f24ee0/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f898b3ab57b38a76d4ff=
3e8
      failing since 187 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
| 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f898b3e93d9bfd70d4ff3f6

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.71-=
23-ga3f8c7f24ee0/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.71-=
23-ga3f8c7f24ee0/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f898b3e93d9bfd7=
0d4ff3fa
      new failure (last pass: v5.4.71)
      2 lines

    2020-10-16 11:57:50.591000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-16 11:57:50.591000  (user:khilman) is already connected
    2020-10-16 11:58:06.063000  =00
    2020-10-16 11:58:06.064000  =

    2020-10-16 11:58:06.064000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-16 11:58:06.064000  =

    2020-10-16 11:58:06.064000  DRAM:  948 MiB
    2020-10-16 11:58:06.080000  RPI 3 Model B (0xa02082)
    2020-10-16 11:58:06.167000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-16 11:58:06.199000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (380 line(s) more)
      =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f898b0cef706fc4404ff405

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.71-=
23-ga3f8c7f24ee0/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.71-=
23-ga3f8c7f24ee0/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f898b0cef706fc4404ff419
      failing since 16 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)

    2020-10-16 11:59:00.148000  /lava-2727120/1/../bin/lava-test-case
    2020-10-16 11:59:00.149000  <8>[   23.371706] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f898b0cef706fc4404ff41a
      failing since 16 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)

    2020-10-16 11:59:01.056000  <8>[   24.393172] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f898b0cef706fc4404ff41b
      failing since 16 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)  =20
