Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FBB354C44
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 07:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhDFF0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 01:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhDFF0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 01:26:05 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA141C061574
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 22:25:56 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so9019752pjh.1
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 22:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hec4YbHW+75gAbOtoGyyhdOc/7GzCKL5JelhldyNbWY=;
        b=tXI004Kq5U5WmWl0GaYzU1QuHMfjptQDcQVlIVF10XQ/mJ02blihBwBb6HfPLzstki
         QxZX+OmD0c3KEfQNTU722SBrN62zU/pRC0YArYX9DoW5GxJJK40NSLa2tVTrgEVa+Hxw
         SNkJIDkOJAfhfFdwj8bvZm3enOzoiFMuP6Ap+M5DkuCd1bntNHSHKaNFEsdR4XZzs6bG
         ZNaCyXCsp12HGM0TZKA8IVKeQVxK9sMtqcIt/CYDWgdFMG6ymoaRn3eg/8cL+QWlM9X2
         4nYj5njXQX4v4F/wgQNNXyHnQLLCgtJua2Ov6A1ce5t4EUKBT+NLUrtFZ1wF1ughS6rx
         nFYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hec4YbHW+75gAbOtoGyyhdOc/7GzCKL5JelhldyNbWY=;
        b=ugzYC9eAK9fsQGti/p94Lg5yzFu1q8/l8oh0zBtqO051op7rOMCmh/agQyaLLjcWM6
         S2K32bBpXX7TJbUv/2YDXYCdBGInMb5YajJeUbbVW7fO6T5tmzM4EMcLcksbrbRz5q/I
         Qe9lQ1lL8eGmVlZW4GwhUk9z+RTvlv682K8H2y4O1qr22NmyYjb5fA6EGf6QbSZ8lw9B
         vbjBQhvtQAXX36NFD3WcACl7XFAYaPH+hofCo+k6pUeX9x3EYsCa6zyolONhivj1awvj
         g+lvagVwWTVNi2ahVaQK3x5PtBnmmqQquA8QJW1vrUJV/1VnGI6nD4sdCvwu9knQm4H0
         VIJw==
X-Gm-Message-State: AOAM5318r8h8e3SmAtkOtIl83Q6xpMljuAsfaTjVydAieaZ92qgD01M5
        UPSW6PDtCRKkX3ysvaWMJDCslQPUfSb/1g==
X-Google-Smtp-Source: ABdhPJzqZkYvh0uLbY6CGjhENcTB0zM44MZTQaEihxXQpLJkTTV319WgJLnZFK5QlNjQG4sUe5uqVQ==
X-Received: by 2002:a17:90b:1b4e:: with SMTP id nv14mr2737693pjb.115.1617686755905;
        Mon, 05 Apr 2021 22:25:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n5sm17712257pfq.44.2021.04.05.22.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 22:25:55 -0700 (PDT)
Message-ID: <606bf0e3.1c69fb81.63298.cb2e@mx.google.com>
Date:   Mon, 05 Apr 2021 22:25:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.228-52-g9fbf2eeb75809
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 113 runs,
 6 regressions (v4.14.228-52-g9fbf2eeb75809)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 113 runs, 6 regressions (v4.14.228-52-g9fbf2=
eeb75809)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.228-52-g9fbf2eeb75809/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.228-52-g9fbf2eeb75809
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9fbf2eeb758098ba5e339e6a04a2ec0d843124b9 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/606bbdd1fb50040267dac6b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bbdd1fb50040267dac=
6b5
        failing since 35 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb75af6beaa530edac6b1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/606bb75af6beaa5=
30edac6b8
        failing since 2 days (last pass: v4.14.228-36-g9f3ce13352b5e, first=
 fail: v4.14.228-37-gf3371b16da688)
        2 lines

    2021-04-06 01:20:23.021000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2021-04-06 01:20:23.030000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb777121635e8acdac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb777121635e8acdac=
6ca
        failing since 143 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb7645c1ec56c9fdac6d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb7645c1ec56c9fdac=
6d9
        failing since 143 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb712b114250ab1dac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb712b114250ab1dac=
6ca
        failing since 143 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb72e8d25047a28dac6b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.228=
-52-g9fbf2eeb75809/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb72e8d25047a28dac=
6ba
        failing since 143 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
