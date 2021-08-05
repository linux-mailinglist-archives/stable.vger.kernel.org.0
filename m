Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06D83E0C62
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 04:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhHECRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 22:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhHECRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 22:17:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297D4C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 19:17:25 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so8592259pji.5
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 19:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UZwoF+7sWHZeZtFfRFzycLW88AmdB/iS0WTbwgR/thg=;
        b=oAO6ZmHQETNx3ZJ215RHJ0PwFZ5xA1PgUydhxBL5lsIjudtihEoRLKc2MovEi+TykU
         st0+7ByZSANljg73iCkyEkZcSEhhsoh0gDv3Rko/30x1i74xLF3IqDoSJ1RjfXe9HlyU
         3lCXiRjZ+ewwdAQYj2K5hgA3O7SEJcTWiiKECxDmQV6kNiL5JZxZC2to1dP8iZXVmz9a
         Azn+lS/8MJWFogXyo3dw8rB/PC3sEWfLhnxFWijYZEpMEfcKSrX5JccKncwQFhCmQP3a
         MdUe6+wR9X6bdJ2FZeArZZ/+ulwyjajX3Sf2N5vydupeOlbW/LX1pdjp7i8HJ0zOp1qL
         ENxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UZwoF+7sWHZeZtFfRFzycLW88AmdB/iS0WTbwgR/thg=;
        b=jDT19dIrNtfTj2cmpx8GDnyYUytkHOzpUXGdG05/QVKBY3ZiULAMMf3BpKsBUPidcs
         AuCJn+eN46e4577ZI/YiI56XTOYfEq9iHNWl2mbRmDSuqql9QvpqlXM8JinJhVC2jstO
         8rq0n2fPdEDjI0my1mNAEQeAyFCpOVZw8RWtL7nBvyK4ikYQXUMRRthrd+J8aT6soF41
         WtNSLDmrneo+3ZmpnXSZ4zuJxgC/Ds+hi9H8A+7ASrXDS00AKF0TRpFdpSObzuHyPw3l
         9IivBPXRF3xsT9nFGhGKEtKeAA/nC3QqypI4d3kfmjiq5CMqHaa8tavweTfY+YswtX7n
         dQHQ==
X-Gm-Message-State: AOAM532z5MBqiXFI1g5ynUCNRVVQycWhP1se9D637nSUezD+kuDR0hNr
        QuFTlJQmRyzPPEOUgWNeC6O7iOo7lXzqJfth
X-Google-Smtp-Source: ABdhPJyUF18FCVEGxmGDGOJQlzq/HWhXE5whvX+9Vj740QOjOKva0t3DG7hISXBI/N+qj7zIdFB/vw==
X-Received: by 2002:a65:6a52:: with SMTP id o18mr937021pgu.414.1628129844460;
        Wed, 04 Aug 2021 19:17:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z124sm5067166pgb.6.2021.08.04.19.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 19:17:24 -0700 (PDT)
Message-ID: <610b4a34.1c69fb81.bfd63.03e1@mx.google.com>
Date:   Wed, 04 Aug 2021 19:17:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.242
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 77 runs, 3 regressions (v4.14.242)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 77 runs, 3 regressions (v4.14.242)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.242/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.242
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      94cb1fed447ac8d328a8b50f9583df4ce70793e2 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/610b1994954b97761bb13687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b1994954b97761bb13=
688
        failing since 491 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610b2252830f667990b13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b2252830f667990b13=
667
        failing since 263 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610b16c1995b281befb1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b16c1995b281befb13=
67c
        failing since 263 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
