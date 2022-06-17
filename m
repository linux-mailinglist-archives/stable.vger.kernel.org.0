Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E113354EE9D
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 03:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379456AbiFQBCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 21:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiFQBCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 21:02:23 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AC957B3C
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 18:02:21 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id h1so2593982plf.11
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 18:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l1oFgPQVy6mZvZDLIUapIsos3l9idp8dGoza85J+Jko=;
        b=0k2FlaLxtVbdq9uf9UxEpHC6S+emRyC2por0DucXbgCO7KbUhkLkfd/UEdLbl1GnSg
         SWylHN5BSCYN+c4MIiLXLQhlxlxZLApzSjYsa9dKn4yUZptrtksktKPhFsa/5yFCbW03
         G6SEIvoPhym9PW9ifCe0K89gxdLGR+mPcOFq8AKHldxsbLzYdu4TDO+NVtpIVNv8IaCo
         /bj7n3y2GZBVvCE2z4sum9if52S79HSOkAosf48Wo/jlrkmGkXWC95qxpZ+mPznljF3o
         0AEZoVQqeYdsZUQU4XR/RhduvIf79qDvRezPrfrMH9vAg+4LlEm3UAz8wRP7nDfnDHnY
         PG0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l1oFgPQVy6mZvZDLIUapIsos3l9idp8dGoza85J+Jko=;
        b=pIVvuWiDL+FxQ/Krmkq4unSxw21weu2HDU9TTRPe9GRT0nAlyfla3fq12EPE8pKr9U
         NttfNzuBL/pzdJVgvY+Y7acPcX80HVZ3EV9WabQB+6hIwSSRkjbwYpo5pzFRjzeEdSjM
         L2mEIViII7ahSN7iA/kEihUuiV91aivuGl3Q18nZfmpazTv3rSGG8ShrpDVSW0+E0urp
         xpaXObDXd6cFXnRAj7p05iD1BWoShNMUpHQchhwcdlzglOpZ5lMdEKcIdGAE0SiRhS2F
         AZ7IOLHn4IoIspRvYooH0m/2nyXhzatcRjQj3AEHb6WtmMK43dacHv8SxWIEAPJi2AXE
         G3MQ==
X-Gm-Message-State: AJIora8TediwHI9o3YccbCy2/VEqGUHeDK+AB/QIBti1/XszrKSwRPtX
        wjlfZsv9VVqY8ggtZ+69/W9Ji26mQnWdxpyzzog=
X-Google-Smtp-Source: AGRyM1tA/Ne/LRi9uixdgHWJpbLXGGowLdmeJIr3JCFoA1fCM4Xk/ilOaH2DruqojwmC96262NOPkQ==
X-Received: by 2002:a17:902:ef8f:b0:163:d61b:ec98 with SMTP id iz15-20020a170902ef8f00b00163d61bec98mr7149115plb.111.1655427741077;
        Thu, 16 Jun 2022 18:02:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w5-20020aa79545000000b005184fe6cc99sm2394378pfq.29.2022.06.16.18.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 18:02:20 -0700 (PDT)
Message-ID: <62abd29c.1c69fb81.ec423.35d0@mx.google.com>
Date:   Thu, 16 Jun 2022 18:02:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.48-4-g76280ca376586
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 184 runs,
 4 regressions (v5.15.48-4-g76280ca376586)
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

stable-rc/queue/5.15 baseline: 184 runs, 4 regressions (v5.15.48-4-g76280ca=
376586)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
beagle-xm               | arm   | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig        | 1          =

jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =

rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.48-4-g76280ca376586/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.48-4-g76280ca376586
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76280ca3765866f935efba130da4c7808ea8a9c3 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
beagle-xm               | arm   | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62ab9f5bb8d5cf0396a39bfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
4-g76280ca376586/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
4-g76280ca376586/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab9f5bb8d5cf0396a39=
bff
        failing since 78 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62ab9e421e6d26448aa39c2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
4-g76280ca376586/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
4-g76280ca376586/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab9e421e6d26448aa39=
c2c
        failing since 5 days (last pass: v5.15.45-667-g99a55c4a9ecc0, first=
 fail: v5.15.45-798-g69fa874c62551) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62aba0cfe8768d024aa39c4b

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
4-g76280ca376586/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
4-g76280ca376586/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62aba0cfe8768d024aa39c71
        failing since 101 days (last pass: v5.15.26-42-gc89c0807b943, first=
 fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-16T21:29:41.637712  /lava-6633139/1/../bin/lava-test-case   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/62aba0a4e8768d024aa39c28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
4-g76280ca376586/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
4-g76280ca376586/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62aba0a4e8768d024aa39=
c29
        new failure (last pass: v5.15.45-915-gfe83bcae3c626) =

 =20
