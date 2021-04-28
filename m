Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7E436DBFA
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 17:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhD1Pk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 11:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240395AbhD1Pif (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 11:38:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65610C06134F
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 08:37:40 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so9232929pjj.3
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 08:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tGYvBxLOhBKoBxErCZRerpeNvzVmuH8sV3MxMpAcVsg=;
        b=BwFPiR6QhlKZJv9F64xyehlTma5mdpSyrmkq+vz+BjyVbJdN9lyherdmVvmbAYWVs7
         KTVg8x8o2CZVr+qmJzaAPOZaBU0455lNnIet1ZH1+5UCOaGs5PE1gjzG0lXX552ldB+J
         YBkHgZeKLTleN+bvVg/zPIUSYPiOu2/aOTVb1+fdh/GBi1D5VgIVGtb48Ql8Fl+ieYGd
         31d7n90ctaXIUwiV8Bx2xV2bC9OeCxJxypmpDV+Ib4a696jJ8f+AtAa511u+UMe6G2f7
         hwIsCyL5rrPU38uaWBq0b3cvmZbelj6WND7n5RZFNYrbR8EpKK3v0+nReGlGAVhY0wz2
         snaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tGYvBxLOhBKoBxErCZRerpeNvzVmuH8sV3MxMpAcVsg=;
        b=lP7fWGyQosSuUC3WykAnxYPi/3laEq2z/ma2DpWfiZ6OhlBbb6XYLydF/POWNeSul7
         tXXmol8/zgkt4riAQJ6LPAn5GkEVOqtdd9ntfA3095MD71m62WfuHMsNfZc8pm83f9pd
         G3inZ/6TRj23GaFvsyJk8TVpkW6UAj0KbYwV4CvpOMxhZyFC3lhTY/xYsSVsPW2h48Se
         BsUhP2xvLVsj8lQrtwlvsgPGX0Mm1w31zK7FAYt5Ly9YfbcPiAqAdM18B7wRO2r2TS6y
         fNe+PXznCkPItfLRvLK10eN+n7Q01r+S5JPYxk4SkTLwUynY9BSaN7TeU76LmBLSB1kZ
         kE1g==
X-Gm-Message-State: AOAM530okcbNArafonxHlseaB7yxIzprGtR3/IKZrxiPK0pTc/FpmiWp
        2k4ME8ck8orzEtb414FlIiUfnCCW88q4aRxK
X-Google-Smtp-Source: ABdhPJzJCqxUkKjczQMR9td97PW55Pw6nIr+QJ3LezSfAU4m9hRg47e3oRW9AEby4rZ4o0yQS62MFg==
X-Received: by 2002:a17:90b:2307:: with SMTP id mt7mr4407390pjb.131.1619624259777;
        Wed, 28 Apr 2021 08:37:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n20sm13692pjq.45.2021.04.28.08.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 08:37:39 -0700 (PDT)
Message-ID: <60898143.1c69fb81.d65b.00b9@mx.google.com>
Date:   Wed, 28 Apr 2021 08:37:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.188-59-g4ef990805bc64
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 113 runs,
 3 regressions (v4.19.188-59-g4ef990805bc64)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 113 runs, 3 regressions (v4.19.188-59-g4ef99=
0805bc64)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.188-59-g4ef990805bc64/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.188-59-g4ef990805bc64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ef990805bc64c22681d1c40ab5eeb780df63c8a =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60894eb56cd8431b0c9b77a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g4ef990805bc64/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g4ef990805bc64/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60894eb56cd8431b0c9b7=
7aa
        failing since 165 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60894ebd6cd8431b0c9b77b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g4ef990805bc64/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g4ef990805bc64/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60894ebd6cd8431b0c9b7=
7b1
        failing since 165 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60894eb95da9f671ab9b77b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g4ef990805bc64/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g4ef990805bc64/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60894eb95da9f671ab9b7=
7b4
        failing since 165 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
