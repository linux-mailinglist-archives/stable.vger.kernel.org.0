Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD70D5970C1
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 16:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240114AbiHQORR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 10:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240124AbiHQORG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 10:17:06 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D4D6052F
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 07:17:05 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c2so3757744plo.3
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 07:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=I1dZWBsfwb4J964aU8oXud6kYeJkDyj2y4LKlBAL3gc=;
        b=HMx+dcV3ecuqBWJMb/h4Mfo2va7VFd3/CJOZZrYwpy//uybKNBt4c9jyvdgmdM0Wf1
         rVmgWOJD94RqFH2Iei24RXLcCalVR8RSjFzDIJXqwV417Ddk1E+DTs0rjPtiszd5Fl4k
         Ja11RfqInv0ebkBIan9uUOCiCb1qS9dVI0Zx3kQUoXPmpMldczbo5Bm/Lkg5Jv6XS0z/
         cX+jg+Tk2Jr2mijuBOQQKp+t9qQ/fGFtU6qi0yCtz48WLfXcNWm82e3FmRQkM/S51aWa
         l3A7OJ7GYsw1xTlvwWSzO2oHEtAJawX8yEw+MHaUzR23f6bFW7hwG9ElvbukL96Bmi6+
         pGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=I1dZWBsfwb4J964aU8oXud6kYeJkDyj2y4LKlBAL3gc=;
        b=0z3hxjP7JbY7WorTPwDeDETqaMYhhLqZPSVxusyXUZGOcFp6I6supkXMvlCBFcYHO5
         8ugEkCQuyL4TUIJk3uNwvmiVSL2ucMG6Mq9p5aLUSphclewH2ixli2mjZFisLXEYJ6Hd
         wis2zKs5PSrDeMJO/yt/Qm/F3QLXsO8Mi8iN8oYXxSwDynXyrW78buXCwSw5czTMF2Yx
         kdIfq2XakyC2V2KgRjTlnqQ8y5PUSteajwC8gWl4MFw2yOnCRuaJq9QoE0pKg4yHeBL5
         EiVJE6kpCyajLDVPq5xoPiWWCwgtLpgYDjsnkxH2kY3PF7JnduTtVfniRKXohpSijHr6
         Jz1w==
X-Gm-Message-State: ACgBeo2IxB6BhbcPt1rdCDTne+B6CTg45KeXqvBuIw4nBOxU0D99Dn0C
        icAx3ffI4WacP8GDpd1steoPF6xyUP+pUcn3
X-Google-Smtp-Source: AA6agR46F1mYffPE+w1vZgrAfSxrRt8I8w5QMqCTKFPYKL6sI49o2YjKjwz2yqZV46GL8xjs8qCnNQ==
X-Received: by 2002:a17:902:ab8d:b0:172:9382:4d1e with SMTP id f13-20020a170902ab8d00b0017293824d1emr4966904plr.133.1660745824620;
        Wed, 17 Aug 2022 07:17:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902780a00b0016d10267927sm1532569pll.203.2022.08.17.07.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:17:04 -0700 (PDT)
Message-ID: <62fcf860.170a0220.59259.2719@mx.google.com>
Date:   Wed, 17 Aug 2022 07:17:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.17-1094-g8723c2af542ca
Subject: stable-rc/queue/5.18 baseline: 151 runs,
 4 regressions (v5.18.17-1094-g8723c2af542ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 151 runs, 4 regressions (v5.18.17-1094-g8723=
c2af542ca)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
bcm2835-rpi-b-rev2 | arm   | lab-broonie     | gcc-10   | bcm2835_defconfig=
  | 1          =

imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =

kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
  | 1          =

panda              | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.17-1094-g8723c2af542ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.17-1094-g8723c2af542ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8723c2af542ca0bd8e818af0b665c533103f1379 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
bcm2835-rpi-b-rev2 | arm   | lab-broonie     | gcc-10   | bcm2835_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcc2f394086697af355651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g8723c2af542ca/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm28=
35-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g8723c2af542ca/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm28=
35-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcc2f394086697af355=
652
        failing since 0 day (last pass: v5.18.16-7-g7fc5e6c7e4db1, first fa=
il: v5.18.17-1094-g906dae830019d) =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcc69ad7da836c71355652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g8723c2af542ca/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g8723c2af542ca/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcc69ad7da836c71355=
653
        failing since 42 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcc71c5653340b9035564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g8723c2af542ca/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pit=
x-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g8723c2af542ca/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pit=
x-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcc71c5653340b90355=
64e
        new failure (last pass: v5.18.17-1093-gaca547a6744f3) =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
panda              | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcc91dce3ecc4ff4355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g8723c2af542ca/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g8723c2af542ca/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcc91dce3ecc4ff4355=
659
        failing since 1 day (last pass: v5.18.17-134-g620d3eac5bbd1, first =
fail: v5.18.17-1078-g5c55e4c4afa02) =

 =20
