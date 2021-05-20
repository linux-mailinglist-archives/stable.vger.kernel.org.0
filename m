Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC1338B432
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhETQ2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 12:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhETQ2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 12:28:13 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A78C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 09:26:52 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso5578691pji.0
        for <stable@vger.kernel.org>; Thu, 20 May 2021 09:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IfKtpQU1jK5Z5FA/cqnuhl7aBVkUH7wOlyyZzIao5Ko=;
        b=Rs4B+ecYBezP6G+ylPfJGChzfj6TQT5ZdZ7/syn60nqrS/YIzSW2o8fMAhVTv0BpKJ
         +0PKKLP/UPgtEDuwb+43OootsGYJAAu+Fcp0H5+FbUU9C0xeLWkm6+BuppdMCOIWqaTE
         PQJARPr9m6QzJb7Ms6IKVqRhQo3i6cS0BtdBcQyx1EGQT76ER9JovU+ZcnPoHvLfkr5H
         b0OzGs2DflnKhIOWKFOBUYvVoypHF2kno6tgPREFXvYO2NnwmqCapwkfEarDIXtqSRxM
         3xaXzQNhHeE1DDhXG65w5ic5dlczcO+OniCipOotjm1mwueyZnx+dbk8pLTgLjtbMZKC
         dcfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IfKtpQU1jK5Z5FA/cqnuhl7aBVkUH7wOlyyZzIao5Ko=;
        b=WpIx9a8V0VNTLdMgrFQF4FH2/AcEeb3jT6PjzO226K3IZ46JVbSMRt7bbZqXJzQXzV
         OQ3qn+xBaaSnJLKdAfihkeHsMoIFTZ1Vw5YIF3OHAJGlfbgq2tI1eSZ+YvXkKZAECrQG
         n/GHL5t1JzKNbzMs4eszZJSNdeZgYOZj6c5JEhKB50keMOHR53PEsKyWJ2yexDTndGx5
         mleoGtL4DHV8TQEaqqcXRWlHzEjGniYMo/cuzEc58Xd82Z+jLiwdMkoGF36my6ZnZt4o
         KhAubfkoLvCmHI8CstRtpO56Cj+xCOmDVNjKFDBN7nDFsTuQpkBLSDVBfv9xW5VdzXCy
         3dsg==
X-Gm-Message-State: AOAM533Tq5lYMPcTze6xXXH/8UEATMoPd4M/Mr8CfmriFleszAHY2f+N
        JGg/PvTaLBlLGgz02z5PP4yiuQwwrvgjPFrR
X-Google-Smtp-Source: ABdhPJx9Jj6ujhr+/S2sZaA4fO8iV6DLdLujYyA/ZG2Zs3JuETb8b5DA5Zxlh850jpPL/3eyRcO8YQ==
X-Received: by 2002:a17:90a:3041:: with SMTP id q1mr6021912pjl.191.1621528011391;
        Thu, 20 May 2021 09:26:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o186sm2218356pfg.170.2021.05.20.09.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 09:26:50 -0700 (PDT)
Message-ID: <60a68dca.1c69fb81.1b537.7a46@mx.google.com>
Date:   Thu, 20 May 2021 09:26:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-239-g085f0a1015d5
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 103 runs,
 4 regressions (v4.9.268-239-g085f0a1015d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 103 runs, 4 regressions (v4.9.268-239-g085f0a=
1015d5)

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
el/v4.9.268-239-g085f0a1015d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-239-g085f0a1015d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      085f0a1015d5abc900c6b3bfe88450c6b6a33191 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a65ac0b180112d4fb3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g085f0a1015d5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g085f0a1015d5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a65ac0b180112d4fb3a=
fa8
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a65ab4b180112d4fb3afa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g085f0a1015d5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g085f0a1015d5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a65ab4b180112d4fb3a=
fa2
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a65a974edc52f236b3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g085f0a1015d5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g085f0a1015d5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a65a974edc52f236b3a=
fa9
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a65a74fc82436dcab3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g085f0a1015d5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g085f0a1015d5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a65a74fc82436dcab3a=
fa5
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
