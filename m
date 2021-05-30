Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480023951E9
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 18:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhE3QFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 12:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhE3QFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 12:05:39 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269CCC061574
        for <stable@vger.kernel.org>; Sun, 30 May 2021 09:04:01 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b7so4010696plg.0
        for <stable@vger.kernel.org>; Sun, 30 May 2021 09:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u5Em/8IwpK9eWG8BiV3i1S4VOFPMoosSvN5IqHESFZY=;
        b=xlTqi0ThW90Azi7U9RegQyMWoEHMQWT7pRXumFfsrU2ZWJcjIuHooEMqaMt9fLnvOF
         VCKPq/7lSFxH2rWaV7pFYlpa8haC7qeL+7Gau7K7DfJbmugaRF7fzoiSzqaiXenc/IGe
         vVCBgMnVT4QHPKy1Q1shrgl0g34YzgGKJ1Ls9wfjiLAG9uvTwKKTGINkGrumw9vd9TqK
         jHo+jfN7mwg8c8hkf6HtW0bj3wryh7Q6X4L/NVRB9bAl4hDqPFUFfZKKltPSYqaOaZaW
         zI7it1PWKrmR0voPIGVn/LQ/cVQzw9YMK7TGV5lFWEG6H9J05Tfgj94fIEm43qrcouA0
         7Jlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u5Em/8IwpK9eWG8BiV3i1S4VOFPMoosSvN5IqHESFZY=;
        b=HSOauZ5T37io1SK0HkRG5bVK/FM/bhWV57C0DNJXEe8tIyJaI1N8kpqcqBFDsnlC3O
         g7lvzz7pLCigcOl+5rO/jaObA6ZJ277F60KXluDtrH4WXYMSPpvW6/ZF6oWnWIYr0MaR
         s+hs2Cb0UBONvDQzYp+A8KLCs73obB/IPW3ELCkpB9Uh1ZTbHauqH8t5XV+XVVRqdAM6
         40/a0EsXJLQACdylxZfmbztOD7GjisUUdJ2Zt/eeu3uPvGDXq1dQ59XOP+eA3ByBeU8y
         2YsGYR6TarsJTCgm8Em9Ns1AMPxBobtbW/YFzKUv5ZwEXEGnBMJnG+LJYJrUuph/rMU8
         lz4w==
X-Gm-Message-State: AOAM5321GVbid2n6mmxuSuW1FukEcQCaA+MzaGTBWHFGlJVs1sa7ccY8
        +H9RDZLpM0xHmMlw0lQURABaScvLhCPpltCF
X-Google-Smtp-Source: ABdhPJzxqUE+ohj+CpbdTMNApqzaygyt2Op/VhnOUay/IFa8zlrlkKkfm5zvIB8cXU5BMsPyJvr6uQ==
X-Received: by 2002:a17:902:e8c6:b029:103:267f:a233 with SMTP id v6-20020a170902e8c6b0290103267fa233mr4514438plg.33.1622390640168;
        Sun, 30 May 2021 09:04:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x21sm8802276pfr.124.2021.05.30.09.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 09:03:59 -0700 (PDT)
Message-ID: <60b3b76f.1c69fb81.d3edc.ce5f@mx.google.com>
Date:   Sun, 30 May 2021 09:03:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.270-18-g8bd4a2fa3f2b
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 117 runs,
 12 regressions (v4.4.270-18-g8bd4a2fa3f2b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 117 runs, 12 regressions (v4.4.270-18-g8bd4a2=
fa3f2b)

Regressions Summary
-------------------

platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_x86_64         | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi    | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.270-18-g8bd4a2fa3f2b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.270-18-g8bd4a2fa3f2b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8bd4a2fa3f2b2d970789d58b7f4710d1d7b31d75 =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37f094c82166fb7b3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37f094c82166fb7b3a=
fb2
        failing since 197 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37f58faebff5ddbb3afac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37f58faebff5ddbb3a=
fad
        failing since 197 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37f19b746ec04acb3afd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37f19b746ec04acb3a=
fd5
        failing since 197 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37f14b746ec04acb3afce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37f14b746ec04acb3a=
fcf
        failing since 197 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37f13b746ec04acb3afcb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37f13b746ec04acb3a=
fcc
        failing since 197 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37f08b746ec04acb3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37f08b746ec04acb3a=
fa9
        failing since 197 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37f44fbee0c2829b3b000

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37f44fbee0c2829b3b=
001
        failing since 197 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37efbad73edd540b3af9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37efbad73edd540b3a=
f9c
        failing since 197 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37f13b746ec04acb3afc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37f13b746ec04acb3a=
fc9
        failing since 197 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37f12b746ec04acb3afc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37f12b746ec04acb3a=
fc6
        failing since 197 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_x86_64         | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60b37fa8957d27f464b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b37fa8957d27f464b3a=
f99
        new failure (last pass: v4.4.270-9-g199ccd881cf3) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi    | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60b3803446d4dc3058b3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-1=
8-g8bd4a2fa3f2b/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b3803446d4dc3058b3a=
fb0
        new failure (last pass: v4.4.270-9-g199ccd881cf3) =

 =20
