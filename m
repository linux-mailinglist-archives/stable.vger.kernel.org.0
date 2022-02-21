Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8964BD685
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 07:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345271AbiBUGj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 01:39:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345278AbiBUGjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 01:39:24 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BCE25EA8
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 22:39:00 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b8so14234881pjb.4
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 22:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MqNTPDQneLobK/51TRHB6wCiuHxCELZFiq6ZbJLVteA=;
        b=PhYRDbYE1mNjHEJcNRlCZju2u0Jzn1fuZyuCf7GER5iUIhz/jXwF3Dr6mjNh1PYVzG
         IqotxTj+4ICZafoZoh1uw8JC/kTRsq7NGU90qXMekZO+ElN0AN837rUo7IZu8HbfGMHY
         O1jv4rP3w+pK6owBEnGTeN5Tj3P2LUkyD9wVJ4NR6QeTymonYO3R2ZLmD78J3CoPXyJk
         RwzXmfKGfBsw2B/uGS5/gHro8LC1mZS1CdPLoLWL/zL3bjSa7NhVJlnrFSeFawWLhe2E
         MZTFcIsB6qHS3eGAz1xCCxph1SAMBhkiQE5nPHj58hIxhq/CsPsmtXCUzlAeTF2E3U5c
         FBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MqNTPDQneLobK/51TRHB6wCiuHxCELZFiq6ZbJLVteA=;
        b=d2a9mP4xfmYhdHRT2w4pZTxumwkx8oES3vA28nVKKO1BhfMdj7nKKSls+18wjy8i4D
         GhIEoqjppn9y5qZv2LBk8xMS+28Kzy9jD+E7PoXWUVB1rOfSowjrKpOD7JAoGavTAlxA
         YPcK1GY3IHSV/jrMnuiXkLeNse1udTuwt/SSg4WeiZSPV7zD7GdkcNKVEfDPNIpKzW4n
         e3pN3clUfTn4Q1vFMCcKmM6tqdoE1krA4dlBJeBToSrByVchkxVhS7Tp5CqWV1s85nYd
         c+ddKOaapiZ2oyitEVbeJes3CZqlL3a1FB3yH1rHauhy8wGuoO2oRfKcZeMxlwWWV2bv
         QvDA==
X-Gm-Message-State: AOAM531i2FMxEr8NXoXrpno8m4QzpsU0iW0aAtOw42FqxBM6IP9EO+WR
        GTsdy23cxktMLeWiqe09dg4gUGDFVNXH1Ult
X-Google-Smtp-Source: ABdhPJy/7jXnCBU13sQ6FJyLv/EaNrtlu31uLMpo98mhqb9pVSMV3IM/6IFmOrOuwvW7spePo4AaWA==
X-Received: by 2002:a17:90b:250f:b0:1b8:f257:c39 with SMTP id ns15-20020a17090b250f00b001b8f2570c39mr19902630pjb.135.1645425540223;
        Sun, 20 Feb 2022 22:39:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090a5d0300b001bc2b469051sm3131450pji.29.2022.02.20.22.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 22:39:00 -0800 (PST)
Message-ID: <62133384.1c69fb81.ca0bc.9db5@mx.google.com>
Date:   Sun, 20 Feb 2022 22:39:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.24-147-gb29251d16676
Subject: stable-rc/queue/5.15 baseline: 109 runs,
 8 regressions (v5.15.24-147-gb29251d16676)
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

stable-rc/queue/5.15 baseline: 109 runs, 8 regressions (v5.15.24-147-gb2925=
1d16676)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.24-147-gb29251d16676/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.24-147-gb29251d16676
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b29251d166763f82d19378b585454d929c51db32 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62130119069a9b0608c6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62130119069a9b0608c62=
96b
        failing since 12 days (last pass: v5.15.21-111-g6704c2c1f104, first=
 fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621302108e978406f6c6299c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621302108e978406f6c62=
99d
        failing since 12 days (last pass: v5.15.21-111-g6704c2c1f104, first=
 fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6213011a127f5f87b3c62978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6213011a127f5f87b3c62=
979
        failing since 12 days (last pass: v5.15.21-111-g6704c2c1f104, first=
 fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621302113371775e88c62984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621302113371775e88c62=
985
        failing since 12 days (last pass: v5.15.21-111-g6704c2c1f104, first=
 fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62130118302bfd0261c62979

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62130118302bfd0261c62=
97a
        failing since 12 days (last pass: v5.15.21-111-g6704c2c1f104, first=
 fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621301e871077409afc6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621301e871077409afc62=
96b
        failing since 12 days (last pass: v5.15.21-111-g6704c2c1f104, first=
 fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6213012b069a9b0608c6298d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6213012b069a9b0608c62=
98e
        failing since 12 days (last pass: v5.15.21-111-g6704c2c1f104, first=
 fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/621302748b16dc2ebfc62974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.24-=
147-gb29251d16676/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621302748b16dc2ebfc62=
975
        failing since 12 days (last pass: v5.15.21-111-g6704c2c1f104, first=
 fail: v5.15.21-111-gbc928abfc73d) =

 =20
