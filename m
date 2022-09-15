Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09105B9FDC
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 18:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIOQqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 12:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiIOQqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 12:46:31 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018AC74374
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 09:46:30 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y127so18629156pfy.5
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 09:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=bjT/5lKxPKNfrQngSH77+A/cT/WdlRZ/Tl4idZ6re1g=;
        b=wFOfifs/HdH1hq5aX6ObinsIPwArcq4W5hxPRsSICRMVadrAQzlDLsIwnO5j3iaHdC
         0Opd2IHRtH4DuvRBt3DYDiM6nfy5wGsE3emq4F3a2v37rmjPLHcxWc3myXwcH6XOZ1dA
         0KeFR6wBJ0GyYfkSYCKoIkFfpcLDVJEOQS+dJK9BQqLhkZ5oD2Rn+dBTKu2mahSrvUJ4
         VD0uwFRA+aRpff1SqgN77rhN++PKp1ccN0z35G7FgEEhdNCWUk70JTIx62neL1fdi97z
         aP7vChBYhxZsuQGgC8OvF6CBJiCIg6diQYp8WEq/ou/+PFWmwG+8AHBGGuhGShzghR5Y
         0/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=bjT/5lKxPKNfrQngSH77+A/cT/WdlRZ/Tl4idZ6re1g=;
        b=Zoo5b6HMz0+QxoynNLsTHQgCJa5rIL0zGiiw3CcpkC+G0RU1YqoIL4rRhvEiIgNWIi
         k4J7h55RtbXD4kC1XOxL2+mdaNbH54CrZ/udrwXqO1uqtJ+p8Am7vbt3yJrpSpYYHe8r
         txTl72RaRfxTh9knGfNfbDyMxIkIqGtA9yi7yHI4PuESFs4X1AU4/oBgaMqLAb1qoSzm
         sJaat5aNt84QTmuxWp2rSLz8hAkrvAE27mCwdKFgBp5ZhMWOJSggh1/eT3ekvTY2H/Io
         JJrJsnN+UVfvIkeQjfAaEmKIyLNtKoIqXjvITOEcl5OemYn/hK9+fHb3Sddp5sRky/DP
         CLCQ==
X-Gm-Message-State: ACrzQf3azXQyR/Der4KUXeDco+Mz66cyIbgTBLZxGGdfMQBC44j8DxHT
        uyfG3R2CHOsbAQvFxfPtaqfQN3Xm/QWQ77HU7L4=
X-Google-Smtp-Source: AMsMyM52g5DM/JCU6kBlX5ziHceIcKdo/h3uo8iTfAdYt8vP2rRufA17fn2uqOJ6T6F1ncTmA9SXHQ==
X-Received: by 2002:a05:6a00:e8f:b0:536:c98e:8307 with SMTP id bo15-20020a056a000e8f00b00536c98e8307mr322629pfb.73.1663260389299;
        Thu, 15 Sep 2022 09:46:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x12-20020a17090a46cc00b001fd9c63e56bsm1840490pjg.32.2022.09.15.09.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 09:46:28 -0700 (PDT)
Message-ID: <632356e4.170a0220.8cee7.3283@mx.google.com>
Date:   Thu, 15 Sep 2022 09:46:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.9
Subject: stable-rc/linux-5.19.y baseline: 199 runs, 5 regressions (v5.19.9)
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

stable-rc/linux-5.19.y baseline: 199 runs, 5 regressions (v5.19.9)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
at91sam9g20ek        | arm   | lab-broonie   | gcc-10   | at91_dt_defconfig=
          | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

imx8mn-ddr4-evk      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

imx8mn-ddr4-evk      | arm64 | lab-nxp       | gcc-10   | defconfig        =
          | 1          =

mt8173-elm-hana      | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1105a680e66b0482bd18048534c58ecabb5c284 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
at91sam9g20ek        | arm   | lab-broonie   | gcc-10   | at91_dt_defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6323223067f3959c02355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6323223067f3959c02355=
646
        new failure (last pass: v5.19.8-193-g5cd198d0e2b18) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/632323d91d5fcd1540355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632323d91d5fcd1540355=
649
        failing since 2 days (last pass: v5.19.8, first fail: v5.19.8-193-g=
3acd07a8c4dd8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
imx8mn-ddr4-evk      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/632329216aa3db3e94355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632329216aa3db3e94355=
647
        failing since 1 day (last pass: v5.19.8-193-g3acd07a8c4dd8, first f=
ail: v5.19.8-193-g5cd198d0e2b18) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
imx8mn-ddr4-evk      | arm64 | lab-nxp       | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/632327d1720e9b364235565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632327d1720e9b3642355=
65d
        failing since 1 day (last pass: v5.19.8-193-g3acd07a8c4dd8, first f=
ail: v5.19.8-193-g5cd198d0e2b18) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
mt8173-elm-hana      | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632324cb5e20f06a02355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8173-elm-=
hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8173-elm-=
hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632324cb5e20f06a02355=
658
        failing since 1 day (last pass: v5.19.8-193-g3acd07a8c4dd8, first f=
ail: v5.19.8-193-g5cd198d0e2b18) =

 =20
