Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72980576480
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 17:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiGOPgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 11:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbiGOPgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 11:36:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD1255091
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 08:36:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so11860234pjo.3
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 08:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GH0cZokFFoeU5C1I+z+KSqjMFKveOmAd6lAgxbXe6Dw=;
        b=z8oBJLIYpj/dm8m+RB+15SHNO8r4QzBeEzGmXImmlbZj08WIql7zaodN8bSOcA88ZA
         GScj7nue4Ro+zCiI7hSAYoF+woNQzXtAFaioBDgHUxoizdZ11TurfGtqMxLEeI1CoNbb
         OEYA+VhVIszEsEzRrV0vNGOu2ykAgU8ZO2CaCS9/pxkKdz9dNnbGQ0ZEXtKSfh3nnSRB
         +D3GleBAXcyAu4i1eAOlRrmljFwBsRO9Scf06w0ffMDvOEgBNDQvPpMrsh/7nxt9nWl4
         vo90YfvbhpPyu198rMx1IhsBiRF33NgtXljVQCHqVKGek1wESl5UojA6juHsUm6WBHSA
         Xbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GH0cZokFFoeU5C1I+z+KSqjMFKveOmAd6lAgxbXe6Dw=;
        b=QGh/QwjmMn8UWoS6o10Dqz8KfDLRWAESfmRePOSDGsSHpJwkod4OnCNJMucPpEp/OA
         2c9VVcUXDdLOdo6MI5BGKnFV4GlJVjHkHPlLLwCZfpKVwCzVxZMLIMH6sk1KPMJad4/D
         ZDE57n393SyLmPYfFeCMqrF2wsxkV9dmAvziyGFTuoaKLvzhonBnoishQRmyqiMlyTc/
         oMoYKfqDgEvoW6ZEVS3UeKPzqhacqMCtfJhHu1m6q3OWdbnTtR/KADXCjOGLmR+ppU6q
         JvKJuhQIk/BHgtuq66zLshWYCex+X+r423R0Sex/tv+VNPAT6E+BWWMFeU49yjLrXw3d
         ICng==
X-Gm-Message-State: AJIora9K9lBrfKX/cf1KxTAnXVKUNQpJSGlBWI0DFI1FLT90j6ObMqP8
        ZDxcHCnfVh50Fb+hR3bba0LQzyXoYNnvtLY4
X-Google-Smtp-Source: AGRyM1sHutNC9UJ3ZPhSORKHrHpbT0YLZm5W/cnvqrrLpzsZesZJhTK3gVteviatEQJ62N3zbPZQ+A==
X-Received: by 2002:a17:90b:4b0e:b0:1f0:2e9:28f8 with SMTP id lx14-20020a17090b4b0e00b001f002e928f8mr16453547pjb.43.1657899369634;
        Fri, 15 Jul 2022 08:36:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r16-20020a63fc50000000b0041245ccb6b1sm3308776pgk.62.2022.07.15.08.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 08:36:09 -0700 (PDT)
Message-ID: <62d18969.1c69fb81.caf72.506a@mx.google.com>
Date:   Fri, 15 Jul 2022 08:36:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.12
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 137 runs, 3 regressions (v5.18.12)
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

stable-rc/linux-5.18.y baseline: 137 runs, 3 regressions (v5.18.12)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =

jetson-tk1         | arm   | lab-baylibre    | gcc-10   | tegra_defconfig  =
   | 1          =

kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.12/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2e9702659dfc309dfda6116da48f200fe425aab =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/62d1549f254cdb8373a39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbi=
t.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbi=
t.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d1549f254cdb8373a39=
bd2
        failing since 14 days (last pass: v5.18.8, first fail: v5.18.8-7-g2=
c9a64b3a872) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
jetson-tk1         | arm   | lab-baylibre    | gcc-10   | tegra_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/62d155238805516703a39bfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d155238805516703a39=
bfb
        failing since 31 days (last pass: v5.18.2-880-g09bf95a7c28a7, first=
 fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/62d15878b91ab9809da39bd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d15878b91ab9809da39=
bd7
        new failure (last pass: v5.18.11-62-g18f94637a014) =

 =20
