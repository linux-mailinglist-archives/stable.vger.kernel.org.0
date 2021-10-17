Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001A6430A53
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 17:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbhJQP7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 11:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237507AbhJQP7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 11:59:39 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C62C06161C
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 08:57:30 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 66so13488305pgc.9
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 08:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vdNz7e/U9+Zehq4Ai3PMjTHTsv9dKtypxbchq30x5HY=;
        b=DKTIJuHOuD8GyAaikUQbmkvyW+6AhIr5nb77o5091JA+odnI6MLrUECUi9j6moTfTD
         hnx8T4Wd5wR6dv2Ov1Wxhs6dzj0adAbsnUiF9keAH29Lo97EuERA6sH8Tz1LCPdJNQ1H
         gho0IhePhMmHc6dU50DKxVyz6OrlMBu7rUEjNGBL/NCBr1yw+AaIezO3l9zEg8tlDwB2
         CLXMZgeMYxGyYXzyVLgaEXZ0EpgSjWKJJV8VnvApnV1xi0Nock5BmkoWXVz979tKWjlm
         SnIgivSl2ltd1mgeh/29WJxvZhEbFwtrw41MQIYJ8MqnWgzybrxJ2XdEaxf4JjrQUBKh
         ixgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vdNz7e/U9+Zehq4Ai3PMjTHTsv9dKtypxbchq30x5HY=;
        b=40wCHxXbOqs2N/F5rF6gke1qEME32OgsKhKrg1Rt6qdqUB6/rabJ1jK6X1uA2w3PUL
         7x/8He1I9OIsBgEoZtNgfftFMNb1QTNg5T4LmGO6Vy6zePZ2DtRDkUGzbNDGAqNB6ADl
         rBcTcAxt/uUmvrcukbUjMwjnc582hWfMGKQi18bvc+iN6E2r+YjSC3ZKrF6IOtfwSDPy
         hublPTMZbuv+UBJf2IrR7NvTiNMC4R6bxxW4/zJZ/rt0EjbouTt2AcFh9Vr8wa572O4a
         0bRpDw+DiBtQGnBcj/bWCPF8XxRC+RP00rpkr3oEqUGDbraDJo3zgEQyHUDO4c6w9l3t
         n1CA==
X-Gm-Message-State: AOAM531LvUDbSFNawiK1S+Arff6ctUg/fIEF60Wgdo+8X58QuVUSy6jj
        AxAn/VoDO9B4F2MS+9h1z/pk+vyACwlt8J/P
X-Google-Smtp-Source: ABdhPJykiyu6J9xmmsHpfdlfvfItCnAUuI9avsYd1HEnmtQD4lyBTY+ywONz9iL43zD3oy3LW1NGYQ==
X-Received: by 2002:a05:6a00:14d4:b0:44c:cdfa:f8f1 with SMTP id w20-20020a056a0014d400b0044ccdfaf8f1mr23096236pfu.58.1634486249346;
        Sun, 17 Oct 2021 08:57:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n18sm10328595pfu.214.2021.10.17.08.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 08:57:29 -0700 (PDT)
Message-ID: <616c47e9.1c69fb81.55b97.d28c@mx.google.com>
Date:   Sun, 17 Oct 2021 08:57:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.212
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 78 runs, 4 regressions (v4.19.212)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 78 runs, 4 regressions (v4.19.212)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.212/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.212
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f74f1728531c43f4569eea4645fcc58feedc677a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c00aa4e1e2934533358eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.212/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.212/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c00aa4e1e293453335=
8ec
        failing since 332 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c00c94e1e293453335913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.212/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.212/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c00c94e1e293453335=
914
        failing since 332 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c02650c6290eb5f3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.212/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.212/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c02650c6290eb5f335=
8dd
        failing since 332 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c007c67e0cdd64c3358e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.212/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.212/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c007c67e0cdd64c335=
8e5
        failing since 332 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
