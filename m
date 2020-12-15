Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE862DA868
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 08:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgLOHOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 02:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgLOHOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 02:14:36 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD3DC06179C
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 23:13:56 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id i7so2953457pgc.8
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 23:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vNJGS7TI1RwD+8L0+TkBl/YvYpy4Ateqi2b1thTc/Kg=;
        b=1WRrXlaL7gy0hrmqx3W9al+qdocWFnrayq7Gd8GMCqUm5kFASh8Vkf2pDksL6CJF0O
         daXsC0F6VFDJTqtP0V+4LNOO+Fwm8WXJJvALPzgzXXUahz1FkSwBdMHT3xZXebC/7w6a
         XWB/ujoUkgWTver+d8g9oCytMj2HqA7MuBAhXavjMtnbyHS3mwkq6jdHvaILiQRQn2Me
         C8dIBSAdJz8Iw8yWsQleBTxcyfyteTosjVWFSX/f6IsRKMkrIKuZsP+UqiAjV1TXiQOh
         Cb544a7IA/IyuLD63pesgaMvdbeukQK/lo+5mUyR3bKjgHiESFJEcWhJ7NU6oz/mMNBQ
         RMMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vNJGS7TI1RwD+8L0+TkBl/YvYpy4Ateqi2b1thTc/Kg=;
        b=r+LHPv+YFk0I3mDKzW0V7/zDy3aQdkH92tQmMOmEqNt/XsBk1YbE/ji7wTW94wRaXC
         A4wKFczIlAVE80RwiFHUOQaC/Y/GUPRtzDuYKzlh5yfbiDUo4hl0eyEVPg/mMhvVdGzH
         Wf2/eJTNRQHYMYlX6PAjl2/q3mcfjp73NkUNbkbfCdks4XEq4L+zG38j8AxStB6Tp1Ue
         8q2iwVNa9daT9/QEnYbdyRU1XA0vP+lqyBUGPHVLizz2TfnpiqwBmcfxagG7P3/YyT1X
         7+lqTqti4sb34Nr6qLDjQ0KKp2BU/itiesUFTSYHD358Jc51MRbcbooqnEPgEqu6H9T/
         QTcQ==
X-Gm-Message-State: AOAM532RDWLOQUyf2FZu4EHm83+x3PP93DK0ne3QQeE2UCnUiibIAahS
        xDDtbmYm5xfBwpneEdAm0k1YkyHwQ/3pkA==
X-Google-Smtp-Source: ABdhPJzzyd3G6ijCFNW0S3JCiyhZCGgeCgyS9E+M0aJ0YgQJSosrPpHNjMkQ3Nx3+k7z4q5t3OvgwA==
X-Received: by 2002:a05:6a00:1623:b029:1a4:e935:87a8 with SMTP id e3-20020a056a001623b02901a4e93587a8mr10452535pfc.26.1608016434895;
        Mon, 14 Dec 2020 23:13:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o62sm21904474pjo.17.2020.12.14.23.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 23:13:54 -0800 (PST)
Message-ID: <5fd86232.1c69fb81.4f693.cbe2@mx.google.com>
Date:   Mon, 14 Dec 2020 23:13:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-28-ge89f25b970ae
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 112 runs,
 3 regressions (v4.19.163-28-ge89f25b970ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 112 runs, 3 regressions (v4.19.163-28-ge89=
f25b970ae)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.163-28-ge89f25b970ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.163-28-ge89f25b970ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e89f25b970aebaadc2950ca4d4c76ab8114f25da =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd82ca68cd6fb5979c94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-28-ge89f25b970ae/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-28-ge89f25b970ae/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd82ca68cd6fb5979c94=
ce4
        new failure (last pass: v4.19.163) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd82f29b010054432c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-28-ge89f25b970ae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-28-ge89f25b970ae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd82f29b010054432c94=
cc3
        failing since 26 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd82f244a4b4e0498c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-28-ge89f25b970ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
63-28-ge89f25b970ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd82f244a4b4e0498c94=
cba
        failing since 26 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
