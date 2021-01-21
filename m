Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEF82FF3BD
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 20:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbhAUTD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 14:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbhAUSxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 13:53:54 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E22C06174A
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 10:53:08 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id m6so2079100pfk.1
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 10:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9S/RHGNCJIOpfQUqrI9KtvD+MlXmIsz0FSWnPdT0Jfs=;
        b=VxFE5KuO8QKwHTz58xKRIXIhgbJ8GX5lDTOHvt6VmqQm8es1ndByD+Lk1WU6L0WZHj
         m0njdcPf6QQskXwqJeERf/wi3ZmeikKMlKNP6J8rn0UGubLIig3d5bUKQ4Jmfhn5ydVB
         I/sf0hBLJ5de1pKK77pLYSEgP1IZClDVb6sbvK+z5vbptyTqAYrMLldtfUYtKg+d3jtP
         qB78pxrMVShDT23BGtSYjxu/4EFIfH6QuNvVne9LEtdzSzRc9phq3DAPd3i4wrPVw0yD
         I8nfYQbP29qpg+q/KwFevZD7h88f9DSl29tE6kvr4IZpDb3y8aSpyeheA1vAFxwWsqMM
         Z/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9S/RHGNCJIOpfQUqrI9KtvD+MlXmIsz0FSWnPdT0Jfs=;
        b=aI8AWApNnznv9/XNADNtyWtU/ikpvJRgX5TcIGJuwMbaudnnsFj3TGIxAm0aBPTOBj
         DB1VhOKpQTkoH5dGsJH4QJ1Ww0607+9vxbEvs6nCfc3FDL18Ykrkl0m7+nMv6Lr5fIq5
         Cqc/f7NUwsjQswbpnMS7jH0R3G5Qk58TZpInQ7Z/Ko183n520q1zDF+Gn5LoxqK4skDc
         m0qZHghAPKIYSRqLrpn1qA1YvduAsGmWaKodMLiv7R8dIaAIeQoERVoKD/wdv/J+Cc2y
         Q80Psw7h9BjTItf3w5kkswsdxlWAC0sWxwL2uahg7Y7cz7eqXTr/uICYFBJRjYxDpVr2
         Yibw==
X-Gm-Message-State: AOAM531f7E45ue1U1exy7aE8x0yfPw/g2BRsWlNrmuQPSYo4emvofNUY
        YWpUCI5cq/m+jINSLcSZ3iNk7yx9DGnwsjAC
X-Google-Smtp-Source: ABdhPJyisDN7K8pQTfgYy3qRErGXyrF9FqUQhVpjZky6ScE4IHSHT5vLt7aZ8iU47aOh28yEcrkYgA==
X-Received: by 2002:a62:d142:0:b029:19e:62a0:ca16 with SMTP id t2-20020a62d1420000b029019e62a0ca16mr868226pfl.46.1611255187559;
        Thu, 21 Jan 2021 10:53:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y16sm6429627pfb.83.2021.01.21.10.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 10:53:06 -0800 (PST)
Message-ID: <6009cd92.1c69fb81.93362.f65a@mx.google.com>
Date:   Thu, 21 Jan 2021 10:53:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.91-11-g621aa170498d
Subject: stable-rc/queue/5.4 baseline: 178 runs,
 5 regressions (v5.4.91-11-g621aa170498d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 178 runs, 5 regressions (v5.4.91-11-g621aa170=
498d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.91-11-g621aa170498d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.91-11-g621aa170498d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      621aa170498d2819c6640fc96aafebf4a5559cb3 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60099566e2e3269026bb5d0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.91-11=
-g621aa170498d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.91-11=
-g621aa170498d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60099566e2e3269026bb5=
d0e
        failing since 68 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60099de8e0154b078dbb5d2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.91-11=
-g621aa170498d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.91-11=
-g621aa170498d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60099de8e0154b078dbb5=
d30
        failing since 68 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6009956e9f3b64d35bbb5d0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.91-11=
-g621aa170498d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.91-11=
-g621aa170498d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6009956e9f3b64d35bbb5=
d0c
        failing since 68 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600995224f934f07f7bb5d30

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.91-11=
-g621aa170498d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.91-11=
-g621aa170498d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600995224f934f07f7bb5=
d31
        failing since 68 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6009951e6d6d00d287bb5d1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.91-11=
-g621aa170498d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.91-11=
-g621aa170498d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6009951e6d6d00d287bb5=
d1c
        failing since 68 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
