Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7716E517F47
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 09:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiECIB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 04:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiECIB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 04:01:57 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899672B254
        for <stable@vger.kernel.org>; Tue,  3 May 2022 00:58:25 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o69so13304181pjo.3
        for <stable@vger.kernel.org>; Tue, 03 May 2022 00:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Abz/+kySYmoZAxfB6YCHSU+bOSPGCln7e9LO7AJZZV0=;
        b=fL1C6ZRwXOSkRPt29rlV1mVT0wcZ36SVzRCr8hPqQkc/c09mHQX9Md5kS5NjRFfz8i
         cRzFIKCmTEYUHvhyL3hvQ/1b2RgPhy8uCMIjvWg309+SefdH7+xTYIhDVzY2YFxmrYiB
         i63EyQOIUElkWj7JLxbPG9bhuMmggi0+vHi2vhZCJoGfUY3qaw6wdXZylA/jAmpChtNd
         B+la9mCvLMEGmtIfLnBFlMGGEUDhQT9jbafrrJKHxgATuH8keVrTXFw38h2Im8DynX3H
         IP141L5Z3cqppxNKfr885lX5am2mXLw5JCVLX6gBmA318rXcE1K7OewvB6CbSOzLan6Z
         msGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Abz/+kySYmoZAxfB6YCHSU+bOSPGCln7e9LO7AJZZV0=;
        b=6qfdIOVtJzbBaQsYNSlsTWLlexYrN2FC3Pioa7YgduTlLwwx2fv5qeYJVxz0O3GAD1
         F+iTgb/8EAWqgpz99Nu6OdBPl7T1eKGE6A/WBlIseUcdA1ie66GWSO8VlgxCR3/+iTFx
         jPWCyGgJnzCqq7yF6C0E6QO0mVxVnTBYdM1CevkRjLd8QaMnQQasQuL9eBNCmqWD/w4G
         6iMQ5G+U52JBbsvtZzI/zF5kPl/O1juJpvgf//iHlYMYEVYwiQ7c6KMhNzDigmfudKpm
         4LIaINc9EqzAK1/hBW3xbw1VSlvpRiytbKL8z4TdoHUO5jIsBvlbvQ1gQVamq/APl65n
         8G+A==
X-Gm-Message-State: AOAM532t85hdyJ6uIcI0IsLvsIIM4/MDZRAgMzFFiVhP81tSptd59W8Y
        cXp7O0NPs+g2wB2GXa9hNiwA7I5hk+R5l0GiQPI=
X-Google-Smtp-Source: ABdhPJwL7N/EX21WSbIVYHprGERlPcnTEZE3O74Dke1D+ghpwqQdmENmPPc03ojF0rGJxtyR75Xhjg==
X-Received: by 2002:a17:90a:8b91:b0:1be:db25:eecd with SMTP id z17-20020a17090a8b9100b001bedb25eecdmr3418191pjn.10.1651564704584;
        Tue, 03 May 2022 00:58:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g4-20020aa78184000000b0050dc7628190sm5808355pfi.106.2022.05.03.00.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 00:58:24 -0700 (PDT)
Message-ID: <6270e0a0.1c69fb81.af817.e952@mx.google.com>
Date:   Tue, 03 May 2022 00:58:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.191-74-g65a8a6ba51b6
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 104 runs,
 5 regressions (v5.4.191-74-g65a8a6ba51b6)
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

stable-rc/linux-5.4.y baseline: 104 runs, 5 regressions (v5.4.191-74-g65a8a=
6ba51b6)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.191-74-g65a8a6ba51b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.191-74-g65a8a6ba51b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65a8a6ba51b6c9bc41503f9d4c677d3aec83f836 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62705794c22187d278dc7b55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-74-g65a8a6ba51b6/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-74-g65a8a6ba51b6/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62705794c22187d278dc7=
b56
        failing since 26 days (last pass: v5.4.188-371-g48b29a8f8ae0, first=
 fail: v5.4.188-368-ga24be10a1a9ef) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62705989e9668c7edadc7b44

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-74-g65a8a6ba51b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-74-g65a8a6ba51b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6270598ae9668c7edadc7=
b45
        failing since 138 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62705996e9668c7edadc7b4a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-74-g65a8a6ba51b6/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-74-g65a8a6ba51b6/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62705996e9668c7edadc7=
b4b
        failing since 138 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6270598be9668c7edadc7b47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-74-g65a8a6ba51b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-74-g65a8a6ba51b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6270598be9668c7edadc7=
b48
        failing since 138 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/627059aa7066d84df7dc7b23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-74-g65a8a6ba51b6/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-74-g65a8a6ba51b6/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627059aa7066d84df7dc7=
b24
        failing since 138 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =20
