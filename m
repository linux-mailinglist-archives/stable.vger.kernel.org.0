Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7BE5EB74A
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 03:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiI0B6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 21:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiI0B57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 21:57:59 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394279E2E9
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 18:57:54 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 8-20020a17090a0b8800b00205d8564b11so325983pjr.5
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 18:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=R+bxR1iO1INjJTECC44BojSTyAGcoISsrqfX710a6xA=;
        b=wjQws5ZmeGgJ7nIVol472Zrq/qu8wE1LUOLDcHDFUrslE8eiBed0L2L83+zRYq0XuJ
         mt1W945gTqwk7tDBuHHehFAxUnt9Ur3Z98M65ZS1OsqEJYoPWESvIzbyNwGZnEyPNjLA
         R7NdMpZnfOizBSGk8zsacqWnsezgejmLmNA7Bcd1p1kELMQIuCUG2pTRL6KoB2/PzK9r
         dGXyPuN/S+YOyLTG+wzpBOJRkBUpsEsVdZwuqiCE02az5N4b6e/0vrP4zntHYq9M0DKo
         HzKd2WIfL35B9aXkwd7QiSqYokcF9AoeQJaI0FCTWux+eO4UWRyIEaSbRk/I8Jv6hAdK
         qVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=R+bxR1iO1INjJTECC44BojSTyAGcoISsrqfX710a6xA=;
        b=2UG2nqzgqs/7htLSZMp7NrgoNK82oq4jILZ7wuc3VPexMQeQEQ7/epB9E3F/dMbLpj
         LK96lIrnj6Q33h8i8FdF31c1ox+ox6aAcIYuDAuFukDRANlAWY40hTYKAlq7QXgc8VAK
         bNzOK73bdZrRqLOhG6uEPl+XL2TXdP7dD4JSzzSBazmVI8Mbqo9SEpP/HUiRudGq4CZ1
         qP1/G+j8+60e/ZV4n2tLgmtkY1hELuIKqf2cuqKtAiq5d1yzysiMfAvrOpaOzZ4b59tH
         CSZSlb4KFlfWPeZR8+9knpxBmGT2rSmab//h1e71D3wOgBoVcVOnTPiWSIPsEBIm/D29
         1Btw==
X-Gm-Message-State: ACrzQf3TjaozqDft6tM+CfTROpgIpJylUe9MBvTbbHj3B+cVg3NyFG2y
        hOTyYuS5cqEzLZjzMGYqeJoGYc9UWiNYWJnZ
X-Google-Smtp-Source: AMsMyM5mrbFubs80VQxTCg+ijak9J/dF7f4aDYQw6rerDo08KvGea5ZmrdImEMRZkXAoDdFq6vPeaQ==
X-Received: by 2002:a17:902:d4c1:b0:176:b795:c639 with SMTP id o1-20020a170902d4c100b00176b795c639mr24290346plg.154.1664243873883;
        Mon, 26 Sep 2022 18:57:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902e5c900b001769206a766sm79359plf.307.2022.09.26.18.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 18:57:53 -0700 (PDT)
Message-ID: <633258a1.170a0220.73936.034a@mx.google.com>
Date:   Mon, 26 Sep 2022 18:57:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-144-g0b09b5df445f9
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 188 runs,
 6 regressions (v5.15.70-144-g0b09b5df445f9)
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

stable-rc/linux-5.15.y baseline: 188 runs, 6 regressions (v5.15.70-144-g0b0=
9b5df445f9)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconfig  =
      | 1          =

imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig   =
      | 1          =

panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

panda            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.70-144-g0b09b5df445f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.70-144-g0b09b5df445f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0b09b5df445f9effa9457d604de74e4c3b6606e9 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6332281ea957afa352ec4ead

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332281ea957afa352ec4=
eae
        failing since 137 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6332263edc1d8873c6ec4ef0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ul=
p-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ul=
p-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332263edc1d8873c6ec4=
ef1
        new failure (last pass: v5.15.70) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/633227b7d9616032b3ec4ef8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633227b7d9616032b3ec4=
ef9
        new failure (last pass: v5.15.70) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63322760b56c0491afec4eb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63322760b56c0491afec4=
eb6
        failing since 42 days (last pass: v5.15.59, first fail: v5.15.60-78=
0-ge0aee0aca52e6) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/633229b857629f404bec4f2e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633229b857629f404bec4=
f2f
        failing since 34 days (last pass: v5.15.60-779-g8c2db2eab58f3, firs=
t fail: v5.15.62-245-g1450c8b12181) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63322bfe3a4fe6abfaec4ec3

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
0-144-g0b09b5df445f9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63322bfe3a4fe6abfaec4ee9
        failing since 203 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-09-26T22:47:20.190443  /lava-7412947/1/../bin/lava-test-case   =

 =20
