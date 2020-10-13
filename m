Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CBB28C89D
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 08:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389207AbgJMG1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 02:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388527AbgJMG1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 02:27:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569A5C0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 23:27:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p21so1516270pju.0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 23:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ofwYr3mV/ZpNfZtk9tXA8eO1ZHmgf6pyMAQb/t//bYc=;
        b=S2KAHYpeL9nOTUbigVYMOYoU7qCXPjX6MVXNw75bs7EjHgn45NCsQSuSq2FVChxCK7
         pijVPZacy6+eXbYPH1PlYRvo66l2qO9ZP/Nfw4pvByBViyhR3w3u08iwOt4k7AmEtLpB
         b6+IEbUlMzV34x1RjXMAWUQP0xKwUDSibtuNspEy9edICIdEnQbPg60NSxdAq9ahqtYj
         uTjIKwz8I0co7Dh5zxdfRJJN+MUTmUnPuGpk0uKwRMW9y5LIwHg6qlRVC6Lm0VMOQ5kR
         VT/KWFwUDc3MjPpYzqrUolQx2l6l3ClssfnIDHdzIFKhlWPhreIC66LJBmxtnD/UpmW2
         aCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ofwYr3mV/ZpNfZtk9tXA8eO1ZHmgf6pyMAQb/t//bYc=;
        b=LTteXJ70NNiyDGzSUK191JR/I7PZ/MxbTjWdyp8tsuJ73Bq3peP7tXD7Y7O2lXoGGr
         H7/HiqEu4+uv8hrrsQshDjGhh7spUnHEoE35lv60jzoQU4Dx2TbJUAVuw/+8SM9znANR
         Uz8h5PmpHQm7H/QUxnSBv5hWozOIuvRO8aTjcKUgQrK/SmxbOj3IFUf2S4OVsIk1JHh2
         BERJ8hCBirvAoxYaYsTjnMLjDJidx+7cOJ3vd49mm/nZqKb/iYMZlEqy+IeIZcS+1QD0
         N2oQ5SZ0AiTJ16UB2fsfIAfERhn88uFF+/m1nsp7ldItLZwJ/COPGH71dixJp/3bnE9t
         sk2A==
X-Gm-Message-State: AOAM533CzqYp45NspBvh62h65ASOG3Mpiya0PRjXDz04ihxOgkXjirse
        DzWYqpQFUgVo3ZpXIT8b9ihEO2fqolWioA==
X-Google-Smtp-Source: ABdhPJybrR7ZzxcWjkBDrnYWD4StYqjBDIWSxnYo5Oc7eCZXG0A7EMgUELFJ69fWOcq6FWBtYRRC0w==
X-Received: by 2002:a17:902:528:b029:d2:ad1a:f47c with SMTP id 37-20020a1709020528b02900d2ad1af47cmr27473419plf.25.1602570437309;
        Mon, 12 Oct 2020 23:27:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm18465406pjx.4.2020.10.12.23.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 23:27:16 -0700 (PDT)
Message-ID: <5f8548c4.1c69fb81.c566e.4f9c@mx.google.com>
Date:   Mon, 12 Oct 2020 23:27:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70-85-g71d398be4665
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 169 runs,
 4 regressions (v5.4.70-85-g71d398be4665)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 169 runs, 4 regressions (v5.4.70-85-g71d398be=
4665)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.70-85-g71d398be4665/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.70-85-g71d398be4665
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71d398be46654421becc8dd30d43be4129eed5df =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8502060b4e65d7e64ff3fc

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-85=
-g71d398be4665/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-85=
-g71d398be4665/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8502060b4e65d7=
e64ff400
      failing since 0 day (last pass: v5.4.70-46-geff08a1fdd2e, first fail:=
 v5.4.70-76-g7e5fbbf60f5e)
      3 lines

    2020-10-13 01:22:47.459000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-13 01:22:47.459000  (user:khilman) is already connected
    2020-10-13 01:23:03.026000  =00
    2020-10-13 01:23:03.026000  =

    2020-10-13 01:23:03.026000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-13 01:23:03.027000  =

    2020-10-13 01:23:03.027000  DRAM:  948 MiB
    2020-10-13 01:23:03.042000  RPI 3 Model B (0xa02082)
    2020-10-13 01:23:03.129000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-13 01:23:03.161000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (386 line(s) more)
      =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f8501f8bda65ceb444ff3ec

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-85=
-g71d398be4665/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-85=
-g71d398be4665/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f8501f8bda65ceb444ff400
      failing since 13 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-13 01:25:04.061000  <8>[   23.121794] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f8501f8bda65ceb444ff401
      failing since 13 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-13 01:25:05.084000  <8>[   24.143538] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f8501f8bda65ceb444ff402
      failing since 13 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)  =20
