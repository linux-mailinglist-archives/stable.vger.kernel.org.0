Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771E528EBC1
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 05:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgJOD5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 23:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbgJOD5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 23:57:05 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55100C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 20:57:05 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id g29so1038210pgl.2
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 20:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z0a//Lt/4OZ/uUODi4uxMp5ySE5Yp0O/Jsa6ORyC590=;
        b=SpaxB3PsRE34mJFypnRZDc9NKz8ajdtNzkmZ6m13majmuY6VEVzMLq3drq904ff+EI
         5ccuhLf/zDlNVKZxYcppIWDRmdx+wndb7RlGfViFOwoAu7yZnlPQNEGb92pOy9nxIOD1
         nj1M4o3kRyLseytlrK8tCDGPUabNa4S+GwJmP7rzROtEY8Wfx9Ov2WJoLZlJdHXKjvq4
         x3xw72ohPZoWlawDvBHW/NAEHrB8Bfc9OHUsXpfIsiQuKz/PLo288nJkledotMRv4SGW
         8xokNt/QCdaa8JZFFDxuGHsGqPQxnadyzmV0jF5ogcV5m+mAcgRk5hdhlHB0wG6+d9oy
         O9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z0a//Lt/4OZ/uUODi4uxMp5ySE5Yp0O/Jsa6ORyC590=;
        b=PLm9Zu4+ZfBK8HXkg3Wu9zdW3hZvub8+YFFaYEXgnTXz8KTyOd2bh2Vv5Ouib+D8bQ
         CHyHVjpvnsPinFRC8FASuJxkVBzw7WYEpSFrd0b/hqcVIKOGOayUgj/WKaF2ZSS1DyJr
         ZnVHG4ta8oiNJ5EMozQPR74ZP8tVHKm7hcDrn+9qLq+QTh3m54R+S/kkE9L2/u3uZahB
         n65PE+TXrZrSnozAEgj82kmSN//LgNzEFSIAn/5PS48aDNinY/76eQxQoFygzwPXYI3v
         fwEWgRIT9w2EtK8xh7rYtEs2AnJg7B+OfwnH3cALcmUFIoImJGqmoYdwV+OfBBHzf+Wx
         jsJg==
X-Gm-Message-State: AOAM531HoEapWgZSWejWcoNdHV/s4ZAFr9/YDeP2qubDAjfikGRhvY1T
        vtk3k29KddDBELuo8Q6ZM6BZ2OLHGHYxVw==
X-Google-Smtp-Source: ABdhPJzaz+6abLH9SROKi32VzbqEtpv/6M0V02D6mMzs9oT72XhtSdP6jgjmS3SZwbKE97CmOuS2DA==
X-Received: by 2002:aa7:8154:0:b029:156:4b89:8072 with SMTP id d20-20020aa781540000b02901564b898072mr2378799pfn.51.1602734224235;
        Wed, 14 Oct 2020 20:57:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n3sm1165415pgf.11.2020.10.14.20.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 20:57:03 -0700 (PDT)
Message-ID: <5f87c88f.1c69fb81.7192e.328b@mx.google.com>
Date:   Wed, 14 Oct 2020 20:57:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.71
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 200 runs, 5 regressions (v5.4.71)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 200 runs, 5 regressions (v5.4.71)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.71/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.71
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      85b0841aab15c12948af951d477183ab3df7de14 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f878f93cb2687997c4ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.71/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.71/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f878f93cb2687997c4ff=
3e1
      failing since 119 days (last pass: v5.4.46, first fail: v5.4.47)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
| 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f878d824325f36ebc4ff3e9

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.71/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.71/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f878d824325f36e=
bc4ff3ed
      new failure (last pass: v5.4.70)
      1 lines

    2020-10-14 23:43:09.425000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-14 23:43:09.426000  (user:khilman) is already connected
    2020-10-14 23:43:24.863000  =00
    2020-10-14 23:43:24.863000  =

    2020-10-14 23:43:24.863000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-14 23:43:24.863000  =

    2020-10-14 23:43:24.864000  DRAM:  948 MiB
    2020-10-14 23:43:24.879000  RPI 3 Model B (0xa02082)
    2020-10-14 23:43:24.967000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-14 23:43:24.998000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (375 line(s) more)
      =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f878ddf65b245d1af4ff403

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.71/arm=
64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.71/arm=
64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f878ddf65b245d1af4ff417
      failing since 13 days (last pass: v5.4.68, first fail: v5.4.69)

    2020-10-14 23:46:31.461000  <8>[   20.644587] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f878ddf65b245d1af4ff418
      failing since 13 days (last pass: v5.4.68, first fail: v5.4.69)

    2020-10-14 23:46:32.481000  <8>[   21.666151] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f878ddf65b245d1af4ff419
      failing since 13 days (last pass: v5.4.68, first fail: v5.4.69)  =20
