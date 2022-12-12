Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1072649F3E
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiLLNAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbiLLM7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 07:59:43 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F9C6160
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:59:26 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id jn7so11961221plb.13
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4IyOtwrfgzR7/yGMWCix6pzz4QfpTIgqDqNgqGoXg/Y=;
        b=jpzcXq1c8brzP30+niRnOp80VZyAk94FCKvmJ6MuKrTDnwwsW4anq+7jO+HUUAON+m
         lIu+8tVLoaT++HoLjBLPCBTnqp4S3s50SWgojjAlUa+KWhsISQ9kXD69jJVySI0o1r0v
         xiGRO8onPgcyayOwzy4B1FFRWwBr/+ObKkUCXh7JB63wev3VLDbUTGdn/HypPH6M9oLc
         CDLH859Txn+uWYkm6FMbcs6fG2TLe+/y3sESgCqHAD2TiHvIItZGSxCRNQdGR3q0RMOS
         6OGsVqmEI1UT/PldsZXABNriyvHzpC13ytN6QK0jeUtzKBn7dXQu7O7Ba2F7vtSTdwdC
         1HAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4IyOtwrfgzR7/yGMWCix6pzz4QfpTIgqDqNgqGoXg/Y=;
        b=jF9MGOVZ8R7FewCD2n438izOSIHNi/Mc/0yly0ZiNPR7qlN71fcLg1oAKaDdGlnx/m
         91rpD8LWePn3cut/icCHWap4zcfofi2OnmguhhcEyvI/UqW4YQ2pZV5SNHtVLz9RDZW4
         pEeFuv1HTyd07hETxdj/TVSDH4dC7w8rl3Ri2+kB7XjtwRGhoTdJtNxq1tsl2MlBcjir
         iJ+vn1OE/W2Lmi2laG60UvS9oRhWDjRrwzXtmplhssU6WhSAu0obLrGMXs9WtsMnEm6Z
         VfNwmoIUIe6hIxr+IJPq4aPD2j8SQrCJ8Qm7y5lTe48MkzSAer+4i2XPZBLrKO/kcNK9
         jUeQ==
X-Gm-Message-State: ANoB5pl7Vo+lw+2iTYUriwbOOEDbqwILN32ELEfwZbhfkPV/sc69wEYV
        AItQXsC8PiRLAW1QJLDNnDUANiSzxB1wckBub2U9Lw==
X-Google-Smtp-Source: AA0mqf6hEeaIwVp587ncoCBRjy+jbQW8XiNRofQDfyUwB8gjCZeoapp4JL9jTetxErKWt06lS1Q7GA==
X-Received: by 2002:a17:903:2408:b0:185:441e:2d77 with SMTP id e8-20020a170903240800b00185441e2d77mr18898082plo.14.1670849965737;
        Mon, 12 Dec 2022 04:59:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13-20020a170902784d00b00183c67844aesm6256491pln.22.2022.12.12.04.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:59:25 -0800 (PST)
Message-ID: <639725ad.170a0220.aefd9.a464@mx.google.com>
Date:   Mon, 12 Dec 2022 04:59:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.301-38-g30c1e37acf96
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 109 runs,
 19 regressions (v4.14.301-38-g30c1e37acf96)
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

stable-rc/queue/4.14 baseline: 109 runs, 19 regressions (v4.14.301-38-g30c1=
e37acf96)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
jetson-tk1                   | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig         | 1          =

meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.301-38-g30c1e37acf96/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.301-38-g30c1e37acf96
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30c1e37acf967b1b89059fa3980ca46be988ba6f =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
jetson-tk1                   | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f4587703b82c682abcfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f4587703b82c682ab=
cfd
        new failure (last pass: v4.14.301-38-gd483dffea1be) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f553bc183bb17f2abd05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f553bc183bb17f2ab=
d06
        failing since 160 days (last pass: v4.14.285-35-g61a723f50c9f, firs=
t fail: v4.14.285-46-ga87318551bac) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f56d2a2e1be5772abd14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f56d2a2e1be5772ab=
d15
        failing since 237 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fi=
rst fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f50184269e9d022abd01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f50184269e9d022ab=
d02
        failing since 215 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f565bc183bb17f2abd37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f565bc183bb17f2ab=
d38
        failing since 215 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f84aaa3f47d8882abcfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f84aaa3f47d8882ab=
cff
        failing since 215 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f99efcafd366d72abd28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f99efcafd366d72ab=
d29
        failing since 215 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f4ff84269e9d022abcfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f4ff84269e9d022ab=
cfc
        failing since 215 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f5662a2e1be5772abcfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f5662a2e1be5772ab=
cfb
        failing since 215 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f836ee35480e7c2abd10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f836ee35480e7c2ab=
d11
        failing since 215 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f9c6d75cb3e7ea2abd01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f9c6d75cb3e7ea2ab=
d02
        failing since 215 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f50384269e9d022abd13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f50384269e9d022ab=
d14
        failing since 215 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f561bc183bb17f2abd2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f561bc183bb17f2ab=
d30
        failing since 215 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f85e054badc6d92abd0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f85e054badc6d92ab=
d0e
        failing since 215 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f93a55a40e25062abd28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f93a55a40e25062ab=
d29
        failing since 215 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f4fd800d7892a62abcfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f4fd800d7892a62ab=
cfb
        failing since 215 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f5630eb6f650222abd28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f5630eb6f650222ab=
d29
        failing since 215 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f7beba13a816952abd14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f7beba13a816952ab=
d15
        failing since 215 days (last pass: v4.14.277-54-gf277f09f64f4, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/6396f976b6057b8cfd2abd13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.301=
-38-g30c1e37acf96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396f976b6057b8cfd2ab=
d14
        failing since 215 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =20
