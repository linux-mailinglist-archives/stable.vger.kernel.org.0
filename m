Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E56554A884
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 06:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbiFNE6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 00:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiFNE6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 00:58:00 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362DD255AE
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 21:57:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h192so7505510pgc.4
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 21:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CkV4EfMOePdErEXwjdxGhoFZAB56uz2LXvNYFxaLRqY=;
        b=7+g3zT4wDyBIXCKGmHTUKrxfzqLPeRlG1hhTQvboSsozDqguU2PS88317ct0n2y61b
         sZ9WjDRXMmTH6xhIHdjzJpjyjF6o1ZjE2HWoUHc+PGlZfJtSoabfqCXg7Ybg+DIJ+k2J
         szEl0Go+d8wCQzx96M6NUaNS4dwjCq58sz8Ex0ZSpmrTIT+g9DYONHOC4Mk3AkJdHrwU
         xcGxdStlUOWHYX739vXUCHr47RBW+izA6pukc/kApMl5/bh8ivVczVrZv3BR7jx3jGJL
         QsVMHCnwoO1M9bLzePacHd5+vW5o6l+Q2Klq4XCz3DN12kYJYazpVk/4my4pszy9c+mM
         W3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CkV4EfMOePdErEXwjdxGhoFZAB56uz2LXvNYFxaLRqY=;
        b=4mk0AAlJ3SRTZ9Ln/3jVpU5sss2ZhBJb7dI1QACJkwYM5x6VfvrNgLkWuFg6FIPYJI
         4tK1zhFQvulQk/9cFmwi60hk3Y0aaHokYEsWcK0flmseTv0NKamnrJKXGv89djmTv+jy
         LBO94nf/hMm2FFLP3IVZbk3Inw4JqU4qUTomBBKrD2vUU3G5DqBcyVKk/3he85jSKCQh
         rfoiKTXR4X6Vcdq0esQvOwyKxFKVCgTOnLAbkeeSKkfnBAULCG3C/p9CeJDaaa7W47rB
         AmzfcpCm3n5kybBo19F4F/pg5sZ0yvnVB0I2QG8X36VP4ux4OBmE/HfoIEXeUQsKZIdv
         jGQQ==
X-Gm-Message-State: AOAM5329RA9hYfaJH+GrQ3zZ9htkNrJWrUpk65Egifm3ZQeav6NPFHRG
        xBmcp/9Itet92W6OmEYz8QEfFKXoq4BvOU7kjoc=
X-Google-Smtp-Source: ABdhPJyTcOmcLutKejqTb3l/lhetZFoNREN+SzzCGfO64q83JI3cROo/IsCaebALEZVTSGESbeZRqA==
X-Received: by 2002:a63:6a49:0:b0:3fd:df6d:5ba3 with SMTP id f70-20020a636a49000000b003fddf6d5ba3mr2835074pgc.385.1655182675279;
        Mon, 13 Jun 2022 21:57:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13-20020a170902e40d00b0015e8d4eb2d1sm6020558ple.283.2022.06.13.21.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 21:57:54 -0700 (PDT)
Message-ID: <62a81552.1c69fb81.1a1eb.77e4@mx.google.com>
Date:   Mon, 13 Jun 2022 21:57:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.2-1224-gaf2e7a0382857
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 171 runs,
 4 regressions (v5.18.2-1224-gaf2e7a0382857)
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

stable-rc/linux-5.18.y baseline: 171 runs, 4 regressions (v5.18.2-1224-gaf2=
e7a0382857)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.2-1224-gaf2e7a0382857/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.2-1224-gaf2e7a0382857
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af2e7a038285744a8a78048530b20adb9c867089 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a7e04c98a5ef750fa39c1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1224-gaf2e7a0382857/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1224-gaf2e7a0382857/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7e04c98a5ef750fa39=
c1e
        failing since 0 day (last pass: v5.18.2-880-g09bf95a7c28a7, first f=
ail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a7dd904876815d7da39bf1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1224-gaf2e7a0382857/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1224-gaf2e7a0382857/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7dd904876815d7da39=
bf2
        failing since 0 day (last pass: v5.18.2-880-g09bf95a7c28a7, first f=
ail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a7e53c0d3b5b4f14a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1224-gaf2e7a0382857/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-t=
egra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1224-gaf2e7a0382857/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-t=
egra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7e53c0d3b5b4f14a39=
bcf
        failing since 0 day (last pass: v5.18.2-880-g09bf95a7c28a7, first f=
ail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a7e2810243609689a39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1224-gaf2e7a0382857/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1224-gaf2e7a0382857/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7e2810243609689a39=
bd0
        failing since 0 day (last pass: v5.18.2-880-g09bf95a7c28a7, first f=
ail: v5.18.2-1220-gd5ac9cd9153f6) =

 =20
