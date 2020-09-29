Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCC227D41D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 19:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgI2RE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 13:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2REy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 13:04:54 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE058C061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 10:04:54 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q123so5177539pfb.0
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 10:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8TaFeOaDwYowWStlTeF1gMW5AYX6wYEB65IM9S+qw9A=;
        b=O/m9eA3WisfEHWSalWWFMC3DMUe64TkL7dw9RM/xMOnJnJAOhZNxBwo28JXLhtWTh/
         qAoXe/cdgj5Uo93FIsUvypfx31Zr0dMK6XjQgutiJSwzaTvPRGE7Ecdj1wiVm2LEQTcn
         tABKQuHnWsBqLlTyr1yEmaqfaXYVVUt3Jy4TrmvMaXdN/qIH7YOK4yVxIwe7aM0mIwti
         paWFWHiJFPA334OatPcLPNiYF1JH7OlvQLoSe20Fvh5EVbHHtzMTAyHKMTuS7zf4sDPE
         EdXtk0EPMmNbufWJyVV9tYeNpPB9dOYf+XQWM8q+x7yS2YHkp2Tf3pUKK038AProQYds
         ml9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8TaFeOaDwYowWStlTeF1gMW5AYX6wYEB65IM9S+qw9A=;
        b=VJjoa/FAOBf9FRgN1wJdcqkou0LbGcIAIf/QPtaHu98R50yBE12/uSRtFzq8+w7gjv
         t0uZrOJ4dMUY+Sp2XebTK4Aq0VImgmRW4jNqzZh9KIlouFgoNWTGXR0y4zD1zXhydStV
         t1UtcrPGjPuj/+dBiHbHArRSuXkk50bvmrpk2l763mueauZI7XTsdZcXgr1wMUKDcK2U
         7jEfoOa6g7Vrkn2xXLOTzeVZ4c1ff64rlftO4CfgFNbjLRLkTusWgE1ZR/NI7UVMwgMf
         8q7pyWc4pARSnM7isuApv6wvja78kQkXSVDYmgNnb08Io+9m5d4z6tYcLoK/gtSb2wut
         rhug==
X-Gm-Message-State: AOAM533NUsMwy3PPb5erZn+rgFK9Sk8y7xVljyJ4L00wm57xtOoycT5H
        LN/39p1K/vsWxRag98bY7F76FtQXv0zcTQ==
X-Google-Smtp-Source: ABdhPJxU6rwJtW7bxS93aLp6H8ESGeWZEBzSMNGPGc5ybNSxFTuZ1Z/UD48wM/EYu3G9/GYH6QVpaA==
X-Received: by 2002:aa7:9f0a:0:b029:13e:d13d:a107 with SMTP id g10-20020aa79f0a0000b029013ed13da107mr5026921pfr.35.1601399093477;
        Tue, 29 Sep 2020 10:04:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13sm5535464pjl.45.2020.09.29.10.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 10:04:52 -0700 (PDT)
Message-ID: <5f736934.1c69fb81.fa36a.af5b@mx.google.com>
Date:   Tue, 29 Sep 2020 10:04:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.68-389-g256bdd45e196
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 153 runs,
 4 regressions (v5.4.68-389-g256bdd45e196)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 153 runs, 4 regressions (v5.4.68-389-g256bd=
d45e196)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =

rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.68-389-g256bdd45e196/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.68-389-g256bdd45e196
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      256bdd45e196b3d68513dcd043370c3809a97654 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f73370d9b97bf9bf1bf9de0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.68-=
389-g256bdd45e196/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.68-=
389-g256bdd45e196/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f73370d9b97bf9bf1bf9=
de1
      failing since 170 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f733402fa4e961c8bbf9f5d

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.68-=
389-g256bdd45e196/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.68-=
389-g256bdd45e196/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f733402fa4e961c8bbf9f71
      new failure (last pass: v5.4.68-388-g8a579883a490)

    2020-09-29 13:17:45.556000  /lava-2667059/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f733402fa4e961c8bbf9f72
      new failure (last pass: v5.4.68-388-g8a579883a490)

    2020-09-29 13:17:46.576000  /lava-2667059/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f733402fa4e961c8bbf9f73
      new failure (last pass: v5.4.68-388-g8a579883a490)

    2020-09-29 13:17:47.595000  /lava-2667059/1/../bin/lava-test-case
      =20
