Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD304344FED
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 20:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhCVTdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 15:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhCVTde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 15:33:34 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D52DC061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 12:33:33 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 32so3214153pgm.1
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 12:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ljkBIvWOrnGYJXkqxmSFtg/HxXuZTFwLj7P2johCPbY=;
        b=nfv0YTEBmqzoqHKz1atdZAI482eulTQ1LjbREtOmkJr3jxz0zElbPLA5r2xBvLnIHc
         cgrx6STVFQRMNFz5ZJ3yo4PkTnhQkCIw7ZyrsGoGOXywu5m1MgSDB0IaP74d1rHLywcc
         FjnVgt9DwrdUwk2PCDLl+7dzr/UJ/o6rNOSh2ME5lo0r6wmUQvXLherXQP7wp2AVh3Ih
         lVrfIWcZgsU46OdU7DUjtszicsLctn2EeOLLJ+29stkZLqp9+oxn5PFWoj0SMRSgvKV1
         J0voV4WR4qNrNf+gaS36ZjTcS+LukMoTdaGGxUAj/oX3aYESPMHyWvd0Tx7CrdG8QbMh
         DGvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ljkBIvWOrnGYJXkqxmSFtg/HxXuZTFwLj7P2johCPbY=;
        b=CKqDvEbG6CcI9CMwsuTcvsTHAII4CNRcOkRrwLtQU/PToAQflmXGNnvbFfSoAtmwAV
         /JFBAedEbgI9SHyNSPZJ/l1G5GTLy9o9xV2XFgEpdsJgSPx/TbtN68l/sRrUty7k5Orm
         WXroJYdWUSODYyeUDLhaoAfFHDSkBQhXresgwh6+MSLxTr4m/hTdCn6ruUC5pA9QPffR
         7ebZhYZQMd9oCqCBCQQO1/AqwPUFXs+y1k2SUAjj+5F7u0snDjA2MaUieidEdu/a5V+m
         S42ofXTFTZiaDSx6NO5rpLLHY1y4pUpHaYTsisV8TQ+iWGUgasc+l7bsNfjWDyD76sCW
         lBIw==
X-Gm-Message-State: AOAM530sj9AQoXoBmHQjcKhGr1GgYEuLHg199TgGX0fqZPYa22X7pU0a
        xk0K4xSTEIO2pyqOVWP9G5FEmf9s4oLAUg==
X-Google-Smtp-Source: ABdhPJzttuFw31XsR4ZXEXAB3CYTH6LmTsQLXXaOYocSl27BKeW11+TbB0jBMB/iXN4BV54pzczlaw==
X-Received: by 2002:a63:4e48:: with SMTP id o8mr964853pgl.420.1616441612455;
        Mon, 22 Mar 2021 12:33:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z2sm15235525pfq.198.2021.03.22.12.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 12:33:32 -0700 (PDT)
Message-ID: <6058f10c.1c69fb81.e7d0f.4660@mx.google.com>
Date:   Mon, 22 Mar 2021 12:33:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.182-44-g4d7ae88446ac
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 4 regressions (v4.19.182-44-g4d7ae88446ac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 4 regressions (v4.19.182-44-g4d7ae=
88446ac)

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
nel/v4.19.182-44-g4d7ae88446ac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.182-44-g4d7ae88446ac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d7ae88446ac4379fcf1eabf9be6130423280eef =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6058b9fac215ac342baddcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-44-g4d7ae88446ac/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-44-g4d7ae88446ac/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058b9fac215ac342badd=
cca
        failing since 128 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6058b9fcc215ac342baddccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-44-g4d7ae88446ac/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-44-g4d7ae88446ac/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058b9fcc215ac342badd=
ccd
        failing since 128 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6058ba100794ff56a6addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-44-g4d7ae88446ac/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-44-g4d7ae88446ac/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058ba100794ff56a6add=
cb9
        failing since 128 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6058d07ffd9a869377addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-44-g4d7ae88446ac/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-44-g4d7ae88446ac/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058d07ffd9a869377add=
cbc
        failing since 128 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
