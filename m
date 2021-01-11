Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6672F172F
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388230AbhAKOCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730324AbhAKOCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 09:02:17 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05CAC061786
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 06:01:30 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 4so9559253plk.5
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 06:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UjVwudUdX66RAf0o9KtyZ8U+hy64YFjat6kgnt4wLyw=;
        b=jyjv1mdVi+TUdUVe7qogvX3bS9rpQ5+2ki4UBje0GtPbH4ycrdTEmsJajzCpXzNU9C
         49+Xi3vBODggVxAdix1EVyuyN8VLe3ZEbC9eJZmK201u8t2sGNAa5nT3YUSlY0Gxe06q
         Km5JFVJ8xWRenBNgXoQPPqMSHSzLzuIJLg2UhOBvm502rvRkr+Skkce+Hf4efmX80ebw
         WMVjvui+BjTJnTK+O/f8iKBOw5AjYlY0Zr811a11Vz56tkqFgm9ZHw/ssgzBjHADhi05
         4aZKQ+q9E61t9wbk2RuzCaY4koY8xff/fA4rajg1HVc1pRTuZeG3XkIqwnHsLkkPNCTR
         spCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UjVwudUdX66RAf0o9KtyZ8U+hy64YFjat6kgnt4wLyw=;
        b=Fw3kYjSQh0Hkf8RWdAoUPhSPAQJS5vtEbRAnSglcH+j/hrnpVnVGruHM+1klkDuNiJ
         /Pv44mhBZCFIB8cgfz1CToG/M77c9Cz2CdOcYWYVxv+36qk6R1njH0hEcK7pA+pbmd5a
         FTNcORRNqK5zToBKNaaijCjiGmdIMQ/yepRog0iji0u0wfjmoTNKwQez4r65LBiZ9a4g
         zQeFeMdSs5Vm9a0v+Lk8X54FHskVYdm634YJpVF1yeMvu4c9zOxyy+I3Ji61BO5f5Cae
         T1+KozJwyu2dtHZ4eFJ3QKA0bT41AviFE/6fUSuTLlblxtsfWnRbi/95onEOUFFqlk6M
         IH/Q==
X-Gm-Message-State: AOAM531eiV7QNgs6qCo+8v8gNRmuN2S2OFdqjbwAEwjsOjfexHhqGkiw
        FtmiUmuvvmwfVci564y5eNX34wDR5fSExA==
X-Google-Smtp-Source: ABdhPJywUmKjcRV+xREF0vKAPfMkV0NSEiq9na1FO0yb1oWuNWcFaVVgHMr3VNjxyDXKsST0WMt0GA==
X-Received: by 2002:a17:90b:197:: with SMTP id t23mr17955065pjs.26.1610373689675;
        Mon, 11 Jan 2021 06:01:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w200sm19095850pfc.14.2021.01.11.06.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 06:01:28 -0800 (PST)
Message-ID: <5ffc5a38.1c69fb81.26df5.8dfd@mx.google.com>
Date:   Mon, 11 Jan 2021 06:01:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.166-71-g94a0436ce07d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 157 runs,
 6 regressions (v4.19.166-71-g94a0436ce07d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 157 runs, 6 regressions (v4.19.166-71-g94a04=
36ce07d)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.166-71-g94a0436ce07d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.166-71-g94a0436ce07d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      94a0436ce07dea628bc38e4d5a7586680a85db98 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc263081e03927ccc94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc263081e03927ccc94=
cc1
        failing since 1 day (last pass: v4.19.166-7-gc896c168805bb, first f=
ail: v4.19.166-9-g84297b8c2cc7a) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc28a2b7cac73dd0c94cce

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ffc28a2b7cac73=
dd0c94cd3
        failing since 0 day (last pass: v4.19.166-9-g84297b8c2cc7a, first f=
ail: v4.19.166-40-g6f3d9bf0e06e)
        2 lines

    2021-01-11 10:29:49.800000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/111
    2021-01-11 10:29:49.809000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc2617fc303de8afc94ce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc2617fc303de8afc94=
ce7
        failing since 58 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc261ffc303de8afc94cfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc261ffc303de8afc94=
cfc
        failing since 58 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc260efc303de8afc94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc260efc303de8afc94=
cc3
        failing since 58 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc27b488ead25958c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-71-g94a0436ce07d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc27b488ead25958c94=
cc1
        failing since 58 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
