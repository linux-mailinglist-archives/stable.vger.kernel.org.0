Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E5F294BF3
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 13:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439619AbgJULsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 07:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439572AbgJULsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 07:48:14 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3BFC0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 04:48:14 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id kk5so1024383pjb.1
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 04:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ctk3NHe8VhEpsT0vF0WgMo17kNdm9GLGcws4yZRDIJY=;
        b=n9zQAdq+KlWiNedH6FQGyQY7MTLupFYPGsq/UAVhy4iJ9o4cQVU3zpyH6a2DJU5zS7
         8ixfasQEWi+9OHEZS/2AXDPJEU4AmIau7ARJmMlBOwZNR/NhmtX7hS+v5kR6cXj/KHlL
         nTK3hBVFewqU1pvL5wClmfyPj2ju/+rhfhW/qvLkzm3tqHR7xXHA3lTqmlzmCVVmx0B9
         ys62yUiXgKHqWTokQBtbOWIYeSaEL2uncDKLZllpBl811gUZ6p507xqPvhAj7jymBkEv
         ZLmSTRgKDVIty7NIjpDYXoEzn+Ukd5S1YwKrlazuTTPCOqKXHKyPSqCagmLV0bPFhe6x
         un4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ctk3NHe8VhEpsT0vF0WgMo17kNdm9GLGcws4yZRDIJY=;
        b=a7e4ub9/EY4DnbolAlw4GPWpHwhWmfzikYz+xafZ08HwWppnmC5xexT8mmWQdUPA/O
         umwg8t7CmA6b87m5mdZZnL83sImqxbVND+G7/eku40pMDNUrHiF+Mpq4Tjy/Cwc6c/tw
         qmWATlVtBNUKICCSxCW9o4cWSvhLqmG1qfmWvdkoTB790mvujFlc+6LlfSUf9kgW9OMg
         l/Xc6DuLDGSe84QywiFk0Gv3Wzi8qoDfveObi1DTT1rlWn79jW8qdjFjsGVT4FpO11VP
         tzHV+eCicDD8WLAeA73DgVHeZQwyB/5G9TY8isNeF6gpk8OdkDp+S/MOZEO4o0KF76mT
         oPGQ==
X-Gm-Message-State: AOAM530buv01eRG897NK29E2Df7ZBHJdA+8eOB845j/A3ANVq1tOCt+V
        TBdN4utKOY4X1oXoLkpiF8vrL7Q202/snQ==
X-Google-Smtp-Source: ABdhPJxdxSm7N6ierdQSJ6PFn5MTSyNVBtDHHKdaedMFqD2B9LHH+YeBF4NcNeLg2YKrSZ+N3pNuLQ==
X-Received: by 2002:a17:90a:e00c:: with SMTP id u12mr3083849pjy.185.1603280893392;
        Wed, 21 Oct 2020 04:48:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e5sm2431150pjd.0.2020.10.21.04.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 04:48:12 -0700 (PDT)
Message-ID: <5f901ffc.1c69fb81.130f1.5ab2@mx.google.com>
Date:   Wed, 21 Oct 2020 04:48:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.72-23-g515f94ebfac5
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 150 runs,
 4 regressions (v5.4.72-23-g515f94ebfac5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 150 runs, 4 regressions (v5.4.72-23-g515f94eb=
fac5)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-23-g515f94ebfac5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-23-g515f94ebfac5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      515f94ebfac5d10556c9161a30b423a7e6882e2c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8feb003ed60d5c4b4ff3f5

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-23=
-g515f94ebfac5/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-23=
-g515f94ebfac5/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8feb003ed60d5c=
4b4ff3f9
      new failure (last pass: v5.4.72-23-g71c30c5eec09)
      1 lines

    2020-10-21 08:00:09.379000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-21 08:00:09.379000  (user:khilman) is already connected
    2020-10-21 08:00:25.245000  =00
    2020-10-21 08:00:25.246000  =

    2020-10-21 08:00:25.267000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-21 08:00:25.267000  =

    2020-10-21 08:00:25.268000  DRAM:  948 MiB
    2020-10-21 08:00:25.283000  RPI 3 Model B (0xa02082)
    2020-10-21 08:00:25.369000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-21 08:00:25.401000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (375 line(s) more)
      =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f8feb6203d13ea5c14ff401

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-23=
-g515f94ebfac5/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-23=
-g515f94ebfac5/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f8feb6203d13ea5c14ff415
      failing since 21 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-21 08:03:37.710000  /lava-2737222/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f8feb6203d13ea5c14ff416
      failing since 21 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-21 08:03:38.731000  /lava-2737222/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f8feb6203d13ea5c14ff417
      failing since 21 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-21 08:03:39.753000  /lava-2737222/1/../bin/lava-test-case
    2020-10-21 08:03:39.762000  <8>[   25.033220] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
