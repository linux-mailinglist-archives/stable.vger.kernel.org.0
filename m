Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2815B7B96
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 21:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiIMTwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 15:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiIMTw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 15:52:29 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B786BCFC
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 12:52:28 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 207so3892176pgc.7
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 12:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=TXP+fon6fkKBSnMWBFKJjOn7RsVTjyB0bzrQyFhopVI=;
        b=bb1XCdTt9bw9gIJXAa4Qc0Agkhej0vobhnxmKOqYqTeEHvUbWCCcZ1wrPDz79cCAQA
         VORxyUkdA1p4RPRTOtZ8Z8aLP2cyEkQVAf9nVqfnChFBFKeYhQ0crstcv7O1lKA2zBee
         Hb+r1twZPjnfcPDSlJrLuuUIPEfQP8ouZ3jcTK2CYGHHCHPuPy4pCtOQ2ZHFLoxHR1bW
         R5810+jp2caH3wVu275oVT8CKYStNuL/fwEwZxAhG/gqQrHY42XAFUW/MncGq7Zwa4P8
         fKYmEddCEq6Mfci0XjLlRlEoZxpsrZXLI67gIZkNNDcBySMJe+KMOxb8aQtr0upCt0/b
         dx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=TXP+fon6fkKBSnMWBFKJjOn7RsVTjyB0bzrQyFhopVI=;
        b=mGRQoE5AAVFgI2UkD/657bRU5wQ4CtVdoagNzsYzefciCivEbItYyMHjuwru/XoP2z
         x2GPROQxQlNFXF2ez2zL8iWyC/kMpQ8g+hDP6m+SVMCEaDIokTbFEJ4+TY+lB2XlgdPG
         sGcMonpQngKXIKtYZOUaYrs4nziJWW4xeL8uIRvGn5sccmrfeEQbOz7YDM3bnA2E/OeP
         hLYipBqzEINhwOANeL4M316mbxMtI93jyrAi7xO8DGlzQZpTQ74jk3eacGTnwqVJrhJJ
         e8Eqwg5OxbE1fidVlXvCjx/6alEa2gUNeJzm8seN1d10hSaZsO86SR+ImbD4UgVjPTzE
         dzlw==
X-Gm-Message-State: ACgBeo1cC/mcGcHHThmCy22udZ2P4r3JCSyrYzegF1VIRJuzw4WPO7P7
        Iv5uKeyA4Ial77mOJq9mgcZQP8+qBWEEsw8cIBE=
X-Google-Smtp-Source: AA6agR7V/HS5iPyw7IL7jOgnjILdFhrSFjlQDh5PmX2ivvsWj8F9RJPYO77Anq0ONENIOpMwWg4ZXA==
X-Received: by 2002:aa7:9d9a:0:b0:53e:8bc5:afb7 with SMTP id f26-20020aa79d9a000000b0053e8bc5afb7mr31597382pfq.54.1663098747637;
        Tue, 13 Sep 2022 12:52:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p67-20020a625b46000000b00540d03f3792sm8257949pfb.81.2022.09.13.12.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 12:52:27 -0700 (PDT)
Message-ID: <6320df7b.620a0220.90a97.e135@mx.google.com>
Date:   Tue, 13 Sep 2022 12:52:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.8-192-g612c301cd75f
Subject: stable-rc/queue/5.19 baseline: 114 runs,
 4 regressions (v5.19.8-192-g612c301cd75f)
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

stable-rc/queue/5.19 baseline: 114 runs, 4 regressions (v5.19.8-192-g612c30=
1cd75f)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =

imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =

imx7d-sdb            | arm   | lab-nxp         | gcc-10   | imx_v6_v7_defco=
nfig | 1          =

kontron-pitx-imx8m   | arm64 | lab-kontron     | gcc-10   | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.8-192-g612c301cd75f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.8-192-g612c301cd75f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      612c301cd75fbf51605aa6fc459e6da43dd3355c =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6320ab3b8dc3b026b8355669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
92-g612c301cd75f/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
92-g612c301cd75f/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320ab3b8dc3b026b8355=
66a
        failing since 1 day (last pass: v5.19.8-181-gaa55d426b3c1, first fa=
il: v5.19.8-186-g25c29f8a1cae5) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6320c2d48c1f5c5d10355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
92-g612c301cd75f/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
92-g612c301cd75f/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320c2d48c1f5c5d10355=
664
        failing since 27 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx7d-sdb            | arm   | lab-nxp         | gcc-10   | imx_v6_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6320adff7f2c0e58b7355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
92-g612c301cd75f/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
92-g612c301cd75f/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320adff7f2c0e58b7355=
657
        failing since 1 day (last pass: v5.19.4-389-gf2d8facb7bd4, first fa=
il: v5.19.8-186-g25c29f8a1cae5) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
kontron-pitx-imx8m   | arm64 | lab-kontron     | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6320ab6f5c600a82e135564b

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
92-g612c301cd75f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
92-g612c301cd75f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/632=
0ab6f5c600a82e1355662
        new failure (last pass: v5.19.8-190-g006ae7d3df80a)

    2022-09-13T16:10:00.894403  /lava-167199/1/../bin/lava-test-case
    2022-09-13T16:10:00.894795  <8>[   22.811529] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-09-13T16:10:00.895049  /lava-167199/1/../bin/lava-test-case
    2022-09-13T16:10:00.895277  <8>[   22.831287] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>   =

 =20
