Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4DE40C910
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 17:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhIOP51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 11:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbhIOP51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 11:57:27 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475DCC061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 08:56:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n18so1897663plp.7
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 08:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Gy4BptoU7GWjzDFOcioPeh/lplEozL/37xcmcI6K8uU=;
        b=JMoH7hazMsK59AtQS2ZbOJQc1BRuTGGuzSo7igZF/3Ws9S0SYiB/mJNvIzwEpsAH85
         VIYhzQb9LJ2N0dNiyDtmx9qCbRGQBWhDRkaKglnG0MlIKt5iWiqnC779QhcwEq9pIImL
         kFR26BwAVp4Q2DqU3nbE8xIBNdLL/lYYxlKuZLUgjdclI74S4HGSe06Q36xbszTczpGh
         Vm4QWmoQun1pqAEJNukBlyg6mSVgJWd/yOAc+PLhHYV7z1Xo8F6sBjjg7STELMp9wSjJ
         pAzVAtLCGLXH8ePtzcE3SSim02ZyXQlvSBeoIFSMJuzIA90oukvo2mCnIe2nn65riV3v
         RCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Gy4BptoU7GWjzDFOcioPeh/lplEozL/37xcmcI6K8uU=;
        b=aVCz0MVvH0u09DarqSghS+nA8Rcdxhq79XbWoKTs1MrW805cRQzzFvcXicssPzfWzg
         Pkj5KbgbLL8/9vmE+aPrDVevpkz3Q3l7TPh3NKmbSGefs4+htFgx6VyDfsRdujRvhsS6
         HZlMGxXgwAdrtxGZAYWETKiBLtk1SvIujJFDNwJMKXYn4zAm5d+9E7v9AR9f6KM0NW0u
         hFYbHFCLPRI9+iW5d7HyXiBKb7R4hLrFzuXqrIFudoKuq+34Sd7tOITnCFWEE7oyC4Sl
         vdpPeSJwT4UGo1G1UarmTgWsGsvkp3HvuKKfv3CMR/YIAw9mzutLFwe9NoeKokFV3lCT
         YhBw==
X-Gm-Message-State: AOAM530NRbyQ4B0uY7bHf3vK67QD2CY4Gs1u6xtKKgXqqziOb0VzzrUJ
        51VAXq9ToV3FAi1BjzsVeMX4oXo9s7jMY0qrThA=
X-Google-Smtp-Source: ABdhPJxbRQH/YrPEiO9APgxt8lEXYoX0olgn2Gewosap+ViXQ0rCEymyo23VViKPo9xH1AuPb88/qw==
X-Received: by 2002:a17:902:9887:b0:13b:9892:860b with SMTP id s7-20020a170902988700b0013b9892860bmr302341plp.65.1631721367570;
        Wed, 15 Sep 2021 08:56:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gi6sm159433pjb.52.2021.09.15.08.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 08:56:07 -0700 (PDT)
Message-ID: <61421797.1c69fb81.e84e6.096b@mx.google.com>
Date:   Wed, 15 Sep 2021 08:56:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206-119-g3a660f16f8ef
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 151 runs,
 5 regressions (v4.19.206-119-g3a660f16f8ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 151 runs, 5 regressions (v4.19.206-119-g3a66=
0f16f8ef)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.206-119-g3a660f16f8ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.206-119-g3a660f16f8ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a660f16f8efe947ccfe6763e9757099d29b3208 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6141e4a7e328ca68a599a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-g3a660f16f8ef/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-g3a660f16f8ef/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141e4a7e328ca68a599a=
2fc
        failing since 305 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6141e4ae2ad24af9b499a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-g3a660f16f8ef/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-g3a660f16f8ef/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141e4ae2ad24af9b499a=
2e7
        failing since 305 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6141e48ee328ca68a599a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-g3a660f16f8ef/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-g3a660f16f8ef/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141e48ee328ca68a599a=
2f3
        failing since 305 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6141e451bf449cb7e499a309

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-g3a660f16f8ef/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-g3a660f16f8ef/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141e451bf449cb7e499a=
30a
        failing since 305 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6141e6cee7896ba12899a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-g3a660f16f8ef/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-=
kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-g3a660f16f8ef/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-=
kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141e6cee7896ba12899a=
2f6
        new failure (last pass: v4.19.206-119-gce9875a18ce0) =

 =20
