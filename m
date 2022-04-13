Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAA94FF9DC
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 17:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiDMPVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 11:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbiDMPVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 11:21:13 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27A22ED6B
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 08:18:51 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id cw11so2311979pfb.1
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 08:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qv0zD05n0qRWAE6Cx6KxPErpg8QQ4OilFoRYZkxlR+I=;
        b=f9TBJ4uGwldFYQsk6XsfGFrksFPbRW9HS7LL8gx36rGKTbPlhNq2GFYZqY5rGTy8wR
         mUCTmaYK39Db+VfApanbOHhYsrhsgY0TF04LZ5sGjbmFpij8rBpJMLbIgYAL4Ah1SHHF
         2puxw5Tb7MkPWFHsKbWyMnTuMa4GFfWBda2mDCo06UsImUIhOr9XGUYbeRdbB7iyWeJW
         Ghx72XscNg0hD9ASoqNLkQwa7rHpldA/CtFV+aobI+39RT+WMWvSh0W9pViHeWpRFCgN
         khHFTEoN1P06QyPYlQwy/4TrjbHW1hL6qFQmFlnwqDpi+d7NV/cdW6nF/vtreGl8zKH8
         bNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qv0zD05n0qRWAE6Cx6KxPErpg8QQ4OilFoRYZkxlR+I=;
        b=B1wu6M9x6LWAhVW90hZWKlwXQrXtbu8ciNLZjTwGkv+CKuHXzny5qdveFPgOunsGZZ
         nn9LJvxzv5igBNELus6CiuN+Le/sfooFmfvrAOOgu/TkRD7EPCjaun7UcNLIP4fMpfdt
         RB5MjUo4szytfQQJH81jFEBIGeCvcQBWKruK3oRsLWVforo+Z/hcOeOFDBYSuwO4Q/TT
         DbtA/Ld3ba3FUtPU+W16Hp6puQqLsrpPTaTBaPnjRsWupz9eovhv9kHbjDOAv2eVkPEW
         h+dUFVaGG3zxa+LA1J6Xn7kGCq5GtZrYp+aCkk9HuXAZ01M8lD1LrocGcFdg+/95nhy/
         svKw==
X-Gm-Message-State: AOAM532vHFE2vjU7K/5yJ4uU7GBlyxzQN7qaGe4epihZUnMfa0QbzxaY
        91q52g03GzeC6Ynf+VWIelkoRVDvNzb0cj//
X-Google-Smtp-Source: ABdhPJy8adI/btfHLKeEeqh3bPhe4EGeJZnKkvAqR8ZfgnLwbWAvaf1+Q3tlDm2xNPG7ct83XPzBPA==
X-Received: by 2002:a63:d44e:0:b0:399:58ed:fa4d with SMTP id i14-20020a63d44e000000b0039958edfa4dmr35013551pgj.307.1649863131279;
        Wed, 13 Apr 2022 08:18:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14-20020a65580e000000b0039ce0873289sm6443215pgr.84.2022.04.13.08.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:18:51 -0700 (PDT)
Message-ID: <6256e9db.1c69fb81.2ca0.0834@mx.google.com>
Date:   Wed, 13 Apr 2022 08:18:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.188-468-g60d6fdc40ea0
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 79 runs,
 6 regressions (v5.4.188-468-g60d6fdc40ea0)
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

stable-rc/linux-5.4.y baseline: 79 runs, 6 regressions (v5.4.188-468-g60d6f=
dc40ea0)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
hifive-unleashed-a00     | riscv | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.188-468-g60d6fdc40ea0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.188-468-g60d6fdc40ea0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      60d6fdc40ea0a2f8726ba5c02bc8f343287b0539 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
hifive-unleashed-a00     | riscv | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/6256b5c796b7b589f2ae0694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256b5c796b7b589f2ae0=
695
        failing since 6 days (last pass: v5.4.188-371-g48b29a8f8ae0, first =
fail: v5.4.188-368-ga24be10a1a9ef) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6256b9fb6af7708452ae0687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256b9fb6af7708452ae0=
688
        failing since 118 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6256b96f4e7e63629fae0686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256b96f4e7e63629fae0=
687
        failing since 118 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6256b9bf4c39648b28ae0693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256b9bf4c39648b28ae0=
694
        failing since 118 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6256b96dec30b2099dae06b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256b96dec30b2099dae0=
6b5
        failing since 118 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6256ba42b9a95ad05dae06a9

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-468-g60d6fdc40ea0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6256ba42b9a95ad05dae06cb
        failing since 38 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-04-13T11:55:30.091894  <8>[   31.727181] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-13T11:55:31.103435  /lava-6076052/1/../bin/lava-test-case
    2022-04-13T11:55:31.111935  <8>[   32.748166] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
