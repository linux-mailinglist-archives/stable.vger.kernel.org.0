Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA373937EA
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 23:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhE0V1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 17:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhE0V1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 17:27:08 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A165BC061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 14:25:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so3193613pjb.2
        for <stable@vger.kernel.org>; Thu, 27 May 2021 14:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vcV9xnyBWnEX68Plnl0aOZYnxBL3zKraFhBjowLulJ4=;
        b=h0+bqPYmYk1YF68Rt53c7oUSSgVSZtIcSa8DMSUktrVNQe7TbMj0o64r2vALq/RZAv
         17YzoI1tyyqzPp0KzxaJskCm6mlI1gwEAnVf0acm4Jn5dA53EGxXQRpF74jGY0x31oYr
         EM8RI6H48uypLhrSSMIPudmXcbk0W2lJO/6bntAT0KPSrfgcRrnHPiGPk/uGBf6rcavS
         DAFqbYW+Y2AMPUNMuKiZUROM2iBNgKr+2apfmP4XX+oH5QAcA6LEBRsulhF1NWhA6a9w
         0SIwKCwTkOSR0YZVtbDTbnQAbaIAyJS/nZSnqWXO0A3IqpBQlfFS49FL/8eXaB2vfVxc
         +qFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vcV9xnyBWnEX68Plnl0aOZYnxBL3zKraFhBjowLulJ4=;
        b=hU0g4k0ZkTFyBvBpFF02R7CtKzVil1H8w8+W569jfZWTfnp3mBr22zAVVdn0kV/aTB
         IjAFtKJl+mDRgOsTtp4yagfvW8qFSB0rF/iWvvEPIYrWuNJkL18oc9WaIiazuRjlbPUS
         OAQhYNxqHxSHj1PZdaI6HJZuCkIEmP7tggYRzjXWN2LuaUOQqWQQ0/snoUIffMwTIw0X
         6Lhv+hr89w3Y1oTOlfQgpVuimg7IlJpfIFz5FcZVZBC0zdV8nDrCN5Ff41euOGmouvNr
         VkVyniB6AykgYWvN/i+Vrbe0/YJTh/sUOIhQeE3n51EZGowi9bTcW9R4HeeXprXYF0lW
         3VRg==
X-Gm-Message-State: AOAM531A3qzEwUrTu4NfZ+vdlGFHvrFDLu7EoMi+qQBcAoyzfqoyx78d
        5Q435GZxr9/jJYKaaD7LlUP/idg/AlKETg==
X-Google-Smtp-Source: ABdhPJwRkB7GvxXofd7E6FRoSxIP/2RtHKLs3hrtzE1mqd54qZRi+VZS0kMRVQi7OMduSTutDKeiUg==
X-Received: by 2002:a17:90a:49cc:: with SMTP id l12mr490174pjm.212.1622150733813;
        Thu, 27 May 2021 14:25:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c20sm2668177pjr.35.2021.05.27.14.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 14:25:33 -0700 (PDT)
Message-ID: <60b00e4d.1c69fb81.edd84.96e9@mx.google.com>
Date:   Thu, 27 May 2021 14:25:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.270-6-g71bb752d4ade
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 87 runs,
 7 regressions (v4.9.270-6-g71bb752d4ade)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 87 runs, 7 regressions (v4.9.270-6-g71bb752=
d4ade)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
beaglebone-black     | arm   | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

qemu_i386-uefi       | i386  | lab-broonie   | gcc-8    | i386_defconfig   =
   | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.270-6-g71bb752d4ade/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.270-6-g71bb752d4ade
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71bb752d4adee6aab235be7278a42e286cb3cd87 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
beaglebone-black     | arm   | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60afd4e36b262d9111b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-b=
lack.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-b=
lack.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afd4e36b262d9111b3a=
fa5
        new failure (last pass: v4.9.270) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60afd65f3cfc986e1ab3afb0

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60afd65f3cfc986=
e1ab3afb7
        new failure (last pass: v4.9.270)
        2 lines

    2021-05-27 17:26:51.275000+00:00  [   23.761962] smsc95xx v1.0.5
    2021-05-27 17:26:51.296000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/121
    2021-05-27 17:26:51.305000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-05-27 17:26:51.327000+00:00  [   23.810424] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60afd2aee02cf46d50b3afc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afd2aee02cf46d50b3a=
fc6
        failing since 194 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60afd2937c3bfea058b3afac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afd2937c3bfea058b3a=
fad
        failing since 194 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60afd2476711a07a13b3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afd2476711a07a13b3a=
fa4
        failing since 194 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_i386-uefi       | i386  | lab-broonie   | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60afd222f71cdb9b66b3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afd222f71cdb9b66b3a=
fb0
        new failure (last pass: v4.9.270) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60afd520927608b5dbb3afab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.270=
-6-g71bb752d4ade/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afd520927608b5dbb3a=
fac
        failing since 190 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
