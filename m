Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159E057369E
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 14:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiGMMwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 08:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbiGMMwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 08:52:02 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B7A31386
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 05:52:01 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id o12so10146326pfp.5
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 05:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lEFHazMOTJyqpadXS8asbm8GjGNF8d8VM/o1ktY4S9w=;
        b=WnHcOZj3L2h8SXq6QfAAElFYEO4BOYDJKyFEHmpA/vdQiB9/qekfqe0E0xIpUESQTl
         Fyu4qzh19+hleFlEDROgQ68c+MgTj5ng1DxM3CkVp+gSpD89AjT5o8GQxIVjilyKWuym
         /qa0rBUc/e7rQP8V6tmmxBm+YqAceW7ESrDrwBD30UYMaxbt3S2nx5IjiNLk4ERyod84
         RfyN6Bmmo0iW9B8Iju/v5RBwLi89RX91aTfeMY6KV/DcRVGXehFOHQLmOKXEpGxbeD9A
         lRHIKswNn4B7+scrRczUB8ZiBP25SP/Lr2vNjgxUUaSBacwhZPnBeYcFhPLPaI2a6mXi
         TQUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lEFHazMOTJyqpadXS8asbm8GjGNF8d8VM/o1ktY4S9w=;
        b=qTSIuz8VnjqdvoNRuMKxS4lfBa4w4QK+37usTpfZGndiG/aInYYyFrhGzsm/E7rzv2
         J2FfH1p+rrLz2GBB73HJOY28vD7gQpoYf2WbPYf4AN+hCKwO0H9N/d8HhD3PWccPeSSD
         IMXa38+0L/gIo/ySuTfFn4t4Dh4i2YlfhoJiLsWECFXC0+hKCqpTtpsJzpwAwmXWPaAd
         NGIiADBoDHaYxE34UTcG/69GJhKiID6aQO+Y0+pJXfZ/MEJ6HApwfytxDnSJEkMN8QMh
         ytrm3t6k721v8AcZKsDAW1rnhwJ2m40Aw8levjlNyfqGIR/gdhsPAna1ET7HIiX17aik
         xxdQ==
X-Gm-Message-State: AJIora91GBE/HsZr4pbh+asIB5YJS5cr4My8u22sbWKN8LCzcS3nnumD
        HSwpT39KeZA6NLXUOoO7B9GlERrFmyKmBTdd
X-Google-Smtp-Source: AGRyM1uEHO5HdzsiQw+5W6mqxXuqckMu+Hz3+b6B70JrSWygfRUdiLf0+rKgqDqYk4+W10Lh2WfEIA==
X-Received: by 2002:a05:6a00:3392:b0:527:f2d3:c2a9 with SMTP id cm18-20020a056a00339200b00527f2d3c2a9mr3221982pfb.23.1657716720617;
        Wed, 13 Jul 2022 05:52:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902eb8e00b0016bfcf8a463sm8621637plg.289.2022.07.13.05.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:52:00 -0700 (PDT)
Message-ID: <62cebff0.1c69fb81.a3cb0.d2cb@mx.google.com>
Date:   Wed, 13 Jul 2022 05:52:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.54-78-ga5f899726e59
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 165 runs,
 7 regressions (v5.15.54-78-ga5f899726e59)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 165 runs, 7 regressions (v5.15.54-78-ga5f899=
726e59)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
beagle-xm              | arm    | lab-baylibre | gcc-10   | omap2plus_defco=
nfig          | 1          =

jetson-tk1             | arm    | lab-baylibre | gcc-10   | multi_v7_defcon=
fig           | 1          =

jetson-tk1             | arm    | lab-baylibre | gcc-10   | tegra_defconfig=
              | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.54-78-ga5f899726e59/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.54-78-ga5f899726e59
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5f899726e5928dd5640ec76f6d35bbefc7d19b4 =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
beagle-xm              | arm    | lab-baylibre | gcc-10   | omap2plus_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce908ce0aa50d198a39c0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce908ce0aa50d198a39=
c0c
        failing since 104 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce9e733d4117ee19a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce9e733d4117ee19a39=
bce
        failing since 32 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | tegra_defconfig=
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce9b191db6f6f221a39be6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce9b191db6f6f221a39=
be7
        failing since 8 days (last pass: v5.15.51-43-gad3bd1f3e86e, first f=
ail: v5.15.51-60-g300ca5992dde) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce8ce41921ed24b6a39c54

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce8ce41921ed24b6a39=
c55
        failing since 0 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce8da96cd64d9c2aa39bdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce8da96cd64d9c2aa39=
bdd
        failing since 0 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce9087e0aa50d198a39bfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce9087e0aa50d198a39=
bfb
        failing since 0 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce9178d7e2ea57cea39c07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
78-ga5f899726e59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce9178d7e2ea57cea39=
c08
        failing since 0 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =20
