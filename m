Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07B5597A5A
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 01:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiHQXpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 19:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiHQXpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 19:45:20 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C452C0
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 16:45:18 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a22so87928pfg.3
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 16:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=9lFGVJQBpnct9TohhLB3cD3McOFvNqYsuXVP3hXe9W8=;
        b=fbQddh94S2h4EYi7G4O+rtyJUgZ+W/PLGXlnf7AJCJbYdDHCFnSy2f8+78mLOfjb3l
         3TxI6iCaf38j1S5CGJRQUWCABEi7BHLy3l65RJpGodobXTjiBOKlT9lrN/dKtPuChHo8
         QEh9Jb42L9iQxqaKBFQkDjo91McMuLSvdueGDchQyQBswoX0l6TRuHsVBvnO4vSPA8aS
         1YGGgIyb9VO2U+NapRNmuRuzFPmtgAFlcceNezAB2yCYLzbYwVp5IZ21tfwXsFs8moD9
         sQrkWWJ2fVdih81S79fDKlNVeCreFuu/8LMcsVZ6iow65VjZsjUs2CWRtzkVVGcx9i+O
         OYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=9lFGVJQBpnct9TohhLB3cD3McOFvNqYsuXVP3hXe9W8=;
        b=VyVk7tz8KH2jUyYpVnIUllqEivlk+WELdYlLlQ5lMZoLMIt1xZ/8c6UnJA1FgR9itJ
         8FCSYk195drDHq9PHPnptp6dDxKWqckFT7iG7aTFiD7n9k6B61ZmTApeNblTqKcqbQRl
         ex1rkQggqjln0Aboml/vXJ2GwNfF/F2h2+cqUVmBiGJQzSty30SBJXSuphP18VW4sGxZ
         UnZTd5QzBgWvAhKkUEMzWMUDXmBmaleafWHMB0ep9tIkKMpUMDziMr//RMJh3o/YP7nN
         2Jqv6uSlRWnBJhsa9cjDjkeHKgqAAq+hTqekBfhS3uSDxvDUhvNb/l6t12HGyEAoT+VN
         9NJA==
X-Gm-Message-State: ACgBeo0rJXNKmH5MIgAIug8T4TWmT+TrPaWGAOv202YTJj+DwNSYFnXc
        Jd5zBAVLdgwz+IQ/DHvYZ+dw2VN59/bz0r+j
X-Google-Smtp-Source: AA6agR7bXEDvUlgj3iApVLpmxfqhNSdcyp/u0PuL8LxczEZzVeSURrQXHLfu5eH7OVQXXD60S4zBEg==
X-Received: by 2002:a63:d617:0:b0:422:4d27:5817 with SMTP id q23-20020a63d617000000b004224d275817mr461867pgg.412.1660779918109;
        Wed, 17 Aug 2022 16:45:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l4-20020a170902f68400b001690d398401sm485139plg.88.2022.08.17.16.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 16:45:17 -0700 (PDT)
Message-ID: <62fd7d8d.170a0220.701a2.12b3@mx.google.com>
Date:   Wed, 17 Aug 2022 16:45:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.210-284-g902835a13a927
Subject: stable-rc/queue/5.4 baseline: 134 runs,
 8 regressions (v5.4.210-284-g902835a13a927)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 134 runs, 8 regressions (v5.4.210-284-g902835=
a13a927)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.210-284-g902835a13a927/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.210-284-g902835a13a927
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      902835a13a9272617b015ba0eca9405327871c17 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4d0d0eb8e4304d35565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4d0d0eb8e4304d355=
65d
        failing since 99 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4fdd87747a0559355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4fdd87747a0559355=
643
        failing since 99 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4d352c99c9c931355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4d352c99c9c931355=
647
        failing since 99 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4f659dae93728535564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4f659dae937285355=
650
        failing since 99 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4d2116b0d790c2355662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4d2116b0d790c2355=
663
        failing since 99 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4f3dbf2f59c7d8355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4f3dbf2f59c7d8355=
643
        failing since 99 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4cf90eb8e4304d355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4cf90eb8e4304d355=
645
        failing since 99 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4fde33cdf30fa8355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.210-2=
84-g902835a13a927/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4fde33cdf30fa8355=
643
        failing since 99 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =20
