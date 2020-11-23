Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B522C10D7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 17:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390082AbgKWQi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 11:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390015AbgKWQiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 11:38:23 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD19EC0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 08:38:23 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id w4so14718752pgg.13
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 08:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9k/c5OUrADMHn//LFvjnw2tOeQoK0p83wyCJk7mRfio=;
        b=fQenJ22o1OvzM/1Knz5wQpgwECcczHOY5lBk9cmFKRw60PKd5N2ovxTCmR8JrdEIlS
         oTtol9ekkYCTeCgj4guxryMDOv/ppjkiYzd0jJx4OhNpHZdpT75g+wF9VMitUwGKcy7m
         JMK3UapiT6noaE60DPMOlODwFxM4LNyk9js97wpUlb7Lj6IQcj/ZUPQbGtuQ2S1tvmMY
         gMm3ie9b8cKeDBnoEFZLRe3gXEO91Sis9DsPNmAKdfQRADcvf6cukm7XzK4sfuF8e0sL
         +teemR/PceCD/f56xPS6hwxqK/h+eqkHcxcejr2W+veyMtZrsC+93Wdk5cGg734t0AQN
         iieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9k/c5OUrADMHn//LFvjnw2tOeQoK0p83wyCJk7mRfio=;
        b=mTjLei4ju3Oj01DIvmUxb1ByZcTmku1P66C2VkWjdTJOZY0tC94C+zPr2ajRMmQU0h
         oIj6XIX0Bh9hhVqejNacsh38BIQK78Ur1rT8ZoT+o99glBrM2Tz/10PCLfwgqU7Z+Jhp
         Uke0LAjiuZgkD50GbUySotvAkCzYCMqCA6/YImMf9JuwpLULf/qcadgTwXb8nMqfFEQd
         caxLpqSYPf4TOuqtxopQtBD/MkTw7Qrw+4tLERJwU9FUynjEI6Re7hYPTtPNzRRpgynm
         7vURyGmKix10BWF/PWKDdk7n6YodEhqVbl1HQd6Jg3XripLcCsHh5v0sx+81i2eudo2b
         sT4w==
X-Gm-Message-State: AOAM530tPz7Uccwy8RL+qb5uIReuxDpgYHcaDTd/+NKE+EKsSt6XkwW8
        lvUPwScl1FyaaGTwBUmhgXQddcLNsE+nNQ==
X-Google-Smtp-Source: ABdhPJzzL9puRWVuzKYfz1fEEdCo7krm5Da8IMj+1IAse+Ogy6C/hxd2lvb1GuIIiWFvq6hBHdoZOw==
X-Received: by 2002:a17:90a:2e8c:: with SMTP id r12mr629264pjd.29.1606149502741;
        Mon, 23 Nov 2020 08:38:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t12sm12191485pfq.79.2020.11.23.08.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 08:38:21 -0800 (PST)
Message-ID: <5fbbe57d.1c69fb81.e0e86.a3be@mx.google.com>
Date:   Mon, 23 Nov 2020 08:38:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.208-61-gc3391de31d51a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 142 runs,
 9 regressions (v4.14.208-61-gc3391de31d51a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 142 runs, 9 regressions (v4.14.208-61-gc33=
91de31d51a)

Regressions Summary
-------------------

platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
     | 1          =

meson-gxbb-p200       | arm64  | lab-baylibre  | gcc-8    | defconfig      =
     | 1          =

panda                 | arm    | lab-collabora | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig | 1          =

qemu_i386             | i386   | lab-cip       | gcc-8    | i386_defconfig =
     | 1          =

qemu_x86_64           | x86_64 | lab-cip       | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.208-61-gc3391de31d51a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.208-61-gc3391de31d51a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c3391de31d51a6a479f081994040a5fb99b29c9b =



Test Regressions
---------------- =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb39e266ba34e90d8d90e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb39e266ba34e90d8d=
90f
        failing since 122 days (last pass: v4.14.188-126-g5b1e982af0f8, fir=
st fail: v4.14.189) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
meson-gxbb-p200       | arm64  | lab-baylibre  | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb10711c74cdc96d8d936

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb10711c74cdc96d8d=
937
        failing since 237 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
panda                 | arm    | lab-collabora | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb2da2c2586b00ad8d91c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fbbb2da2c2586b=
00ad8d921
        failing since 12 days (last pass: v4.14.205, first fail: v4.14.206)
        2 lines

    2020-11-23 13:02:15.169000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/97
    2020-11-23 13:02:15.178000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2020-11-23 13:02:15.191000+00:00  [   20.220031] smsc95xx v1.0.6   =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb2c1fba4a6cf10d8d90f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb2c1fba4a6cf10d8d=
910
        failing since 8 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb2c623c69b4f46d8d912

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb2c623c69b4f46d8d=
913
        failing since 8 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb2b61974a285e8d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb2b61974a285e8d8d=
8fe
        failing since 8 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb27d56842befebd8d966

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb27d56842befebd8d=
967
        failing since 8 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_i386             | i386   | lab-cip       | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb2830ceb67a69fd8d90b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb2830ceb67a69fd8d=
90c
        new failure (last pass: v4.14.208) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_x86_64           | x86_64 | lab-cip       | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb1eb78b95756e0d8d905

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
08-61-gc3391de31d51a/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb1eb78b95756e0d8d=
906
        new failure (last pass: v4.14.208) =

 =20
