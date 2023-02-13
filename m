Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169846944FD
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 13:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjBMMAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 07:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjBMMAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 07:00:14 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E7D18153
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 04:00:10 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id r9-20020a17090a2e8900b00233ba727724so5491210pjd.1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 04:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cFr5PcPFCYY5o54ALca6gAbzAGMC/Ro9q4hg/3Suzxg=;
        b=qktMqTAfc2EdbbJmP/apCr+3BDmNpVByxLhbADbEsdfMKv9t3CW2UHSrFWaQO5EakI
         XhSmEMDZU0VuIi4xrHA6lNNeVgUQau48S04hD4elnwEHc8y6xdoDR25465yMAPJccGwU
         8MizWus01NDwBKWNJcdcCfi0qDi0J0j1H/yNiAYn12QGJ7IobYt9B2VwaQeth1HZDiBz
         9kcwO5LF3uD6h0QLWi/qec9RX473qUUjT+H/ju7oEBzzUvy9LqGDwpn6+ozs0DKo/u2r
         I8dARNPW5sZmeJE4KrkuPn4DVp/tziHMCSRYf4l/dAUlicewSqmhk/GwbWn0tEGVcC8W
         LGkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cFr5PcPFCYY5o54ALca6gAbzAGMC/Ro9q4hg/3Suzxg=;
        b=vu9Ln+E/emcn754X8/IgkwwGKBgMiGyR7A3JW6rrB9w3h9Kp0549jOhZ42CsmTpPX3
         gokuVYDYERKLngZjYNjcPLcVIOqj5cT6pFxRJ7KNLztlmc43hMF16wLirVgJwSKJsFgN
         zJrzlPLW/oxU67SPSUUi9xj46RqqINBVEojs7TUXT9nnyttlwoiMOsEbOqly+sfg9eQJ
         ME75gzZB7XHXXLXUV3kEvjPhRX4TZUOBy46tpuj9XsvaijQrV1EC9sI4BRf1hmd3Gl4T
         Dz2dBQ+5u0sO2/JlKsA84CDIYYCsRiB8O1OgSmGr+6ytAPg8Np8AJ3HMBNh6YetHL+xD
         1UgQ==
X-Gm-Message-State: AO0yUKWEXoU3iB063/7X1RI6L2OWX6aEaAL997gU7ULoP5Jw6MeW4wrN
        ROuvWIFSOXgHXllLZ22zbO3DBDWemRK3u12mJpk=
X-Google-Smtp-Source: AK7set+bHxxiNbvTguyqqcVho022kxfw8bJnQBqLTWvM9uWbhDnfkF8hGbwt/LWVrOf0cmjLQnWGFg==
X-Received: by 2002:a17:90a:1a02:b0:230:11a7:7900 with SMTP id 2-20020a17090a1a0200b0023011a77900mr26333451pjk.24.1676289609309;
        Mon, 13 Feb 2023 04:00:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18-20020a17090a7f9200b0022335f1dae2sm7400703pjl.22.2023.02.13.04.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 04:00:08 -0800 (PST)
Message-ID: <63ea2648.170a0220.7b238.cd4a@mx.google.com>
Date:   Mon, 13 Feb 2023 04:00:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.167-127-g921934d621e4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 158 runs,
 27 regressions (v5.10.167-127-g921934d621e4)
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

stable-rc/queue/5.10 baseline: 158 runs, 27 regressions (v5.10.167-127-g921=
934d621e4)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beaglebone-black             | arm   | lab-broonie     | gcc-10   | omap2pl=
us_defconfig        | 2          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 2          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =

kontron-kbox-a-230-ls        | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =

kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 5          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

sun8i-h2-plus-orangepi-zero  | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.167-127-g921934d621e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.167-127-g921934d621e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      921934d621e4bdff7cff2ce8f2ee8243a562b45d =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beaglebone-black             | arm   | lab-broonie     | gcc-10   | omap2pl=
us_defconfig        | 2          =


  Details:     https://kernelci.org/test/plan/id/63e9f5bfd1202966d18c863a

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63e9f5bfd120296=
6d18c863d
        new failure (last pass: v5.10.167-123-g60f1e5752ec8)
        176 lines

    2023-02-13T08:32:46.018827  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000010
    2023-02-13T08:32:46.019235  kern  :alert : pgd =3D 70f74a51
    2023-02-13T08:32:46.024411  kern  :alert : [00000010] *pgd=3D8387a831, =
*pte=3D00000000, *ppte=3D00000000
    2023-02-13T08:32:46.029953  kern  :alert : 8<--- cut here ---
    2023-02-13T08:32:46.035561  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000010
    2023-02-13T08:32:46.041026  kern  :alert : pgd =3D e172a9a7
    2023-02-13T08:32:46.046677  kern  :alert : [00000010] *pgd=3D838a5831, =
*pte=3D00000000, *ppte=3D00000000
    2023-02-13T08:32:46.046984  kern  :alert : 8<--- cut here ---
    2023-02-13T08:32:46.057849  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000010
    2023-02-13T08:32:46.058167  kern  :alert : pgd =3D 05f18cfc =

    ... (181 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63e9f5bfd120296=
6d18c863e
        new failure (last pass: v5.10.167-123-g60f1e5752ec8)
        20 lines

    2023-02-13T08:32:45.979359  kern  :alert : 8<--- cut here ---
    2023-02-13T08:32:45.985012  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000010
    2023-02-13T08:32:45.990600  kern  :alert : pgd =3D d316ef4a
    2023-02-13T08:32:46.007428  kern  :alert : [00000010] *pgd=3D838b8831, =
*pte=3D00000000, *ppte=3D0000<8>[   42.109336] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D20>
    2023-02-13T08:32:46.007767  0000
    2023-02-13T08:32:46.008038  kern  :alert : 8<--- cut here ---   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f25a8ba1f6885b8c8630

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e9f25b8ba1f6885b8c8639
        failing since 17 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-02-13T08:18:09.513862  <8>[   11.390522] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3332383_1.5.2.4.1>
    2023-02-13T08:18:09.624332  / # #
    2023-02-13T08:18:09.728281  export SHELL=3D/bin/sh
    2023-02-13T08:18:09.729513  #
    2023-02-13T08:18:09.831827  / # export SHELL=3D/bin/sh. /lava-3332383/e=
nvironment
    2023-02-13T08:18:09.832988  <3>[   11.611288] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-02-13T08:18:09.833588  =

    2023-02-13T08:18:09.935900  / # . /lava-3332383/environment/lava-333238=
3/bin/lava-test-runner /lava-3332383/1
    2023-02-13T08:18:09.938112  =

    2023-02-13T08:18:09.942536  / # /lava-3332383/bin/lava-test-runner /lav=
a-3332383/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f23627ee11e8528c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f23627ee11e8528c8=
630
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f1fa2409c2d8d48c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f1fa2409c2d8d48c8=
635
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f9dd754bf5ebab8c866a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f9dd754bf5ebab8c8=
66b
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f25fbe44cacc938c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f25fbe44cacc938c8=
645
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f2106f521139648c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f2106f521139648c8=
636
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63e9f47859bd7592e48c867b

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63e9f47959bd759=
2e48c867e
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7)
        2 lines =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63e9f47959bd759=
2e48c867f
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7)
        11 lines

    2023-02-13T08:27:17.127334  kern  :alert : Unable to handle kernel pagi=
ng request at virtual<8>[   20.649487] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D11>
    2023-02-13T08:27:17.128403   address fffffffffffffff8
    2023-02-13T08:27:17.129594  kern  :alert : Mem abort info:
    2023-02-13T08:27:17.130677  kern  :alert :   ESR =3D 0x96000004
    2023-02-13T08:27:17.131724  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL =3D 32 bits
    2023-02-13T08:27:17.132756  kern  :alert :   SET =3D 0, FnV =3D 0
    2023-02-13T08:27:17.134076  kern  :alert :   EA =3D 0, S1PT<8>[   20.67=
5067] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D2>
    2023-02-13T08:27:17.135114  W =3D 0   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f329e70271fb868c8689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f329e70271fb868c8=
68a
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f58b42899ead2e8c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f58b42899ead2e8c8=
64d
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-kbox-a-230-ls        | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f43e3785f0b8668c866b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox=
-a-230-ls.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox=
-a-230-ls.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f43e3785f0b8668c8=
66c
        new failure (last pass: v5.10.167-123-g60f1e5752ec8) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 5          =


  Details:     https://kernelci.org/test/plan/id/63e9f33be536e11ff28c8655

  Results:     92 PASS, 8 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28=
-var3-ads2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28=
-var3-ads2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.spi-nor-probed: https://kernelci.org/test/case/id/63e9f=
33be536e11ff28c8664
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7)

    2023-02-13T08:22:01.328457  /lava-273787/1/../bin/lava-test-case
    2023-02-13T08:22:01.328860  <8>[   18.565991] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dspi-nor-probed RESULT=3Dfail>
    2023-02-13T08:22:01.329103  /lava-273787/1/../bin/lava-test-case   =


  * baseline.bootrr.at24-probed: https://kernelci.org/test/case/id/63e9f33b=
e536e11ff28c8666
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7)

    2023-02-13T08:21:55.000613  /lava-273787/1/../bin/lava-test-case
    2023-02-13T08:21:55.000993  <8>[   12.210661] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-probed RESULT=3Dfail>
    2023-02-13T08:21:55.001231  /lava-273787/1/../bin/lava-test-case
    2023-02-13T08:21:55.001453  <8>[   12.225952] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dwm8904-driver-present RESULT=3Dpass>   =


  * baseline.bootrr.spi-nor-probed: https://kernelci.org/test/case/id/63e9f=
33be536e11ff28c8664
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7)

    2023-02-13T08:22:01.328457  /lava-273787/1/../bin/lava-test-case
    2023-02-13T08:22:01.328860  <8>[   18.565991] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dspi-nor-probed RESULT=3Dfail>
    2023-02-13T08:22:01.329103  /lava-273787/1/../bin/lava-test-case   =


  * baseline.bootrr.at24-eeprom0-probed: https://kernelci.org/test/case/id/=
63e9f33be536e11ff28c86b2
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7)

    2023-02-13T08:22:02.352977  /lava-273787/1/../bin/lava-test-case
    2023-02-13T08:22:02.356056  <8>[   19.601841] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-eeprom0-probed RESULT=3Dfail>   =


  * baseline.bootrr.at24-eeprom1-probed: https://kernelci.org/test/case/id/=
63e9f33be536e11ff28c86b3
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7)

    2023-02-13T08:22:03.405690  /lava-273787/1/../bin/lava-test-case
    2023-02-13T08:22:03.406094  <8>[   20.621164] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-eeprom1-probed RESULT=3Dfail>
    2023-02-13T08:22:03.406335  /lava-273787/1/../bin/lava-test-case
    2023-02-13T08:22:03.406563  <8>[   20.637056] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drtc-rv8803-driver-present RESULT=3Dpass>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f52e0bb659c3fd8c8659

  Results:     85 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-efuse-probed: https://kernelci.org/test/case/i=
d/63e9f52f0bb659c3fd8c8684
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7)

    2023-02-13T08:30:16.338255  /lava-9141551/1/../bin/lava-test-case

    2023-02-13T08:30:16.352637  <8>[   33.676471] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-efuse-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f44a6dbcf523d68c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f44a6dbcf523d68c8=
651
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f747b1624d5edd8c866e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f747b1624d5edd8c8=
66f
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f4c9666fca87298c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f4c9666fca87298c8=
647
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f40de82b54b1658c8682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f40de82b54b1658c8=
683
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f414f438e6688a8c866e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f414f438e6688a8c8=
66f
        failing since 3 days (last pass: v5.10.167-88-g51abf75149f2, first =
fail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus-orangepi-zero  | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f068659bd5fac98c865d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f068659bd5fac98c8=
65e
        new failure (last pass: v5.10.167-123-g60f1e5752ec8) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f23494cb485b068c8659

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e9f23494cb485b068c8662
        failing since 11 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-02-13T08:17:26.787583  <8>[   10.605815] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3332382_1.5.2.4.1>
    2023-02-13T08:17:26.892725  / # #
    2023-02-13T08:17:26.994447  export SHELL=3D/bin/sh
    2023-02-13T08:17:26.994856  #
    2023-02-13T08:17:27.096174  / # export SHELL=3D/bin/sh. /lava-3332382/e=
nvironment
    2023-02-13T08:17:27.096584  =

    2023-02-13T08:17:27.197923  / # . /lava-3332382/environment/lava-333238=
2/bin/lava-test-runner /lava-3332382/1
    2023-02-13T08:17:27.198565  =

    2023-02-13T08:17:27.202316  / # /lava-3332382/bin/lava-test-runner /lav=
a-3332382/1
    2023-02-13T08:17:27.307174  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9f09a7f8544e1a88c866c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-127-g921934d621e4/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f09a7f8544e1a88c8=
66d
        failing since 2 days (last pass: v5.10.167-97-g823a8dcef4738, first=
 fail: v5.10.167-99-g1ad87c7b6bae) =

 =20
