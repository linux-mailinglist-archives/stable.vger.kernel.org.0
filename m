Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8211C5A898F
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 01:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiHaXnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 19:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiHaXnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 19:43:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36134EA8BE
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 16:43:40 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mj6so10521875pjb.1
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 16:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=1r5biEje4En0hkurI18qTBP+U7GB8TFGDwMwghySuDs=;
        b=MAOyh4IAUrm3crMNF5HqLUZQOMtHiOkBJ3y9ykQ4GKuUFqhJNuhVUm3MrVBKztItJK
         61MsbFs9kOQ2B/EJAmpg44Rw9qhVN66Un/y7GKGOl+b4INe3iBZp7i7L1yTEzRjdCm0q
         YJGELIEPgmmt/0jadhmFW9R+2sHdRATxqcdhuJY80k9kJUcYMqdKtgq39VFZXoZXR90g
         5hh5XWEF282TDD7HtBFQBVMhf9g5mUvJ9R2wDiRIGO62kFnS/kpm6uycp7n25gdzvH0n
         ppDNeJMS3t12eo8JhKaU2nA5LhLpLUsWnVRthw9hZn0E7nq67qPUtPSSWUJEN+o72t6G
         iirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=1r5biEje4En0hkurI18qTBP+U7GB8TFGDwMwghySuDs=;
        b=yE0+DPsvbzJWHRG3fdAZvfLXARV8gbu5LUQ8I9BOsJInyZYrNMc/i0w3l+KeenDSug
         hTptUbrIKYDkF7uQVhUCOfrdOvejdOkUYtSuJ0qzRwuUjo2rVbgnBu5vtHmQqUCC6Rq2
         qWACO8wxR4xS2l5XCNvflQz/pKBjbY8q4oyj9zV0KrYLFrPoaZeHsxm/GWM80dKNyqt+
         npkWsYabjC2V9ImgMdiEGuFpdM0fEpF/LFLT8DJtsVsbzD1oKDHfn9WMjxrQp8GonZJQ
         52W0TlRyNf8H/CED61gt5zeXBTDE9HKilmr5wWVrk1f2o7tWDwcQA1b/sNZknsckPzEd
         DZxw==
X-Gm-Message-State: ACgBeo2RMKDJR5gPcXqz4sY5BChRgAVRhacS9wYRuBY9bsRSDU6Yt2/9
        8OBXeqdjbwG+M+zyOrVXlM9krdbeAYcu2EWQWhg=
X-Google-Smtp-Source: AA6agR5ZpfAfL9pwOeM7NyTKEP0b6qODrVHwqmKcZ6x8RR5TwWa5vYXi7z4pnPAVO5LkEH/6j5ACOg==
X-Received: by 2002:a17:902:a705:b0:172:ecca:8d2d with SMTP id w5-20020a170902a70500b00172ecca8d2dmr28207920plq.27.1661989419471;
        Wed, 31 Aug 2022 16:43:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t18-20020a634612000000b0042b08b6158dsm3943726pga.56.2022.08.31.16.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 16:43:39 -0700 (PDT)
Message-ID: <630ff22b.630a0220.f54dc.82b6@mx.google.com>
Date:   Wed, 31 Aug 2022 16:43:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.211-49-g216810ca71f2
Subject: stable-rc/queue/5.4 baseline: 130 runs,
 12 regressions (v5.4.211-49-g216810ca71f2)
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

stable-rc/queue/5.4 baseline: 130 runs, 12 regressions (v5.4.211-49-g216810=
ca71f2)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-10   | defconfig  =
                | 2          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.211-49-g216810ca71f2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.211-49-g216810ca71f2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      216810ca71f2cd3d47499f24df54a4e137f36501 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-10   | defconfig  =
                | 2          =


  Details:     https://kernelci.org/test/plan/id/630fbf578343fe1d00355650

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/630fbf578343fe1d=
00355655
        failing since 0 day (last pass: v5.4.210-388-g548ae3c507a8, first f=
ail: v5.4.211-48-g475eb32ae1a3)
        3 lines

    2022-08-31T20:06:24.639417  / # =

    2022-08-31T20:06:24.645727  =

    2022-08-31T20:06:24.752763  / # #
    2022-08-31T20:06:24.757060  #
    2022-08-31T20:06:24.874568  / # export SHELL=3D/bin/sh
    2022-08-31T20:06:24.885425  export SHELL=3D/bin/sh
    2022-08-31T20:06:24.987107  / # . /lava-2438248/environment
    2022-08-31T20:06:24.997697  . /lava-2438248/environment
    2022-08-31T20:06:25.099993  / # /lava-2438248/bin/lava-test-runner /lav=
a-2438248/0
    2022-08-31T20:06:25.109683  /lava-2438248/bin/lava-test-runner /lava-24=
38248/0 =

    ... (10 line(s) more)  =


  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
630fbf578343fe1d00355658
        failing since 0 day (last pass: v5.4.210-388-g548ae3c507a8, first f=
ail: v5.4.211-48-g475eb32ae1a3)

    2022-08-31T20:06:25.698861  in:/usr/sbin:/bin:/usr/bin'
    2022-08-31T20:06:25.701164  + cd /opt/bootrr
    2022-08-31T20:06:25.701339  + sh helpers/bootrr-auto
    2022-08-31T20:06:25.717086  /lava-2438248/1/../bin/lava-test-case
    2022-08-31T20:06:26.709101  /lava-2438248/1/../bin/lava-test-case
    2022-08-31T20:06:26.722224  <8>[   11.822952] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>
    2022-08-31T20:06:26.722451  /lava-2438248/1/../bin/lava-test-case   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc13b5eb1874b5535565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc13b5eb1874b55355=
65b
        failing since 36 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc27ba087f5f41035567b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc27ba087f5f410355=
67c
        failing since 113 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc02cd5974cc52935566a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc02cd5974cc529355=
66b
        failing since 36 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc0af9002119168355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc0af9002119168355=
657
        failing since 113 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc2a4d2efb0e6f435564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc2a4d2efb0e6f4355=
650
        failing since 36 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc130f7d85ee547355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc130f7d85ee547355=
644
        failing since 36 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc0b0900211916835566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc0b09002119168355=
66e
        failing since 113 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc2a39dece07b0f355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc2a39dece07b0f355=
651
        failing since 113 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc0b19002119168355673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc0b19002119168355=
674
        failing since 113 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc28fab1e6fefa1355667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-4=
9-g216810ca71f2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc28fab1e6fefa1355=
668
        failing since 113 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =20
