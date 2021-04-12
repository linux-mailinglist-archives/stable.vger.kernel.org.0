Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362BD35CA63
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 17:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243097AbhDLPst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 11:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239633AbhDLPsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 11:48:47 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA92AC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 08:48:28 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso7336210pjh.2
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 08:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZOAC4QV+BQTKpskRTXSyR1MC54aGnhQqAFHv5a4rL0I=;
        b=r6CLf+5mbCxzt7X/7+mcw7ifcQsCAjqmPy1Bu3Lygh9/lwr3DzmjtfT3qy0vlrtO5g
         a4rwR4EyuVTvmu3joV5A6ckPDaqRx/J+Z9ewUa5GJe3qfy/o02WjHQNKfFE1XuoJiBEK
         gRfUFOp6OdT8cSLGuGO9Eyz6EH8eGik7C2XaX8upo2M0NQPX8PzjXkaIwYdofs4q5Xu4
         EkGzIc+Ng5wgcIPu8kv2vRcO3N3/42BKu4NOXVl96bP3nSOfuatfbePYyzAXDI5p2AAt
         y/whqGNufsZEJAaIQM+w9sSpP1/cVJMIEMChvRqCyW6rYEwe12s4FL3TC2UihWwueyWE
         2YJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZOAC4QV+BQTKpskRTXSyR1MC54aGnhQqAFHv5a4rL0I=;
        b=SNS6VbcdhxUw0AJWmYgYfziX+Sw6BGvPbDp5TFCGKO3Ebxuyon89deWnUxT9xrJJ2e
         ouHjnztO1udUg+FiUk6YRYbl912suLqzxl8J1xMOA3FoiFZ8xb+wnPjqUdCQh6/LeVeX
         4X0gqY1ohQkAlEfRPnpTrPvFcl7zJu6Gm1T5aUDYEG2on8TubcwJxYFe+9phDPJo1N/C
         ztPsQnfPB28De2ReS0/kZDL3rAxFkiE2L5C2tJvdMg4SvIZyU/znjnB+PcLsEI5aeCZx
         fMl3BtOEVBqi85x1uSsOnoP4Ic0ErGYNf5SuQGA+s3xtm7jNTFsUNR1GxKbTleDZBFrh
         kssg==
X-Gm-Message-State: AOAM533F3CIbcbhW6Qa2lGS+qhkL41s07odRMto7/k09Olo462RaDcoe
        aTpWt2qfkL7NBRep7FCn6QbD6X1SmNDkW+Gb
X-Google-Smtp-Source: ABdhPJyw0zB2SnZjv1hW/IuEeHSVZTXnKRRjbwvzvoRjAJ0z2GPJj58ZV4E22FIwDvvXMT/EWF5oDQ==
X-Received: by 2002:a17:90a:df15:: with SMTP id gp21mr29923098pjb.127.1618242508132;
        Mon, 12 Apr 2021 08:48:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m14sm12963300pgb.0.2021.04.12.08.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 08:48:27 -0700 (PDT)
Message-ID: <60746bcb.1c69fb81.c35bf.f18d@mx.google.com>
Date:   Mon, 12 Apr 2021 08:48:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-43-ga0c17d36dea38
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 93 runs,
 4 regressions (v4.9.266-43-ga0c17d36dea38)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 93 runs, 4 regressions (v4.9.266-43-ga0c17d=
36dea38)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.266-43-ga0c17d36dea38/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.266-43-ga0c17d36dea38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0c17d36dea387762568063793bff9a81f4667f6 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607436c7aabe30ae12dac6b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-43-ga0c17d36dea38/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-43-ga0c17d36dea38/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607436c7aabe30ae12dac=
6b5
        failing since 148 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607436ad69d30a2de0dac700

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-43-ga0c17d36dea38/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-43-ga0c17d36dea38/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607436ad69d30a2de0dac=
701
        failing since 148 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60743661ca88baeb7bdac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-43-ga0c17d36dea38/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-43-ga0c17d36dea38/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60743661ca88baeb7bdac=
6b3
        failing since 148 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/607439f338dbbbc817dac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-43-ga0c17d36dea38/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-43-ga0c17d36dea38/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607439f338dbbbc817dac=
6ca
        failing since 145 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
