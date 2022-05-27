Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38ACC5361D2
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiE0MHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353838AbiE0MGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:06:33 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159A31133
        for <stable@vger.kernel.org>; Fri, 27 May 2022 04:56:43 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id i1so3952225plg.7
        for <stable@vger.kernel.org>; Fri, 27 May 2022 04:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1FVVNVLi8w0xGxbkAbtUHLpKjM3KEuFkuUohvvEZk/8=;
        b=0bHPHobjoxswcYJ7YQFOSK1YwpbtXu0JAM7QYc9PAo0lPl1D3TM2e3DK6I2juQDxdf
         k7ZWK3kNFgMPuOehN8g7PhuTkAwkwQH/A2SyhxqFh+nzhdjz14yH7dY3IxHRWh0ejCt6
         cYDuhQhat2KFHYJx3jWxPidH32e4X/F5VsxrsxDIgI4cM9Cy1Pow5d4ZKCigqMDkqoUi
         ppMY5yvfBOHhGt3UW/CasUk77WTBEm1AQsmFsYXQFGWuH6W0nOFUXTHDoOONxC6Z1/jg
         N4xKPkqRRBi0uwgEAo685WsiX2Z2N7e80SQTXbnZPdzIEZeP7FTYbhFjzq7YMWuvK+i2
         hvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1FVVNVLi8w0xGxbkAbtUHLpKjM3KEuFkuUohvvEZk/8=;
        b=6E3hY8t8tOMcSgy13aU8Py6ioboJcfC89E4ZOnOuu1XS3ZdkGUC53JpcGN0qXxGCCK
         JIe1OYCZrQ3NHKW7z+3YTtPTnsE9ttBCpDy7yPRKoDUbOjG4tIJIQPq6quDx/5njizt3
         wxIPNgzrQsXUWS3aSmtjCLBlo7HFcVgkd7n6byEkodXCsUDcz2/UiOEYCp+h7PABxxCr
         cTKWw5iVuzYEkFx3S+3EcWQLovVvKSR/uZ59VZ0Ty+PMeNdAMlPGbtNTwVOc3KXhFPDc
         8ambx0lCVQ9t96ZlpOtSu50FM/N1imHkTdonbfH2KS2QSIv8FPxBCUAdh47AJlLSUn7J
         8uDA==
X-Gm-Message-State: AOAM532xzRMqfylEmTX9TvafHn7FMhE02OfeENnH9NZe3VzP51guPLiR
        s+/MCT9fjGAR5xozKCaw1hrPL4AQkxQxVOLbEq0=
X-Google-Smtp-Source: ABdhPJxVHpVXcTjGYqoBKfBg+Dke42AnP7CsDO6PdXnSCpc/OTjpyQMSdaccviE4rwKz4YzXlFamdA==
X-Received: by 2002:a17:902:e2d2:b0:163:759b:7ea0 with SMTP id l18-20020a170902e2d200b00163759b7ea0mr8731742plc.96.1653652602429;
        Fri, 27 May 2022 04:56:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q31-20020a631f5f000000b003fae8a7e3e5sm3189459pgm.91.2022.05.27.04.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 04:56:41 -0700 (PDT)
Message-ID: <6290bc79.1c69fb81.ccf2f.710c@mx.google.com>
Date:   Fri, 27 May 2022 04:56:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.196-10-gb713e662ca6f
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 63 runs,
 4 regressions (v5.4.196-10-gb713e662ca6f)
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

stable-rc/queue/5.4 baseline: 63 runs, 4 regressions (v5.4.196-10-gb713e662=
ca6f)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.196-10-gb713e662ca6f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.196-10-gb713e662ca6f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b713e662ca6fba9027dfd5804da1976b0907b0a2 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62908ae89a9dd9ad36a39c07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
0-gb713e662ca6f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
0-gb713e662ca6f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62908ae89a9dd9ad36a39=
c08
        failing since 17 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62908aac7710512d34a39beb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
0-gb713e662ca6f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
0-gb713e662ca6f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62908aac7710512d34a39=
bec
        failing since 17 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62908ac0eb72681917a39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
0-gb713e662ca6f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
0-gb713e662ca6f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62908ac0eb72681917a39=
bd4
        failing since 17 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62908aad038ccc287ba39c02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
0-gb713e662ca6f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
0-gb713e662ca6f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62908aad038ccc287ba39=
c03
        failing since 17 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =20
