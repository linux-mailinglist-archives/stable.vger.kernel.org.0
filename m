Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12175F4A71
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 22:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiJDUky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 16:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJDUkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 16:40:53 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3A557259
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 13:40:50 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p3-20020a17090a284300b0020a85fa3ffcso8026060pjf.2
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 13:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=6Pe3ZVw702Jll/Jo2BldS5bBCIXqrjLskcbYAzdbR7A=;
        b=BTRYmHrn2RLQNb+6XSyG7ONtQGiRnPycLBZu37DCIzamZ4XWbwMCYzBsSE8mH1QsV0
         58SKrKHkcrc8h0ezgI5XJErT4T0EQrikm7xiutgbwa0zFerslcJdxVgxNNbLmwn9BWg7
         QXX7hT9EUCUPLOT7Ndb1BHTAsYsTJI5qPsRSpF7WV9Ow3t4d9pEPL6BwvqiNb3Q11119
         4VrnvUnDU6MZ8X0jy3Qb73oCg3ZZWs/OwOP4PJQYS2ibH/ZqHnhXnMSJQnh2otEb1dJ6
         DNsz2XoqRyhLdqw4zJYg13STVJS2/+T6JQtrAncGpbjBKfU0ZSMTlzKVm6ImS9hK+eEs
         FWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=6Pe3ZVw702Jll/Jo2BldS5bBCIXqrjLskcbYAzdbR7A=;
        b=eZRbdwvEMhn3KfWaYJYlz9cReTFT8D99+SC3Jv5zEOZ3KvnM2XXI6ueez3GW6Bjw4Z
         q02lShEMZcYaG84ROKJ3kc2qLbPjt6qOEmeQPJbdi0sO64DTS+F2Gnr4fFejwigGqt81
         pKlbUz8E4TjGABi2n8idEzdjIVGZQQe/qUczAavCbjEGqSYWlGsvC/gI3vPltppdOdXw
         Cl2tNAVe+t7P1ZtWm7U9urdGYMMewnROWjXw29gTPt3lRFtB+OH9cXi92MuzrgriRJfl
         IIk6QkAV+Lf/d8sR2cSwo+OroD2d8HIRBn9R8tRy3scmPvMUxgxY29196pZqL6Nao0JE
         L24A==
X-Gm-Message-State: ACrzQf1UqjYwTWt4oU4vzYnm+GJnH83aaFu7qvyn120SO+sDv4T72t+z
        aglRi3w/9bFVDk8BFiknEgyaVFlByMec6MK5HA8=
X-Google-Smtp-Source: AMsMyM6hrzWvq4/LGmf3IhrsS/4LvzNvXgCHtMIPYHRlh+RPgnrJCvvGwfKlFpLheKfbM4QXKH8hIw==
X-Received: by 2002:a17:902:6907:b0:179:c9bc:dd73 with SMTP id j7-20020a170902690700b00179c9bcdd73mr28507024plk.159.1664916049852;
        Tue, 04 Oct 2022 13:40:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090332c200b00176b5035045sm9418622plr.202.2022.10.04.13.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 13:40:49 -0700 (PDT)
Message-ID: <633c9a51.170a0220.9edca.044a@mx.google.com>
Date:   Tue, 04 Oct 2022 13:40:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.260-25-g581649feed402
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 76 runs,
 7 regressions (v4.19.260-25-g581649feed402)
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

stable-rc/queue/4.19 baseline: 76 runs, 7 regressions (v4.19.260-25-g581649=
feed402)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.260-25-g581649feed402/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.260-25-g581649feed402
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      581649feed40293ad140223f4862215e65392988 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633c76babd8a7b1d9ccab626

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c76babd8a7b1d9ccab=
627
        new failure (last pass: v4.19.260-42-g33d36daaa2310) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633c6306020ebc7fd9cab610

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c6306020ebc7fd9cab=
611
        failing since 168 days (last pass: v4.19.238-22-gb215381f8cf05, fir=
st fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633c68354382a0536fcab5ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c68354382a0536fcab=
5ee
        failing since 70 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633c67faee0080331ccab632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c67faee0080331ccab=
633
        failing since 70 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633c696161f31d366acab602

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c696161f31d366acab=
603
        failing since 70 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633c694dce1461279bcab623

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c694dce1461279bcab=
624
        failing since 70 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633c67d71a95f6046dcab60f

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-g581649feed402/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/633c67d71a95f6046dcab631
        failing since 212 days (last pass: v4.19.232-31-g5cf846953aa2, firs=
t fail: v4.19.232-44-gfd65e02206f4)

    2022-10-04T17:05:08.665031  <8>[   35.919119] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-10-04T17:05:09.676910  /lava-7497817/1/../bin/lava-test-case
    2022-10-04T17:05:09.685329  <8>[   36.940019] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
