Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5909D3397CE
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 20:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbhCLTxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 14:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbhCLTxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 14:53:21 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092AFC061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 11:53:21 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 16so2589489pfn.5
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 11:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gp5lNUxfcVrXzldE5z3GYz4XOKqf9mL2wWsLzz5SZJA=;
        b=1I4ExIhmWlgnNFEXJOHMwGu9SaP8rERZK+AFOqdtD7wkl/WrwNLD4xpvLFhPJDihcF
         OFZnYDHFJyMEPZROdx44OAdHdZZuqAzS8F8xZzoNSxWXaNf4d0kjRC9G0olgNH4GqNir
         9Q5XSBLKTk2UZyURwW61SwqQB9GHJ/AcIgptsrrES5QfmNTVC44b5heswVrfPBfmKK7s
         rSeyO3OWgcEZ95CuV1oKWB55Lpk0pV3Psms4UEGKrs20eaJe38XesDQti9lc8Hz+GYpg
         bFWfolv1ivq58eXFB9vZaIBMvlBbG554HkyC7VAYBhkEV1C68XG5MejRDGucvspa4dTG
         5vRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gp5lNUxfcVrXzldE5z3GYz4XOKqf9mL2wWsLzz5SZJA=;
        b=pwG8+JIj/RfCN/cS3n98NmIRAzz7Wj39kCX1YWKpuyM6pIv4YD6lJlZl9aFbfl9yH4
         ZS39aXFNxqTyot7HcmMG5n+FXsU7f9z+znvCF+dNrJpqjWnat3NNlAcV76e9JWFggF+l
         h4NueWbz/iDvxU+vl1HoC5iID8TU+uaPHLKEIZTu4pCV6pE4J+UIULL1vcaokSF2vYHU
         JTZMK8X5WLxUFIgvYch+4Lv2GAhXFB4W1c+BQJ+BRxHG0k2q4wxH4ZuTyrmDDhWy58oh
         PCZWQbdSCZ0QzmBa44/P0DznUTINrvo3YDJ1wEBAKhnmR5w3oT7nXsYHLzRzFrko/yXq
         Y7Gg==
X-Gm-Message-State: AOAM530nWdjIyc7GufyDcTT47uGrfbZSy0GIXEMFDHXD0HakCVbBze1o
        XLKhENn96g2ck7RYNMFhjMKSKbwhryiidg==
X-Google-Smtp-Source: ABdhPJyWh82OMUBf/Nn8+S/5iiCF5S8vVcTz3dr48+nA250/7udHD0RuZdLEVdFBqs2QhSx+N7AQ1w==
X-Received: by 2002:aa7:8a56:0:b029:1f3:9c35:3cbb with SMTP id n22-20020aa78a560000b02901f39c353cbbmr13457549pfa.24.1615578800145;
        Fri, 12 Mar 2021 11:53:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l20sm6748347pfd.82.2021.03.12.11.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 11:53:19 -0800 (PST)
Message-ID: <604bc6af.1c69fb81.9f08a.1845@mx.google.com>
Date:   Fri, 12 Mar 2021 11:53:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.225-30-g76cdeeabd8084
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 124 runs,
 6 regressions (v4.14.225-30-g76cdeeabd8084)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 124 runs, 6 regressions (v4.14.225-30-g76cde=
eabd8084)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.225-30-g76cdeeabd8084/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.225-30-g76cdeeabd8084
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76cdeeabd808403c2ec0bf25d309d0576f060f30 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/604b9685f201497353addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b9685f201497353add=
cc7
        failing since 11 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b8d90037e1ceb98addcde

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604b8d90037e1ce=
b98addce3
        failing since 0 day (last pass: v4.14.224-20-g7af575ced3e9a, first =
fail: v4.14.225-11-ga5cc03880a07b)
        2 lines

    2021-03-12 15:49:33.237000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/97
    2021-03-12 15:49:33.250000+00:00  kern  :emerg :  lock:[   20.497436] s=
msc95xx 3-1.1:1.0 eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc9=
5xx USB 2.0 Ethernet, ae:87:16:d6:85:3a
    2021-03-12 15:49:33.261000+00:00   emif_lock+0x0/0xffffed34 [emif], .ma=
gic: 000000[   20.514099] usbcore: registered new interface driver smsc95xx
    2021-03-12 15:49:33.266000+00:00  00, .owner: <none>/-1, .owner_cpu: 0 =
  =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b91ac139e07ded7addcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b91ac139e07ded7add=
cb7
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b8ba442c2f54b36addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b8ba442c2f54b36add=
cc1
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b8ba5e9d36dda27addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b8ba5e9d36dda27add=
cc8
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b8b539cae43bb05addce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-30-g76cdeeabd8084/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b8b539cae43bb05add=
ce2
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
