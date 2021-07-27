Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7933F3D7876
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 16:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhG0O1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 10:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236623AbhG0O1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 10:27:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30914C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 07:27:42 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d17so15917298plh.10
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 07:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ER1c5J982BaqcwyJ+0fCRSvWg+75+adPYrsoXVuLHL4=;
        b=qqkKdTkDq025MYR1heYxVkQ67U5OGNJzNwBqqvTJpNdstbRfZEi3WJiXIYMLs+Rjac
         2dOjzvubnPukhwb8o6Cgue4qBpa8a9Q5BjhgFnRhomqPninLqIkF62/hoHNtrarvHw1R
         Or5fVvhyvTOcJSjfzyD+pVrO3YEOjZYK8cF1AbuMz3Y1pb1KKrOvM/0xtbzGPyo1FaUI
         K8/rJ7I6jy50yYFh0X9TV2vlb7v9fc3yDf+H6XnMuBIR/52nYwkMIm7K2n0/30iHpGSS
         jacCBuk19ZpmSvAvw43cNm6V7i/huilKqMUbAqk+HDKPAngajJ9X/Ao9Tfpks1wn5WEY
         t5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ER1c5J982BaqcwyJ+0fCRSvWg+75+adPYrsoXVuLHL4=;
        b=hFsnkA+HVUCVnsDj5Svcwy+yAVJR8nsS2MIfifjH5ACjtPQsQPPMoFkX/XDzIHwkPB
         gXgH6hw0N8YxiprpqnvqxyX6lSaYNg1dDr6izJ51zXiyLXHDYq0eP6zYzeGyAaEtQYNu
         Qf0CvnT8WCztzC5+vHJ21QqpoPSdLN4Tzxx5k/jSbxpuDw87dJCPEvl3Zi2DIgqfiS8R
         EOkng5YP4PBLrtMowoezFGlPpm0FQhxtUpjVM0iQtTRe1+Q9I1sFVuFL5Xn1JNDnk4iQ
         yWwteGUlX96X/LG7glXWmeI9ZyBwX9sC218aFMReGrAUKukxsJXGIj82ZDvsMSAAeE5o
         u0vQ==
X-Gm-Message-State: AOAM531Yk6zbfRLGjBFs9jpZ4sKyeeVzTMjGwqZHQ3OAnJaSlVeB8MP6
        F3xPsoA4uah2iDRJXZIGFgl+i4zbEgbBHEOU
X-Google-Smtp-Source: ABdhPJzsTlYWYC5XDRN9skfCCmLWZCf8qTNMv6xuCsAWpJ0i1hl35dIn5aTmdo2kYMUo0n7gQ5pqpw==
X-Received: by 2002:a17:902:7689:b029:12c:1fe6:c0e6 with SMTP id m9-20020a1709027689b029012c1fe6c0e6mr9340389pll.73.1627396061617;
        Tue, 27 Jul 2021 07:27:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w22sm3905269pfu.50.2021.07.27.07.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 07:27:41 -0700 (PDT)
Message-ID: <610017dd.1c69fb81.3801f.b9bd@mx.google.com>
Date:   Tue, 27 Jul 2021 07:27:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.276-59-ge7069404d897
Subject: stable-rc/queue/4.9 baseline: 142 runs,
 5 regressions (v4.9.276-59-ge7069404d897)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 142 runs, 5 regressions (v4.9.276-59-ge706940=
4d897)

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
el/v4.9.276-59-ge7069404d897/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.276-59-ge7069404d897
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7069404d89785d5cceebf7850c34c5bae067cdc =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ffe351b0b432e72e5018c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-ge7069404d897/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-ge7069404d897/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ffe351b0b432e72e501=
8c2
        failing since 255 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ffe74bc148d4b6bd5018cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-ge7069404d897/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-ge7069404d897/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ffe74bc148d4b6bd501=
8ce
        failing since 255 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ffe3555cf061382f5018c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-ge7069404d897/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-ge7069404d897/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ffe3555cf061382f501=
8c2
        failing since 255 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ffe2ee73976d56575018db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-ge7069404d897/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-ge7069404d897/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ffe2ee73976d5657501=
8dc
        failing since 255 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61000c621096a47ce75018d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-ge7069404d897/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-ge7069404d897/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61000c621096a47ce7501=
8d6
        failing since 255 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
