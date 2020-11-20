Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E692BA9E0
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 13:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgKTMKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 07:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbgKTMKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 07:10:18 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E7CC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 04:10:18 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id v21so3504238plo.12
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 04:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bY5G9pPuamFuV0MFfQtqbPMqSIbJljEDBfh1GnuwCVM=;
        b=SlYZIvVuXOrhA7gzLmHz/2oezuREsyp6lZuGGQ0Jbv9wpY/CEt6EvQjbYdJEFmD2sc
         2eM9WvvthyDPowyfLRaWDWNSYUUMycMsKmpoeCTg+LW/pEg74+ALdJnoIa9StSjcaOMf
         zkDZPEo66LGca8usunv9BAiRNcMb0qc2mOqvHGaVZ8Ulpar9blO+JpWXo9m42AiD4mh4
         s9pT1Jb70ehr6CwKvMBmisiBosJ/Efj05q6pz6q2pDvHfwaaabWuWbBbxUKo70vdA7Z8
         OYvrTr67oyMJTODJn22iAl7mE4H9736VY2bVexpgZNTMadaLj1RHtyDn0cCQn94lX2dT
         bLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bY5G9pPuamFuV0MFfQtqbPMqSIbJljEDBfh1GnuwCVM=;
        b=WtYXeCc0/9ZtogMKWWbjJxcaU+GVs9lzSj4xHRkw2OCjyRjRRnN2oGwc7fKnagxcKK
         iiUEFUQd8kWQ14kyNUk5hFxoH2nZL2jpdriEohMXMukRUUUuntM2pLuV2r8Vc+pynb8P
         WtYsBTzZeXvW6/5h6nLMsG/eTFPxkMJc5wL66UbCf0E1/DLpYjOlEu8L+wFXWBYD38G+
         REWmPP3jxzhVhKHJipKzYf4EmnN2huPk2VNMm/sTDkAoStKGa14IIWPsGrhP6psrgO+I
         hddfiuGF4zStb3uIrAedzeXbIZo9m74S/Q9KRgfx/I5S52yTddO+EWsp7crhKGE8xE6U
         l8iA==
X-Gm-Message-State: AOAM531oogTM8ZJ+z6H2V3y/4VoCMq0DIBpcfe3vI3i0ElYa57LHrG88
        lnKjuJMa9FQnFCJ75n8ZnJdSkM/cZGpw+w==
X-Google-Smtp-Source: ABdhPJy0pzcI6e3IR1D6U9PgdGozIwOwH8jgM1Pbh2K8459oOg4Y9tK1U7MkT9qoNnYdaBkoWIah7w==
X-Received: by 2002:a17:902:bb94:b029:d6:edb2:4f41 with SMTP id m20-20020a170902bb94b02900d6edb24f41mr13316564pls.3.1605874217587;
        Fri, 20 Nov 2020 04:10:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k4sm3669570pfg.130.2020.11.20.04.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 04:10:16 -0800 (PST)
Message-ID: <5fb7b228.1c69fb81.271ca.6e36@mx.google.com>
Date:   Fri, 20 Nov 2020 04:10:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.244
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 116 runs, 7 regressions (v4.9.244)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 116 runs, 7 regressions (v4.9.244)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
jetson-tk1           | arm   | lab-collabora | gcc-8    | tegra_defconfig  =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.244/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.244
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c3203bb03db01f205a909d5010782358bc92bc0a =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
jetson-tk1           | arm   | lab-collabora | gcc-8    | tegra_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb78565b5d3837657d8d923

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb78565b5d3837657d8d=
924
        new failure (last pass: v4.9.243-79-gd3e70b39d31a) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77e0bbe49c5a551d8d8fd

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb77e0bbe49c5a=
551d8d902
        new failure (last pass: v4.9.243-79-gd3e70b39d31a)
        2 lines

    2020-11-20 08:27:51.474000+00:00   udevd/123
    2020-11-20 08:27:51.484000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2020-11-20 08:27:51.505000+00:00  [   20.514251] smsc95xx v1.0.5   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77d088ae3a99173d8d916

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb77d088ae3a99173d8d=
917
        failing since 5 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77cc04fce53eddfd8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb77cc04fce53eddfd8d=
8fe
        failing since 5 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77c9f4434df507fd8d909

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb77c9f4434df507fd8d=
90a
        failing since 5 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77bac12a6159d38d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb77bac12a6159d38d8d=
905
        failing since 2 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-79-gd3e70b39d31a) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb78b2318c9ab91ffd8d91c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb78b2318c9ab91ffd8d=
91d
        new failure (last pass: v4.9.243-79-gd3e70b39d31a) =

 =20
