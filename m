Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120B437F01E
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhELXxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 19:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241411AbhELXnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 19:43:17 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D48C061263
        for <stable@vger.kernel.org>; Wed, 12 May 2021 16:33:13 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t4so13393118plc.6
        for <stable@vger.kernel.org>; Wed, 12 May 2021 16:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=14bBOtPkIlZbP72mwWzpBGuer6L2wSeutOMKmjKQ7rk=;
        b=a+4uJ5yWf1Ai/aNJ/kbz3fhj0QgT3yqDCaPS0jaxsOPT3uLvKOqKPgdpWr8ueJvaVL
         W1GFzH0OeWy/2sgyCcETP9BQMw1ExGavJov52WzeFp/Pr+MPIRkSIPC7EJL07Uf/YbZA
         Snh1JLlBp9nvWDheAJxWEmt8BA/yLwgtbhvmEZBs9QU1eW/s5yY0Cne6fYyuX5b506EL
         8UfiAUniX98VIstoA2C23+zgn+tKQ0kPkan9PSz58n1rGJVFSLB0GQBmDoPYOtY7v+mx
         rYJbd/cO+eutwvgRkgAt2it+Rql4r9ATAxj1IRZtNLLKuzEZ2p+NMRo9G5rafqHoWuYe
         egcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=14bBOtPkIlZbP72mwWzpBGuer6L2wSeutOMKmjKQ7rk=;
        b=uoPef5OqUlbIftJMOyoai2ZDWcoITSvQTTMEyEbsdUEfTt2yCSw2mbdthmaeiruyr9
         roPOPsJxHenNIHhQENAEAG1003R8Vq7JWaqRi3sRS6cckhnl7wi97rimvOyQDOKB4S03
         QwRaE9u+OV//D/q0Tq/kJHfvUWNJw7HICo4wXkRi1jwPH/UQMC4Y04t7rrTFijPeK6HP
         RJdQt08Ly2fdyzxhMBDUh5dJqxem9/STEmzaR467AmLOvvwz4SwlB+WPDsw3uU8rSIZv
         4i5aW0ZLjzTIJYWuBF31jRHpn7zjXVRCA4I6XYbftE1F9opzv3PPRlCMop1RAJLu574S
         QgfA==
X-Gm-Message-State: AOAM531DId55R8chzUezP/049xsCLt9/pduqblFssHFiAAL44ip1A8+b
        Y0BI5br5gCcH0TAl5ptXG+sBKNuLWLHjc1E6
X-Google-Smtp-Source: ABdhPJwux8EbWppxQuTfQRNz4jbLASodLuZkrxXaM3hQHQGyflMqTg8znsJuVa0E/hmBRZE19DNOwg==
X-Received: by 2002:a17:902:e84f:b029:ee:cd36:80e3 with SMTP id t15-20020a170902e84fb02900eecd3680e3mr37662697plg.70.1620862392456;
        Wed, 12 May 2021 16:33:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o3sm719333pgh.22.2021.05.12.16.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 16:33:12 -0700 (PDT)
Message-ID: <609c65b8.1c69fb81.9ea56.3498@mx.google.com>
Date:   Wed, 12 May 2021 16:33:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.232-234-gdb409d166f5c0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 123 runs,
 6 regressions (v4.14.232-234-gdb409d166f5c0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 123 runs, 6 regressions (v4.14.232-234-gdb=
409d166f5c0)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.232-234-gdb409d166f5c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.232-234-gdb409d166f5c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db409d166f5c0d520b50b72ad028624690915768 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/609c34f10aa3101d6519929d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxb=
b-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxb=
b-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c34f10aa3101d65199=
29e
        failing since 407 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/609c33fba94cbea08519929a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm=
-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm=
-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c33fba94cbea085199=
29b
        failing since 48 days (last pass: v4.14.226-44-gdbfdb55a0970, first=
 fail: v4.14.227) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c30bd474f02a97f1992aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c30bd474f02a97f199=
2ab
        failing since 179 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c30b88ca5d1c6541992a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c30b88ca5d1c654199=
2a4
        failing since 179 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c30e1dad0e6e2d0199286

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c30e1dad0e6e2d0199=
287
        failing since 179 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c3143c9ec5ed82619927f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-234-gdb409d166f5c0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c3143c9ec5ed826199=
280
        failing since 179 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
