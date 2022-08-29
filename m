Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE0F5A5457
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 21:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiH2TNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 15:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiH2TNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 15:13:48 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E7D83F25
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 12:13:47 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h11-20020a17090a470b00b001fbc5ba5224so9572880pjg.2
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 12:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=7BZYs5AyuSDYoqiB/YYu2wdkC3w+6BHGUJOuyKP/zsg=;
        b=n4fcyv+Ic95o29peyBeNuexCh9AH3ilmumnSfhKNx23Oxiv+VwAVk8ps8LrMGZ9uCO
         fX4uy/honGn+LsrW4X+bc6Khz/cdiNjezi83IcGlTURjJqKbQWqBQsT//8ZpqC1jC3SL
         TIGNs86VCNw8weNopaD3ohN5DLxjWh17XglB42bm52v7QEDtM24oWwxFHmQ1m6PAJg2j
         n8lTm+5dQCx0Y2fQmrDQAEpfBR/C3ub5Ac72J+J0ykcGlTmwUmFukPvY6iGU24gCLYqS
         0tMsg4QK1D19jIbj637tpmdqRssTkfA+UTQi2Tz3R8vOg7q0j6AHcBW5AvSKcwkLJmft
         BFMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=7BZYs5AyuSDYoqiB/YYu2wdkC3w+6BHGUJOuyKP/zsg=;
        b=YjpIMbclATPUBsX0r8RwfzoIBFm+6V0XaCVuMo6dr6WcPNkdJ/d0gxg4AiGM7yLv7n
         OtSSGr+0tEqszTJdyrxcaboEvD20HyQRqQjJd7pJQOuEiBueLJj7glrwSZ1/crDtl/xh
         0dkA6AmRjELUovg8LJHjOuYSUWfym60WJ0EW5OpoBWAZaLzELr3IB9SXAB+0DmxyDSa2
         Efkkxkn9YTDFLUkOmd9wSWp7rFcvE2o41aMJSYAERU2zGaBMZovbu6AGNGEsqoxgjVxx
         Vc0DTJycWHzPJGeNXpv/p0cRT7CxlaUqBkdotdHuZO/yDe3RBjbqbNX+LkSP75uahJpV
         6jPg==
X-Gm-Message-State: ACgBeo0h9Ow4ktl32FyU6cU/2Sv0wase5vxG2PzWFc2pPgPPvG8TWd/9
        0EhnByhmnwHmygd9uwpGLh8L7RjpPWAy+c6D27o=
X-Google-Smtp-Source: AA6agR4PHpjqMlgewPYB0/7mAzcD0x/XjH+iLufhwGmDxzzFpAKs0gY9lTb7d9rD3AauxXG2B/EP+Q==
X-Received: by 2002:a17:902:e886:b0:172:c859:dcc6 with SMTP id w6-20020a170902e88600b00172c859dcc6mr17641260plg.160.1661800426413;
        Mon, 29 Aug 2022 12:13:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2-20020a170902c94200b00174f7d107c8sm1509863pla.293.2022.08.29.12.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 12:13:46 -0700 (PDT)
Message-ID: <630d0fea.170a0220.3d9c9.3043@mx.google.com>
Date:   Mon, 29 Aug 2022 12:13:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.326-16-g3c2305a62137
Subject: stable-rc/queue/4.9 baseline: 105 runs,
 8 regressions (v4.9.326-16-g3c2305a62137)
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

stable-rc/queue/4.9 baseline: 105 runs, 8 regressions (v4.9.326-16-g3c2305a=
62137)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.326-16-g3c2305a62137/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.326-16-g3c2305a62137
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c2305a6213701bd06150368f2a79e3ef44a35d7 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630c8e0f4d2ef290c835564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c8e0f4d2ef290c8355=
64e
        failing since 34 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630c8df774d5d4c34e355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c8df774d5d4c34e355=
658
        failing since 34 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630c8e234ee826457d355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c8e234ee826457d355=
644
        failing since 34 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630c8df1da7aa3a17a355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c8df1da7aa3a17a355=
645
        failing since 34 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630c8e104d2ef290c8355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c8e104d2ef290c8355=
651
        failing since 34 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630c8df3624cba6386355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c8df3624cba6386355=
648
        failing since 34 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630c8e264ee826457d355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c8e264ee826457d355=
64a
        failing since 34 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/630c8df9624cba638635564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.326-1=
6-g3c2305a62137/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c8df9624cba6386355=
650
        failing since 34 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =20
