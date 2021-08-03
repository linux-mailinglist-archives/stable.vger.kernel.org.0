Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF5C3DE4DF
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 06:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhHCEC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 00:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhHCEC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 00:02:57 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5ACC06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 21:02:47 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so2960757pjb.2
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 21:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kDlCV/ws8APSQ+tJef/kQDW4XKm8Q650Ler70Ad4K5s=;
        b=tygFgjFrqNaexYzKRt4hlac3J2iOaMcl5HUdH6WC6qcRkuSc5MHGANo00wjZnVzjM6
         R/oCJDTKDQRtwdGmRTILTwhcU53/yOni3MPhvT8R6Aj6lPq/VOA0Fv/gLD+obe0HqsLn
         XU+QT1sUgtluLFf8UubtqoXsS/orXI8PfOkPVzEEqswHQtfSxvmw/lm0bPO5q6nLaoQC
         vEjOZCEIM6i6BhrPyHdvdBPm8ibfkNNbM+u9UNrCrat4mfbfudKOJRyakdwItYQD+zQL
         BwUX/RapvqM3bhdqqaO3Iy7kwr9LWrdO9JzBwLZR4ikSrhTZyXcZQicIOOqiy5qxHwla
         AOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kDlCV/ws8APSQ+tJef/kQDW4XKm8Q650Ler70Ad4K5s=;
        b=q2ebOB1sBwZADSxu9LNZFWswW+xyl7Fu1HIAxftGzJ/IA2QDnOCOqg50iAw59bkYEb
         hEwirhJ6ugArm2mDakvs7Mqrp17u5m7it+pMCeAdM6mK9X7aDkMPMGuxniP8V1oTTsBR
         ZN5fE6+VSt+2bcH/Bpr5kItjotgLvlHiKeff69uykncp98jfQqe+taTUX+mujwRnXk1Y
         yaEpAdpBg7k79eT/CZL8pM81wjps0GewwyR43D/hG8s4xB1F6GsO91TCDd7agAjXuo3C
         ws1EtJpqfA+Yy0VZvYvOX7mI2KAmkQVm/A/sZoXO+5JHLsM0ZXVAYAiPFiWxAjsLC8vF
         lABw==
X-Gm-Message-State: AOAM533TwZ0qCGXLIWCMshZvYDnIoCamsig+LjpOz5qqowJZl/fu9TNH
        uBXVDKu+S13H+l7A4/3e5pZVWlscXLUPVKQU
X-Google-Smtp-Source: ABdhPJxLent1v0bXpN/EWWSGxK0/xVPa5NyxQYwg+/0Qw8vVushjsrZjUzhs0tf7ZkWOzsXbQ2l2nw==
X-Received: by 2002:a17:90b:158:: with SMTP id em24mr21296232pjb.174.1627963366753;
        Mon, 02 Aug 2021 21:02:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jz24sm8560985pjb.9.2021.08.02.21.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 21:02:46 -0700 (PDT)
Message-ID: <6108bfe6.1c69fb81.f9aae.92d0@mx.google.com>
Date:   Mon, 02 Aug 2021 21:02:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.277-33-g2e921520d320
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 4 regressions (v4.9.277-33-g2e921520d320)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 4 regressions (v4.9.277-33-g2e92152=
0d320)

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
el/v4.9.277-33-g2e921520d320/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.277-33-g2e921520d320
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e921520d320c0648ea1251529d356c9bcd42abc =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610885738d9dc76fc2b1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
3-g2e921520d320/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
3-g2e921520d320/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610885738d9dc76fc2b13=
67c
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610889df17bbe70856b13668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
3-g2e921520d320/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
3-g2e921520d320/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610889df17bbe70856b13=
669
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61088548e63ea06fa5b1367f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
3-g2e921520d320/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
3-g2e921520d320/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61088548e63ea06fa5b13=
680
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610887106eb2804b0bb13694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
3-g2e921520d320/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-3=
3-g2e921520d320/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610887106eb2804b0bb13=
695
        failing since 261 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
