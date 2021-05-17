Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4595E382CC8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 15:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbhEQNEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 09:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbhEQNES (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 09:04:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48A0C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 06:03:01 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gm21so3626106pjb.5
        for <stable@vger.kernel.org>; Mon, 17 May 2021 06:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p8SeghO0jVnPYXKrpWmzePYCAfuiFRw0KDVj6FNpwZA=;
        b=folmMQD0y8DTgRuwpqKdlFqn9eXqP4zkphsnFTXg7ocKwkLkYE3NPfGpVRcM1AQAm1
         05077+JMksEnE/XHzAwiy56u6Bj0+VGRvWUNpWkUOAj42lHLvWW2rCktJjW0t3t3jZSV
         WkZ/JQJ0Tjg9ja3LhCDgVSU7rDbZxaORdnZyg3IAQRG/BVWH4VWgfZB5rfQ7aVh8FW7W
         9t+dG/0tSeU56BoTZP4t+O3uDM4dWLVUfOTASQzMFgllSh+415+f651UBKMatCr/MVb7
         RUXJKshxkmrW21ZUCajTKEgoAOdj/6ui3XrM37BjruqZlwh91x1DgBxO+4Jhexi4qFW0
         Uqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p8SeghO0jVnPYXKrpWmzePYCAfuiFRw0KDVj6FNpwZA=;
        b=m9qH8npfsQVfnErH2d2FPI/S15qTznNWhqyjUTXoXis+1skQ3zPv+PyLZowiIlPZAA
         N+TP6moHA1EOLqK49YgYiMWRLFMErBJ2o96QdAy/yNqmH2ja6PzoPX00G69HZEK0V384
         6/UC85MpZVHtJyU6uKLQ1zGPwLBc10k/jwdUR1zGBIOycY3Oz/fQsteobuXKWZb0Y0Cw
         O6N7nYWeRBwIAvTltnEL0fRTO2+5hr3QMr8rfQ4tV0TEpCzydVbHWqSzimyyADUzKEL0
         ZxLarkhv9BEtJHIXvOMmyomo5jseB8fIIEZDbzMCq7LDqa2ySTJbGTvEQt9b2kgylImW
         JyWw==
X-Gm-Message-State: AOAM532DIv4M2ojW3Ee7V2TNDgviQp7w0yePlzJ/MRSzhB6QZ3TONEHi
        4pffZDjWO4oOHGN4LjCOShIejWzDlkyUS480
X-Google-Smtp-Source: ABdhPJxT3/uW/kpgi6rUmW28dPTpwWV3Y70fdXPy0xtwt4Jzqa8NWHck2jN2OGXTipkzorI1Xt4mjg==
X-Received: by 2002:a17:902:e850:b029:f0:baa0:19ea with SMTP id t16-20020a170902e850b02900f0baa019eamr12501225plg.47.1621256580991;
        Mon, 17 May 2021 06:03:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm4571283pjq.5.2021.05.17.06.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:03:00 -0700 (PDT)
Message-ID: <60a26984.1c69fb81.58be6.df9d@mx.google.com>
Date:   Mon, 17 May 2021 06:03:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.268-166-gc9c590ffcb0a
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 73 runs,
 7 regressions (v4.4.268-166-gc9c590ffcb0a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 73 runs, 7 regressions (v4.4.268-166-gc9c59=
0ffcb0a)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.268-166-gc9c590ffcb0a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.268-166-gc9c590ffcb0a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9c590ffcb0a7c239e8ee7acda9c95dd1a3ad723 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a23879ea5dc0c83fb3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-do=
ve-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-do=
ve-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a23879ea5dc0c83fb3a=
fbe
        failing since 18 days (last pass: v4.4.267-33-g78d632f91b0e9, first=
 fail: v4.4.268) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2386dea5dc0c83fb3afb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2386dea5dc0c83fb3a=
fb8
        failing since 183 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a238742a1821db9db3afb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a238742a1821db9db3a=
fb7
        failing since 183 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a238790285e296f6b3af9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a238790285e296f6b3a=
fa0
        failing since 183 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2386c0285e296f6b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2386c0285e296f6b3a=
f98
        failing since 183 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a23873c992f359e1b3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a23873c992f359e1b3a=
f9e
        failing since 183 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2387bc992f359e1b3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-166-gc9c590ffcb0a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2387bc992f359e1b3a=
fa4
        failing since 183 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
