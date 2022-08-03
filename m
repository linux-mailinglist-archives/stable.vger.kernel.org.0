Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2AB588C40
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 14:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbiHCMhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 08:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiHCMhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 08:37:46 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBA624F05
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 05:37:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 15-20020a17090a098f00b001f305b453feso1894727pjo.1
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 05:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hZjC+igqdGAqxANXHXxIx3HR3ccrub+20JGZRi1p0us=;
        b=LD97x7e1p70jN7mLfCE+eRjB7wJcRKZxznkxtii3FP3XJ9OdutJ04m4tQkporv0xbG
         5EKqe3MTG8bZHhU8qbaTdO7cQFkMuvojFV1BGrLzRJ8ZUDD2BDiTLZeES5gDsUXeZeak
         +fNNAHglKyWUr9E5H+YHBmFa9eJeRwrlOE40Y2Eu5UvRervpxBWwQu6Eisj34I1o5uJv
         HEJFpgmHukVIeYAXu6do3LSRNv1wDpF8ZCA6XKpJ/XzW9vZ12xKevROcnQGbKJUZVwSb
         rz5tTqkvL7sfwsFDmjleRH+73PvGaM5zQus32g2k6jaXR+L/mCT/h204BILqeQuplgpT
         8Mug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hZjC+igqdGAqxANXHXxIx3HR3ccrub+20JGZRi1p0us=;
        b=EF2NuVR5hYh8mvhiOcpXt/BKtb7C3wwXHE1e93tmiXXCKxiUwSTLjlacsRhPcITHsk
         EzkCn8wgLWmcQpRlFtJmToSbZHxBDiEU+DYZn4kXoTEWQmHwNCoW2sF9ZPbscBxx0iO/
         zQPoaQQ/t61dWTnT6BBE+kwB9oqQOsDwwklMmdlnnXWADqDCuxzgtnZCrmWxovUuW7ho
         xoJJkIbeVxNMtE+m5ivQvKpyO72Af6XAq9fiyPzGNfUPBS9Ze380Egf5xsuRp1wnLqyq
         aoU82AIjadvTLJWsqo14PPnXdsPL27aiIvP6MWFePxudln/s7L5tMP0+eUXzBLsXuWRr
         sTGw==
X-Gm-Message-State: ACgBeo2gOEOXFK6eh0d176Jd22hKVicXz0/liAbmnARMYSJ/h8EqbaLV
        0GMIbH2hrrA441SwK/LeAqLVb5tdPoYbi6oUWfU=
X-Google-Smtp-Source: AA6agR78joDctSbhtfHwQOjebwqP1GD1H/um4fX7LgDjZr4wNJ4znONqQEPhceY8FB73vXq2rT6H2A==
X-Received: by 2002:a17:902:704b:b0:16d:d2c2:9942 with SMTP id h11-20020a170902704b00b0016dd2c29942mr24454720plt.85.1659530263923;
        Wed, 03 Aug 2022 05:37:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y62-20020a626441000000b0052d40c4c06esm7854190pfb.39.2022.08.03.05.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 05:37:43 -0700 (PDT)
Message-ID: <62ea6c17.620a0220.38dda.c90a@mx.google.com>
Date:   Wed, 03 Aug 2022 05:37:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.207-122-g43c690387ae2
Subject: stable-rc/queue/5.4 baseline: 76 runs,
 6 regressions (v5.4.207-122-g43c690387ae2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 76 runs, 6 regressions (v5.4.207-122-g43c6903=
87ae2)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
am57xx-beagle-x15          | arm   | lab-linaro-lkft | gcc-10   | multi_v7_=
defconfig         | 2          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.207-122-g43c690387ae2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.207-122-g43c690387ae2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43c690387ae266ac619d583f4a9f66d94101fbdd =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
am57xx-beagle-x15          | arm   | lab-linaro-lkft | gcc-10   | multi_v7_=
defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/62ea39a84b5a747844daf059

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g43c690387ae2/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am5=
7xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g43c690387ae2/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am5=
7xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
62ea39a84b5a747844daf05d
        new failure (last pass: v5.4.207-122-g8f2a91af14ede)

    2022-08-03T09:02:15.286835  /lava-5348143/1/../bin/lava-test-case
    2022-08-03T09:02:15.287402  <8>[   23.148959] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/62ea39a84b5a7478=
44daf060
        new failure (last pass: v5.4.207-122-g8f2a91af14ede)
        1 lines

    2022-08-03T09:02:12.089545  / # =

    2022-08-03T09:02:12.096718  =

    2022-08-03T09:02:12.201724  / # #
    2022-08-03T09:02:12.208705  #
    2022-08-03T09:02:12.310559  / # export SHELL=3D/bin/sh
    2022-08-03T09:02:12.320605  export SHELL=3D/bin/sh
    2022-08-03T09:02:12.422163  / # . /lava-5348143/environment
    2022-08-03T09:02:12.432565  . /lava-5348143/environment
    2022-08-03T09:02:12.534133  / # /lava-5348143/bin/lava-test-runner /lav=
a-5348143/0
    2022-08-03T09:02:12.544444  /lava-5348143/bin/lava-test-runner /lava-53=
48143/0 =

    ... (8 line(s) more)  =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea358a4b9c263cc2daf072

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g43c690387ae2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g43c690387ae2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea358a4b9c263cc2daf=
073
        failing since 85 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea3565c4a7d086a5daf07d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g43c690387ae2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g43c690387ae2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea3565c4a7d086a5daf=
07e
        failing since 85 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea359e3d4e67c455daf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g43c690387ae2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g43c690387ae2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea359e3d4e67c455daf=
06a
        failing since 85 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea3563c4a7d086a5daf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g43c690387ae2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-g43c690387ae2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea3563c4a7d086a5daf=
07b
        failing since 85 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =20
