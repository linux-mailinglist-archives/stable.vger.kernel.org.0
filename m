Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B0A2C6D82
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 00:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgK0XJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 18:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730999AbgK0UHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 15:07:51 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11BCC0613D4
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 12:07:24 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id l1so3173144pld.5
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 12:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ByEl6chYHUF3bmFHM3cCjmdDZpwBXwE7yPAsrQytGsE=;
        b=gtCGR67iV9iqP4wmImgR6Q0wtvxGrW08+I3HbQxs8JmhQPWCg6mhp8nZmEQz9l9f8r
         bB/Q3nxu4yKwkXaPRu1zmI9KkFbCNy84ClAsYSjrIU9qBkMMPW2XPZGLh7iuaWqq+bC8
         pZtC8xxJDZMT9pEZ9Gd9G6Z1CyfglsfSxOLGbSvIc7YJsFyuuZ6IHghy4P3QCbrX7UMO
         YbPwT9CJweS7YXpcl08xoQmxcQ2YmEkcoNXrxCSrpJffgBW3TNASTYRouJWlFF8YUnXh
         Y0ZGENTOaKXN6kGYKjJyMCaHKRNvG8kt3qtFQ+AUj7+MpHq0i+tlXgV/1YQ7u636js4f
         l59A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ByEl6chYHUF3bmFHM3cCjmdDZpwBXwE7yPAsrQytGsE=;
        b=XbhY2ulT2bbv6eftbLDxg/jQczMlJyU1++3AbXpFLLoUVGnBbaZLLp/TmcEN+zaoHb
         z8duZPSvKPdDkz9j1jVK7/YuN1EaCQDymgX5JQV1xKm1ZIZwgwIiixh+kMc84qPS2L/P
         VlB7c82JprMM6NsvVYk6wUJ0zZnHvbWaw0v/P48Mxpexs42hNqqfSYfGov+m8vVbm0Z4
         JFiAYyQI7QKgwQdHDFFHXrNexLBAnb9RkEd6JPsbSBd5YR/NCbAxVkUS+3kVCcPHFxr2
         aEWqok5dFetT9BttkSiOZjPaF3qeBIiqVE8lTZpz+DmzZzXZMH2/qFLlz1rCpoNtrKpI
         fLMQ==
X-Gm-Message-State: AOAM531xp1c116f5Oc3Z06l2P0ndecQSZvOY+Ulvt46/HIxpFIxfxqwg
        LQcbtG36HSEvgjBNn2kK3EuZE9BmS2ayjw==
X-Google-Smtp-Source: ABdhPJwRbFrnMl3V0f0RVQwOg9wbbbBEkjKfh5aH7A6TMnlLm5HhT9Y/9W7h6Ni22jqRWTZecUR0bw==
X-Received: by 2002:a17:902:ed11:b029:da:3137:2695 with SMTP id b17-20020a170902ed11b02900da31372695mr8411528pld.1.1606507644097;
        Fri, 27 Nov 2020 12:07:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e8sm8587662pfj.157.2020.11.27.12.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 12:07:23 -0800 (PST)
Message-ID: <5fc15c7b.1c69fb81.e3373.4653@mx.google.com>
Date:   Fri, 27 Nov 2020 12:07:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.80-8-gf6b141cddcc6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 211 runs,
 8 regressions (v5.4.80-8-gf6b141cddcc6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 211 runs, 8 regressions (v5.4.80-8-gf6b141cdd=
cc6)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

meson-gxm-q200        | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.80-8-gf6b141cddcc6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.80-8-gf6b141cddcc6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6b141cddcc614aa78ff132abe1f3dc48651d2dd =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc12a1d0d2b1d42d7c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc12a1d0d2b1d42d7c94=
cde
        failing since 29 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc129d454daca93c8c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc129d454daca93c8c94=
cd3
        failing since 7 days (last pass: v5.4.78-5-g843222460ebea, first fa=
il: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
meson-gxm-q200        | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc12914ef08a9300cc94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc12914ef08a9300cc94=
ccc
        new failure (last pass: v5.4.80-3-g778c35c99c99) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc129eb978d0fb5c2c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc129ec978d0fb5c2c94=
ccc
        failing since 13 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc12b3ae23c5fbd1bc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc12b3ae23c5fbd1bc94=
cba
        failing since 13 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc12a01c09c90a4e2c94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc12a01c09c90a4e2c94=
cd2
        failing since 13 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc129b9694f6ad606c94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc129b9694f6ad606c94=
cca
        failing since 13 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc129aca245c9363ac94d44

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-8-=
gf6b141cddcc6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc129aca245c9363ac94=
d45
        failing since 13 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
