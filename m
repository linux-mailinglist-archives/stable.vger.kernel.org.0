Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8EB591D74
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 03:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiHNBip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 21:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiHNBio (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 21:38:44 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A0931DCD
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 18:38:41 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso4031867pjd.3
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 18:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=ymJhO/QrY1rD8wjtqL7dOC9HXAuiJfLjAdiATwjh8MM=;
        b=tXXp8ZJUcWW9L98Rx0HNrYG1df9ZJP570mvN5vU7qL9CF0ome3W6bjEuAqvyIf84NE
         Kt1cN1qfekGMwQBLZ2cLKbiu6bBReW09/eWbXW4hHMgvjp5GtWiY1ux4mAn9y2O5j1bb
         N+ba4j1n7TymrPGVK3Pb/2k9iv0vFGANMFmBqBfui4mXRsRoJuAZUMl/wSuG0Hkdo3gi
         ABbNbOmp8HX29a1HF4nE0UAfSjh6fOG0DD9Rst1MD6BP3v7t71rrzmiQ7tVxBL2AN3xZ
         i656Embzb+CpV32JAfxNIEHfppFMOF7AvyMHjKRxMgg+0mNGmhDcc8c4DNHgy4xY9k8X
         uvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=ymJhO/QrY1rD8wjtqL7dOC9HXAuiJfLjAdiATwjh8MM=;
        b=PsxjMfUE2c7kElHnKQ6/mlAeIar1y0BPO4OTzoBo2FNqAX8NPmo8gtdBrrvjvSGskS
         PcjiejUu+7xvs1RaICAeoD62Ps8m0kaF0/ygWhF6+gRqnRIf9JnVJrE045jkvfkoIf7H
         DNdyMM1OYm946iI96Xama0MEywRUldqWDjMQE+upYstRStD9AYBdgcMbj4j+wfZZjRBx
         f6UQs++rHHS6vVzqwUuLvE0reMpOIOxT4zGv0XMyQQmRI1A/QHa6QpeX609oe2J3guoQ
         2CuJDoEf6mxBdpM6Zvvb0cQJOyfkQr/aIW4hC6FGs7/UmR/etCE3NIhXAkybbsjsPqKw
         CfPg==
X-Gm-Message-State: ACgBeo346vIGLoGI9IaeFaTiGxtfBLrkC3r3yxivsqN9RHjwkQO8XUuE
        do9E4fBENpeZ7Vkwp2zlva0m39C9LMGtgh6G
X-Google-Smtp-Source: AA6agR5fcYBMR8pY6dPhFfvnGyH2QlCmUyFRKF34cPMmgLvno6zwKco3zYa5HB109IRmW6+GOJtUrw==
X-Received: by 2002:a17:90a:f016:b0:1f4:e30c:188d with SMTP id bt22-20020a17090af01600b001f4e30c188dmr21085117pjb.60.1660441120551;
        Sat, 13 Aug 2022 18:38:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902d4c500b0016d6963cb12sm4367279plg.304.2022.08.13.18.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 18:38:40 -0700 (PDT)
Message-ID: <62f85220.170a0220.f21c0.7a4f@mx.google.com>
Date:   Sat, 13 Aug 2022 18:38:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.136-453-gca8ab62d0916d
Subject: stable-rc/queue/5.10 baseline: 136 runs,
 28 regressions (v5.10.136-453-gca8ab62d0916d)
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

stable-rc/queue/5.10 baseline: 136 runs, 28 regressions (v5.10.136-453-gca8=
ab62d0916d)

Regressions Summary
-------------------

platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
at91sam9g20ek               | arm  | lab-broonie     | gcc-10   | at91_dt_d=
efconfig   | 1          =

cubietruck                  | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6q-sabrelite             | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6qp-sabresd              | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6ul-pico-hobbit          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6ul-pico-hobbit          | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig  | 1          =

imx7d-sdb                   | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =

jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | multi_v7_=
defconfig  | 1          =

jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | tegra_def=
config     | 1          =

odroid-xu3                  | arm  | lab-collabora   | gcc-10   | exynos_de=
fconfig    | 1          =

odroid-xu3                  | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =

rk3288-rock2-square         | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =

sun4i-a10-olinuxino-lime    | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun5i-a13-olinuxino-micro   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun7i-a20-cubieboard2       | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun7i-a20-cubieboard2       | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =

sun8i-a33-olinuxino         | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h2-plus-orangepi-r1   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h2-plus-orangepi-zero | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h3-orangepi-pc        | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.136-453-gca8ab62d0916d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.136-453-gca8ab62d0916d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca8ab62d0916d61415250e7a192f219cd721f2b1 =



Test Regressions
---------------- =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
at91sam9g20ek               | arm  | lab-broonie     | gcc-10   | at91_dt_d=
efconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81e13149186d997daf080

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81e13149186d997daf=
081
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
cubietruck                  | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81e30aad57b7e55daf070

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81e30aad57b7e55daf=
071
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f823c478fac6f012daf076

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f823c478fac6f012daf=
077
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81f8d3ce6857816daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81f8d3ce6857816daf=
057
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6q-sabrelite             | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8209fe6f6662411daf063

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-im=
x6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-im=
x6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8209fe6f6662411daf=
064
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6qp-sabresd              | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f82086e6f6662411daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-=
sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-=
sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f82086e6f6662411daf=
057
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8217afa7236ea19daf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-=
sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-=
sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8217afa7236ea19daf=
05b
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81fe9c2cc78b28edaf0db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81fe9c2cc78b28edaf=
0dc
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8217c0767adb508daf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8217c0767adb508daf=
05c
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81febc91c12037adaf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81febc91c12037adaf=
066
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6ul-pico-hobbit          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f823b078fac6f012daf063

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f823b078fac6f012daf=
064
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6ul-pico-hobbit          | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f820f55a2f03f57ddaf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f820f55a2f03f57ddaf=
059
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx7d-sdb                   | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8209be6f6662411daf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8209be6f6662411daf=
05c
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f821772f399ac451daf0a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f821772f399ac451daf=
0aa
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81fed90caae7dfcdaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81fed90caae7dfcdaf=
057
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81f9cc2cc78b28edaf097

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81f9cc2cc78b28edaf=
098
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | tegra_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f823d178fac6f012daf08a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f823d178fac6f012daf=
08b
        new failure (last pass: v5.10.136-25-g54da4071add59) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
odroid-xu3                  | arm  | lab-collabora   | gcc-10   | exynos_de=
fconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81f1e56a8d5505cdaf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81f1e56a8d5505cdaf=
066
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
odroid-xu3                  | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8230d37d7d935a7daf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8230d37d7d935a7daf=
063
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
rk3288-rock2-square         | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8203bb011134867daf07f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk=
3288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk=
3288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8203bb011134867daf=
080
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun4i-a10-olinuxino-lime    | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f820acd019359592daf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-=
a10-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-=
a10-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f820acd019359592daf=
074
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun5i-a13-olinuxino-micro   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81e54aad57b7e55daf0ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-=
a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-=
a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81e54aad57b7e55daf=
0ac
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun7i-a20-cubieboard2       | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81e32aad57b7e55daf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81e32aad57b7e55daf=
074
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun7i-a20-cubieboard2       | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81e32aad57b7e55daf076

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a2=
0-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a2=
0-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81e32aad57b7e55daf=
077
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-a33-olinuxino         | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81e47aad57b7e55daf0a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81e47aad57b7e55daf=
0a4
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-h2-plus-orangepi-r1   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81e4265f518d014daf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81e4265f518d014daf=
060
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-h2-plus-orangepi-zero | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81e4465f518d014daf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81e4465f518d014daf=
065
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-h3-orangepi-pc        | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f81fff90caae7dfcdaf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-453-gca8ab62d0916d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f81fff90caae7dfcdaf=
05c
        failing since 0 day (last pass: v5.10.136-25-g54da4071add59, first =
fail: v5.10.136-78-gf8cc9c11edf75) =

 =20
