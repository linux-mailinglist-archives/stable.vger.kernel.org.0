Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF7B57A510
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 19:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbiGSRU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 13:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbiGSRUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 13:20:54 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF1DC0A
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 10:20:53 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 70so14192787pfx.1
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 10:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ymrc4UcSzhRrck5s8YL9ZKZapD4EsafFCuY17ROrlgc=;
        b=jkqw/kGh3EjqYxoqXSrExTyVuplxl9crMwMDfMP809NuNjLvpZ++tb9By8wtq4077n
         Nrq3yQu7aQqM2gwXPYP1Ul9OkPwtTRDTNYbaoQLUWjZ2juPYDDfpkynqdQgf7jONSTqr
         lWyg9d7ALi8q7AoFA9iNkgsCT0LjMgoOHTXQBxm+uFM/V2cqoFbcPOurrBOMSixYz0GL
         JOM9/n5T06y2Zk4ZCBbjvvs0XtFaGGbGQ9GkgJvcV0+OJlHuROO9qnWumE/LE7+L7l3I
         fjx4C5+KhIEBBwv0zV3XZzubILOLn0zBqf2idW88zCs36FhsABlZV17JQK/UM68ezAlv
         FPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ymrc4UcSzhRrck5s8YL9ZKZapD4EsafFCuY17ROrlgc=;
        b=WsuomKYZTeYgF9CZyeQmTWHSPYCUIZWEZ1cIKtSupF3MjtenJAOWnTu4HQoft8nr0g
         QR0cTOgn4KxHLq5sV/hY/Fx0yqwixPelZOvlAH5FaiBxX2ca/rpJIvBIuDz9FMOlCv9h
         8pq+39gEaBEOqoL/hYAx0ktWi8KGdx7l5098QEHaNhnp+UJX30luQF6edUar26fZObOo
         PG4ABkVmXAbdkJX2KyNbcw70F/zLZradAYsM9BgXwXNfpMqD14BdsbkGbhBiNAnmDpQ1
         y8hfnf9MkVvpmMWCFiBdRI316ZJKMsV2DWoL56ZqITZniW0FFLOnsJJw/7zRD3oYMvQU
         8iNA==
X-Gm-Message-State: AJIora80ghwZmowTtbpE2f/Z++cbZGEH5RmH+/Pmra/hUiVoxUzWnFcH
        TYub2Tdu1GGUmACqyAJ969XFICgyw8Mp8JUl
X-Google-Smtp-Source: AGRyM1vArKJluvT4yq4QV8iAaNT5jeBQrMalLmGOgxA/rBvaOgbQruG9FQhRaN2+8WnFNRLjJJ2drg==
X-Received: by 2002:a62:442:0:b0:528:641c:cfde with SMTP id 63-20020a620442000000b00528641ccfdemr34772250pfe.14.1658251252470;
        Tue, 19 Jul 2022 10:20:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x5-20020a1709029a4500b0016bf185d234sm11932317plv.2.2022.07.19.10.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 10:20:51 -0700 (PDT)
Message-ID: <62d6e7f3.1c69fb81.c7ea1.20bb@mx.google.com>
Date:   Tue, 19 Jul 2022 10:20:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.55-168-g91c6070d5ced
Subject: stable-rc/linux-5.15.y baseline: 171 runs,
 3 regressions (v5.15.55-168-g91c6070d5ced)
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

stable-rc/linux-5.15.y baseline: 171 runs, 3 regressions (v5.15.55-168-g91c=
6070d5ced)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
beagle-xm          | arm   | lab-baylibre    | gcc-10   | omap2plus_defconf=
ig | 1          =

imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =

meson-gxbb-p200    | arm64 | lab-baylibre    | gcc-10   | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.55-168-g91c6070d5ced/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.55-168-g91c6070d5ced
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91c6070d5cedab812864b5440077d94efc003953 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
beagle-xm          | arm   | lab-baylibre    | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6abf13eb8078894daf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5-168-g91c6070d5ced/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5-168-g91c6070d5ced/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6abf13eb8078894daf=
063
        failing since 67 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6afd0051e4ec727daf0f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5-168-g91c6070d5ced/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5-168-g91c6070d5ced/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6afd0051e4ec727daf=
0f7
        new failure (last pass: v5.15.55-168-g9cec26c76053) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
meson-gxbb-p200    | arm64 | lab-baylibre    | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6b2438ff95f249fdaf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5-168-g91c6070d5ced/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5-168-g91c6070d5ced/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6b2438ff95f249fdaf=
065
        new failure (last pass: v5.15.55) =

 =20
