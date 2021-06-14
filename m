Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E83F3A71F2
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 00:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhFNWeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 18:34:16 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:40707 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhFNWeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 18:34:16 -0400
Received: by mail-pf1-f174.google.com with SMTP id q25so11722724pfh.7
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 15:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TA57gB550aiKIz1KFhdtjmbRLki9KL0tYpMJgn8ehQE=;
        b=SMK+a9fudd+mQKcGXe+YfCO6Lp0CbRy2U6JgP/AWVBvLTFg/4KTxPLJ3eN05k/ECPa
         6vhyiwt7HEZ+C5o+6X4bRnlPfKTmsavjtm47/ha9qIy3VD4FGnbm1OtLfsdNXjJtBUdP
         poLs4eXkgQCtD69vwioRaXERBnEfEk06WFH9q0rFnLH1tca79Nj3zYJlV7siMJxJQ3xa
         ZcbEJaaXd2P2EzOVMa0q4H3C7dAecGi9DcQN9GncFV43LnrQBVH8ANRk/rlF9R1pm8Si
         2jN4zzKpGf3F6voyDL6DiP/BcBoBNUKK2OxW1JinzzHDsnU0FiBZIIOUwxkRCq98mXKm
         jTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TA57gB550aiKIz1KFhdtjmbRLki9KL0tYpMJgn8ehQE=;
        b=VHZKPc47gC5XjQvIEokWPemgOeE2iv4Af+KXkmiU/5oKmQB8EWCupf7+/BgdPw3Wou
         yAT5cH9WKg3aoD02bE7Kjf/oS9K/IZAlbjtujxaZctmz2Y1inSynx49jNfID7ZClPEMR
         7wwVshVxSfENFefD8xWLd6DewF3cb+cIrkuklkB+MJnfJSIKblas86PTsxvB4i2BZqKs
         6fIT3Cd7sB6q1Tl48ptVuVPzXrtAYMGeZfmRrzYjMGH+8qC4SpaQk0OUEzncG0rr97M9
         ShrNOPXkxgncR3TSeJMJkt3jOmcI+Ki5F8fg03/StqpG6H9usWWY5tIllMNL45Q/gISu
         q4tg==
X-Gm-Message-State: AOAM530LharWu4LExLpsRSQkvjIEKVwcfwZculvKXEXz8FyKT1BpgSKF
        K36fApl66tT0hbJX2hHaDYWrQRZ5Jcydczsv
X-Google-Smtp-Source: ABdhPJy5iYdvYfBKwru3tsli0GTf47WS/9s/c36RevsYBeVcULY4Jp/c9Ap7UUeBUyTk93CifwpCAw==
X-Received: by 2002:a62:2bcb:0:b029:2f8:82d6:e4fa with SMTP id r194-20020a622bcb0000b02902f882d6e4famr1139741pfr.66.1623709859455;
        Mon, 14 Jun 2021 15:30:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q16sm4870375pfk.209.2021.06.14.15.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:30:58 -0700 (PDT)
Message-ID: <60c7d8a2.1c69fb81.38866.dd97@mx.google.com>
Date:   Mon, 14 Jun 2021 15:30:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.194-67-g1b5dea188d94
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 128 runs,
 4 regressions (v4.19.194-67-g1b5dea188d94)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 128 runs, 4 regressions (v4.19.194-67-g1b5de=
a188d94)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.194-67-g1b5dea188d94/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.194-67-g1b5dea188d94
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b5dea188d94046e825dec23a9bfe67fa0677b80 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7a0a96bf8cb5191413294

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g1b5dea188d94/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g1b5dea188d94/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7a0a96bf8cb5191413=
295
        failing since 212 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7ada5818dc2aff8413273

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g1b5dea188d94/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g1b5dea188d94/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7ada5818dc2aff8413=
274
        failing since 212 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7a0a2f2d46f341841329b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g1b5dea188d94/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g1b5dea188d94/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7a0a2f2d46f3418413=
29c
        failing since 212 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7c81ddd560b42a84132cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g1b5dea188d94/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g1b5dea188d94/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7c81ddd560b42a8413=
2cd
        failing since 212 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
