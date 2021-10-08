Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4788427093
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 20:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239973AbhJHSPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 14:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239981AbhJHSO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 14:14:56 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A60C0617AD
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 11:11:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so8455347pjb.0
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 11:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DbJwNZKti+MVyI1GAHGWpqPmOq5HOn7RymQVw/N1AdM=;
        b=8ARADY7ezw6cpyG/mqECTUQAhXN4tVK7aQJwfCQcevNP0OifSyw7x2//HBijHYqBoH
         zofMUIDFolRMsy5MOBAf099zyFjlS/xNW1+hTQ4SrFFzrONFYZB3ferkhDmzkS9DcbXY
         Mon95nHKybvgK4D95mPU04LpOvMnbltPtyEzDsmZwgHjQtrgVwJOinFNBtYjCAaFfxjm
         mQWySYqEzY5MK9zHHoYJS7g8ImMXLUbIFAx9ZvMnxFtCex4T0VYPmEfEsG8yvTFTv7VP
         HJKQu89nJY2YBk+sYz+5Mm3KWs3aBnk/vuUEZSDAq49C0r2DmAD0wcMIThao/wgvgtyH
         NOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DbJwNZKti+MVyI1GAHGWpqPmOq5HOn7RymQVw/N1AdM=;
        b=oylwVhHjbk4NWP+cYCOnB1VWLwSioOGX+UlSnPNrC2mwE9Vu2VoCUoGNbLAe3O7YkS
         DzLa2jhSTcAAGemQv6UN+MzWGzqK6FjM9BMRo5kARtroOoAM+2KaG/cX9xLEjx/3k/R/
         3vB4v0aS28HU7VvuH8Hu80AfPEN5K0XZnsi5qxdo6xHOMYgsfxqwSpapnUsv/oc54qeq
         9+HDLiGATUpF79sShC2hM/sQZtWGZFkx5o3RS3oTsGQI34WncakiQeC5Z6Hsq4CubvcN
         Z2Zvpf7yvue3vSYnD8JVnI6QzKMLO9H05RM5e7lpd/N6fOATdNKT2WBZ+fIbNcgFLcSX
         Ng2w==
X-Gm-Message-State: AOAM533kBzJqF6lAEqYAx3SCsb1qg8Rn0LvLIHEf88A9PiNrnNnGDYle
        Hd2VRolyaDbD0TxKeqXAWt/AltUQLnQdciyg
X-Google-Smtp-Source: ABdhPJx/x7sdbsFdsRQYqctyT7eGjCbdPKp9HZflWP0d2AcZ0ariZfg4iNxtbZ8jdM/7riajdkj0mA==
X-Received: by 2002:a17:90a:de0b:: with SMTP id m11mr13366396pjv.90.1633716709097;
        Fri, 08 Oct 2021 11:11:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a10sm17338pgd.91.2021.10.08.11.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 11:11:48 -0700 (PDT)
Message-ID: <616089e4.1c69fb81.35276.0169@mx.google.com>
Date:   Fri, 08 Oct 2021 11:11:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.209-13-g0cf6c1babdb5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 136 runs,
 4 regressions (v4.19.209-13-g0cf6c1babdb5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 136 runs, 4 regressions (v4.19.209-13-g0cf=
6c1babdb5)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.209-13-g0cf6c1babdb5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.209-13-g0cf6c1babdb5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0cf6c1babdb51acc917475373133f5d05d584d35 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616056497a0e4913f899a308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09-13-g0cf6c1babdb5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09-13-g0cf6c1babdb5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616056497a0e4913f899a=
309
        failing since 324 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616089cc3659fc8a8899a2e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09-13-g0cf6c1babdb5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09-13-g0cf6c1babdb5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616089cc3659fc8a8899a=
2e2
        failing since 324 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616058c3ef5170847999a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09-13-g0cf6c1babdb5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09-13-g0cf6c1babdb5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616058c3ef5170847999a=
2f0
        failing since 324 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61606f94693fecb03f99a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09-13-g0cf6c1babdb5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
09-13-g0cf6c1babdb5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61606f94693fecb03f99a=
2ea
        failing since 324 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
