Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D693ADDC7
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 10:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhFTIsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 04:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhFTIsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Jun 2021 04:48:15 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EEFC061574
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 01:46:02 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id i34so5940643pgl.9
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 01:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iV50Ed/whB5mFRAejtjfGvMRcBUlLUDBdv/ysUDju2g=;
        b=A2U4Te+84hLFiDt7N+T2bZJONq1uzAjiK/gJnn2NIyPakqZNgg2H/ATJ36kFMJaTOG
         NEE0BmM+AFon/lb8BL/TcA/2Xbz+AsoYUxdtUDYSCAUd4qntKfcQZM3/75qT1G8hJrpP
         s4fLq0WhIQpGoN1n3ITslTxONawq6ipl1sx7CBYklQVZTrmd/WxA3U6s4w4lUSAt0ssB
         0cIYVd7oRJ+FNhTbh5HKZL7bUc57HiL4iG7kj8yWLKgU6hVp27fez7/RkUB2yaABuRYZ
         BMxgTftWgzzCxvUNzB0ymZ5Gy1hT299mVVvhlUqkeZaBMkuYQFBUq+zx5MHA9sd0jCxr
         F3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iV50Ed/whB5mFRAejtjfGvMRcBUlLUDBdv/ysUDju2g=;
        b=jXCGBERrTaKiF5m//uYj8CRnI191ydU0hPZ7Gcp7i3Pd0Dwx7zCqwthB8CFFbAVOi7
         FXiTCpRn27f0XgDg3xu16oiZIW2+9x1jvCo+DqJgpKmIV+7T47J1+fRZaYKkvuLT2u01
         64d4jUwlZuyhVKP6XIWOk6cl6E/r59hi8VX9yI8b7BNlcsNsehj972rRx58YyG64SbYN
         iA56eBGlKz/w9O5ge7StMvdyWmQBc+n0E+4g0Pz7ukLX4vsgNG+rTVx9UaXDEo0U6D0W
         N7LxHx4yjV/C5zmxr51a+TNxx1A7jMFi9X5+y2KJeTFKdLIDlFSDtBHbUKVCSirI77Ri
         Gdgw==
X-Gm-Message-State: AOAM530lMz/WsATLBGXrEmLz0lJj5qiVoVRTw4aLb4hccY9ZUhQWHFdG
        hdS9lQrio5S3IOwQX8Y4ck12+RLh7uqkEmAo
X-Google-Smtp-Source: ABdhPJwMVG3ENwhnPxrqCq4GyXxFDQ/i0jguzGexPMyHoMthY7IlEd84oFDczi6MVT+fOKk6QGyVKw==
X-Received: by 2002:aa7:9409:0:b029:303:1db:94d5 with SMTP id x9-20020aa794090000b029030301db94d5mr859230pfo.72.1624178761480;
        Sun, 20 Jun 2021 01:46:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 33sm10145848pgt.46.2021.06.20.01.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 01:46:01 -0700 (PDT)
Message-ID: <60cf0049.1c69fb81.5687e.ad2b@mx.google.com>
Date:   Sun, 20 Jun 2021 01:46:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.12-87-g668d8cf8d379
X-Kernelci-Branch: queue/5.12
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.12 baseline: 179 runs,
 6 regressions (v5.12.12-87-g668d8cf8d379)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 179 runs, 6 regressions (v5.12.12-87-g668d8c=
f8d379)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b    | arm64 | lab-baylibre  | gcc-8    | defconfig          =
| 1          =

bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =

imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.12-87-g668d8cf8d379/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.12-87-g668d8cf8d379
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      668d8cf8d379df1300aef93b8b100be6a489ea8a =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b    | arm64 | lab-baylibre  | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60cec985253d826c9441327c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
87-g668d8cf8d379/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
87-g668d8cf8d379/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60cec985253d826c=
9441327f
        new failure (last pass: v5.12.12-12-g7d43f7090254)
        1 lines

    2021-06-20T04:51:57.761866  / # =

    2021-06-20T04:51:57.772319  =

    2021-06-20T04:51:57.875488  / # #
    2021-06-20T04:51:57.884255  #
    2021-06-20T04:51:59.143953  / # export SHELL=3D/bin/sh
    2021-06-20T04:51:59.154439  export SHELL=3D/bin/sh
    2021-06-20T04:52:00.776473  / # . /lava-469094/environment
    2021-06-20T04:52:00.792364  . /lava-469094/environment
    2021-06-20T04:52:03.742821  / # /lava-469094/bin/lava-test-runner /lava=
-469094/0
    2021-06-20T04:52:03.754163  /lava-469094/bin/lava-test-runner /lava-469=
094/0 =

    ... (9 line(s) more)  =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60cec90046b3a24cbe413267

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
87-g668d8cf8d379/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
87-g668d8cf8d379/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cec90046b3a24cbe413=
268
        new failure (last pass: v5.12.12-12-g7d43f7090254) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60cecb1d8b46cbae97413292

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
87-g668d8cf8d379/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
87-g668d8cf8d379/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cecb1d8b46cbae97413=
293
        new failure (last pass: v5.12.12-12-g7d43f7090254) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60ced22131120afc1d41326e

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
87-g668d8cf8d379/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
87-g668d8cf8d379/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ced22131120afc1d41328b
        failing since 5 days (last pass: v5.12.10-48-g5e97c6651365, first f=
ail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-20T05:28:58.485800  /lava-4062988/1/../bin/lava-test-case<8>[  =
 13.034806] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-20T05:28:58.486269     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ced22131120afc1d41328c
        failing since 5 days (last pass: v5.12.10-48-g5e97c6651365, first f=
ail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-20T05:28:59.505141  /lava-4062988/1/../bin/lava-test-case
    2021-06-20T05:28:59.522040  <8>[   14.054373] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-20T05:28:59.522433  /lava-4062988/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ced22131120afc1d4132a4
        failing since 5 days (last pass: v5.12.10-48-g5e97c6651365, first f=
ail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-20T05:29:00.923877  /lava-4062988/1/../bin/lava-test-case
    2021-06-20T05:29:00.933887  <8>[   15.481732] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
