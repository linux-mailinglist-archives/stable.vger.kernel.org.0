Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C4C382948
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbhEQKDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbhEQKDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 06:03:10 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68310C06138D
        for <stable@vger.kernel.org>; Mon, 17 May 2021 03:01:34 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id w1so1924452pfu.0
        for <stable@vger.kernel.org>; Mon, 17 May 2021 03:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5N0pjLwj/3onP0GK9sugZ7JELafNy09kr3043jkEVk4=;
        b=cCIIN5h6jvOhrNW0F8Yrh+yvJhughRJzvuiCEE/Kms/QJ5hZXi3TbLFdsh6nKrdQqp
         em/ZifP3yfbjuJFTw/HzxM0G860RGrLszaWF6nysverwglKCZNauNEeLaWCwZIm52wJI
         g0MlW5kycAklycQufWat2QWeYaUmIlw/UF45OVmTLe67aHLRaQtn2NFBxgslzN8qbJGz
         tkhR97a+RSnauCum+ZAP7No77tuus5JFd/PtwJtaCWBtuhPdHRAntP6fcwVZdh5JgB3Q
         gAfH4z/HO+Tg4l8W9flLJCAGqntkD2tFxnYk6IMlitlh15a1BiiueqHv4MJQY8IPeiOp
         hurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5N0pjLwj/3onP0GK9sugZ7JELafNy09kr3043jkEVk4=;
        b=JXTPDUZ/Xe3x2nLSuUcd3tFggMybmDviy5wHyv4u6qhW0DOhdAQH+vSh4cNhDTQ9Vn
         xSvxwyCQHuStYvZoDV+0u7+pqZSBOHxF0xBzuNrsmvm6uXjp3am5tqEpl19wcUckc8m1
         8It+YXyNEvCEuPALAUWLbmEzeBWbVT7Eh371OHnM1XxlSK/r02XbP+N9AvmFcyE7NOLu
         s+H4NjZKOssvBkPgPTwWhmTP08c4Np4h7fa0vhbLXC4z23L4G5efIQBnLYF/Np5umVY+
         t4UE71kHs197X/KlT4oCc1V2+M05VJ+L44iPyS8taAtcqNTO9WXLJRaFTf5sZ3wn3ZGl
         bPEA==
X-Gm-Message-State: AOAM532NnfdEneNtNC9h/z4lcPkQk7OVXkoejEngW02YbbCm9YS6/qpU
        ziabnhF+A2ohbAhI8tNDs31XWpeqbK8x8Uk9
X-Google-Smtp-Source: ABdhPJzYa+/v6WbkIsXLGHcvsaI6pVIb9rDZSBZBjG3ficXNbF6twrTpUcDyZPdInUS0rwjvWtj20A==
X-Received: by 2002:a05:6a00:238d:b029:2bf:9f4e:7069 with SMTP id f13-20020a056a00238db02902bf9f4e7069mr39136092pfc.28.1621245693204;
        Mon, 17 May 2021 03:01:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t141sm6783201pfc.3.2021.05.17.03.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 03:01:32 -0700 (PDT)
Message-ID: <60a23efc.1c69fb81.11ece.613e@mx.google.com>
Date:   Mon, 17 May 2021 03:01:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-285-g3efa1f26d219
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 117 runs,
 5 regressions (v4.14.232-285-g3efa1f26d219)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 117 runs, 5 regressions (v4.14.232-285-g3efa=
1f26d219)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-285-g3efa1f26d219/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-285-g3efa1f26d219
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3efa1f26d219ae1e680986fbbac60e78b16b4c40 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a20a87fd4b985f02b3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-285-g3efa1f26d219/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-285-g3efa1f26d219/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a20a87fd4b985f02b3a=
f9a
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a20a51dc24d647efb3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-285-g3efa1f26d219/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-285-g3efa1f26d219/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a20a51dc24d647efb3a=
fa9
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a20a76696977e3d7b3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-285-g3efa1f26d219/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-285-g3efa1f26d219/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a20a76696977e3d7b3a=
fbf
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a20a0799622f3a94b3afcc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-285-g3efa1f26d219/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-285-g3efa1f26d219/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a20a0799622f3a94b3a=
fcd
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/60a20a6d5dff3d160ab3afcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-285-g3efa1f26d219/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-285-g3efa1f26d219/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a20a6d5dff3d160ab3a=
fd0
        new failure (last pass: v4.14.232-281-g5fe9dd19d1d1) =

 =20
