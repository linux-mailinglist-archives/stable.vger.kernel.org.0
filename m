Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A715538A2
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 19:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbiFURPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 13:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236051AbiFURPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 13:15:00 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C7928E3B
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 10:14:59 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id bo5so13673990pfb.4
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 10:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vSljOKwhUNnfnMAd8kJk2/aNYC4a6VvrQQ+zO/3o8pg=;
        b=bClcj5AJYTlT8BoiYgixqzQktLoWSaKxmSHBLCJhKm1xt0EloHfceUMIbXDGNChtds
         2h9HXdS8v0vdgSAWv0hHshOpJyp3MhSpkMYu6P/HTaxjdFNQH+hggIAl4Hve3SGm1J0q
         5MsZ+EPsoNu9jhlV6+UbfrvjybnmeZerw2aFGkQ/xvqlrqb9taK9IJ7VjngOXvZOjnW8
         l/DxAEQIfGRSoRdPXR4mxALIPjLI+OsGNrZBTZclQOFsfuO+b4LF7obAp4FvzYZo4OVX
         VzTLS1Yt9g7T9vuhfGlbIu/KOJR5cl42Oec3qFYfnlnngKJ5GIOuGu6D+ABJD6c4Dq+Q
         +TSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vSljOKwhUNnfnMAd8kJk2/aNYC4a6VvrQQ+zO/3o8pg=;
        b=Zs2Z47QiECPntfp5MI8ecuaCYasp7b8WOxzYKXdYWVOcSvKGDJhB7Xf0INS0zfF1nh
         b6m7v/eXVPWL+qCMDLpR3Yd4ZRF22wGin0DyNhxDybgitA/HeJXiufO4oZuL1adhrA39
         bOAVAqWW98Eycqvpcf2T4oS/Sc+H/USRtRDU4k+sO8yWUakFKS7tVyFDZ08DvbrF1jTK
         tc88aJX9FUEzjEvZuovFv5FbxrXDm6xfRPzJi3LT3RtEarwBfrr7aYZfLa6estSTwc73
         UrZiZa3rGAhBflCUoIQEekjAw3Gnzc30Xmff5/y3rRJNLWmAy3/8xQoFhqvzIMHn0BFe
         mzBQ==
X-Gm-Message-State: AJIora+BTw08e9klGH6+g+B2Lfs9JkywaCnHRSK5ij0YLQ+1tdN0RGIk
        PusFA9EKUSxuNeNezFi/Pbdsk4furjBneSE8Auw=
X-Google-Smtp-Source: AGRyM1u+cWOyIaK0fz3nXN/jo1eT0iwCT81Bp0O25/2OJwOxQXCrNUxjfnefgaL6PHWdhwUCiDtlyA==
X-Received: by 2002:a05:6a00:194d:b0:51b:eb84:49b1 with SMTP id s13-20020a056a00194d00b0051beb8449b1mr30732323pfk.77.1655831698764;
        Tue, 21 Jun 2022 10:14:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k198-20020a636fcf000000b003fd1111d73csm11326376pgc.4.2022.06.21.10.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 10:14:58 -0700 (PDT)
Message-ID: <62b1fc92.1c69fb81.a9029.02c4@mx.google.com>
Date:   Tue, 21 Jun 2022 10:14:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.48-105-g42c16662078af
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 195 runs,
 4 regressions (v5.15.48-105-g42c16662078af)
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

stable-rc/queue/5.15 baseline: 195 runs, 4 regressions (v5.15.48-105-g42c16=
662078af)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.48-105-g42c16662078af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.48-105-g42c16662078af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42c16662078af064fb9ff1cde1a55ef38dae49c8 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b1c6fef9b23c8c0aa39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g42c16662078af/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g42c16662078af/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b1c6fef9b23c8c0aa39=
be5
        failing since 82 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b1dc0b26da848855a39bd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g42c16662078af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g42c16662078af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b1dc0b26da848855a39=
bd9
        failing since 10 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b1da3c6ee76bb867a39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g42c16662078af/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g42c16662078af/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b1da3c6ee76bb867a39=
bd3
        failing since 8 days (last pass: v5.15.45-833-g04983d84c84ee, first=
 fail: v5.15.45-880-g694575c32c9b2) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b1c537ca9384c7faa39bcd

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g42c16662078af/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
105-g42c16662078af/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62b1c537ca9384c7faa39bef
        failing since 105 days (last pass: v5.15.26-42-gc89c0807b943, first=
 fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-21T13:18:33.417855  /lava-6660433/1/../bin/lava-test-case
    2022-06-21T13:18:33.428762  <8>[   60.925271] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
