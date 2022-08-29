Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9715A5017
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 17:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiH2PVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 11:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiH2PVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 11:21:01 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E84D67179
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 08:21:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y127so8510722pfy.5
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 08:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=2lYh9ohrz4iNb2tfUDceMZpG/++G9RNwmEE0kUOt6sw=;
        b=szXEW+Rx2c/F0wNjNslTQXtT0u/KbWsyf6afOPLalLP2iQVUXQ1r2fhxo+1IgKGu28
         q3RDL1BukWLaEiM3XpqAordY1pWgRfssDNZymo/SjDcegxQ4YPsu2D7iBuawQfCCDkMj
         ZuTNgn5xbgtEoBln+tq1UQhoGhXX3gBNMqDXdKgA8Xz4BSMOZyoU4voGVMOedrMp+HmX
         b8ayrxSl/aMXBz36zaBZrOley4VLGEf9/X90qGfk0vT+U8WgC5X3+CUv9QV1FZpGgmvy
         8J3/LIiP1e6Ibnrk41rng0YrZ+TdBPPU1cFUId1SSE6Z8Rs0G4YGfHBGzJkyJipvQR6I
         x0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=2lYh9ohrz4iNb2tfUDceMZpG/++G9RNwmEE0kUOt6sw=;
        b=DjKX6r3LZW4GsIpu5SbY0LM6UvAezst1LpISyvbnEA5oSQHJg+PymmfrQRihbULjX7
         MOYFplmT+mB5alveMtWZFdA8d0GrQ9KIdHuD4L/4fq3ptnUg/0Ocla9StWIw6fqlT1XP
         X2cQYh4cZ3+5URSj33H70B/3rlo3382BApFobdz3IID3zAVGW8PeUfo3XVM6NmVyHCTI
         tLeLOGHXckXNdw0bjsg2PRJKY50h4gU7Y4dLrJ2zgWU2zw1KH2zPnkGmSg0KdbTnMc7c
         jrnMQz/tQj10VYF0fCp+6lSkXby/7ulROU+VVcJrLPzuNiDTyh6BM0zKQN43oOrq9ZO7
         iaoA==
X-Gm-Message-State: ACgBeo2Z3w9N+AiT02oS1CcErbjkF4xxsu9ZI4FIw4B6E8nVILCYUOZ+
        OjcsJDAp1UP6XD3SieDGuSskM844XcHmEIbh3yA=
X-Google-Smtp-Source: AA6agR52EAScK2pzHkylO+Y5oOXiCgoPd+hFkUO640CNg8q5ueKAQWuJuq7h7qXWsDYYf/Uymf3eyg==
X-Received: by 2002:a63:b648:0:b0:42a:ad58:74ce with SMTP id v8-20020a63b648000000b0042aad5874cemr13987838pgt.489.1661786459623;
        Mon, 29 Aug 2022 08:20:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6-20020aa79f46000000b0052e6c058bccsm7378485pfr.61.2022.08.29.08.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 08:20:59 -0700 (PDT)
Message-ID: <630cd95b.a70a0220.4a177.c7e8@mx.google.com>
Date:   Mon, 29 Aug 2022 08:20:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.139
Subject: stable/linux-5.10.y baseline: 109 runs, 5 regressions (v5.10.139)
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

stable/linux-5.10.y baseline: 109 runs, 5 regressions (v5.10.139)

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

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.139/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.139
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      665ee746071bf02ce8b7b9d729c8beab704393c2 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630ca8df060c4fa6c6355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.139/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.139/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630ca8df060c4fa6c6355=
643
        failing since 111 days (last pass: v5.10.112, first fail: v5.10.114=
) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630ca9947a4c9efa53355660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.139/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.139/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630ca9947a4c9efa53355=
661
        failing since 111 days (last pass: v5.10.112, first fail: v5.10.114=
) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630ca97f7a4c9efa53355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.139/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.139/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630ca97f7a4c9efa53355=
643
        new failure (last pass: v5.10.101) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630ca8d6a88fcdd60a355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.139/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.139/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630ca8d6a88fcdd60a355=
667
        new failure (last pass: v5.10.101) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630ca9937a4c9efa5335565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.139/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.139/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630ca9937a4c9efa53355=
65b
        failing since 111 days (last pass: v5.10.112, first fail: v5.10.114=
) =

 =20
