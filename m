Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487E955FF11
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 13:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiF2Lw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 07:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiF2Lw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 07:52:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B643F882
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 04:52:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id r1so13878277plo.10
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 04:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yMYF3zF8HmnCoLqniRRELTI/PAwnTKrgcGUUlQj9FvI=;
        b=W0tqeI0zq+ILCUx2m6ZUWinGvL2e9ESmxXFHvqzgqsIvmUDQdzYqnIBB5u4tiI14dA
         jzHUSJJ4RuBMbNEIc+aYBQrgDiBpRGt2A1QKPT9oEKVXACaRINs8k7MKGGO5x0Vc8X2D
         v5IS0PuIwxEt8NDO7Pm9P0IbjnJ+D8ehgp3JEStQO4PMHclzMm7BcLgP+fU7RhWYNrOO
         rpGg/THjJ8rZCLohtMBK9odca4mos6GOysKe9fd2lnx495QDjqdwTD4jhVRzod20PZbs
         DgMGf9N4pKKRBLxmWyVixd7I7N0Lx7gwuhwzDPiiBfppQPONqOYw6m6e2XGU10lMD8OE
         2kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yMYF3zF8HmnCoLqniRRELTI/PAwnTKrgcGUUlQj9FvI=;
        b=ByXXAThw4ktfINRmBlZB+jLNi/Zv6w4PdomxpNiYln6rh12+4tQAV2IZVAzMUoRcbL
         I8XRba8gmzUXzaS5K239TW8855eVF/+eeztQtXSstBK5NvQ16bj/l7ogT6bnzfGS16v9
         PxU+bQyiTCGhtSWhZO3ZxoF4Vz1Mzs63NLRcDn8ZM8XRHIXiaISNlI1Keat2i3gFGz9K
         k3MbplcrQ5uoVVJ4SeFHC8Iuc2pJFNVtN6lHePyNRsBRKrsLIwBGOpyPv9lzqRZremqf
         BePJSKYGxpr5ThX4RPO4QOz/IHv8cWz+wk3Ysuf3uNDrZC28C3bEIw/1ehKInOiuejDZ
         56pg==
X-Gm-Message-State: AJIora8D85Q4NBimFEj9vHnTbhuBBfwik+Z8NhdhLqoe51tBFzDpetbV
        iMt+XguL+EsqZY4Nix9FOVZc5inNRWI/XixK
X-Google-Smtp-Source: AGRyM1sOaAa17+SJyTmODYixE3m62eDvJnSGzFiD2ltKN3oi3ESLRz0e8EMFQcdTvE/p2Xa6v01vNw==
X-Received: by 2002:a17:90b:2bcc:b0:1ec:89c6:be9b with SMTP id ru12-20020a17090b2bcc00b001ec89c6be9bmr5626981pjb.74.1656503545362;
        Wed, 29 Jun 2022 04:52:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i4-20020a17090332c400b0016a214e4afasm11279881plr.125.2022.06.29.04.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 04:52:24 -0700 (PDT)
Message-ID: <62bc3cf8.1c69fb81.9dd51.fbe9@mx.google.com>
Date:   Wed, 29 Jun 2022 04:52:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.50-135-ga6708fb92f9b
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 113 runs,
 5 regressions (v5.15.50-135-ga6708fb92f9b)
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

stable-rc/queue/5.15 baseline: 113 runs, 5 regressions (v5.15.50-135-ga6708=
fb92f9b)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig        | 1          =

jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | tegra_def=
config            | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

tegra124-nyan-big            | arm   | lab-collabora | gcc-10   | tegra_def=
config            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.50-135-ga6708fb92f9b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.50-135-ga6708fb92f9b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6708fb92f9ba090fbc48f75d314883107e4057b =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc093b3ca45c820ea39bd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-ga6708fb92f9b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-ga6708fb92f9b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc093b3ca45c820ea39=
bd7
        failing since 90 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | tegra_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc06d250413f60a8a39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-ga6708fb92f9b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-ga6708fb92f9b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc06d250413f60a8a39=
bd2
        failing since 16 days (last pass: v5.15.45-833-g04983d84c84ee, firs=
t fail: v5.15.45-880-g694575c32c9b2) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc06bb7048d007c3a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-ga6708fb92f9b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-ga6708fb92f9b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc06bb7048d007c3a39=
be2
        new failure (last pass: v5.15.50-135-g7ebec9568872) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc08843f5e1b4a10a39bed

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-ga6708fb92f9b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-ga6708fb92f9b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62bc08843f5e1b4a10a39c13
        failing since 113 days (last pass: v5.15.26-42-gc89c0807b943, first=
 fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-29T08:08:10.557694  <8>[   32.514475] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-06-29T08:08:11.583102  /lava-6704969/1/../bin/lava-test-case
    2022-06-29T08:08:11.594588  <8>[   33.553094] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
tegra124-nyan-big            | arm   | lab-collabora | gcc-10   | tegra_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc056f0736f198a7a39bf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-ga6708fb92f9b/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-ga6708fb92f9b/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc056f0736f198a7a39=
bf8
        failing since 10 days (last pass: v5.15.45-915-gfe83bcae3c626, firs=
t fail: v5.15.48-44-gaa2f7b1f36db5) =

 =20
