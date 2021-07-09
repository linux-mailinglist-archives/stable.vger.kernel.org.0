Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D65E3C1CBD
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 02:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhGIAfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 20:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhGIAfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 20:35:21 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D281DC061574
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 17:32:37 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id k20so1204436pgg.7
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 17:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zBC/mgkJoKMdKJ5G5X5304YYHvb3SIiZSmCdLYOXN5M=;
        b=1D2x18if9zmdCpRwbUMuwgyavglLSccKZ5LNgCbvmso/LqY6Fbux8oPweGZv02lm3d
         ypzJJDClfalant5c3j3EL7AvF++MOtrrvl6/Wp2i/ZOODL7n+7t1U40bpSq44fASuSD4
         S48CI7Lieo2wsXlk5CsMtFuaaUvCJHtba5qQy5YMTO9uO5ZqV54t9+8GXrt45GzQIq5y
         QOmLnn7JWsT2UsF/wubd2a8kwpN5OX3YK+pERrhRLF2i8ik/rfkHnW19IBPK9GUKfvLr
         3JbMLzI+hH07hUOKk7OZA5VUCKsENB14oybHfkZkIDAqrMVtsIOJpGd2+YyeEAiT0Hn/
         69xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zBC/mgkJoKMdKJ5G5X5304YYHvb3SIiZSmCdLYOXN5M=;
        b=i4eI0qUUfStE36K/OjGuLD4RItFsjxDFE/GEpKXJlgn8UZGJ6P3UFtMTcz/L/iugDw
         XVxyC6Ha69GXO208Jj7FpJmICTS+rCPg6mn5jKTNmNdJRY4jE+xDqn/2B+EQviJFphw/
         iWsfXrUz6HjX6Pwla0etQFcV2V2FgOsxInk8/LFmrf2hfxmgnBdzRV0XhqwfUBNFRG7A
         ZCGICsSDB18FP6EiFNNAZPl7OOASi+iFT4j/1mWx7xmDj2NoVuRNzV14SWk1ywr2ORZW
         MnssblyS79aUeMta/a7NJ8FKpEeb8/UcOOZaSsb9d3nuRAJU1yenVmu1ABQHQyAzokNI
         PiEg==
X-Gm-Message-State: AOAM531uA677bSjAUtlgE5rgJFTPxCTgreS4eh40g+M/S+3EBUJ+7Mgf
        KPmPhjk5cBusiNdnMOMrJeM88048td23Evkv
X-Google-Smtp-Source: ABdhPJw2qtcI49jRpauPJB5ExpXJnPXjql0BE0akkouYGeHvzT3v3w6mUgkHImwpD5zcDuvCuleKwQ==
X-Received: by 2002:a63:1d41:: with SMTP id d1mr35240517pgm.199.1625790757198;
        Thu, 08 Jul 2021 17:32:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e18sm3898244pfc.85.2021.07.08.17.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 17:32:36 -0700 (PDT)
Message-ID: <60e79924.1c69fb81.277b9.d075@mx.google.com>
Date:   Thu, 08 Jul 2021 17:32:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.274-9-gb8450830f4be
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 127 runs,
 4 regressions (v4.9.274-9-gb8450830f4be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 127 runs, 4 regressions (v4.9.274-9-gb8450830=
f4be)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.274-9-gb8450830f4be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.274-9-gb8450830f4be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8450830f4be46f520283976a4e51740dda251b7 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e7642a76fc35881d11796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-9=
-gb8450830f4be/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-9=
-gb8450830f4be/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e7642a76fc35881d117=
96b
        failing since 236 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e764ab21158ab6b911798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-9=
-gb8450830f4be/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-9=
-gb8450830f4be/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e764ab21158ab6b9117=
990
        failing since 236 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e764344a5071aa9a11799a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-9=
-gb8450830f4be/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-9=
-gb8450830f4be/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e764344a5071aa9a117=
99b
        failing since 236 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e7641f077850916b117985

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-9=
-gb8450830f4be/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-9=
-gb8450830f4be/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e7641f077850916b117=
986
        failing since 236 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
