Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842DA3A09B7
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 03:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhFICAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 22:00:21 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:44768 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhFICAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 22:00:20 -0400
Received: by mail-pf1-f173.google.com with SMTP id u18so17166688pfk.11
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 18:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wMKVxMK2PiUEPlXj/kpAcVr+oiRTDa3LaO5+/hblroo=;
        b=VQpk/5Z9nCvYs4kaIOs++nhuYXymb29DZ0m3AMQ+3b3AaRRLCmcWbw5qTdH6TrQukw
         KwTLJavF/ZGOQ7JNUlv/28k1RoIj+ss4n3rbtBC3vUzLY546Qcz9NaNirt/GPvbrE2hP
         Oiv6f5SPidPXcCQOsqVwzeYrW4f3aZU5IZgY5EVcln27ta3VYBCbIhLunPmHE7s6ylcW
         aeZMwaQEZMjoP/SfyphA1Z9r6RbkvOSjqIvviR1HGMfZEXJ0M9vI7z/0Pq0hxRNWiBpM
         aLoUCEET2XWyqESfEb1WTioW8ZnBh+wdtCR5a3/YOJhBXopef8eai1d/xKGnHKUn3qtS
         jSCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wMKVxMK2PiUEPlXj/kpAcVr+oiRTDa3LaO5+/hblroo=;
        b=O+M0rsb3A3k8dayHs9LSc567R7wZTe5X5KO7QDuDyKl+5CQNNM1/NQsWDZNy2tmFDs
         qvalmlR/qSCQIn+9tg150UFohKZV1L3Sgn/HcvVOGgoPV/c0wnBQlOEWw13cYVpMZ7Ia
         0BgWsIAp+Uy8+6rjIPQ7sdfarWbSdvju8plN8CR+pBMbjv32M51+e17WVzfbk5ekf9Sh
         vE/vmSweCabKjZcQD8KQEPbE6E2ABspWuj895Zwk6ob5W4fnwVyp9xQNx6VLJar5VS31
         DbfpRGn3zlKv/l9OpvIPQFtuqNllw3IkjOzpTI2tRR1f2HU89HOLURmE/NzpCVe77soQ
         urGg==
X-Gm-Message-State: AOAM5302vgLQe9Ugm+hHCTI8/jhnxZSosX6ueFg6PhHh9nlEhMN8mIXN
        rpKWZIMhsbnbMJkTHcF17g7P+2R4houFgdZh
X-Google-Smtp-Source: ABdhPJw15HzyePpZ8GDq7yMNSighUWHN5gJkv1sBsPEGxxGXj1gaHXtDVSU+ctD/AXlZDcMYw8wIKQ==
X-Received: by 2002:a63:7702:: with SMTP id s2mr1285337pgc.106.1623203831810;
        Tue, 08 Jun 2021 18:57:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l201sm11766487pfd.183.2021.06.08.18.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 18:57:11 -0700 (PDT)
Message-ID: <60c01ff7.1c69fb81.31b56.4e91@mx.google.com>
Date:   Tue, 08 Jun 2021 18:57:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.271-24-g1aa9f2da3002
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 103 runs,
 9 regressions (v4.4.271-24-g1aa9f2da3002)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 103 runs, 9 regressions (v4.4.271-24-g1aa9f=
2da3002)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_x86_64         | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.271-24-g1aa9f2da3002/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.271-24-g1aa9f2da3002
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1aa9f2da300268ec8eddf371b698eb77dd21960f =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfeebc40cdb688dc0c0e0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfeebc40cdb688dc0c0=
e0c
        failing since 206 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfeffa5b517a24f50c0e06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfeffa5b517a24f50c0=
e07
        failing since 206 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfeed3a08ade63520c0e09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfeed3a08ade63520c0=
e0a
        failing since 206 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c00a919c7836c8c70c0df9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c00a919c7836c8c70c0=
dfa
        failing since 206 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfee45736984d8fd0c0df5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfee45736984d8fd0c0=
df6
        failing since 206 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfef5a251463526a0c0dfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfef5a251463526a0c0=
dfc
        failing since 206 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfee5b736984d8fd0c0e07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfee5b736984d8fd0c0=
e08
        failing since 206 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c009719473d3d4e50c0e06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c009719473d3d4e50c0=
e07
        failing since 206 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_x86_64         | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfee1b08450db7dd0c0df5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.271=
-24-g1aa9f2da3002/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfee1b08450db7dd0c0=
df6
        new failure (last pass: v4.4.270-65-g1c2a0157411e) =

 =20
