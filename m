Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5E72D05C0
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 16:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgLFP4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 10:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgLFP4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 10:56:00 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10B4C0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 07:55:14 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id s2so5821222plr.9
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 07:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/MiqikTTYLH7LJ/ZHBtJUDGrafSVkeAHmpSphVoL0s0=;
        b=F2JrXXZnGJhoMMvIUEzkmjS8i4IXjaAjeF6xzTDSTKbypzM0CjStO0y2Vv5LSyA7mw
         ZQwaffcgi3E0cY3/t30eIxMRG2X+MIfZXLmqAaHMYXGTaJw0BC85sx6TwHk8XEaMeGGh
         W9TehiDQOe+5MCIa+cqBzoV9pIJvAahIS9RY085C6U+XDoeXyQSVAVFM5M8T6JnLvqay
         VBbKKUQSQzM42B4kugpYXqPDrsmUVUcHE0wvA5pSjspHhrOUa/rd8g0DeJkbiXwZdOce
         zPpsx4c3T1r3vryWiOTk8CDa6tZrtdIY+Uk4kZsGlqUEu0SohIH7n3TK9NQDZms0ce1g
         hPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/MiqikTTYLH7LJ/ZHBtJUDGrafSVkeAHmpSphVoL0s0=;
        b=O8hINNQj/Tx+rAtkmle/WEkZF9bWim0tbhzVj0/ZP3C6XWE4eOscKBC98fgGdIBn5i
         w1ZJcp8trg2kqUjHqMQz92t3XtnFq874tQVncNRdAfxifbjlzE62laxmmx2m/ebpApzd
         e7WBNEE+Mlp6CrJEB84ZLTmt/ohruVdhv0/Qr7f3DvJxVELTWaj2IMQkxaTSQb/O3FjH
         lPZAK5vpj+fjeLORCg6asgGc/oR0WirfibCUrmEtBI6a63XuNBasa7A7Mbi1STGisPCz
         dxzRkH3QqGj1ENmO9uO40AlpbZhto9ux2hSvrGGcuEztl1YmpOYqYNOcVqCt7xENbfqS
         0kNw==
X-Gm-Message-State: AOAM530YAGxJDZRs1EFWIecNnsxeEDqSmR2shKM2eu6IL0Bo2Q7lh/er
        wj20WQgb15B6RSqf7TUKqn2UqDNrrUjzww==
X-Google-Smtp-Source: ABdhPJwO/u0aQZYzSqgqy3KFhaOImQOmYXK7YCAfYnuKUwQY+iO2bhP6KoYThJiE30gUO9pzyPjRGA==
X-Received: by 2002:a17:902:8e86:b029:d9:e12a:8888 with SMTP id bg6-20020a1709028e86b02900d9e12a8888mr12037360plb.51.1607270112738;
        Sun, 06 Dec 2020 07:55:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x6sm9060966pgr.20.2020.12.06.07.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 07:55:12 -0800 (PST)
Message-ID: <5fccfee0.1c69fb81.5da4e.4864@mx.google.com>
Date:   Sun, 06 Dec 2020 07:55:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-17-gda0b38954b23
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 134 runs,
 7 regressions (v4.9.247-17-gda0b38954b23)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 134 runs, 7 regressions (v4.9.247-17-gda0b3=
8954b23)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_x86_64          | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =

r8a7795-salvator-x   | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.247-17-gda0b38954b23/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.247-17-gda0b38954b23
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da0b38954b2396901ab1357fa807b588da5d746d =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccccb6dca18be612c94cde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccccb6dca18be612c94=
cdf
        failing since 21 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcccca2e5ceb2803dc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcccca2e5ceb2803dc94=
cba
        failing since 21 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcccc7c0edaf00fcbc94cf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcccc7c0edaf00fcbc94=
cf8
        failing since 21 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcccc38d46887632ec94d03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcccc38d46887632ec94=
d04
        failing since 21 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64          | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcccc2dd46887632ec94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcccc2dd46887632ec94=
cba
        new failure (last pass: v4.9.247) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcccc2ed46887632ec94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcccc2ed46887632ec94=
cc6
        new failure (last pass: v4.9.247) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
r8a7795-salvator-x   | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccc938509ec02420c94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-17-gda0b38954b23/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccc938509ec02420c94=
cd5
        failing since 18 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
