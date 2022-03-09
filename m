Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315BC4D389C
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 19:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiCISSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 13:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbiCISSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 13:18:04 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444B2A2F3C
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 10:17:05 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id kx6-20020a17090b228600b001bf859159bfso6062819pjb.1
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 10:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=amxOHnH5s44m+8DgXgz4dCY1SIxN0d+05feTOdp3EIw=;
        b=ynQEU22Nx3r7etZkk/KayuM/pVFIDHIa6Bda79+t4pHSQfAj/MsgoF2zIBn3sivOcG
         lO2OJvLA4YRlRrz8ThUSqGIOAlZXdlxjb6WDg8yzwrlN5fvmyS0/0Ay6eRI01lLXWCCO
         d1e8bfahT6FKXnn8At5bmFxxdDwvQmUzOkC8BDHUt5GIdBMWd0m/Yn5TkIpvW+CfX3GN
         xeC6EtOUXqurm6cnNl6fEbUKW//PjqQnklVRZ35ryZXCGrez9MB7zegtOYFrb//gguCf
         B/KD+M4Hi3hoF8+Um8giO5ZtK0ONGyQKLzRck+2po20YUz0glwnH1WvSw4cGBJ9Kin5a
         CJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=amxOHnH5s44m+8DgXgz4dCY1SIxN0d+05feTOdp3EIw=;
        b=kF+GQoNt9A+MxSvVwIXor9DxGezqivMIED9X2u7kY4HHlK9ngUPOnH8hNOKECxKc+J
         tYDnMGUKUpE41ClsiJdbweqISC5Zcn+gbFmbEJF/OKKzRp6wpQqHVcsA/oL9oO5ZMKti
         pVCq3GAQGHh7IS4URYGwhVjYSAc7szL/82SyrnvV8U6GJ6R+bFKeWJjIbgdAbYh1cXsy
         2YmKaUldGgskfcl/pomISSDsXhOIvjxbKfoevbRkiTdtJVatpAsudRSCELD5IM041qm8
         waH+YugpEJqbSP2LBtkopa2xATu7Xv9BReTHIh5MT/LqwlQ0g5y2jAYdoIklddthmdLc
         xchg==
X-Gm-Message-State: AOAM530LfrXZcIYIoxZVf2IqGGgkNvFknc9Kaz0BY+fXaDO92r1CxmQ0
        4TOLNPojlWX3n7fuZzA3hJ9UT+AJajN3sN71GiM=
X-Google-Smtp-Source: ABdhPJxYUiW6Hf2CG7sGG8qzJvJO2+h9zcbUs/P6JVFLzWe9Y0zWSknOrOgcToXDmwXktOkyREK2qA==
X-Received: by 2002:a17:903:2350:b0:151:e633:7479 with SMTP id c16-20020a170903235000b00151e6337479mr731600plh.74.1646849824536;
        Wed, 09 Mar 2022 10:17:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o125-20020a625a83000000b004f6d32cd541sm3665221pfb.152.2022.03.09.10.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 10:17:04 -0800 (PST)
Message-ID: <6228ef20.1c69fb81.6ddd5.919b@mx.google.com>
Date:   Wed, 09 Mar 2022 10:17:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.183-40-g251931769911
Subject: stable-rc/queue/5.4 baseline: 75 runs,
 3 regressions (v5.4.183-40-g251931769911)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 75 runs, 3 regressions (v5.4.183-40-g25193176=
9911)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.183-40-g251931769911/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.183-40-g251931769911
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      251931769911f8de3e1fc222ebca5b6cbd3a2d71 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6228b76984cbed2d35c6297a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-4=
0-g251931769911/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-4=
0-g251931769911/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6228b76984cbed2d35c62=
97b
        failing since 83 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6228b799411a73f022c6298f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-4=
0-g251931769911/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-4=
0-g251931769911/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6228b799411a73f022c62=
990
        failing since 83 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6228bc00a30bda22b4c62968

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-4=
0-g251931769911/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-4=
0-g251931769911/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6228bc00a30bda22b4c6298e
        failing since 3 days (last pass: v5.4.182-30-g45ccd59cc16f, first f=
ail: v5.4.182-53-ge31c0b084082)

    2022-03-09T14:38:51.111239  /lava-5845630/1/../bin/lava-test-case   =

 =20
