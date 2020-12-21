Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCBE2DFF51
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgLUSHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgLUSHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:07:36 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C77C0611C5
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:06:56 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id bd6so4812035qvb.9
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jWO9TzP8zBfvduhSqKCxzGvQDXKg6HuS4G/eTg0euIQ=;
        b=HAOhCSGGJwI3utX6/Wm+4dib9WjFNC4i+lCZ6xre0zEQ2lj938Kri03kA1/HayL3dP
         S82Utf2chWfbcLDjstG8F+en2hlkuenFxvCKYlGYC/8KGergKMgnmFgiDfcRpgQtrKy3
         hc1KG8YSSjaR/7xADvlOaJIAajXcrmkbpvp3dOG7duW5Hgo6HbHm3w0qbzvkeUcUkKBf
         cgr5maKMwvuzfrzRouJ7S4j5x0sIp3/81IaufN1nFF8ruigV/osnt0bxB5opfsY7KOxA
         VxLHuzVflcvCxv0ew7G7DTp1IFboSLAyJ01CzUS7PmhzLhPUZvyQG+9ROHosbhx4Q44J
         yilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jWO9TzP8zBfvduhSqKCxzGvQDXKg6HuS4G/eTg0euIQ=;
        b=VhgtEwzLSOTCt/4wZfcHpoxMOg9wOEoUgdomwUFDCIWdl2hzBBr+ok2O8iAYPrvfSj
         dP1yQBAKNsGjO3dNv/f+La3d4CYLgoqT7aYjIotlEartLghoOYczq6d2nwGQSPZkq2dt
         XG3POA8KaGQdaVB7Uu83HQJhrRm20bAPnPOMp2qNqqLCPWGNNET2sjLS6lXuRO6M2iNJ
         a/AYMLjyyXgxKSA3nO7OMFMrS9KZP0XTolwlMMm9C3qb9rFC2CMQ1NwRN7ar918Fe8wf
         Tjrl0+qbhCtYo9mCAD6QCq9hGscq1Jqbr/iPcFSbgYYiBQH6DwqpooCe/4MZ2nten4jh
         /q6w==
X-Gm-Message-State: AOAM532AVuw5X5abVdpBzzM4bbrZFh2/V4oIbkpziDJv7WaHAs4JkVVO
        XOOUk/OU+A0heRKmGeoyv5spzrRzjaEGDQ==
X-Google-Smtp-Source: ABdhPJwV/6LSd0V0mmZ6PWnc+xkfnwb2gfDTk8Ipsw+eefLxqJnys6INvzfGSnADeZ2IOzvYPPwDqA==
X-Received: by 2002:a62:1a56:0:b029:19d:b6eb:291a with SMTP id a83-20020a621a560000b029019db6eb291amr16861877pfa.10.1608573567250;
        Mon, 21 Dec 2020 09:59:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2sm16840395pff.79.2020.12.21.09.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 09:59:26 -0800 (PST)
Message-ID: <5fe0e27e.1c69fb81.18f89.0441@mx.google.com>
Date:   Mon, 21 Dec 2020 09:59:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-34-g4302ba21a5a87
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 138 runs,
 7 regressions (v4.14.212-34-g4302ba21a5a87)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 138 runs, 7 regressions (v4.14.212-34-g4302b=
a21a5a87)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

meson-gxm-q200             | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

panda                      | arm   | lab-collabora   | gcc-8    | omap2plus=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.212-34-g4302ba21a5a87/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.212-34-g4302ba21a5a87
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4302ba21a5a87f6ba341f40896910b33069f2957 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0a81b86b464258dc94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0a81b86b464258dc94=
ccb
        failing since 1 day (last pass: v4.14.212-33-gf6029879256d, first f=
ail: v4.14.212-34-gf9a3a712c0d7) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxm-q200             | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0a8ef2480518c36c94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0a8ef2480518c36c94=
cdd
        failing since 13 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
panda                      | arm   | lab-collabora   | gcc-8    | omap2plus=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b196bff3b3ed82c94d42

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fe0b196bff3b3e=
d82c94d47
        failing since 7 days (last pass: v4.14.212-2-ga950f1bfe7736, first =
fail: v4.14.212-9-g0472cccb2d80)
        2 lines =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0a85cc583501864c94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0a85cc583501864c94=
cc2
        failing since 37 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0a868c583501864c94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0a868c583501864c94=
cd7
        failing since 37 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0a8157c238bf17bc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0a8157c238bf17bc94=
cba
        failing since 37 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0a82486b464258dc94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-g4302ba21a5a87/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0a82486b464258dc94=
cd7
        failing since 37 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
