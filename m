Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962A1382C7B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 14:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhEQMrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 08:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbhEQMq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 08:46:58 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A23C061756
        for <stable@vger.kernel.org>; Mon, 17 May 2021 05:45:42 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c17so4851890pfn.6
        for <stable@vger.kernel.org>; Mon, 17 May 2021 05:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bXVdFyig/9kz6W4wDqIFovUe8uQRZMTUF/JQMGFP5Mg=;
        b=B1eGcTE4DQSK9LZ81OhlnOAUAIPpxs2ywIeGTSTXSiyOAFcVHjwfkZa7V0+/OOchhT
         yiMLRA6lHClvasV03tqtoINjYGFZ3BuophILd/YE1jTQZI4iGJqe1dFvMENJVl3Ou/4I
         2ADgcNHm/LY7JRxuKySg2JpOvQpRyvJ+BTJpLKE8RI+gG5UlAfg49fKhSIIbvNmkU48D
         hqFgNItK2+jlXgqElxtmpVi4DcERaw9lYmbuZCaB2dAHHZZgdGXqqbJszP/l1mtdJGaE
         eRUETxsFZZXI8S6YeNzmssL//+E2Y1iDF5FgRoObX4YT4jxXgt4fXbty3Dgwab+dF96s
         ETzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bXVdFyig/9kz6W4wDqIFovUe8uQRZMTUF/JQMGFP5Mg=;
        b=GRrn7/pZbf331zEnA6iSdUA7yo3C9QWbWuE3SF119dzHQoaSGk9dJvZ3QUJ860fWsF
         NIa2mJkQo0R+i324dI2FlroyT/OblrwGYWu9Tinajwmuxzl8fjIuIZ//nv+C4Zl2GOhv
         6Dg7atiOxapeIUZjcAbnbYnT7WG0qLIQeoCJVblnhH1idb1MqZQWKG0j10FkfEtVAcGf
         T3xX18Ip2PAqYJXqmmW0kNUinMJ+6IWRsVMhHLFI3DvdVMtqys41ySifqh5QJ48vGHd4
         2Ko8WAm0m6OHTtcSk6TtMtbLK5XVFJHk1a8yBa1DqnbMejkezZo2psUe9xNGwxE7UEib
         Y6bQ==
X-Gm-Message-State: AOAM533tPEShhR8G2g1QFiP8REcFW0kXEFQf6tmVphjNCQA9izV2Nb8F
        UMQARMc1JARajrq/vr/BschGP+LXJM3vcAxZ
X-Google-Smtp-Source: ABdhPJzZARoWGs2GGm1kBXfRBqlBCZay4QYpWZUC7bdLIZSAk+ON3JWvQR7VkqAE7mohkggODSSo/A==
X-Received: by 2002:aa7:90d5:0:b029:28e:df57:47ff with SMTP id k21-20020aa790d50000b029028edf5747ffmr60435889pfk.74.1621255541939;
        Mon, 17 May 2021 05:45:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gj21sm1984153pjb.49.2021.05.17.05.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 05:45:41 -0700 (PDT)
Message-ID: <60a26575.1c69fb81.ec7c1.5c92@mx.google.com>
Date:   Mon, 17 May 2021 05:45:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.119-112-ge641e9ecc222
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 127 runs,
 4 regressions (v5.4.119-112-ge641e9ecc222)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 127 runs, 4 regressions (v5.4.119-112-ge641=
e9ecc222)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.119-112-ge641e9ecc222/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.119-112-ge641e9ecc222
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e641e9ecc222f379855a2ffc5008a1d057cd892e =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2312c245e2c948db3af9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-112-ge641e9ecc222/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-112-ge641e9ecc222/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2312c245e2c948db3a=
f9b
        failing since 178 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a22fd27ea172fd18b3afb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-112-ge641e9ecc222/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-112-ge641e9ecc222/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a22fd27ea172fd18b3a=
fb3
        failing since 183 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a22fe17ea172fd18b3afc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-112-ge641e9ecc222/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-112-ge641e9ecc222/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a22fe17ea172fd18b3a=
fc8
        failing since 183 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a22fd67ea172fd18b3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-112-ge641e9ecc222/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-112-ge641e9ecc222/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a22fd67ea172fd18b3a=
fc2
        failing since 183 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
