Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A20F528DFB
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbiEPTd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiEPTd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:33:28 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8102430575
        for <stable@vger.kernel.org>; Mon, 16 May 2022 12:33:27 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso298386pjg.0
        for <stable@vger.kernel.org>; Mon, 16 May 2022 12:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0D5tpIB/3zBXbJ/GzO+sDS5bjqC+otn0bSxX/IXkYgc=;
        b=gq4OSXZxw2H4bLIY4NpdjKuo64b0O3jb4TpGaYS5fAwC2GhVJD69O+a3BAsu8Gca6I
         JPUo3XN0EKQCUUaTgJMRHIoOJrwVAMtzm/U1lO1n+va2zGr7bzSW8+rkggmn4w+l5pUH
         OaCzNR2n9SmMuBb2Ps/1F9JJOfE1AEqbcXUynS4EwL3ev+JbTBXLm6fHoR79tQ68xgNJ
         7z7hVSTRyajXGw+teLZbHIvfwJBttmcimg69lc8Thzx2R2t18mOY/AWBanxHZ5iq6y9o
         9bHURcZ7TBkTzxtaTyacZ38DpV/bpjsMrVRWnUOuBUrPI0rpmrAH+VtXc8Fy4QB+ADjr
         Npxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0D5tpIB/3zBXbJ/GzO+sDS5bjqC+otn0bSxX/IXkYgc=;
        b=J2H85bK1mFbX7EKH4JalFkAIjZ6AE0KtcXZ8kSGIAHccu6iz3a72TsMpfRFIfoN95D
         7PY/m+eBICta6o12bGBBuf1DHdS6MTxrJ8WcmMzz+9ACNxIBBXMhm8OJNPfW6mdmMKb5
         BpCSnuFqDZLV9l7b4LxgIYZHKbZ7uTSG3ZfRnArX7bKzjYqJ2OoF8o6obU7b70P4m/8k
         gnCU3+eXHUz7431ug0sVGM1JZo2qrsjy/mK8a0fDph1MhGtdPbeb/Sqxvvf5WYphJzxT
         kF4gv0z3z8y4qNCO+ij8Mv2VaJ0YaiaBBUee6XZ36YIwZOzp18tNOR6FL6fYh6ZktWi9
         5VRw==
X-Gm-Message-State: AOAM532U2FLqip8Smq0wbH5KfLrSYLF3+YTjEzuHURERv4sZQ3iN0vTs
        xi/O3LatwYcfzpWun3CuCUdfr7CkA1+qU28p7PE=
X-Google-Smtp-Source: ABdhPJxF3KwwNMCsBF8q09d8hFjfARpPpxmHaJfiLBTwbWe0HyDpMWpuJOcIqqUm/PcnDJNx0EEuWA==
X-Received: by 2002:a17:903:244e:b0:15e:b3f7:9509 with SMTP id l14-20020a170903244e00b0015eb3f79509mr18433094pls.42.1652729606785;
        Mon, 16 May 2022 12:33:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gd8-20020a17090b0fc800b001d9780b7779sm72716pjb.15.2022.05.16.12.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 12:33:12 -0700 (PDT)
Message-ID: <6282a6f8.1c69fb81.e935b.0549@mx.google.com>
Date:   Mon, 16 May 2022 12:33:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.194-43-g71ab15716d94
Subject: stable-rc/linux-5.4.y baseline: 87 runs,
 9 regressions (v5.4.194-43-g71ab15716d94)
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

stable-rc/linux-5.4.y baseline: 87 runs, 9 regressions (v5.4.194-43-g71ab15=
716d94)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
hifive-unleashed-a00       | riscv | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.194-43-g71ab15716d94/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.194-43-g71ab15716d94
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71ab15716d941846af0392680e4121844683c79b =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
hifive-unleashed-a00       | riscv | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/628273267a117e20028f5761

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628273267a117e20028f5=
762
        failing since 39 days (last pass: v5.4.188-371-g48b29a8f8ae0, first=
 fail: v5.4.188-368-ga24be10a1a9ef) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6282786460ed4690be8f5727

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6282786460ed4690be8f5=
728
        failing since 6 days (last pass: v5.4.191-85-ga4a4cbb41380, first f=
ail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62827d1ae1e1fe33578f5734

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62827d1ae1e1fe33578f5=
735
        failing since 6 days (last pass: v5.4.191-85-ga4a4cbb41380, first f=
ail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62827829f022d4054e8f5719

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62827829f022d4054e8f5=
71a
        failing since 6 days (last pass: v5.4.191-85-ga4a4cbb41380, first f=
ail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62827cf1d2658649b58f5742

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62827cf1d2658649b58f5=
743
        failing since 6 days (last pass: v5.4.191-85-ga4a4cbb41380, first f=
ail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6282785729ccd257f28f5737

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6282785729ccd257f28f5=
738
        failing since 6 days (last pass: v5.4.191-85-ga4a4cbb41380, first f=
ail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62827d4149b8bef58b8f5736

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62827d4149b8bef58b8f5=
737
        failing since 6 days (last pass: v5.4.191-85-ga4a4cbb41380, first f=
ail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6282787c60af40c7c38f5723

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6282787c60af40c7c38f5=
724
        failing since 6 days (last pass: v5.4.191-85-ga4a4cbb41380, first f=
ail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62827d19e1e1fe33578f5731

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-43-g71ab15716d94/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62827d19e1e1fe33578f5=
732
        failing since 6 days (last pass: v5.4.191-85-ga4a4cbb41380, first f=
ail: v5.4.191-118-g7dae5fe9ddc0) =

 =20
