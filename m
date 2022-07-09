Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7082556C58F
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 03:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiGIBDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 21:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIBDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 21:03:36 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8A9BCBF
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 18:03:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so3474658pjr.4
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 18:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Or75XUil2+dVhY/QRgzKzA4aiXdIxofU2X94945sV3k=;
        b=jnagDHxZk79hpbK+YmLFipildGGfSnmbP5rJ17FvnqAqXkzjMBBTZOI+e5147OD500
         XWnHT+HgAJZxZwhnjUszFKcwGbHNv+/70GzOeoJTtPeqvucGo8+imEgbUI+wH/UHByHa
         2T5LKbDmNQv5wc8wLH+UI3OiSR4mFrmM0Enj0cGIzZGzh07qSVITw7JFENTmxnJz3Qnq
         sEFWIrcxmUbVI4DLTdphHbzcDL/BQEMHDkC4LPKuWmXVvism3mU735oqV4m7fvME5Cjw
         qEUDl215YS10WJA3maU2NTRBVq3hnojzvOPUcDAi/LTcGZSdM3jwgl4vkDNLp9N/ZyJX
         5ETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Or75XUil2+dVhY/QRgzKzA4aiXdIxofU2X94945sV3k=;
        b=a4SH1vzDeh4NcJ27RHDiwVYpy05By6ZjBzjvBihab8yrk4+sZBTWqkJ0+7G2Y9HaZL
         /OURRGuySPIeBZAKO0cBttYsoszEn6aceXRxVaWa4/sjxNLKXFAmSAR5D/OoX5yHlzkI
         y7Qt+m4zpxKxawyFabytjjuw4PbG93VTzowqI2512bJhCiqJlqIGr9h/JlBdCW/VeIxL
         zXKHC1uV+KoNFJEGUjvF+OqD27gUBol02c0BuPimgMck+H/RFPHgpFsIR16JMLr+dKNA
         sQlXXgTmtS0z7L2XPy5MI2zTwaoTGDXPJZCT9Fe3BNk/6MOnpkUrHOUBkf3tUL8UPCye
         FUdw==
X-Gm-Message-State: AJIora+CuPzpKqcD9voQd0mK49+x9pVF9FyAyYlsxrlLuM6P68qPZ9NB
        D4I63UFqH/66KUmARc6Jpctgknpwy455GPoK
X-Google-Smtp-Source: AGRyM1srKtBpyS6xdy44XM/gQlUYytdW23b1Qe8PeWVm9QPRiHu+GMDBA39smwSJWzMTZvlpBRlt3g==
X-Received: by 2002:a17:902:8543:b0:16b:fbd1:9f68 with SMTP id d3-20020a170902854300b0016bfbd19f68mr6661468plo.101.1657328614130;
        Fri, 08 Jul 2022 18:03:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3-20020a627903000000b00528999fba99sm198695pfc.175.2022.07.08.18.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 18:03:32 -0700 (PDT)
Message-ID: <62c8d3e4.1c69fb81.5ad10.07ea@mx.google.com>
Date:   Fri, 08 Jul 2022 18:03:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.10
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 139 runs, 4 regressions (v5.18.10)
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

stable-rc/linux-5.18.y baseline: 139 runs, 4 regressions (v5.18.10)

Regressions Summary
-------------------

platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit  | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defcon=
fig | 1          =

jetson-tk1          | arm   | lab-baylibre    | gcc-10   | multi_v7_defconf=
ig  | 1          =

jetson-tk1          | arm   | lab-baylibre    | gcc-10   | tegra_defconfig =
    | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre    | gcc-10   | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.10/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc560cecaa8b2517932808fa939e36371ffa036e =



Test Regressions
---------------- =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit  | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c89b2d5fca2114cda39c00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
0/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbi=
t.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
0/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbi=
t.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c89b2d5fca2114cda39=
c01
        failing since 7 days (last pass: v5.18.8, first fail: v5.18.8-7-g2c=
9a64b3a872) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
jetson-tk1          | arm   | lab-baylibre    | gcc-10   | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62c89dc63347195c3ba39beb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c89dc63347195c3ba39=
bec
        failing since 9 days (last pass: v5.18.5-154-g1fbbb68b1ca9, first f=
ail: v5.18.8) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
jetson-tk1          | arm   | lab-baylibre    | gcc-10   | tegra_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c89b1e5fca2114cda39bf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
0/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
0/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c89b1e5fca2114cda39=
bf5
        failing since 25 days (last pass: v5.18.2-880-g09bf95a7c28a7, first=
 fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
r8a77950-salvator-x | arm64 | lab-baylibre    | gcc-10   | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c89f863b00de5792a39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c89f863b00de5792a39=
be3
        new failure (last pass: v5.18.9-103-g7622cfa48fbd) =

 =20
