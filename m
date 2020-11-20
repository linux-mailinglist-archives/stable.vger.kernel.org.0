Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2972BB07B
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgKTQYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbgKTQYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:24:09 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B138C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 08:24:09 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id i13so7686749pgm.9
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 08:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bePLbmm/3dOxO8GUhY3djNf9Nk5DFOzk0ktVqi/OmYM=;
        b=iGB2uh0LkFwmmGw0d337rNahV0C7EV3ywTytFPfyMxoawIQwWzXnH9SIRDZipj4J9P
         o/ufOPZLLmzjy50+VGBXW58Hg3CoGJVzK2V7xejYgLF87EN+4PPQFxOwfhN9v1le0Dzg
         kIdOLr50yTZLyEK8MPOE8TlXNPdLTaZXFs/Zd3uFZvWFbQyAX6lOYmoU2I5+OEv7EVg0
         OfNjhmi99TpkDdy8k/ngeEVm2Pa7jzlCbhWRpv016auRFmuQmRo9Yv28uFxybO7IM7U2
         4kDRRodDyy0VjBq0QQkIUkPArkJvSB5NmIzX0rfLmZQTl4W5MFwWzdfiF7HdwjGX4lMT
         NznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bePLbmm/3dOxO8GUhY3djNf9Nk5DFOzk0ktVqi/OmYM=;
        b=lRSpclayUwUu47/yiOPzRhf0hXyGisGfefvKMNNPRrutINEfDKNBBDOgoH1srAA6PC
         Ny/VSds/QIwSv7JtQWO/j4AQ4XnEya7rlcxJrsgwHTPhd/ghjMzF8l/ZXeKtxZNfb0be
         EetT1NXsZMQhL1d1AlpIC3x5DUd/UmfslUhM741Da60iZQnqzaTF6QWWM/DRCdO6II9c
         GuIP7Y5vOpFa8B0ueMa3/e/sKTAwDYkaBt/8Ez2irHbKGYYI6fnLu+03Qbu1GeV6pkTU
         IvySLtTEPGuCkvGcgoy2mA9hvPn7i5xgCEUpmhcxNxTue5x21GZ8oWzoFD7pICEcXg/k
         aFyA==
X-Gm-Message-State: AOAM531D4FRJ0T5EiaaFdYkIEC9XwbcUzC55GCb7UFkFN9K1i6Rz9URw
        nIbP9hEZ8zVVJnuabgl+QcSx/yKAZsMIuw==
X-Google-Smtp-Source: ABdhPJz8MTnnTMo+jC+GTKQ1labdlcK3zshN5TRG+qJsgoU85/ergvoXmuM99kuFL4eoI+1x4l6RCA==
X-Received: by 2002:a17:90a:bc83:: with SMTP id x3mr11111552pjr.90.1605889448228;
        Fri, 20 Nov 2020 08:24:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 19sm3467001pgo.80.2020.11.20.08.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 08:24:07 -0800 (PST)
Message-ID: <5fb7eda7.1c69fb81.f89c0.678c@mx.google.com>
Date:   Fri, 20 Nov 2020 08:24:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.244-17-gb75776b03db0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 114 runs,
 4 regressions (v4.9.244-17-gb75776b03db0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 114 runs, 4 regressions (v4.9.244-17-gb7577=
6b03db0)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.244-17-gb75776b03db0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.244-17-gb75776b03db0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b75776b03db0bcff278a791d60b6ed02df615c1c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7b9953fb29e4370d8d922

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
-17-gb75776b03db0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
-17-gb75776b03db0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7b9953fb29e4370d8d=
923
        failing since 5 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7b9a04a09526ba2d8d968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
-17-gb75776b03db0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
-17-gb75776b03db0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7b9a04a09526ba2d8d=
969
        failing since 5 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7b95c3b92bbabadd8d915

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
-17-gb75776b03db0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
-17-gb75776b03db0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7b95c3b92bbabadd8d=
916
        failing since 5 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7b79838458545ddd8d91a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
-17-gb75776b03db0/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.244=
-17-gb75776b03db0/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7b79838458545ddd8d=
91b
        failing since 2 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-79-gd3e70b39d31a) =

 =20
