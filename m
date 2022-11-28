Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4EC63A25E
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 08:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiK1H4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 02:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiK1H4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 02:56:49 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9372115FC2
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 23:56:47 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 9so9657858pfx.11
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 23:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4Bo+xenIC1kScVhVFtZjs9ODTGcywdSQYZOhuEE2H0M=;
        b=VfuR7AUS1QS4+0Zhmdyihf6eviqjiA80YDEcnMOuA8424Umvjlig6mM1s2rE3YB4aV
         yKQczFsJUsKfQmVTIIqR11VQISJU0vmWkpesHT2mDnK31s0DYPSq9nUm0r8st3plS0pU
         vql6hNWE97+WB1l+lYHW57XSYcmqQQHT+uq3Z/8a4O6+yjx47sFppZdu+AhtTplp8gJa
         /hVzrpvya+db07yGHG0WuAQWsr8Ni3dCiMfI+HPzLiHIlFiVIMkCRMxztEixJJ4H0SH9
         c4of2wPvQmKPlMid/DvPpDC/hu3TstymDdhHuWTdG9ljRl872zmXUdO6tqBR46tvMI3Z
         LBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Bo+xenIC1kScVhVFtZjs9ODTGcywdSQYZOhuEE2H0M=;
        b=L45TmxIwH/e61JzO5OGThrVDzeP+ioNewl9nNGKnKXoomQbVAte5rXlBMiyaL4uisd
         X95Rj1yAlNG4fUlZsGHsV1MlcrzTMR+y/5iTjW1yZ8J5F8HXrUgfcfw8KUVIVtx3G6Jc
         VvqdqH1e/Tl5NbC7ExoMWbVuYR/HMdUPfudvro/ZwMrWxudMrJ8JJxPmqlNhXcVZUgPe
         LHgI5iKFnEO5IU5PlfexQq2K7ur4M8qnVbdlAaG5tUVOFghCTwY5IM1bIs1inc1bkZJY
         4mUo7EhES0+quR+ZcioEVuWAN1/fq3dHz/kBfpkxu/EWGM6/J1Xf/Mv+6ssMO23JQ7hf
         9gvQ==
X-Gm-Message-State: ANoB5pnWiovaF0eUOgKbnjAbRR9/QoOtCq7svUggCqBvR14e6D4fEZEp
        nT+EPkgEbe5YwJwiRRqIFTRZVf7RxENjbeN0
X-Google-Smtp-Source: AA0mqf5AcLlL6knGMDlXkn9+K0bQvyBE6JULis5ys1v1fMHzJKKgcWPoznupQjbDR5vp8CzEq+HYTg==
X-Received: by 2002:a63:1062:0:b0:470:a47:996a with SMTP id 34-20020a631062000000b004700a47996amr26635307pgq.377.1669622206652;
        Sun, 27 Nov 2022 23:56:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oj8-20020a17090b4d8800b00217cdc4b0a5sm8946679pjb.16.2022.11.27.23.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 23:56:46 -0800 (PST)
Message-ID: <638469be.170a0220.8f781.ca20@mx.google.com>
Date:   Sun, 27 Nov 2022 23:56:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.333-96-ga5e7fdaf3328
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 54 runs,
 4 regressions (v4.9.333-96-ga5e7fdaf3328)
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

stable-rc/queue/4.9 baseline: 54 runs, 4 regressions (v4.9.333-96-ga5e7fdaf=
3328)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.333-96-ga5e7fdaf3328/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.333-96-ga5e7fdaf3328
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5e7fdaf3328b827938d193d97df2f092a48eb8e =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6384384d75b45eed9f2abd1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.333-9=
6-ga5e7fdaf3328/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.333-9=
6-ga5e7fdaf3328/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6384384d75b45eed9f2ab=
d1b
        failing since 201 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6384384a75b45eed9f2abd0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.333-9=
6-ga5e7fdaf3328/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.333-9=
6-ga5e7fdaf3328/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6384384a75b45eed9f2ab=
d0c
        failing since 201 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6384384b75b45eed9f2abd0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.333-9=
6-ga5e7fdaf3328/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.333-9=
6-ga5e7fdaf3328/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6384384b75b45eed9f2ab=
d0f
        failing since 201 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6384384c75b45eed9f2abd14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.333-9=
6-ga5e7fdaf3328/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.333-9=
6-ga5e7fdaf3328/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6384384c75b45eed9f2ab=
d15
        failing since 201 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =20
