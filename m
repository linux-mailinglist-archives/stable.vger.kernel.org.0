Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1801B54A72F
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbiFNC7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355454AbiFNC6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:58:50 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E05019C12
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 19:54:18 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 31so5646747pgv.11
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 19:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b5yvvm/C0vnfmE6fE0cP+PwvBqdq+AMG8KnDlZ6uk9k=;
        b=WbCEJSM8R/PqRsyck4dz1ywRAbtVzd/iC7q2yC3Z+Ntm3T9+Qat3jq+QJwhOLWjr1J
         sD/GR3GLlMAK4JZVaFy5mMRfyI0wSMiCr3fXM92arfazOie59+tpFBYelCuYMbsxFUwD
         F/0/Tww2ePXJ5RldpKQKD9q7b+qLB04qhJdWTPLz+XCAExyUuJZ1GiWHJErw4tROgUdX
         VxRGNw7G7YQxt9TyaDnuyCukF9jCYJnk0emnbDZYNt7lrAdaE3itqoDVbgtByR8vbza+
         E33GvM+s8FumlIsnLoZDHpZXKA++sS8WwODozn9C7twTZ3fl5VHPzE/ZxMRJYqS3h7kb
         ULrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b5yvvm/C0vnfmE6fE0cP+PwvBqdq+AMG8KnDlZ6uk9k=;
        b=H7CXJd9UmDEh/i1ES4imEbxEIzJL+yOXZfMQsoVb8uo+Pc/GcwHdyh0LoaD2DjD8OL
         1D3tO/Eii0z3I85QO6iPmWcuoCU0K0xAF26l4LwIZ9fBQDB0HKMEdc4afINEtl3SEOS1
         W8Mp2BpflInkHqGNX+70/VSqWo3xROVGNtbfv72JttsmU5WODrddT56JtVSvisR/86Ky
         F/Uxwb24jVLDM34etSoM6MwHXVefBu4nkc6vE8Mg3EjqSYS5hQrfFUm2PSiNi27y+LUb
         UgN16rs29N8OB+mUg2U50YZkfSKLlnsFyHMbNiTLgxZhJa2EMyVZ6JKxu1OzGQhwYv+H
         faow==
X-Gm-Message-State: AOAM530GUB8tNnBPUS89H4ZzozS9zn8Quy0SY69EJlX1RQd9ISLVz4Ne
        g33MjsDQnUj/m0ZM1Eao0JCBTWy9g1Hq2Qj36Ow=
X-Google-Smtp-Source: ABdhPJzW5bnq/BuXCXhLgj1w9vcC+JijaXJ7X84hPSy7efBUecy8c9c1EKgMIfOblpKsnmVPEOZj1Q==
X-Received: by 2002:a65:67c1:0:b0:3fd:ebd6:5dab with SMTP id b1-20020a6567c1000000b003fdebd65dabmr2435685pgs.75.1655175257601;
        Mon, 13 Jun 2022 19:54:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13-20020a62a20d000000b0051877c10ec4sm6268102pff.175.2022.06.13.19.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 19:54:17 -0700 (PDT)
Message-ID: <62a7f859.1c69fb81.d3a7d.7687@mx.google.com>
Date:   Mon, 13 Jun 2022 19:54:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.120-624-g355f12b39acea
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 119 runs,
 13 regressions (v5.10.120-624-g355f12b39acea)
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

stable-rc/linux-5.10.y baseline: 119 runs, 13 regressions (v5.10.120-624-g3=
55f12b39acea)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 1          =

jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | tegra_defco=
nfig            | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

tegra124-nyan-big          | arm   | lab-collabora | gcc-10   | multi_v7_de=
fconfig         | 1          =

tegra124-nyan-big          | arm   | lab-collabora | gcc-10   | tegra_defco=
nfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.120-624-g355f12b39acea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.120-624-g355f12b39acea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      355f12b39acea720fa2fe8ce6ef486377e1d0b6a =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c34e4a34148579a39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7c34e4a34148579a39=
bd4
        new failure (last pass: v5.10.120-623-g6690b0cb74729) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | tegra_defco=
nfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c1585dfb384e12a39bf3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7c1585dfb384e12a39=
bf4
        failing since 7 days (last pass: v5.10.118-218-g22be67db7d53, first=
 fail: v5.10.120) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c2d0553f997e71a39bf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7c2d0553f997e71a39=
bf6
        failing since 35 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c2d4553f997e71a39c17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7c2d4553f997e71a39=
c18
        failing since 35 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c2cf553f997e71a39bf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7c2cf553f997e71a39=
bf3
        failing since 35 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c2d3553f997e71a39c09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7c2d3553f997e71a39=
c0a
        failing since 35 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c2d1553f997e71a39bf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7c2d1553f997e71a39=
bf9
        failing since 35 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c2d5553f997e71a39c1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7c2d5553f997e71a39=
c1e
        failing since 35 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c2d2553f997e71a39bfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/=
baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7c2d2553f997e71a39=
bfc
        failing since 35 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c2d6553f997e71a39c20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7c2d6553f997e71a39=
c21
        failing since 35 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7c2fddbc8029628a39be8

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62a7c2fddbc8029628a39c0a
        failing since 98 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-06-13T23:06:16.780501  /lava-6609102/1/../bin/lava-test-case   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
tegra124-nyan-big          | arm   | lab-collabora | gcc-10   | multi_v7_de=
fconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7cfc2135b6dddc7a39c03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7cfc2135b6dddc7a39=
c04
        failing since 0 day (last pass: v5.10.120-453-g08871e799a04f, first=
 fail: v5.10.120-623-g6690b0cb74729) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
tegra124-nyan-big          | arm   | lab-collabora | gcc-10   | tegra_defco=
nfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7cc144b5de51ea6a39bf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
20-624-g355f12b39acea/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7cc144b5de51ea6a39=
bf1
        new failure (last pass: v5.10.120-623-g6690b0cb74729) =

 =20
