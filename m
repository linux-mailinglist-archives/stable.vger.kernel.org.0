Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1C4290654
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408001AbgJPNbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407350AbgJPNbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:31:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC1CC061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 06:31:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id az3so1396477pjb.4
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 06:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8DGLtH+GkVtDY7oMlpC2fnjELm4VGn6qBO+ilKfDjrY=;
        b=vh3A0VtdhaKAJpLjiuMmCveeqlYOHwXPz4MZlCCBrD9DGAr2V5fykWQt5haKG3rxOT
         h+RZ6sw5iHjlTKqqVoPO1sCxAib/eZaRsRQ8j3nc3/gBnD7ANAmXgG0rcCAxXA2bP+A/
         ZOvGibwrgFTK4S+omPscIDgk3V/Cw9gT0N3LlLTtF/+o8wnvRBQQZRAYSA8X8RmfUAkZ
         PZ1P6nV5xDvxb4F1tmcTbRYCry4cvJz3z3MqnjMJMzBSg1xYmFU4iocYmxdmCdZdaJxA
         LwOqG0oackFglDkD9bXXRtklaB1swi4lI9kCr1h0u5jVWTmvfT0BzK/KwQAjtycsk9k0
         3sLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8DGLtH+GkVtDY7oMlpC2fnjELm4VGn6qBO+ilKfDjrY=;
        b=KHjZHOuEMo/x9KLYwn7xiFsHH5k80zyOof5mv7aADEjmCucMoSmX0zlZI/WYRRbBKE
         vE6Tmw8++TkOuZ1exWqDwg2JlpF6yHR3UI7/1dsHywQGjfDEMgZRsZRyCRfX00ArPWOT
         fWFCkBmoQEh2/zwJPJs64WtDVD+jhZHpXd2fOnnweBimOEls0DCiPl7CPNqphmCnrLri
         gBjwbRP6DyOAVuOJqdWy6KhoPzQOlH8F65SC2nspLiIhZeFbMOBn+5e9jC14Poe/oQo+
         C2oQG3dDP/f918zpJOE+W1wVzXK26IEuPGEzownh9xGqKM902Fid+f5NDNOdPo1kCXEc
         ubxA==
X-Gm-Message-State: AOAM531UG6K8se8BoJBWrz9oNDV1jNT1qrdfVS2V11gdumz0mJ1t9xjV
        49xNE5lakw6Ctoozgboxg5s2Sv1dfOWhmQ==
X-Google-Smtp-Source: ABdhPJyE9pMDm8K2dbfw/RQ2WK+/cR619zzSv5Pn/qtT7k9F2lynFq2T7P1DSVvFasb1BkB02ePmxw==
X-Received: by 2002:a17:90a:e00f:: with SMTP id u15mr4203812pjy.87.1602855089792;
        Fri, 16 Oct 2020 06:31:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t17sm3004181pjs.39.2020.10.16.06.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 06:31:29 -0700 (PDT)
Message-ID: <5f89a0b1.1c69fb81.915d3.61c0@mx.google.com>
Date:   Fri, 16 Oct 2020 06:31:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.71-22-gbe1190d55f11
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 185 runs,
 4 regressions (v5.4.71-22-gbe1190d55f11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 185 runs, 4 regressions (v5.4.71-22-gbe1190d5=
5f11)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.71-22-gbe1190d55f11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.71-22-gbe1190d55f11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be1190d55f118684ba27992749f1116f2cff3bbf =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f896686c1fcc8bb4a4ff4c7

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.71-22=
-gbe1190d55f11/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.71-22=
-gbe1190d55f11/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f896686c1fcc8bb=
4a4ff4cb
      new failure (last pass: v5.4.71-5-gb8377737c2ee)
      2 lines

    2020-10-16 09:21:08.619000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-16 09:21:08.619000  (user:khilman) is already connected
    2020-10-16 09:21:24.692000  =00
    2020-10-16 09:21:24.692000  =

    2020-10-16 09:21:24.692000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-16 09:21:24.692000  =

    2020-10-16 09:21:24.692000  DRAM:  948 MiB
    2020-10-16 09:21:24.708000  RPI 3 Model B (0xa02082)
    2020-10-16 09:21:24.794000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-16 09:21:24.826000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (380 line(s) more)
      =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f89666ac1fcc8bb4a4ff3e0

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.71-22=
-gbe1190d55f11/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.71-22=
-gbe1190d55f11/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f89666ac1fcc8bb4a4ff3f4
      failing since 16 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-16 09:22:40.992000  <8>[   22.980634] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f89666ac1fcc8bb4a4ff3f5
      failing since 16 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-16 09:22:42.013000  <8>[   24.002181] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f89666ac1fcc8bb4a4ff3f6
      failing since 16 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)  =20
