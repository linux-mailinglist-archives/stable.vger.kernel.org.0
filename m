Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C17376409
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 12:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhEGKop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 06:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhEGKoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 06:44:44 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1076CC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 03:43:45 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id z6-20020a17090a1706b0290155e8a752d8so5045672pjd.4
        for <stable@vger.kernel.org>; Fri, 07 May 2021 03:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HtjpQPcqopuLkheKYLP5W+KY4Zy0JhO0koAg4hr4RIg=;
        b=KIIGMGN3EimkO2x7A+0CkFkd5IEG35KpyYampqEQquHP3X7lI39NvOhXpSnXk4UxXM
         m4ARUsrBkWldcefxwPbLR8DhLS6/xMKDF+I4KL6mJH9BgelraXdLyWbpI/Q6vX0PMXaS
         w/B9Zf8kuAO6ydebu7a/QtS/nwRGegMZYXlOSGra/milqaVKamGPkV8Zq635j/30G2Fc
         Gv0ySyg32BPmUPxm/gSdKuInH07RWZahmkBAHmG7N7wQkwmKag8prh098OvgSmWpG5GU
         sD3PwExUfR7IZYSk3FfdTvIWR0mD74PKkTj+3Lny9BIIs6VLxYo3//JBpO9lreLy8uSP
         AuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HtjpQPcqopuLkheKYLP5W+KY4Zy0JhO0koAg4hr4RIg=;
        b=tgPsikLJxIROWwGOwlSaj1faaWCM4bFK2+8zd6h5kRNHUtSoqj2UNptJ6xkSiu2GGt
         BPcvv8epwVXTWuxxVXBBt33yz/YnlDWO3XkZQj1vIx8DxHhylHKu27/xPx32WT3C15BL
         wHwzPdMCc8I9NapdPp9gTJmFZKd4p6DONkXI/7ThQIMqf4kNGRLtlDb68zZemr3lk0kJ
         WiLCWHeZ5PsPuzYUJ13simfSstHHO1woNr9VMaVub660BTMrrpKH703RsOte6PeiSuJF
         mqSVHXF8YJ1uZC2gSR7KfnFUe6UwrU1BMTChe6zgHWwk3yTpFBeho4j0sIu1ZBEdC3Lz
         F/iA==
X-Gm-Message-State: AOAM532BaQMPcLMnYAIVhjraQW335xMwwNe8+7SSWlGYiwzB7tsmMsPK
        Dowt5mrnA498iusVshR+usBQVbPBvMyT9/EM
X-Google-Smtp-Source: ABdhPJyPAuq0vwYjQiE2bqVtzSTY+Ptnu2CRIW8tc0AFSQ+FS197G1dT5Ja/PGGzvWnWY+WYSqGg8A==
X-Received: by 2002:a17:90a:4b0e:: with SMTP id g14mr22174681pjh.48.1620384224439;
        Fri, 07 May 2021 03:43:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l126sm4346367pga.41.2021.05.07.03.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 03:43:44 -0700 (PDT)
Message-ID: <609519e0.1c69fb81.221d7.c9e9@mx.google.com>
Date:   Fri, 07 May 2021 03:43:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-16-g9e1419cb87411
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 99 runs,
 6 regressions (v4.14.232-16-g9e1419cb87411)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 99 runs, 6 regressions (v4.14.232-16-g9e1419=
cb87411)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =

meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-16-g9e1419cb87411/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-16-g9e1419cb87411
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e1419cb874112aa0ce22767acadc0450887b161 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6094e80a235c6014dd6f5473

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094e80a235c6014dd6f5=
474
        new failure (last pass: v4.14.232-16-gdb80cec6360ca) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6094eab9d5114c5f226f5474

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094eab9d5114c5f226f5=
475
        failing since 67 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6094e54016051d814b6f5482

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094e54016051d814b6f5=
483
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6094e47028b06ae1ba6f548d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094e47028b06ae1ba6f5=
48e
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60951425d25a9e493f6f5470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60951425d25a9e493f6f5=
471
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6094e41a88902999b56f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g9e1419cb87411/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094e41a88902999b56f5=
468
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
