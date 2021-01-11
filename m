Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DCA2F1946
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbhAKPN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbhAKPN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:13:58 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07433C061786
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 07:13:18 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v1so7972161pjr.2
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 07:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y/43E1DOESJiJG37bOvOzgpaaFh5SgMOl0zDP2XoArI=;
        b=CZpaMeTJljc4P3hr2gS/aB4hvm35kZodReL05/ShVOc5S6YgmHWZrmOvDoN66ljL6Z
         l9MmXQK09nSp0ap24c83AutGQ4KkcpNPYrXVL8SoTa3IpRmiFr6gX6u/w8lQqSt2sYGZ
         mW+O6nR1/QhVLIW2pUFFb8JovFXtR8wJzmuiRP2MZ6NZ0rGxqktisHjDjeXUTuEf9WVh
         WhjiirYVMWEdKWjAAvvkqb39tNuctZqVxOooZXlxBMKPaGNtFDJu8y7Qn/RQ1Biuj5I9
         nG2k4cGs7EV5wK+d9aTOd3Jig7QCMhCYiXYngj325426xEuAEDeDRcALeEiUejjXJRT2
         ZnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y/43E1DOESJiJG37bOvOzgpaaFh5SgMOl0zDP2XoArI=;
        b=ZidP83eyvgw080VU6CL4nMGWgMc0kBEzWFMuinP2mmTHIH/J5ZCbi7QOiKbyLV4MXh
         JTKq1bcZGwh2CZC7FHJiWQsEe3KI2lNXG6+7hLuEmjDAIX3MiEVNlm87GM377Q/bXjHk
         V7goYoNLfKBYZtG/giFNxydrcjQN3UvI8Kv9VW+9+z8rCsL5b55OHv+VjG3DvwWHFdVg
         PaOFa6ogo85qepJnTv0SqNA2q9p0Edn29nzyHuAqMDXmzH6vHIco5fSbRHpy6l11T/ek
         Z4+0qusAxcunO6O7HwaZWjMOuWUDYVmwI5RCYIl7fSTxTv7e5CeAmpCqd+e7OpYGtyKp
         S/Xg==
X-Gm-Message-State: AOAM53391xi6Rj8MnCYh51NSSS06iYV1bzF2nEq8mhf1VEa2fE1+qQ7e
        oM6zBe8opXCWJe2hR9+Z88kxyWk3lhZPlA==
X-Google-Smtp-Source: ABdhPJzSD5sR0h/pdl0ZDgo4wK9/GgdLxBI7/IckxQnYDPGhbkUykSWJPOqX6CyCFcIokMjceFyHxQ==
X-Received: by 2002:a17:902:c155:b029:da:9460:99a0 with SMTP id 21-20020a170902c155b02900da946099a0mr233697plj.20.1610377997179;
        Mon, 11 Jan 2021 07:13:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a141sm19568894pfa.189.2021.01.11.07.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 07:13:16 -0800 (PST)
Message-ID: <5ffc6b0c.1c69fb81.d207e.9726@mx.google.com>
Date:   Mon, 11 Jan 2021 07:13:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.214-54-gec361fb28cca
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 135 runs,
 6 regressions (v4.14.214-54-gec361fb28cca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 135 runs, 6 regressions (v4.14.214-54-gec3=
61fb28cca)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.214-54-gec361fb28cca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.214-54-gec361fb28cca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec361fb28cca60ca105e60594ed00d9b2dffd82d =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc3980110949404ec94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc3980110949404ec94=
cc3
        failing since 285 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc38fe7bfb1ba8d7c94ce1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ffc38fe7bfb1ba=
8d7c94ce6
        new failure (last pass: v4.14.214)
        2 lines

    2021-01-11 11:39:35.821000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc3869daf81456d9c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc3869daf81456d9c94=
cc3
        failing since 57 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc387c7d67a7c550c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc387c7d67a7c550c94=
cc4
        failing since 57 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc3864a04086925dc94cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc3864a04086925dc94=
ced
        failing since 57 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc38a8368ced04a3c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-54-gec361fb28cca/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc38a8368ced04a3c94=
cd6
        failing since 57 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =20
