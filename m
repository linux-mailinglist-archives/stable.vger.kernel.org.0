Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC62858B878
	for <lists+stable@lfdr.de>; Sat,  6 Aug 2022 23:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiHFVp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Aug 2022 17:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiHFVp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Aug 2022 17:45:28 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94D32BCD
        for <stable@vger.kernel.org>; Sat,  6 Aug 2022 14:45:26 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id 17so5502179plj.10
        for <stable@vger.kernel.org>; Sat, 06 Aug 2022 14:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=4o/uY21kIjMZCPKYMiNJOg/nGFBvZY4TzdaqrW6iFe8=;
        b=IQiIYmFy693ddsc5Ghj/ipsHvaP7wCPuDdlFCLELm8t0HSjszFxy0HCoqQJjNsFQRr
         X7lKnOz/d6NtxiVnSMEbISAjOPLYxNXGq2vo0x6lFUCrO7EkYZNj+3XGG0gDarfJ5rca
         2iAF5tIP0va/aTgqCAv6cfT3z0zHniZZJWL3p6oewkbKtQ2UUrH+mP1K4Qp+BRZhKr54
         EvEpN1ZehQdegI/vP6TNFXkTCami6XTAFolDuxsOp/s4AAk0t0fLxkYQSLOP6uc9S1/R
         I6s0bAo9naka6WMRwOikCgL5qNgBL4Mu7aTYTB2JGJhb18TAhKZa+qdZBPJihhSq8/yY
         CcRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=4o/uY21kIjMZCPKYMiNJOg/nGFBvZY4TzdaqrW6iFe8=;
        b=b3FRDS6lMYSqFMVYKtaTiJRVYdTaLgcM5hBbd+PkZ1lOX7nPHj1zHEECktApUkraBa
         cmfDkV5xEpfvhdmy0O9D9HyXfPYjjWalhKj4cjin42v1YtaZSG6iQ7z4Vai7vnu3hfCw
         ap+NSm5oyNX3xvzyazFnHFghMNQCYKaCgd8rghPnU5UsD0HDroRs8mDjrGi92o5T3odh
         B0ShFm8PGgav5rIPcBBA27RGCb7S7vZOb6HhA4EQ3vr0i8XonbL8MdxxthKn8C+m5TGm
         zPtlhPjUfz6sf4xShmNGC70E6isDe/DAyYxL4TWSyD3nIQQT1uuF17EaWEc0S0xSuPCP
         AWOg==
X-Gm-Message-State: ACgBeo3e46ojZjbKCxkzY8ZPeTDDoV9AMKcY5eHv/J+jvpsN8jfUKQCf
        cRzuvs2UPBzrflaomnlr32WVJec6zp1rv9+y7s4=
X-Google-Smtp-Source: AA6agR7aukNsX5Wdb/5hpdUGb15SgIeP5tiTOw6KavpHsKcCmcGrwBVxVZ14l2Ue+djkxRemDwoMkg==
X-Received: by 2002:a17:90b:1b07:b0:1f5:115c:79a4 with SMTP id nu7-20020a17090b1b0700b001f5115c79a4mr13900766pjb.166.1659822326187;
        Sat, 06 Aug 2022 14:45:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0052e2a1edab8sm5550994pfq.24.2022.08.06.14.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 14:45:25 -0700 (PDT)
Message-ID: <62eee0f5.a70a0220.da1ba.9235@mx.google.com>
Date:   Sat, 06 Aug 2022 14:45:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.135-12-g2bc9f8fa0baee
Subject: stable-rc/queue/5.10 baseline: 163 runs,
 7 regressions (v5.10.135-12-g2bc9f8fa0baee)
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

stable-rc/queue/5.10 baseline: 163 runs, 7 regressions (v5.10.135-12-g2bc9f=
8fa0baee)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

r8a77950-salvator-x        | arm64 | lab-baylibre  | gcc-10   | defconfig |=
 1          =

sun50i-a64-bananapi-m64    | arm64 | lab-clabbe    | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.135-12-g2bc9f8fa0baee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.135-12-g2bc9f8fa0baee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2bc9f8fa0baee8394b1db7c8320a493e325466e3 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62eeac3211e771f97edaf074

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62eeac3211e771f97edaf=
075
        failing since 88 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62eeac3179435ae9dcdaf05d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62eeac3179435ae9dcdaf=
05e
        failing since 11 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62eeabfe282a3d6739daf0aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62eeabfe282a3d6739daf=
0ab
        failing since 11 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62eeac4505df278280daf0ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62eeac4505df278280daf=
0ad
        failing since 88 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62eeac1c11e771f97edaf061

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62eeac1c11e771f97edaf=
062
        failing since 88 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
r8a77950-salvator-x        | arm64 | lab-baylibre  | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62eeac52b62a764ac9daf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62eeac52b62a764ac9daf=
060
        new failure (last pass: v5.10.135-10-ge5e0ac3f4514c) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
sun50i-a64-bananapi-m64    | arm64 | lab-clabbe    | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62eeababaa31a5a2cfdaf07d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-12-g2bc9f8fa0baee/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62eeababaa31a5a2cfdaf=
07e
        new failure (last pass: v5.10.135-10-ge5e0ac3f4514c) =

 =20
