Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08705352D7
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 19:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239138AbiEZRok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 13:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiEZRok (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 13:44:40 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1930ADFDC
        for <stable@vger.kernel.org>; Thu, 26 May 2022 10:44:39 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c2so2040047plh.2
        for <stable@vger.kernel.org>; Thu, 26 May 2022 10:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2fkjfzwrdDw1mNlworsng38wqvhq2f8phEHuIPSRvf0=;
        b=lsWApr/b5/JZ7U0YyiqMFO2pWOu6+ZffTe40jC9VIQgHTPZ8Z8W5dsPD6V/yFZdvQ5
         6thY0ReTFhsKLfueaL6OO8viZaLrC4n4CBRMVu8OTddUUfxOs4/2Pb6HhzO5tQ+nbECg
         qwB533dOHvosIGT655q5YZiCoZVg3dakdCEw+i0T9JllNR+jCQIjSRB5N/A5fshuYw8W
         e5m2/JcmokNDKuQaCczU/HMDTJAflt7E7t6cu3b5JgkxuYLNW8OTlyv/hW/ct1xq9VbH
         rx/Zc/5s1G61WrvNlMnu2h7LOlgIjfi4m0lw69xNcYJ0wSXsb9sGRhACr3V0eLAmHTze
         YNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2fkjfzwrdDw1mNlworsng38wqvhq2f8phEHuIPSRvf0=;
        b=tnruEkJzl6dSaFtjk9twd+AEBDS/Jd81JlnBpPX5JNrMZcWxXXmIxav2DSwKlnCQlO
         idWuoR8QJlKGhgvCs/0LJ6dG6Pwt7ksrhLzDv0qrCk22rB3R2yai8+WriEFX5wf85FZ+
         wuRwkrgIBYAijbjJcTxE0XAHOQjdgPflVFdcZ2mlCPZLwxZpOHIyvQK/0nX5NDI3x1eV
         QI6fw+om7MiG6SpYCd7VZDNybOML8Yoj0ObiK/OABkQebvxGwqkgQeb7cwn4r4LUr63L
         hs4Tg81FKnRy6qIZOXBLA1c2uQeoUkn2dAIGzg1Z0sr5aNLShB3yQuQ9GyCuBDIM+Trp
         ztIA==
X-Gm-Message-State: AOAM530eJysXH8oyiXlblY7WB00yrsDaIHmA64yNOG0f1+XSJ47YV37G
        pMz9G3HDzbs2GX2QjXydQ7KE+4OIv4DtofFx8QQ=
X-Google-Smtp-Source: ABdhPJw/+wFDtJecj7JLbyamQKoOe2Z9+QhxJNPQzRbGs3GvtqWwqu49WfORzGFtx2UAlUeRtuaoMg==
X-Received: by 2002:a17:90a:930b:b0:1d5:684b:8e13 with SMTP id p11-20020a17090a930b00b001d5684b8e13mr3800671pjo.153.1653587078390;
        Thu, 26 May 2022 10:44:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v1-20020aa78081000000b0050dc7628178sm1786899pff.82.2022.05.26.10.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 10:44:34 -0700 (PDT)
Message-ID: <628fbc82.1c69fb81.1ff39.3b8d@mx.google.com>
Date:   Thu, 26 May 2022 10:44:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.281-4-gdc34edbe196e
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 72 runs,
 11 regressions (v4.14.281-4-gdc34edbe196e)
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

stable-rc/queue/4.14 baseline: 72 runs, 11 regressions (v4.14.281-4-gdc34ed=
be196e)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
jetson-tk1                   | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig         | 1          =

jetson-tk1                   | arm   | lab-baylibre | gcc-10   | tegra_defc=
onfig            | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.281-4-gdc34edbe196e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.281-4-gdc34edbe196e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc34edbe196ec84e833e653cad59ba53f419dc87 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
jetson-tk1                   | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8d16d7ae7b8079a39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8d16d7ae7b8079a39=
bd3
        failing since 2 days (last pass: v4.14.278-4-g95c4f04a529a, first f=
ail: v4.14.280-33-gfbdef5eaf17e4) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
jetson-tk1                   | arm   | lab-baylibre | gcc-10   | tegra_defc=
onfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8ebc88ca35bda9a39bdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8ebc88ca35bda9a39=
be0
        failing since 2 days (last pass: v4.14.278-4-g95c4f04a529a, first f=
ail: v4.14.280-33-gfbdef5eaf17e4) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8b1f69b0540efba39bd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8b1f69b0540efba39=
bd7
        failing since 37 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fir=
st fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8b84019cc39c3da39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8b84019cc39c3da39=
be9
        failing since 16 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8d78653766f3d2a39bd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8d78653766f3d2a39=
bd7
        failing since 16 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8b85b4e844ade0a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8b85b4e844ade0a39=
be2
        failing since 16 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8cec59357b2c1da39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8cec59357b2c1da39=
bd4
        failing since 16 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8c88bfa32d56e6a39bde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8c88bfa32d56e6a39=
bdf
        failing since 16 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8ced59357b2c1da39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8ced59357b2c1da39=
bda
        failing since 16 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8bd48f277b1b66a39bd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8bd48f277b1b66a39=
bd6
        failing since 16 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
                 | regressions
-----------------------------+-------+--------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628f8cd8b556b7dcd9a39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-4-gdc34edbe196e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f8cd8b556b7dcd9a39=
be8
        failing since 16 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =20
