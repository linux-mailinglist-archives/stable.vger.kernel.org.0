Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F3C280467
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 18:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732360AbgJAQ6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 12:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732096AbgJAQ6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 12:58:54 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAF6C0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 09:58:52 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t14so4476300pgl.10
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 09:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=higb5YoI9ZrG7rytS7UZ1Vem50ThuTZCrPY8krBi0WE=;
        b=Ew1jVGjM4n/IgA3iqOg2oKaWnHDPuPJdId4Cwb6TopdxnnJoLBrHNd13sIbxVuraVg
         LqKAWOXqqyuIUyv5Al7wEARAiCFxq+N1l0kV+cgawkE6gFJU6zet4sXv0uZE86Ca0Oms
         9yF2AVILBvZ++4OrZIXm1ivCG5KMqV2aca0Pp9ZKy5x4+O3Gi4MvW3yVXaeaDqQArcYI
         iYvuD8PiAjQmT2AJvvp3At9cddFq51f+IjoPo4k8mC44+eWxgZRCHclAPeC2TEhtovKL
         GRQrEbPhBbjyFzyJzOkqJlnevyvhOphmH25YluzCIFL89a7LcjGMmjvluxasBXLbacmW
         H4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=higb5YoI9ZrG7rytS7UZ1Vem50ThuTZCrPY8krBi0WE=;
        b=L+Ub8f6lJ3pbMnwVnOGjgNRBXWuCQTm0YFllSMG5h5kz151UdRxujIvwYMhssyeQmd
         8p1ciPJzsMGlVPwQXJV4RzZ1kM7VUEjX0hTf5ov/QVWEESgDnQWKash+3XrpfsuPDJVe
         +zn3g5CLXaEDeSgLIkyubn58gWBxfpL6bc5gp4AMSDKvz91OZf7Zze6AmymxgIf0GNkC
         kIVII62tPtF8MZLCH2rd40O3H/NGEr+pj6gdoc2aHCQefAjNZVr6HT51KZpEKyijvtEE
         iX6+7mTTliDHSnG5+BBxaKvSbkWH2AwDXBXoBDZOKvNHQAD4as/+IxKpnjuejG0mNYaZ
         jmsA==
X-Gm-Message-State: AOAM5311b48FT0H/I6M5ZczpL16l3C4Q46R2/rfA+qtHIRkymdalTA7D
        2eoA9u3pb5ng5yM6pT94feNJqge3mxfxLg==
X-Google-Smtp-Source: ABdhPJz2LgLYfYPMXx96il2IE4C9bRKb4WE9+FLiWUHM1UV2zXg6fz/g8VrgD5LGPZgYcoOBmAMpQg==
X-Received: by 2002:a17:902:ff0b:b029:d2:cc1:615f with SMTP id f11-20020a170902ff0bb02900d20cc1615fmr7865422plj.27.1601571531121;
        Thu, 01 Oct 2020 09:58:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x13sm6746810pff.152.2020.10.01.09.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 09:58:49 -0700 (PDT)
Message-ID: <5f760ac9.1c69fb81.825d7.de62@mx.google.com>
Date:   Thu, 01 Oct 2020 09:58:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 156 runs, 5 regressions (v5.4.69)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 156 runs, 5 regressions (v5.4.69)

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
v5.4.69/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a9518c1aec5b6a8e1a04bbd54e6ba9725ef0db4c =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f75dbb52560a35c15877178

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.69/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.69/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f75dbb52560a35c15877=
179
      failing since 105 days (last pass: v5.4.46, first fail: v5.4.47)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
| 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f75d65d3e38ed92ca877180

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.69/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.69/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f75d65d3e38ed92=
ca877184
      new failure (last pass: v5.4.68)
      2 lines

    2020-10-01 13:12:55.653000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-01 13:12:55.653000  (user:khilman) is already connected
    2020-10-01 13:13:10.836000  =00
    2020-10-01 13:13:10.837000  =

    2020-10-01 13:13:10.837000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-01 13:13:10.837000  =

    2020-10-01 13:13:10.837000  DRAM:  948 MiB
    2020-10-01 13:13:10.852000  RPI 3 Model B (0xa02082)
    2020-10-01 13:13:10.940000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-01 13:13:10.971000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (380 line(s) more)
      =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f75d63e474333dbb0877174

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.69/arm=
64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.69/arm=
64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f75d63e474333dbb0877188
      new failure (last pass: v5.4.68) * baseline.bootrr.cros-ec-sensors-ac=
cel1-probed: https://kernelci.org/test/case/id/5f75d63e474333dbb0877189
      new failure (last pass: v5.4.68)

    2020-10-01 13:14:31.335000  /lava-2676195/1/../bin/lava-test-case
    2020-10-01 13:14:31.344000  <8>[   23.909147] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f75d63e474333dbb087718a
      new failure (last pass: v5.4.68)

    2020-10-01 13:14:32.366000  <8>[   24.931402] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
