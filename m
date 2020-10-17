Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27C02911E0
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 14:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437961AbgJQMin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 08:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437960AbgJQMin (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 08:38:43 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3981C061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 05:38:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gv6so2978185pjb.4
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 05:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kRKR2T9AumttcgSyDeyh4w2zMzgSuYpcffu+h3dxwkw=;
        b=cyLebI8tDXZqzzX+Q6Ioa1Xa+hX/o9dRoGz9hV0syz+syomaPtdLRGhMMNmRnTIHKs
         85LMdL+5RSvxzUyJxlg9DX23nCeQlp6fUJ2yTiDk1FNuF7Y7YreRRwhQ8kBpVTq66w8a
         6F3Agw13phVtyhIs0QWVv/7paULig0x8X0Wi43R8RTj7j+pDIw4WCKUy4g3P+fpjW8U5
         12hrXsUpzMVDvRQ3PIMpvdoMqIJoMoG5qRFud0uhICLPCdJk6WchllcSK9GyFREQOiK5
         LocPUKOLNCUyzAjGHAfneREsPINLWA37+pKOCCFl6FkjlWKRNVQt4E4Z4j+I0pamVcH3
         5uOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kRKR2T9AumttcgSyDeyh4w2zMzgSuYpcffu+h3dxwkw=;
        b=j+vtaVc14vqyrzW1ZTkMjJIJAGUceBUmqkVVRh73EhTM8MWUkIMJhmdH9LJepAo7VU
         Deuxmo/KWRyHfdfUXjLXgsRmbIhOtnOy7PDyVFb0Gjl9yPNXDZOYInPcvz1yDsSzpafD
         hBL01RkAm9mi8lyWKRwOVd6ZH0kjAxD0v4WA66Liy8HZYeDys1vwza3PmCsZjveuGqht
         X0ilxaNhQmLkVIFldCoLsu87EYA9GxEBmeIZJ2H/hFYja+4Ok47aQZUNYidQke+y3SO0
         ccboLK6gRakT689IXG3g2e432RpWeiEqCGXWwW91UxEW22gVCGoTzZAnmQ8Kp4blB91i
         BaOQ==
X-Gm-Message-State: AOAM531j9LfNEWq9QK/CLBDsPjmgLMS5SoZvj2gotlBoz6Vxp+azj5u6
        NozHmhPVyPCgjKOCK7Ptz81fAx1AiMszVQ==
X-Google-Smtp-Source: ABdhPJwimpkoH41PX8wDN2pHWds0FaMc3XUdrsGFZhT+ahJAaVYY8Bm3YlSnhuCNDeuTHeHyxh7log==
X-Received: by 2002:a17:902:b595:b029:d4:db82:4403 with SMTP id a21-20020a170902b595b02900d4db824403mr8807625pls.49.1602938319991;
        Sat, 17 Oct 2020 05:38:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a9sm6166953pjm.40.2020.10.17.05.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 05:38:39 -0700 (PDT)
Message-ID: <5f8ae5cf.1c69fb81.5fcc5.ce93@mx.google.com>
Date:   Sat, 17 Oct 2020 05:38:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.71-22-g6d23415dabee
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 198 runs,
 4 regressions (v5.4.71-22-g6d23415dabee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 198 runs, 4 regressions (v5.4.71-22-g6d23415d=
abee)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.71-22-g6d23415dabee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.71-22-g6d23415dabee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d23415dabee49f7a7fde0abd8346d1c9c2b6038 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8aa401296b44d5994ff408

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.71-22=
-g6d23415dabee/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.71-22=
-g6d23415dabee/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8aa401296b44d5=
994ff40c
      failing since 0 day (last pass: v5.4.71-5-gb8377737c2ee, first fail: =
v5.4.71-22-gbe1190d55f11)
      3 lines

    2020-10-17 07:55:09.738000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-17 07:55:09.739000  (user:khilman) is already connected
    2020-10-17 07:55:25.451000  =00
    2020-10-17 07:55:25.451000  =

    2020-10-17 07:55:25.451000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-17 07:55:25.451000  =

    2020-10-17 07:55:25.452000  DRAM:  948 MiB
    2020-10-17 07:55:25.468000  RPI 3 Model B (0xa02082)
    2020-10-17 07:55:25.554000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-17 07:55:25.585000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (386 line(s) more)
      =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f8aa3b1a4bd7325d84ff3fb

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.71-22=
-g6d23415dabee/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.71-22=
-g6d23415dabee/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f8aa3b1a4bd7325d84ff40f
      failing since 17 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-17 07:56:23.941000  /lava-2728912/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f8aa3b1a4bd7325d84ff410
      failing since 17 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-17 07:56:24.973000  /lava-2728912/1/../bin/lava-test-case<8>[  =
 23.888582] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dcros-ec-sensors-accel1-pro=
bed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f8aa3b1a4bd7325d84ff411
      failing since 17 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-17 07:56:25.986000  /lava-2728912/1/../bin/lava-test-case
    2020-10-17 07:56:25.995000  <8>[   24.910513] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
