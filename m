Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CEC3DB029
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 02:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhG3AN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 20:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbhG3AN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 20:13:26 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EE5C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 17:13:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d1so8963119pll.1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 17:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hSl9MUXrP/kUS4ohD9SsFmAGZaA1Azu+qhggSer43z0=;
        b=1Di5DUXx6HF9UadjcP2PmpGt05/OCbA+BQBmW98YHlubTZ06YzsjRuvqF7Vw87Xtoa
         xeyWfdbyZuL9V6o/nePtWpd958wf02IcjDR+E/t0bPvYyEPVFwcVHMChmdoqDUutcJwZ
         ged85TorNhBLTf+t1YcRz6IAlKhki+e/Vouilw7IRUWK3F3phZywqmOTylvqouuFK0rk
         AB91xfbCirJ4j2louBTBoUETV94RtTRwWYtOVbGHdDCCghtOzV9Rg3TCvVpZS71vFlJH
         7URt4KXie0rXhjWZJj2KnfIjX9sKmrTUxCqnJ0Co4LO0g8hwGdfQ4YH/kmSjPMk/DLmx
         M6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hSl9MUXrP/kUS4ohD9SsFmAGZaA1Azu+qhggSer43z0=;
        b=Tbg7F4vsVpNNiDXdA3cvqyLvwFMt+VJ4YqexZrLN//DPIItF7ie2whAPVUc7HqsFpn
         62WQE8bVPOyqYCX6/8sGL9/e8dmNv6usNig7kFwqLys1jAhyi7WIsqJlHlk8tTVpkSat
         giA7nmX9JXWKk2dbOpuh6s4ck5oPjIn8tO5qZb3sMlw5nkGaeAArDrlLmKK577TqInUX
         shAdgCRxpAPs6GfnaGjt3400gYmUgdgW6BwgVqRcR8Y2FCX4Mucl73CnqgRxidfKPs3C
         PE2NHzyocHGJZkCehekSX7xQwa4gdJkbJBUkpBmNfA+sSKHgToiTldGdMD47BWLcm+nz
         Ou/A==
X-Gm-Message-State: AOAM530PJrKeTSW/LxDysT+A6C0XA+AWVkoyl7dfiubXdoXUu84D6u2N
        cAUYYb7VEpKliJLEbNJ81vEZMc2zpuh94K4U
X-Google-Smtp-Source: ABdhPJyyxcaJbvOAheArQV7j+RF56otHqyqeJ731Jn8xMj5qhsvMaqxdzO6kP288+TmQN/JedhPHBg==
X-Received: by 2002:a17:90b:14ce:: with SMTP id jz14mr2125892pjb.35.1627604001035;
        Thu, 29 Jul 2021 17:13:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x10sm5416409pgj.73.2021.07.29.17.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 17:13:20 -0700 (PDT)
Message-ID: <61034420.1c69fb81.374fa.1997@mx.google.com>
Date:   Thu, 29 Jul 2021 17:13:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.241-14-g8cb34df08062
Subject: stable-rc/linux-4.14.y baseline: 116 runs,
 4 regressions (v4.14.241-14-g8cb34df08062)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 116 runs, 4 regressions (v4.14.241-14-g8cb=
34df08062)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.241-14-g8cb34df08062/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.241-14-g8cb34df08062
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8cb34df080629a5aaa41651773f610b246e16a11 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61030efb0c08f6ede55018e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-14-g8cb34df08062/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-14-g8cb34df08062/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61030efb0c08f6ede5501=
8e4
        failing since 485 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61030b9ce7bc8ee4f55018f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-14-g8cb34df08062/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-14-g8cb34df08062/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61030b9ce7bc8ee4f5501=
8f2
        failing since 257 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61030ba0e7bc8ee4f55018f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-14-g8cb34df08062/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-14-g8cb34df08062/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61030ba0e7bc8ee4f5501=
8f5
        failing since 257 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61030b41de511842e55018d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-14-g8cb34df08062/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-14-g8cb34df08062/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61030b41de511842e5501=
8d8
        failing since 257 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
