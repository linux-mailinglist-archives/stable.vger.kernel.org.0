Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700A728C3BA
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 23:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731967AbgJLVDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 17:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731960AbgJLVDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 17:03:01 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CE3C0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 14:03:01 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w21so6588606plq.3
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 14:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5Aqgss+LAk1YYUBKpfZl7bI4/QBYQzZ88GnSck8f6GE=;
        b=0HyyaKJBolul3st+ltX9Ka9R9tvY8BCc52rE+qQq1r6YWvwvHG71rGqq99DFzLIMbZ
         4+ivbK+DUuzwjdvrf7lJbaBFYdOVkwmShgCbykBlTGzpnFwU96SPVCeJWz0N5JYrUI50
         5jM/RtkjbYbYOIdPJ3qkxl5L7d7ALA1HKkcZq4V8G56cqX308Gyr3//RFnPdpaoZwCcc
         Jq/hlOd+Z4m7CB+Vzo8S2b0ilgATYuIdZ0SwnE9Catp8mjM1KcxbOQT/l8MguKkIUt9X
         szH7jQfki1jhO97Rs/5DrtmhnimQs1qmIDAAWX0RWbBANckZrZDOjP7qEhYi1Qupnes4
         7TXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5Aqgss+LAk1YYUBKpfZl7bI4/QBYQzZ88GnSck8f6GE=;
        b=iyu8V07e1Ae//KxRaWrED2gYU4aIupY8oh/NzSvvDNQ1u7OL3o5RHtZTZ4fVywFAUz
         eSS3X0TKF7vpJFYw2SJQDIWptPmr4CkDFrvEFDCTCzErqVd0cM2zJAjJomacoe9XQAUn
         N8xjXAwfb/w+IlcWI7dBriEZA+g2QeAyg9N3cFZN1PMlZP49hzmEKPZ/preU+R5V9N7A
         zOX0VyRzd7QRP2vlycmjBA/7ZXhWLkxSMeI2BV2AEkiseyD2ocPVj5uIlsqgIdXK+Dyu
         28GbOsMgJBIxbm00gsX3Xb7MqCOaxXHLF9j3JktQWXiXhThMictKxBgvsGdKRo7i2AFZ
         Ddhg==
X-Gm-Message-State: AOAM532fZbPmHXLGOH7avDZNsp3aC96VGGcRKIgiHekF/KMY2vWTV4Nx
        eLrMSy6NL3e9GJwjpytqAsg86PUrt0rlFA==
X-Google-Smtp-Source: ABdhPJy7qh5z2Ly47Jrbndcb1+cH3x7Qef+pTtb7WmJwgKeP+7sNh56cMpHaZAfoOEjWr+BEQOh/5Q==
X-Received: by 2002:a17:902:bc8a:b029:d4:dc57:6c29 with SMTP id bb10-20020a170902bc8ab02900d4dc576c29mr6548906plb.77.1602536580517;
        Mon, 12 Oct 2020 14:03:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2sm25629896pjk.12.2020.10.12.14.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 14:02:59 -0700 (PDT)
Message-ID: <5f84c483.1c69fb81.84ba0.1a14@mx.google.com>
Date:   Mon, 12 Oct 2020 14:02:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70-86-g228d88e992eb
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 130 runs,
 5 regressions (v5.4.70-86-g228d88e992eb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 130 runs, 5 regressions (v5.4.70-86-g228d88=
e992eb)

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
el/v5.4.70-86-g228d88e992eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.70-86-g228d88e992eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      228d88e992eb144f13037001b6b6d0289b9b2f00 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f848291f02c008b074ff3ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
86-g228d88e992eb/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
86-g228d88e992eb/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f848291f02c008b074ff=
3eb
      failing since 183 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
| 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f846871d8fe145c814ff3f1

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
86-g228d88e992eb/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
86-g228d88e992eb/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f846871d8fe145c=
814ff3f5
      new failure (last pass: v5.4.70-38-g55678c4c1bef)
      2 lines

    2020-10-12 14:27:56.775000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-12 14:27:56.775000  (user:khilman) is already connected
    2020-10-12 14:28:12.519000  =00
    2020-10-12 14:28:12.519000  =

    2020-10-12 14:28:12.519000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-12 14:28:12.520000  =

    2020-10-12 14:28:12.520000  DRAM:  948 MiB
    2020-10-12 14:28:12.534000  RPI 3 Model B (0xa02082)
    2020-10-12 14:28:12.622000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-12 14:28:12.654000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (382 line(s) more)
      =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f84682e0e01189dd34ff3ec

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
86-g228d88e992eb/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
86-g228d88e992eb/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f84682e0e01189dd34ff400
      failing since 13 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)

    2020-10-12 14:28:53.796000  <8>[   23.203901] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f84682e0e01189dd34ff401
      failing since 13 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196) * baseline.bootrr.cros-ec-sensors-gyro0-prob=
ed: https://kernelci.org/test/case/id/5f84682e0e01189dd34ff402
      failing since 13 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)

    2020-10-12 14:28:55.830000  /lava-2715347/1/../bin/lava-test-case
    2020-10-12 14:28:55.839000  <8>[   25.247346] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
