Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E49407230
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 21:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhIJT5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 15:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbhIJT5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 15:57:30 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9A5C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 12:56:18 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id v123so2801785pfb.11
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 12:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2rNhVgFOWZMyJPoAWlwfxXijGK8plZ28EG7M7wJhj6k=;
        b=HOve+JFP7BdSYowUZQSn7zLk8icOsX4XHlGh/VKM2cZlp9+tJsElINRTzJVVMzRxX4
         rcYmh7V0kTvyy7KSJ0icODmhz8PXMyjGNsxtep5Pz0nyrIsVHxaSLXqZGWHO2TTWSPWY
         jI2lN4quXQTQx+9dhosuX5x2VymJoY/2/7JFaEToAasBY+Y2p/U0P9nT0RBJaVWOOcoI
         jONGkCDJo6dHXkYmcYQWpoJT7xZHBvLlj86MYp8cbqKb++kzqBv20UT+qA2VpXg8aZqm
         Wjy4t+x/aM8/SFacmNL47AzLIBRbh0TyZdFHU+VKwTkSnq3BoEN3thc7SvJD6/NcDbDd
         oAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2rNhVgFOWZMyJPoAWlwfxXijGK8plZ28EG7M7wJhj6k=;
        b=dksn7eeGJIVc5iuwzI7AAX54TKZTYvMG0IqUmPXa4baf7i+gl31QDfX4FRKe0bhByW
         65gDkMX3fPeBYBj2J0o7vOB279nshAiPjGshn0BkqP+qvaPUO5hurJm6PZumMhQx14Hv
         Pn50nakgSwuJXZsyh2xa5qWKYOTNemwQ5HruvJVNV3yT90SKzh/z68pIbXXuKWGoaRF/
         SYtGtoDOpL9Xc+PX82Xb5zIhdaLpTcWBAktkz5y+vzDSdfgwDPA1kC65MVXO585XaHQ2
         P3qGcFm78QDkcssQqkUPyaQ4pVqSRsV497Z1ZQO3r5XHD+5CN8+PHseuw4NRJc1LK64Q
         8Ecw==
X-Gm-Message-State: AOAM5335U1T65liuGFMEHrNFcvqJu7LpE4MR2XbvHgvqbyST/zbpRmga
        +XZ6OoY0qgxVSagh4VdeOHNTeTrkwBA7xfva
X-Google-Smtp-Source: ABdhPJyfBaEQH8oazvRFkpTwKCCBRYhqCypNTa4wMNvdKhdprhZpxK4a5qe/MCl/4TlPl1nS5lJgqA==
X-Received: by 2002:a05:6a00:2291:b0:412:3db4:908e with SMTP id f17-20020a056a00229100b004123db4908emr9757690pfe.78.1631303777802;
        Fri, 10 Sep 2021 12:56:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j25sm4656657pff.34.2021.09.10.12.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 12:56:17 -0700 (PDT)
Message-ID: <613bb861.1c69fb81.2405d.d0f7@mx.google.com>
Date:   Fri, 10 Sep 2021 12:56:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-35-ga885f5ea560f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 132 runs,
 6 regressions (v4.9.282-35-ga885f5ea560f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 132 runs, 6 regressions (v4.9.282-35-ga885f=
5ea560f)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =

r8a7795-salvator-x   | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.282-35-ga885f5ea560f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.282-35-ga885f5ea560f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a885f5ea560f6ab5d7e1a5de9ae22dd2708e291f =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b7d2a6746dd4ac2d59691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b7d2a6746dd4ac2d59=
692
        failing since 300 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b7d36051d41be82d5968c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b7d36051d41be82d59=
68d
        failing since 300 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b7d115f07c6a8e3d5968c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b7d115f07c6a8e3d59=
68d
        failing since 300 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b7ccb6a8853b0f9d59683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b7ccb6a8853b0f9d59=
684
        failing since 300 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/613b7d9bd03ee78af0d5979e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b7d9bd03ee78af0d59=
79f
        new failure (last pass: v4.9.282-35-g6816688535be) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
r8a7795-salvator-x   | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/613b7df26199053d2bd596a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-35-ga885f5ea560f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b7df26199053d2bd59=
6a3
        failing since 296 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
