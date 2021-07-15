Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D222C3CAD85
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 22:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345224AbhGOUFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 16:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345077AbhGOUFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 16:05:36 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218E1C05BD12
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 12:50:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso6196356pjx.1
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 12:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AlYfhIJGpQs+3s95YtVD4scmX+PXsjWy0Rqeu4svdds=;
        b=KPbjmhIDPoKlP+JDFBCVDois9s9mqFt2EL2HMxrV8dS416hXsvL4jqhMNZ+f3M9skd
         EUX/OxgT8EJbB7UJqmbQn/KcOgrIQ6d+25ObD9r/XnXdce+wYES4axJYFHFqLc//oFEj
         3DG2hZHfuWO5PqCRKt376KUDunBYSo8nS/3Cf7AZkmNWH7mp7XGYwXyArN60x9hjTEnq
         +/NTUjb6+lP0aYZSDIVIHUsdvCnSA18Oa1anvsViONCojfqjw2E1v/5rvMMKACR3hKMj
         fstXPxqM6z7gV7qctKJMNaV8udyFvuf6g9fmsJhDiZb4MBVdV/JoisNN6LL9qbfNv6b6
         V5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AlYfhIJGpQs+3s95YtVD4scmX+PXsjWy0Rqeu4svdds=;
        b=YMYHXE/SI5SG+HkJH8IhfciNTYywlP5mkxhENT+vS0XVJXU71TjUY0VvTGQw6rCuV8
         q5H0iAY+I6qiwzrHO5d/xVJuxFzlOXjSwJ0dpon8e/r9oaVBu20poiUlVkET1544VGbH
         25QWrG2Q91iS5pRPiphxsrJvQtCPyv/fGXtqhmmQ9Y+cP1HjLCpynA2YVWxSOZXVI7AD
         jPI4KkKLLqd2iDVgvdVn4fwl2iqQTTr5r5JW7Zun59mmRKX7nwcflfeorgVrWocgtYrt
         p4Opvl3d+AMnwhpPmq2RQOkdVbeOvYCcBWw9+EVli7cRZx44dhXaN29sMWDbr+J5yWgC
         w7Yw==
X-Gm-Message-State: AOAM531SQl0H0XzDXypsK5I2jp0dG1nQjFTMqraK0CW7+YZ3SLH0ZL0d
        i+HWGhVhpn4Eu94krqz3Gl7vE0z1hmHrbr8k
X-Google-Smtp-Source: ABdhPJxMVaWdSUEQaY2C0qySRCvMXCxMfCtbY8pnMKFNDbV5WRNyRriLsnVZLnmb+vUxzsrHb5+pFw==
X-Received: by 2002:a17:90b:4a90:: with SMTP id lp16mr5807790pjb.137.1626378628714;
        Thu, 15 Jul 2021 12:50:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v14sm8320982pgo.89.2021.07.15.12.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 12:50:28 -0700 (PDT)
Message-ID: <60f09184.1c69fb81.4b8f.9e75@mx.google.com>
Date:   Thu, 15 Jul 2021 12:50:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.275-142-g98e9af4e7b0a
Subject: stable-rc/linux-4.4.y baseline: 129 runs,
 9 regressions (v4.4.275-142-g98e9af4e7b0a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 129 runs, 9 regressions (v4.4.275-142-g98e9=
af4e7b0a)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_x86_64-uefi    | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.275-142-g98e9af4e7b0a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.275-142-g98e9af4e7b0a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      98e9af4e7b0a7f74d69a27ccc30e5edd25f3d7c2 =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/60f05fec1d10c12a818a93bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f05fec1d10c12a818a9=
3be
        failing since 243 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/60f0600e207cafce8a8a93bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f0600e207cafce8a8a9=
3bc
        failing since 243 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/60f06008131cc4e4448a93d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f06008131cc4e4448a9=
3d3
        failing since 243 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/60f06008207cafce8a8a93b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f06008207cafce8a8a9=
3b5
        failing since 243 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/60f05fead300e45feb8a93d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f05fead300e45feb8a9=
3d7
        failing since 243 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/60f06021eb908ebd128a93a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f06021eb908ebd128a9=
3aa
        failing since 243 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/60f05fe91d10c12a818a93b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f05fe91d10c12a818a9=
3b5
        failing since 243 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/60f06006131cc4e4448a93cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f06006131cc4e4448a9=
3cd
        failing since 243 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_x86_64-uefi    | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f060aefb466e963c8a939b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-142-g98e9af4e7b0a/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f060aefb466e963c8a9=
39c
        failing since 0 day (last pass: v4.4.275-94-g308b18533d01, first fa=
il: v4.4.275) =

 =20
