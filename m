Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BA82C1005
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 17:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgKWQSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 11:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729881AbgKWQSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 11:18:06 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B78BC0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 08:18:05 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id w187so841242pfd.5
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 08:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qXgwIAANJEVgYgEnVnu79OyoMaIlVx8HFAo76Bc8oHU=;
        b=0lz+6hO2vnp0xBdT37qFtRtpHbskKAsIqU6YfK0JAUGtnOHLh7FJjmdzMjYmFAXjD2
         JSDH1wtgbGDPhv4y4jRNjwKJjRIpOnVi1arIBj11aYivTSVek8Yec3XWRiPTD7IpyDW2
         J1iXsUnpz/qVJP5XaYU0ZWTWJNcJdvi1ms6oj1t30C6dhig0HAjbO8IxMPj7zAh5Y6Dx
         CAsPZ5bfYloY5Rmu83i8Hr1/gk9caG2kRNM1yhwWfX5q3SMlu2wl2tcZuMUec1uTYeJh
         Q5mruaId8zu4pRzoiB1+C14XDksr+m4JSr1sJ+kVrVS8BmFSWEuhidx/zKU1HlG4Dq0M
         +LGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qXgwIAANJEVgYgEnVnu79OyoMaIlVx8HFAo76Bc8oHU=;
        b=hdmJj4Y2SZEOsndzr+TC9a54gxFW/PzZjZDWJ0+HGty92JLtaB3JMXkD1KUFNVEBLl
         e4UsbwReZ1z7Z55EPBIt9szr8UjEB0i7Mfz5R5GdpYHn6XEJw+jj3Ug4aKzw171dOVz3
         y33bBQjpeDTBiratGKO4wEBQdw1mX+eAcogxO+qISrZyMHv3Z4zSUjkJoFTXDixLVKU/
         IImyGfCwZ86kQVchJ4p1HsX1x95/Uwuo/etJZOQXZdxy+P6ZmKZb9Vns4SnF9Mbwxfvl
         lAyRHbYmETH0Q3FX5iI5ZqV3nCkInvLwd2VDs3pDDqiTLbMXOC1K4FFZMciW/Z0OM4nC
         1XaQ==
X-Gm-Message-State: AOAM5311/S7Hu4Ptp1y/wX1/CqDd1KuLcVKKFxuXIj8NBal1ZYVUjmls
        HjlrfcxExUudOBKff3gPUcXb29mIPYkU7A==
X-Google-Smtp-Source: ABdhPJw9il57Plc9vnIHFrRkAZY5u6PU2sgH9rxU8QiZw9rCyjdYc4H68H3rjni9JnYKcdZg6rhYLA==
X-Received: by 2002:a63:2107:: with SMTP id h7mr171173pgh.157.1606148284472;
        Mon, 23 Nov 2020 08:18:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b5sm12401828pfr.193.2020.11.23.08.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 08:18:03 -0800 (PST)
Message-ID: <5fbbe0bb.1c69fb81.36fc0.ab7c@mx.google.com>
Date:   Mon, 23 Nov 2020 08:18:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.159-92-g6f94b70fe8f9
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 128 runs,
 4 regressions (v4.19.159-92-g6f94b70fe8f9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 128 runs, 4 regressions (v4.19.159-92-g6f9=
4b70fe8f9)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 1          =

qemu_arm-versatilepb  | arm  | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb  | arm  | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb  | arm  | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.159-92-g6f94b70fe8f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.159-92-g6f94b70fe8f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6f94b70fe8f995a6d337b163e35735f9dc957ef7 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbae5aff6fcb3185d8d92b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59-92-g6f94b70fe8f9/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59-92-g6f94b70fe8f9/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbae5aff6fcb3185d8d=
92c
        failing since 160 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb  | arm  | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbac3e00571dbae2d8d91d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59-92-g6f94b70fe8f9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59-92-g6f94b70fe8f9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbac3e00571dbae2d8d=
91e
        failing since 5 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb  | arm  | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbac4e7287c500cbd8d91f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59-92-g6f94b70fe8f9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59-92-g6f94b70fe8f9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbac4e7287c500cbd8d=
920
        failing since 5 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb  | arm  | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbac49df791452d9d8d919

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59-92-g6f94b70fe8f9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59-92-g6f94b70fe8f9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbac49df791452d9d8d=
91a
        failing since 5 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =20
