Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE171426F65
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 19:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhJHRRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 13:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhJHRRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 13:17:47 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C22BC061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 10:15:51 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id m26so8792657pff.3
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 10:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tHsX7yALii/CDTw0qT+WGi2Hgune/f+IBczf+IlQvNU=;
        b=n8vFTMRgYmvmDPyfF3UEKl/6Rr8SW0zbAHetftdWfiBVM3dJHSwndzcWs68hy5V7PJ
         +yoy2SOXURI5xbus8SuSjOw9fL5SDv6HXYREo01h/8Pj18tgIJOCrr6wTKCNBwJN+wcL
         OZlaGlmp0yzctDGXtnujUkBCBpOvdII7KiLosq7dV8YgcllDRacQa6IBdhm/rD5xvxqa
         I6HQ4v4X8GIooxRyne8Y6D1w3YjJT35jvVEt6UAE5eIBfMRO0ADunRWsIx8Eb4kUz217
         Xw1rMFt2tAJ8ID8pFDTiFuUf2GyI9oqSm5N39eglorweLWeZY0mZmKpL3TWTJ/5ZyGiI
         vBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tHsX7yALii/CDTw0qT+WGi2Hgune/f+IBczf+IlQvNU=;
        b=wRaQtYWMshVwCqvAAFSADkcaowuMpR8LkaXVTwou/qs27XWOurCWy61dQroXw2kZHI
         EMNZNdWX4YZ3vaQ/dREncr6keLdu14i2mQt8U6mws2101wPgCuXCgrXHSYn+6W+dfPcm
         mN1LMbuXBLskAb4c3gYPkbrJhRvB9FvQKUx8NTCiZnINRwJNX7xNUZWGyDvJtaYyxD05
         VQExa5RSPFRTydnEBHRoCUBSFaQw5BLkNT0wClgU6zRhwu3fuEln/i4/jSVCS6CmcHxs
         NMONFhJU+5nc3t/zW83rIsDEEPTcpnmW/GctgcoQwJzr03aP5hAkCDr1dfMATu52nxBe
         BgIQ==
X-Gm-Message-State: AOAM5313PuV/iUxL59aekjWaXF00OZiB7JbTO4VTG4cnAaLfX1nAwBm1
        NBu/EqzlqJZH/YA83whyO1V5dRf6SOgqu09z
X-Google-Smtp-Source: ABdhPJwXnmNNuUBgPRVzR1o61p+di1BIHxYUhe4phcti4gW2st24g32vJVzFWqm0ZliAvx0cZ/dEiw==
X-Received: by 2002:a63:1406:: with SMTP id u6mr5691763pgl.106.1633713350822;
        Fri, 08 Oct 2021 10:15:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a28sm3401196pfg.33.2021.10.08.10.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 10:15:50 -0700 (PDT)
Message-ID: <61607cc6.1c69fb81.54517.9a56@mx.google.com>
Date:   Fri, 08 Oct 2021 10:15:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.285-8-gae5c7d8cd6c7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 136 runs,
 5 regressions (v4.9.285-8-gae5c7d8cd6c7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 136 runs, 5 regressions (v4.9.285-8-gae5c7d8c=
d6c7)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.285-8-gae5c7d8cd6c7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.285-8-gae5c7d8cd6c7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae5c7d8cd6c77b7bed59a0fce82bb05e0a0243ba =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6160471e5173154f9199a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-gae5c7d8cd6c7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-gae5c7d8cd6c7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6160471e5173154f9199a=
2e4
        failing since 328 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616075f0c5b2be5cd799a307

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-gae5c7d8cd6c7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-gae5c7d8cd6c7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616075f0c5b2be5cd799a=
308
        failing since 328 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6160471a49b7642c4a99a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-gae5c7d8cd6c7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-gae5c7d8cd6c7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6160471a49b7642c4a99a=
2f5
        failing since 328 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616059870d7ef95e4b99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-gae5c7d8cd6c7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-gae5c7d8cd6c7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616059870d7ef95e4b99a=
2e1
        failing since 328 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616046e7b5a29413e599a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-gae5c7d8cd6c7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-gae5c7d8cd6c7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616046e7b5a29413e599a=
2f8
        failing since 328 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
