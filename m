Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0432D20ED
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 03:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgLHCiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 21:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728035AbgLHCiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 21:38:17 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABEBC061749
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 18:37:37 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id e23so10816195pgk.12
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 18:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TQxnVHWEiaIYpAEnDl/NPPWH5UJgaEIUT/SohgsKmMI=;
        b=IasWOoEGc+LvFTbZRTbzkirPSqq6jKGS5V2pOeOSgYwYnK3502Bx3419vYUl6DF240
         SoN76PnYZm7Tbt3tYcYDn09THpLi4gP42OSaFyKE/nGtVyzqlqgX2XyjLmC9NI5XQbJf
         HJ8Uul/0MJC/NBfS0Kda5fcLPSSLuxnZjLEgYk+M2jIPTt9oN9QfFixzyZEGdOAItWEl
         pZiyS4omARWjOscKnHcHG3bWlcdwLKiSe1tV/73PvWWY16qZbuAtHg/VVVxOKcRK0YJA
         +r6iAvSwzYz5zM7IvGfz6r/4WLNWKumTCuiiSh9xxul/o/cAhRQzZ2rTJatfqD2JaXTK
         x32A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TQxnVHWEiaIYpAEnDl/NPPWH5UJgaEIUT/SohgsKmMI=;
        b=Stob6lwQeCvOubIwiktURU52fZEmbY62l2QnmHqEqBdpnr8BNJEg/7d+fGMxfhGzN+
         M2MPjTQiJvJ9Z8wi1aB5njT2ZHN8ELzgWK8xeV8B+96wN7Xej5lUKe6ADKAgMGr9Wnge
         xKcnmkbR6Aoph+48AWbLJ04TlHY9P0FBM1WQU4+B3PKYmB+N+Boa/gf1GZut6v+jC4SX
         PrGJEoaTICXS/oaLm/cC99h+XzGLDlnw2IJXxixyU7werK/d1JUwFTQDP80KD3Kq31CA
         ZJO7jfEndXUe019pCzsFXMlOAU1GVo9dP8e0c7wqgeDNxNR17GWVQxhkAJm4E+HOCAZv
         1Mpg==
X-Gm-Message-State: AOAM531ZUuQh/46MfbnPFMGWqXMj8N4nnIQw7qPnKH5cVZREliTEGsQ0
        VEQmlLN3//uCjIG4P41QJoG1MwsJ2rTKbQ==
X-Google-Smtp-Source: ABdhPJyiel/3xiRjgwWa0VeUOAtWUwMOlhw1r04EGFNFFmyC26D/qD7X+ZUeuS25FwR/w1v4bT+HQA==
X-Received: by 2002:a17:90a:49c5:: with SMTP id l5mr1868893pjm.116.1607395056007;
        Mon, 07 Dec 2020 18:37:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nm6sm755383pjb.25.2020.12.07.18.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 18:37:35 -0800 (PST)
Message-ID: <5fcee6ef.1c69fb81.c9460.2ade@mx.google.com>
Date:   Mon, 07 Dec 2020 18:37:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.247-13-g8f96dadc6cc2d
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 131 runs,
 13 regressions (v4.4.247-13-g8f96dadc6cc2d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 131 runs, 13 regressions (v4.4.247-13-g8f96=
dadc6cc2d)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =

panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.247-13-g8f96dadc6cc2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.247-13-g8f96dadc6cc2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f96dadc6cc2d33ea42fbcf2cff02e88365fe6de =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =


  Details:     https://kernelci.org/test/plan/id/5fceb4561da211265dc94cc8

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fceb4561da21126=
5dc94ccb
        new failure (last pass: v4.4.246)
        1 lines

    2020-12-07 22:59:47.960000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-12-07 22:59:47.961000+00:00  (user:) is already connected
    2020-12-07 22:59:47.961000+00:00  (user:) is already connected
    2020-12-07 22:59:47.961000+00:00  (user:) is already connected
    2020-12-07 22:59:47.962000+00:00  (user:) is already connected
    2020-12-07 22:59:47.962000+00:00  (user:) is already connected
    2020-12-07 22:59:47.962000+00:00  (user:) is already connected
    2020-12-07 22:59:47.962000+00:00  (user:) is already connected
    2020-12-07 22:59:47.962000+00:00  (user:) is already connected
    2020-12-07 22:59:47.962000+00:00  (user:) is already connected =

    ... (477 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fceb4561da2112=
65dc94ccd
        new failure (last pass: v4.4.246)
        28 lines

    2020-12-07 23:01:37.626000+00:00  kern  :emerg : Stack: (0xcb8fdd10 to =
0xcb8fe000)
    2020-12-07 23:01:37.633000+00:00  kern  :emerg : dd00:                 =
                    bf02b83c bf010b84 cb99be10 bf02b8c8
    2020-12-07 23:01:37.641000+00:00  kern  :emerg : dd20: cb99be10 bf2200a=
8 00000002 cb937010 cb99be10 bf24ab54 cbba8510 cbba8510
    2020-12-07 23:01:37.650000+00:00  kern  :emerg : dd40: 00000000 0000000=
0 ce226930 c01fb3c4 ce226930 ce226930 c0857d30 00000001
    2020-12-07 23:01:37.658000+00:00  kern  :emerg : dd60: ce226930 cbba851=
0 cbba85d0 00000000 ce226930 c0857d30 00000001 c09612c0
    2020-12-07 23:01:37.667000+00:00  kern  :emerg : dd80: ffffffed bf24efc=
8 fffffdfb 00000028 00000001 c00ce2b4 bf24f148 c0407354
    2020-12-07 23:01:37.674000+00:00  kern  :emerg : dda0: c09612c0 c120ca3=
0 bf24efc8 00000000 00000028 c0405828 c09612c0 c09612f4
    2020-12-07 23:01:37.683000+00:00  kern  :emerg : ddc0: bf24efc8 0000000=
0 00000000 c04059d0 00000000 bf24efc8 c0405944 c0403cf4
    2020-12-07 23:01:37.691000+00:00  kern  :emerg : dde0: ce0c38a4 ce22091=
0 bf24efc8 cbbad840 c09dbb68 c0404e40 bf24db50 c095e460
    2020-12-07 23:01:37.699000+00:00  kern  :emerg : de00: cbbbda80 bf24efc=
8 c095e460 cbbbda80 bf252000 c0406408 c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb454fdddbe75a5c94cd8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fceb454fdddbe7=
5a5c94cdd
        failing since 5 days (last pass: v4.4.246-25-g412881df37c23, first =
fail: v4.4.247)
        2 lines

    2020-12-07 23:01:34.722000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb54423faa147a3c94cea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fceb54423faa147a3c94=
ceb
        failing since 23 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb6c47f23e09f72c94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fceb6c47f23e09f72c94=
ce3
        failing since 23 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb516ae71efd631c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fceb516ae71efd631c94=
cbf
        failing since 23 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb54323faa147a3c94ce5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fceb54323faa147a3c94=
ce6
        failing since 23 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb5284f9fbc9e06c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fceb5284f9fbc9e06c94=
cd3
        failing since 23 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb5264f9fbc9e06c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fceb5264f9fbc9e06c94=
cc7
        failing since 23 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb710691eed7449c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fceb710691eed7449c94=
cd3
        failing since 23 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb509de8cded35dc94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fceb509de8cded35dc94=
cc5
        failing since 23 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb5324f9fbc9e06c94cde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fceb5324f9fbc9e06c94=
cdf
        failing since 23 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fceb5294f9fbc9e06c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.247=
-13-g8f96dadc6cc2d/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fceb5294f9fbc9e06c94=
cd6
        failing since 23 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =20
