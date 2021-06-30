Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A2E3B8A95
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 00:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhF3WsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 18:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhF3WsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 18:48:23 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3E3C061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 15:45:53 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w15so3910566pgk.13
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 15:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hRJE/EuUEh51UtX/WN/WBqH0WkA8KI3eT/HH3JiVzYk=;
        b=T+CNObv7lnwCKVwHSUZz7Agn97rv+Jvdbp3NgKt1gctQlcsRbb0Au6vrLthNX7vzwe
         UinGbG/h/Fiu2pijnyJdP6AaysOCEx2FM6wJ8wUN+5x7gJQn1lVLZo4Vf5won9iX/QDW
         mGX+Ryo1RQZadjLLzCIrCrbNveQKlGg5yMGEgpQY7naOBG+22y09jtrumNTXZst4aDeJ
         mOan+JPY357Hw0bNZLjOF5QulSxlEi2snbDCxcwRCe9RDgjBThtiMfE+FqNZ+ueqzsos
         HmoHaZS7NPcx1/XUiIYBSmWAshOe1wf/lwCeKrQRvggLujZm0fAYiXOKpVZAAEG8I12W
         h1wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hRJE/EuUEh51UtX/WN/WBqH0WkA8KI3eT/HH3JiVzYk=;
        b=RshjXBQx9rgwBx+arH4eOZkI0UE9K7Riv57fnFKoGAPNsPAMzPFirrJoGdXCsJgKwt
         KuRmMA3zlY4j/V36uO5Is+Rl/Tc7lv60JAUZcyAEO5TXJ6P76v6CAYaHf9a4q/60mX3R
         XdNLstR7Iw/v2fSkKUirbVuOWC5NNu7T7SU21/QfVVTneq1c2Mr2TzQ7Ok9LmNjZoesw
         NJXB+mLO4diId0vWAYdva5kxWiVA5w+3KIpJBNYBX+B6RDFyW3lpiQWyaSszQoG+2wE+
         guDUJnflw7lDEDqBoT80JE0qKeCaX7WnoSZpXDlqdKl+e4NuYwzxnFQ6+yEyoR5RKwfs
         haQA==
X-Gm-Message-State: AOAM531wvMxr7zcyEt/IW1iFwmSngT0IyYh88jvPrvEW5GuVoyNaJasC
        1z021hxhPuHfvZwxi0r1k6BE0/vdIvyYDkKo
X-Google-Smtp-Source: ABdhPJyEIeXGBChjOGNYqdKuAuPpX8z0dHq+zl9hCbheBaVDmhX7kdtU/EH7y8fQ3Iw9OovU3WXhmg==
X-Received: by 2002:a05:6a00:be2:b029:30c:b0e:6cc5 with SMTP id x34-20020a056a000be2b029030c0b0e6cc5mr19625046pfu.79.1625093152665;
        Wed, 30 Jun 2021 15:45:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h1sm7524994pji.14.2021.06.30.15.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 15:45:52 -0700 (PDT)
Message-ID: <60dcf420.1c69fb81.a0ebd.8b2f@mx.google.com>
Date:   Wed, 30 Jun 2021 15:45:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.238
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 125 runs, 7 regressions (v4.14.238)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 125 runs, 7 regressions (v4.14.238)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200      | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

meson-gxm-q200       | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.238/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.238
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      313e82bbefb3d1d926858b58092f5d50f41d924d =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200      | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcbf5a792244949723bbbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcbf5a792244949723b=
bbe
        failing since 456 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
meson-gxm-q200       | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcc003174cdb4c3f23bbe5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcc003174cdb4c3f23b=
be6
        failing since 97 days (last pass: v4.14.226-44-gdbfdb55a0970, first=
 fail: v4.14.227) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcbe5d2d7e8e8e9e23bbc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcbe5d2d7e8e8e9e23b=
bc4
        failing since 228 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcc4f1586409577423bc04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcc4f1586409577423b=
c05
        failing since 228 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcbe7bb2133fc1cf23bbdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcbe7bb2133fc1cf23b=
bdc
        failing since 228 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcc84eeb1e92b61a23bbd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcc84eeb1e92b61a23b=
bd9
        failing since 228 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcc3897d95a92cf523bbcc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
38/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcc3897d95a92cf523b=
bcd
        new failure (last pass: v4.14.237-71-g66c6950a943b) =

 =20
