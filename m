Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6052DAAFD
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 11:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgLOKgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 05:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbgLOKgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 05:36:39 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672BBC06179C
        for <stable@vger.kernel.org>; Tue, 15 Dec 2020 02:35:53 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id c12so14461845pgm.4
        for <stable@vger.kernel.org>; Tue, 15 Dec 2020 02:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sdxUxAuEjumIxTLv++8T7HvFLjIFemBgCl0OI477jgo=;
        b=vE6uhXeVwzTpww/827ykKMD2bniau7WfnMg60X3T50NKSOfriflno9aH4knDMKSwSs
         XKRnkCVnVAfh1wO3x6NjIUKzwB0B/EJrYVhJ9NmAAKUtntILD7HXNbEhsT6tC5C6xmU7
         69HVBC2aBolpE8PF+fxMKPqQvdvsQyEM8ACFla9NBhUpUZZNdakBvMxkjVgL6UdSGwXc
         WYoUy5NiumDqq9po7KIvpFFiAPOMOmmcX2GL8Kp8rgIwB0E1G62gP+ZuN7PNhRCD/Otp
         Cznf6OkRWUGgLVQ2gXxe8fnNBYPj6uQo9N6ilzkQgUl0KglxS6xXqwx3WCyMYUIhf/Tn
         AV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sdxUxAuEjumIxTLv++8T7HvFLjIFemBgCl0OI477jgo=;
        b=LPNBIZUrxgefywBIXJeVo2zSJRfqJeLJFkRLEUikOup7pbTkcFT1cSDFvDi2GuyX/R
         iSGbYjFcKYK5MT/k5tMzsUI+7VXozJbLgKOu0xql8qNaOLQ4P2fn3jiQeELARGGs6fdj
         QygUWMizloSwPO6qhpySf36TYwUZSvq+HliliQEI0VbYtfeNJduZyzYR+3qvXznBYLAt
         lFQGycEFht2zKXhjRZsccLbxswD9gBL4H/KXJjRGTm+mL3XGyvDvlADnQM+8/Mftr7nu
         ux+Cc9i2+X00lOLO8zxslrSvVYrYFVC1dpP7HW3dmUvBj+xB/ihXMyfCRJmVKzBjwlCi
         IpcQ==
X-Gm-Message-State: AOAM531+RO2Ev4gjb+/VK2TMFaufiDNgE2UVf7pkSVeWWi8Rd18RSh0g
        5cMBWi1ecG9V0RKaJm5yzXQUI5E2Qxdt9w==
X-Google-Smtp-Source: ABdhPJxYbjxB43csNqtoYWbsdzYUCk2auHX3SSyjCcwG6sYi5vM/NFvIXAm51H1CF/kYh8UKYAoHIA==
X-Received: by 2002:aa7:8499:0:b029:19e:6c5:b103 with SMTP id u25-20020aa784990000b029019e06c5b103mr304449pfn.13.1608028552525;
        Tue, 15 Dec 2020 02:35:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 198sm9022995pfw.29.2020.12.15.02.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 02:35:51 -0800 (PST)
Message-ID: <5fd89187.1c69fb81.ccc86.61ef@mx.google.com>
Date:   Tue, 15 Dec 2020 02:35:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-27-g777e215ff3fc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 64 runs,
 6 regressions (v4.19.163-27-g777e215ff3fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 64 runs, 6 regressions (v4.19.163-27-g777e21=
5ff3fc)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

meson-gxm-q200             | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 2          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.163-27-g777e215ff3fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.163-27-g777e215ff3fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      777e215ff3fcd69d71d9fd0192b9b4a889fcd675 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd82a8a58b4caceeec94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g777e215ff3fc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g777e215ff3fc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd82a8a58b4caceeec94=
ccd
        new failure (last pass: v4.19.163-16-g4065dd9e0ea73) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxm-q200             | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 2          =


  Details:     https://kernelci.org/test/plan/id/5fd82a5ab42c8ef9a4c94cc7

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g777e215ff3fc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g777e215ff3fc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5fd82a5ab42c8ef=
9a4c94ccb
        new failure (last pass: v4.19.163-16-g4065dd9e0ea73)
        8 lines

    2020-12-15 03:15:33.883000+00:00  kern  :alert : Mem abort info:
    2020-12-15 03:15:33.884000+00:00  kern  :alert :   ESR =3D 0x8600000d
    2020-12-15 03:15:33.925000+00:00  kern  :alert :   Exception class =3D =
IABT (current EL), IL =3D 32 bits
    2020-12-15 03:15:33.925000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2020-12-15 03:15:33.925000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2020-12-15 03:15:33.925000+00:00  kern  :alert : swapper pgtable: 4k pa=
ges, 48-bit VAs, pgdp =3D (____ptrval____)
    2020-12-15 03:15:33.926000+00:00  kern  :alert : [ffff80007da8ad00] pgd=
=3D000000007fff7003, pud=3D0068000040000711   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd82a5ab42c8ef=
9a4c94ccc
        new failure (last pass: v4.19.163-16-g4065dd9e0ea73)
        3 lines

    2020-12-15 03:15:33.926000+00:00  kern  :emerg : Process udevadm (pid: =
1526, stack limit =3D 0x(____ptrval____))
    2020-12-15 03:15:33.956000+00:00  kern  :emerg : Code: 00000000 0000000=
0 00000000 00000000 (704eb088)    =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd82a9f7301f49bdbc94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g777e215ff3fc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g777e215ff3fc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd82a9f7301f49bdbc94=
cc8
        failing since 31 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd82aad7c027279d3c94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g777e215ff3fc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g777e215ff3fc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd82aae7c027279d3c94=
cc2
        failing since 31 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd86282202cc8a7f5c94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g777e215ff3fc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-27-g777e215ff3fc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd86282202cc8a7f5c94=
cc5
        failing since 31 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
