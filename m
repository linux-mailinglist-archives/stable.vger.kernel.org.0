Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EBB2DA829
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 07:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgLOGjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 01:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgLOGjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 01:39:16 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B187C06179C
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 22:38:30 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id w6so13908632pfu.1
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 22:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r1dA3yj1Hw99o7a8EJrjz8IJ74CuaG+AyGVYx/f8Rtk=;
        b=W7Y9vWfFb536DkttALTQyLZujuRD4N4t1q+XXAqagvHckDpjw33Ifb5zREVm6ta8Ja
         bwgGjyQCq3SS5YSPnilmzEXSYHoB2xiITma7ShPDAb0yC5XHEU+HZst1KXsRb9fs2b7E
         Mo6C5pEB1zgZA5m/5x72P0Uusp+SgZLgwSckEhD3jV1RZavVd4Wck4AMyGZRg/0VxPgC
         SUJopa00QNxy/Llxm5QZN7hDVCWDcak2L1VeYS+yae3/WHTCMbVvGju1SHE6NSlaEfXJ
         uPlGOBJpoPJubhHo9wRECztlYmyyvOLNCneI2P98buJNZi7dP8vHRqqehwfk41K0vnDF
         eL7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r1dA3yj1Hw99o7a8EJrjz8IJ74CuaG+AyGVYx/f8Rtk=;
        b=aQnmTCZtFM4Y9LvLq2Wd7k8+oFqiWbJc2451fZo8Ck6SjkzS9WK5tee3BNRzASJGFL
         5Kv3mrF8QxPYr/Uwtat8hGz8YW8mxQPv+2jV/m2svcFKoz2G4InLUncYf56ukRRfEKkB
         L2tyVOXDpen8jMVFGDzBHa47QjXQP8+IvhcH06g88yjjLmZMpYZ+H+yrLbAv4Wv1TUPQ
         GQPZQiXqRlRqGcxIZ+Lp7A18OFLehsEqswvQAVVFzP15LCKt80BbIb0S+ViwlHVzCwHY
         YDuYwTkyBW0twDVljRIHtpkvOpKBqM8i0sqKjFWowBQgrkrT+Uxp0wpadCWKbuBbXmXe
         zbHA==
X-Gm-Message-State: AOAM531OlqkYSMEg2v2xepankWa5KLBUVRP5N657DjYu2a6zp/FQ9lj1
        q5tdM+JCu1xYzV4wY/sdf8Nu9b39mXh6IA==
X-Google-Smtp-Source: ABdhPJxEQOGs080XWLmywCRwO0TUT4qrEJR9jGfjG+ZzZ8RTILmea13fpKPkZRerjJBI5K9ucvCwVg==
X-Received: by 2002:a05:6a00:1389:b029:18b:2d21:2f1a with SMTP id t9-20020a056a001389b029018b2d212f1amr26982998pfg.1.1608014308986;
        Mon, 14 Dec 2020 22:38:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a23sm20498363pjh.19.2020.12.14.22.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 22:38:28 -0800 (PST)
Message-ID: <5fd859e4.1c69fb81.cd405.b103@mx.google.com>
Date:   Mon, 14 Dec 2020 22:38:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-12-g036089ecfc3a
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 71 runs,
 3 regressions (v4.9.248-12-g036089ecfc3a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 71 runs, 3 regressions (v4.9.248-12-g036089=
ecfc3a)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.248-12-g036089ecfc3a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.248-12-g036089ecfc3a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      036089ecfc3a52f94b9c8744a9657d5a2b55b568 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd825a43956023b47c94cea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-12-g036089ecfc3a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-12-g036089ecfc3a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd825a43956023b47c94=
ceb
        failing since 30 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd825b02b44ff1d80c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-12-g036089ecfc3a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-12-g036089ecfc3a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd825b02b44ff1d80c94=
cc1
        failing since 30 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd824aa9d35c319d1c94cf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-12-g036089ecfc3a/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-12-g036089ecfc3a/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd824aa9d35c319d1c94=
cf6
        failing since 26 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
