Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9C532BC0B
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380985AbhCCNi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241108AbhCCBjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 20:39:22 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8341DC06178A
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 17:38:42 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id k22so13127531pll.6
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 17:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y0UoudU0OpP/C+4rWt04chWkl6RJp2BJUe5weizrVPk=;
        b=Xgi7njA+U7pVqg0sTjMcFfWb+wOhx+Waxn0/E72ekw4rZF24AObhSKqEXc3onqcs5Q
         UTuVaJIqRKyCu1tO9ymIns+cgMSpA1fwdgUHxkvHHKHQbm1GciNZ9Ss5zftODLJP27F7
         oB+fBsvdHV+YnEoLbBVE4eWmaZFrzTgQOX87XSjXQuG9tp7sbkns8r/4hbsqIJeJ6smB
         Or8qKlyY69EXpKic/SuRB9AXtkkjHdvWma03lWQuyqV1qWyC+xh4pVP49Md3UaVmVkme
         bzlCsG5t+XOAGwagpU/VqNnhNflnsrXYGUKgXGDxoheLEmBKu/meFviU6rJiGVoqM1FQ
         Agvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y0UoudU0OpP/C+4rWt04chWkl6RJp2BJUe5weizrVPk=;
        b=H3LOvxzzMyejksfH/tX91qt1nyIl1RVjk90dm9yY7URfmRyCDdT92WX2q165q+8RMG
         y8NmwVwtltY5rvVBj38K6J8x0MsuFSObtOU990Wvei5n0DCnYWFYktV2uPlKYnbrpgsQ
         zTmbpKtb/SNCBB0QgVTuMZ8z4kD8OD4tqtNPDvDQ6dkX5AknsYeK8hdTFEZO8U7CiDy7
         woaOLJ24XGViTQUNsbmeb+eFLS4ym1J2VVyULCqKzAYmgnrpJZbhglOv4vnwhyU2j64R
         Ax/SfFTtTF+DYYnY0ouf2SXaAUwOiqoKYaJDSnTEZJtPmkFaub9hLJR9pQB1J5b4bgZ5
         HZ1w==
X-Gm-Message-State: AOAM532TygEMSqbatK7c0x1AYm7ulNC/+ZiBGtnJxkeYneLp5873YT4T
        pZD85t/fhPwQovJDm+Rot/biSG5QGvn7cQ==
X-Google-Smtp-Source: ABdhPJyKR/rM5oG3IX/e88sSipt2qNDtddak+usWdtzyfzjk0SgvcH2NkcEpU+qB8z9WZPkHonqRbQ==
X-Received: by 2002:a17:90b:360b:: with SMTP id ml11mr6262497pjb.98.1614735521862;
        Tue, 02 Mar 2021 17:38:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m10sm4570468pjn.33.2021.03.02.17.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 17:38:41 -0800 (PST)
Message-ID: <603ee8a1.1c69fb81.a43b8.aaf0@mx.google.com>
Date:   Tue, 02 Mar 2021 17:38:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-135-g90d5aacad5cf6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 60 runs,
 3 regressions (v4.9.258-135-g90d5aacad5cf6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 60 runs, 3 regressions (v4.9.258-135-g90d5a=
acad5cf6)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.258-135-g90d5aacad5cf6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.258-135-g90d5aacad5cf6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90d5aacad5cf640a69a965432687787f5ad7a949 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603eb41aba12ccf54eaddcb1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-135-g90d5aacad5cf6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-135-g90d5aacad5cf6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603eb41aba12ccf=
54eaddcb6
        new failure (last pass: v4.9.258-136-g5fde7b797e1e9)
        2 lines

    2021-03-02 21:54:30.888000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/119
    2021-03-02 21:54:30.897000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-03-02 21:54:30.912000+00:00  [   20.902832] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603eb4f952d3940a6daddccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-135-g90d5aacad5cf6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-135-g90d5aacad5cf6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603eb4f952d3940a6dadd=
ccd
        failing since 108 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603eb47ae8f4925402addcd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-135-g90d5aacad5cf6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-135-g90d5aacad5cf6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603eb47ae8f4925402add=
cd6
        failing since 108 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
