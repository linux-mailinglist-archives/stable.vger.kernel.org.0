Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691F05962BB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 20:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbiHPSzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 14:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiHPSzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 14:55:41 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FE47C181
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 11:55:40 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id p125so10103768pfp.2
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 11:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=g+3LPxkMQdFhMWFB3zYDfLmy0BGoY7t69vd62NasQho=;
        b=HIldckjzMkUY6T+fGf37h8WEWGIe/X/zcL3RmT11Xovv69viXaJsqM3A5ROrcxCdoK
         UnlJQs9Rde1KLvWgkxF/XBXj0CViRXLcP65yESrSm3Hd+nUmMm7Z8dSVD7h0r/bT5EzU
         NQBYgXIRw/iFgm1BPZXvo6HuSC5jpHqA1SWc3xAEb8NdU+VpClYmOJFEyuHyQ5cizp1E
         B3lJbtN1EPwWJ5xtTz+Pt7iN8KhaR9IE2aq6p+nVHlfSj54rHkzQULeevrSj+tcFJbFc
         K5OcUETwIPJz1OCE0gz2MPtaD98J+XbG/8y9tNfdo5E19tSyAkzhBpqjMWHNRxLtnDiu
         WA1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=g+3LPxkMQdFhMWFB3zYDfLmy0BGoY7t69vd62NasQho=;
        b=i63chailVZ5O+MZ64cH2ghfEIA1arvV9DlCtPZhM6uzN1p2E+Spu62hs3I3m5g9tr0
         XjzR9IIbFDcI0DSmJ3UHPCd5dkndUs2LT2TOdLI4XAAZ7awvfMCQOCNiAKCdwZ64Uvta
         wz71Y0M6l5Ppkmknf8c68TF5ZF4QCp9r+EjNCNtzt/DT7zhTv7QMVPWd/3bzMjqSnvgd
         mYlR1LgGe4X8rlGAgv5pYuBRmxwIOLrgPxVweqgJjksvr4oa9pzlzi2CiGm+uSl4+DMG
         WOaVloDY+osNQMmzteUw5j9KVwRN3EaulI/eIaOIM3g1GNOGte2qNSlu/pKVOZPuUo7k
         U92Q==
X-Gm-Message-State: ACgBeo3kxc+hgj9L7pD7KZSnGdaVPMV5/yKVCDpiwwW0XEfOQT8Gtkil
        tRAnAnXa05V1axcSk40sAvmpuqHOyuiGJa96
X-Google-Smtp-Source: AA6agR7qlvp6ks2GYTiBNJ+rFN9KVB9pMxPJUajWPQ6oWOSextVba5ZsSMVSuRlxQoCU+JAaMCLIuA==
X-Received: by 2002:a05:6a00:1588:b0:52f:a5bb:b992 with SMTP id u8-20020a056a00158800b0052fa5bbb992mr21809772pfk.38.1660676140081;
        Tue, 16 Aug 2022 11:55:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090a2a8900b001f239783e3dsm6645503pjd.34.2022.08.16.11.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:55:39 -0700 (PDT)
Message-ID: <62fbe82b.170a0220.8bd08.af93@mx.google.com>
Date:   Tue, 16 Aug 2022 11:55:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-779-g8c2db2eab58f3
Subject: stable-rc/linux-5.15.y baseline: 146 runs,
 5 regressions (v5.15.60-779-g8c2db2eab58f3)
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

stable-rc/linux-5.15.y baseline: 146 runs, 5 regressions (v5.15.60-779-g8c2=
db2eab58f3)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
bcm2835-rpi-b-rev2  | arm   | lab-broonie   | gcc-10   | bcm2835_defconfig =
         | 1          =

beagle-xm           | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g        | 1          =

panda               | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig=
         | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.60-779-g8c2db2eab58f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.60-779-g8c2db2eab58f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c2db2eab58f308a0d28c81153b59bfa5161050d =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
bcm2835-rpi-b-rev2  | arm   | lab-broonie   | gcc-10   | bcm2835_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbb30fed4d062dea355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-779-g8c2db2eab58f3/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2=
835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-779-g8c2db2eab58f3/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2=
835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbb30fed4d062dea355=
65a
        new failure (last pass: v5.15.59) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
beagle-xm           | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbb7b742b70455b0355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-779-g8c2db2eab58f3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-779-g8c2db2eab58f3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbb7b742b70455b0355=
649
        failing since 96 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
panda               | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig=
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbb923fb552a23f3355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-779-g8c2db2eab58f3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-779-g8c2db2eab58f3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbb923fb552a23f3355=
649
        failing since 0 day (last pass: v5.15.59, first fail: v5.15.60-780-=
ge0aee0aca52e6) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbb272584c6f0cd735565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-779-g8c2db2eab58f3/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-=
salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-779-g8c2db2eab58f3/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-=
salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbb272584c6f0cd7355=
660
        new failure (last pass: v5.15.60-780-ge0aee0aca52e6) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbceb5a77156633e35564e

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-779-g8c2db2eab58f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-779-g8c2db2eab58f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62fbceb5a77156633e355670
        failing since 161 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-08-16T17:06:36.967349  <8>[   32.840877] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-08-16T17:06:37.990873  /lava-7050847/1/../bin/lava-test-case
    2022-08-16T17:06:38.001594  <8>[   33.875355] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
