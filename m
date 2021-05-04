Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B886B372CE6
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 17:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhEDP0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 11:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhEDP0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 11:26:48 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6330C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 08:25:53 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id i14so7353610pgk.5
        for <stable@vger.kernel.org>; Tue, 04 May 2021 08:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cs3n5l6cnYo/A9XVGb6rBjvcrBrVFd0/fPs0Gam+xwI=;
        b=WeTeiRZoW5CZzj2P3qQcSTQJ9ECQEK0kvRb3A8eryFHIPVGgwDkq6hrvDWUAHpDlyk
         f+fd/u0ZSW0D+SmkoCOwi2eBBdvF+vV5mF3neH+hSw4oDdT1NKI1Qll0CYPXKbqA1Ow3
         KdgQmWOyT3fPbaOqw1B5Jm9Fp5WsPWNGW0J0EK1AWuLoeiLXNjEQBXW5Ck2yx/pos57k
         j2HPpbZc+qA4g+QVKZOaY+2m9JEwA7FOGh18q5fXL7oNZgzxOr75Z04oKcjoHjgt7JWt
         Aat8DiQNK2h5tA9/saJLMzLddwYQXt9kzLjej7QeB+zlHq9z54p5eB0KX0+1YkjyDIBq
         HTZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cs3n5l6cnYo/A9XVGb6rBjvcrBrVFd0/fPs0Gam+xwI=;
        b=XedoJu6JURBFezUzGTVfkmBVXTqzSK6RjC7nLqdd95kLfxOADl/6gnQS5lot5t+cfA
         FONb3Cl0xFaHyuAkMrBXCeCkvJ0LVNVOSPfMIJlTdWoZmi+Y2bGQCHXEjreZmZTVXWH2
         MwNIWiO4tN/2Jggf9CvH19C8yTivmSDh7baz0IMNiQCSMIAiwTAae8PEVQ2MzfiZGrEt
         v63VWVFuxtZXk9LSPwUZ0tQd2rIUjXxlOCUxGULiEvX5hSGXQuaOPXu82ARpp0g5I7Fb
         HagtKcxZvX4Oiac9VUPL2jWRf9NTu+kDifnJO9U5LI21vPuSXN+rKR8W6S8mTSB5kISb
         xJeQ==
X-Gm-Message-State: AOAM531AFjEVkhrygnl16BmOBFLniM6WbrbITXnEaMrqKiGsMht0YmRA
        McuthrcFT5Mv4lrKi4v+vOn0xkV7DLi6FbOx
X-Google-Smtp-Source: ABdhPJxNYM4xxgTGiQPqoQxP5NUIU2TATmyNiPqr/X3f/ClyYJFRl2XQI9c0Ukfh3irf/JvrsywYQA==
X-Received: by 2002:aa7:9f1b:0:b029:27a:264a:57d8 with SMTP id g27-20020aa79f1b0000b029027a264a57d8mr25093984pfr.20.1620141953164;
        Tue, 04 May 2021 08:25:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z8sm4196153pjz.43.2021.05.04.08.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 08:25:52 -0700 (PDT)
Message-ID: <60916780.1c69fb81.d082a.8695@mx.google.com>
Date:   Tue, 04 May 2021 08:25:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.232-10-g37b50fe5707f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 100 runs,
 6 regressions (v4.14.232-10-g37b50fe5707f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 100 runs, 6 regressions (v4.14.232-10-g37b50=
fe5707f)

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

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-10-g37b50fe5707f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-10-g37b50fe5707f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      37b50fe5707f172a383869cb2bd117e7bf31c25c =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6091311d6ec70864da843f17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091311d6ec70864da843=
f18
        failing since 64 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60913711cefd612115843f21

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60913711cefd612=
115843f26
        failing since 3 days (last pass: v4.14.231-51-g09d3b447c34f, first =
fail: v4.14.232-1-gcc63f168dbc1c)
        2 lines

    2021-05-04 11:59:09.755000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, mmcqd/0/60
    2021-05-04 11:59:09.762000+00:00  ker[   20.287719] usb 3-1.1: New USB =
device found, idVendor=3D0424, idProduct=3Dec00
    2021-05-04 11:59:09.773000+00:00  n  :emerg :  lock: emif_lock+0x0/0xff=
ffed34 [emi[   20.299316] usb 3-1.1: New USB device strings: Mfr=3D0, Produ=
ct=3D0, SerialNumber=3D0
    2021-05-04 11:59:09.779000+00:00  f], .magic: dead4ead, .owner: <none>/=
-1, .owner_cpu: -1
    2021-05-04 11:59:09.798000+00:00  [   20.329833] smsc95xx v1.0.6   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609132f993b72509ba843f29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609132f993b72509ba843=
f2a
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609132ff213546a029843f21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609132ff213546a029843=
f22
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6091330344b6697b7c843f1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091330344b6697b7c843=
f20
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609132b752a5142570843f21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-10-g37b50fe5707f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609132b752a5142570843=
f22
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
