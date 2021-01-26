Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183A3304C02
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbhAZV6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731055AbhAZTDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 14:03:12 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E792C061756
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 11:02:32 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n25so12070584pgb.0
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 11:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U/w5odv6oSfv9+f2nFsS6Rt25xpXJ/x3rbp/Z5uO704=;
        b=g6+3URXVMTwVJ96RVeBrYW4y+DgnRgO14W0Wih0AgwUJbvILW/goVsi7PFmgCoI6EF
         kRmIN6hlXXpfj6nC2Z9ZtYSLdmnKVkPhz3n/Lb/k9gGUZqbZEusSfMR/156gceNFBuLM
         izHGQjg/yFFWt8igP0EsgyMRBKR7LiqNPp7JyTT8ZnwUpqQUIWfyy2s95qiVHpW3hQmz
         Vunc8jf0sZYP70IHq824+ADfv+yG8Migv6h0kdDh03rpayxGr41l6IpMy4/u6ur5hAdJ
         ydoPjBEZ99rX2vqM8BQIfF60Vhl2k7XQNgm58wnKDQJmU9dpafkBd1tOPsK20N20v21N
         Sv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U/w5odv6oSfv9+f2nFsS6Rt25xpXJ/x3rbp/Z5uO704=;
        b=A62D/CDIkV2SWZvQfOKYBwKwOUpxRj42C844+KIrfr8g2im+5Xr7Bw8P3YbmcsHYll
         3N1LEj+yI71OU1PtLitpiQB3jcpa40UiJRBw5jytrnDlmAeI/UnSsmVlidxVMzIkCeLv
         7q/dxkDIXoyQz1UlojXOFYay3pJTY1rgwwXKPap2t8Bkfir3xRiW9YlyXgXNOgYUjZ60
         xiZzDIjqkZ4Uz9TCBDKh26ziBxOk5f8KeBJmJGRO43ETg5RjKHY9LpoEEu766XTmNUgD
         UiWBtw28V9kwgclgRZ/0lq6brGE6EYo91wXlkiLqsFFM3jPQABhqWpsm5KO0ctZqmEJh
         3QnQ==
X-Gm-Message-State: AOAM531REcNKb9gt6csC2uMaGnv5w2PRdL3voxFwFrrFjFoPS7ULtQ4F
        r5AjsiupmC4FUxwBYJJTAxfqoH3Ju3fhUxgr
X-Google-Smtp-Source: ABdhPJzxVX9KKpn3KL/SiWh9+GKksAfrxBep7pqryxAqmHSsABDf/lh5Jhxx5zz/mA/mcgPbc3UsXw==
X-Received: by 2002:aa7:8602:0:b029:1bb:4dfd:92fc with SMTP id p2-20020aa786020000b02901bb4dfd92fcmr6604221pfn.63.1611687751541;
        Tue, 26 Jan 2021 11:02:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7sm19390294pfc.50.2021.01.26.11.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 11:02:30 -0800 (PST)
Message-ID: <60106746.1c69fb81.8c260.f7e1@mx.google.com>
Date:   Tue, 26 Jan 2021 11:02:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.92-88-ga2ea77508efe6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 186 runs,
 8 regressions (v5.4.92-88-ga2ea77508efe6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 186 runs, 8 regressions (v5.4.92-88-ga2ea77=
508efe6)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 2          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.92-88-ga2ea77508efe6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.92-88-ga2ea77508efe6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a2ea77508efe6948f831b5f5bb3a86e014cc4163 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/601030c2312ffb5d8fd3e038

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601030c2312ffb5d8fd3e=
039
        failing since 67 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 2          =


  Details:     https://kernelci.org/test/plan/id/601031a0bec5e4ef85d3dfde

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/601031a0bec5e4e=
f85d3dfe2
        new failure (last pass: v5.4.92-87-g3deaa28e41d97)
        27 lines =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601031a0bec5e4e=
f85d3dfe3
        new failure (last pass: v5.4.92-87-g3deaa28e41d97)
        6 lines

    2021-01-26 15:13:28.143000+00:00  =3D00000000022a6000
    2021-01-26 15:13:28.143000+00:00  kern  :alert : [ffff8000110841c8] pgd=
=3D000000007ffff003, pud=3D000000007fffe003, pmd=3D0060000002000791
    2021-01-26 15:13:28.143000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address 0000000001a3c3e8   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60102e9fd68e24cecfd3dfcc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60102e9fd68e24cecfd3d=
fcd
        failing since 72 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60103b5a560a0915d3d3dfe4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60103b5a560a0915d3d3d=
fe5
        failing since 72 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60102ea9d68e24cecfd3dfec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60102ea9d68e24cecfd3d=
fed
        failing since 72 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60102e63ad4468a702d3dfd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60102e63ad4468a702d3d=
fd8
        failing since 72 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601039a3ef906d1aa2d3dfcc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.92-=
88-ga2ea77508efe6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601039a3ef906d1aa2d3d=
fcd
        failing since 72 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
