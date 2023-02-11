Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C993693309
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 19:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBKSns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 13:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBKSns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 13:43:48 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E58E3B9
        for <stable@vger.kernel.org>; Sat, 11 Feb 2023 10:43:45 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id d13-20020a17090ad3cd00b0023127b2d602so8750672pjw.2
        for <stable@vger.kernel.org>; Sat, 11 Feb 2023 10:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=v/j4NOeSc9I5SqeJPUTxrNSc79PY5nyuyUgaPmPkHYc=;
        b=zDQBQPvbmV7pDkwePJ3ynlE062NKeicUItuFfh58JtRlp7/E1BrTdh+Q11AZOkU/sz
         teF6WqPw5P4HRu1XCddxODzx9VHE4XWpPCRxV+FZe4MB7f7nO6UDTv9CzpcbRNvt5PLU
         iC7Yl+v3QQRWX4D4l04kmE+EfJphD13yB2GjOzXGqtfeCQ9EQWcZbG0mjwgua8AGbxpy
         XB3/XVx4NsdFzMtZcZUqLOThjvDaW0wlwZ4mrg8fp7Ak+vtwLJ31W5nO7FCM8q8dGC6P
         3SZctr1iRkVRqRAU3FSXfKg01fBHKt6qcAaYQAODrnM7mW89PHVqIAm7bzvIrO0gV48O
         vg1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v/j4NOeSc9I5SqeJPUTxrNSc79PY5nyuyUgaPmPkHYc=;
        b=PeZvqQ1IN+ZbNLCKrRreXxn+y3//blQCbitmLg0tc//5TsWFg2Yc079Qy1+UsgUDb2
         THQNNQaqbdHkLrquNXc26p0QX3quFnEjHI/mI80sanDugjiGCutrYj/KJNl+U4f9y33B
         MF8WI0yI/WsCN80MzbBYxJbluSML6u6DrWmLwlAUQvxwXmlr3fMJ4OkpZVuPoyS473vX
         GdyvEW/1HpMvZAjaeoYUCOmm2HRb2vG9dgjyKxvYwFzfuIzWIBw3hD2hXpadx49+hRiK
         T10mJqhEOhvH0pAgZaLC9Ju9UCcVQ3VWDaP01/DfcjUkzB/S/z+vJlQQEyE53RKwODZc
         56zw==
X-Gm-Message-State: AO0yUKUUgOl4HX3frRGopXo/mL2BOp/A/hKVI7G3qCw5WQrH969p03mx
        pbSVrJCsLLcU25+/Couo1+CR5EraQayf+awsGsny4g==
X-Google-Smtp-Source: AK7set8g8ircvqvq5tIzyLOwiwBO/+a72Zv/iDWlRV42KfpCrO62XTyYKqK/sqGl/3A7AAw6B1DdFg==
X-Received: by 2002:a05:6a20:6722:b0:c0:c3df:261 with SMTP id q34-20020a056a20672200b000c0c3df0261mr18088960pzh.37.1676141023898;
        Sat, 11 Feb 2023 10:43:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l13-20020a62be0d000000b005a7c892b435sm5182298pff.25.2023.02.11.10.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Feb 2023 10:43:43 -0800 (PST)
Message-ID: <63e7e1df.620a0220.46a6b.921c@mx.google.com>
Date:   Sat, 11 Feb 2023 10:43:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.167-105-g9ff628d46886
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 146 runs,
 30 regressions (v5.10.167-105-g9ff628d46886)
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

stable-rc/queue/5.10 baseline: 146 runs, 30 regressions (v5.10.167-105-g9ff=
628d46886)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig                  | 1          =

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

kontron-kbox-a-230-ls        | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 4          =

kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 5          =

meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.167-105-g9ff628d46886/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.167-105-g9ff628d46886
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ff628d4688675caf3ffe3356e353fcb4af8ba92 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7b165fce4480ce58c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7b165fce4480ce58c8=
63e
        new failure (last pass: v5.10.167-105-g33398e62147f) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ac73a80ff38a3c8c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7ac73a80ff38a3c8c8=
643
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ab1f85312d44018c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7ab1f85312d44018c8=
630
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ab491ae33291ee8c8688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7ab491ae33291ee8c8=
689
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ac87ec25c5d2d18c866b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7ac87ec25c5d2d18c8=
66c
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ab3485312d44018c865e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7ab3485312d44018c8=
65f
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63e7b265abc02527b98c862f

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63e7b265abc0252=
7b98c8632
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)
        2 lines

    2023-02-11T15:20:36.750198  kern  :alert : Mem abort info:
    2023-02-11T15:20:36.751583  kern  :alert :   ESR =3D 0x96000004
    2023-02-11T15:20:36.752675  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL =3D 32 bits
    2023-02-11T15:20:36.754138  kern  :alert :   SET =3D 0, FnV =3D 0
    2023-02-11T15:20:36.755203  kern  :alert :   EA =3D 0, S1PT<8>[   20.21=
6715] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D2>
    2023-02-11T15:20:36.756153  W =3D 0   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63e7b265abc0252=
7b98c8633
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)
        11 lines

    2023-02-11T15:20:36.744684  kern  :alert : Unable to handle kernel pagi=
ng request at virtual<8>[   20.190555] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D11>
    2023-02-11T15:20:36.745804   address fffffffffffffff8   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-kbox-a-230-ls        | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 4          =


  Details:     https://kernelci.org/test/plan/id/63e7b1372371aee5668c8660

  Results:     77 PASS, 11 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox=
-a-230-ls.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox=
-a-230-ls.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63e7b1372371aee=
5668c8664
        failing since 0 day (last pass: v5.10.167-99-g1ad87c7b6bae, first f=
ail: v5.10.167-105-g33398e62147f)
        11 lines

    2023-02-11T15:15:26.626851  kern  :alert : Unable to handle kernel pagi=
ng re<8>[   40.819592] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3D=
fail UNITS=3Dlines MEASUREMENT=3D11>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63e7b1372371aee=
5668c8665
        failing since 0 day (last pass: v5.10.167-99-g1ad87c7b6bae, first f=
ail: v5.10.167-105-g33398e62147f)
        2 lines

    2023-02-11T15:15:26.628282  quest at virtual address ffff800011702760
    2023-02-11T15:15:26.628511  kern  :alert : Mem abort info:
    2023-02-11T15:15:26.628730  kern  :alert :   ESR =3D 0x96000047
    2023-02-11T15:15:26.628944  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL <8>[   40.842580] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESUL=
T=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2023-02-11T15:15:26.629161  =3D 32 bits   =


  * baseline.bootrr.at24-probed: https://kernelci.org/test/case/id/63e7b137=
2371aee5668c8671
        new failure (last pass: v5.10.167-105-g33398e62147f)

    2023-02-11T15:15:29.374415  /lava-273069/1/../bin/lava-test-case
    2023-02-11T15:15:29.374811  <8>[   43.548246] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-probed RESULT=3Dfail>   =


  * baseline.bootrr.caam_jr-driver-present: https://kernelci.org/test/case/=
id/63e7b1372371aee5668c8698
        failing since 0 day (last pass: v5.10.167-99-g1ad87c7b6bae, first f=
ail: v5.10.167-105-g33398e62147f)

    2023-02-11T15:15:31.030631  /lava-273069/1/../bin/lava-test-case
    2023-02-11T15:15:31.033839  <8>[   45.243935] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcaam_jr-driver-present RESULT=3Dfail>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 5          =


  Details:     https://kernelci.org/test/plan/id/63e7b0e6236305f9bb8c86c0

  Results:     92 PASS, 8 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28=
-var3-ads2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28=
-var3-ads2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.spi-nor-probed: https://kernelci.org/test/case/id/63e7b=
0e6236305f9bb8c86cf
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T15:14:25.364106  /lava-273068/1/../bin/lava-test-case
    2023-02-11T15:14:25.364512  <8>[   18.532760] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dspi-nor-probed RESULT=3Dfail>
    2023-02-11T15:14:25.364757  /lava-273068/1/../bin/lava-test-case   =


  * baseline.bootrr.at24-probed: https://kernelci.org/test/case/id/63e7b0e6=
236305f9bb8c86d1
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T15:14:19.023289  /lava-273068/1/../bin/lava-test-case
    2023-02-11T15:14:19.023698  <8>[   12.163008] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-probed RESULT=3Dfail>
    2023-02-11T15:14:19.023957  /lava-273068/1/../bin/lava-test-case
    2023-02-11T15:14:19.024189  <8>[   12.179038] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dwm8904-driver-present RESULT=3Dpass>   =


  * baseline.bootrr.spi-nor-probed: https://kernelci.org/test/case/id/63e7b=
0e6236305f9bb8c86cf
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T15:14:25.364106  /lava-273068/1/../bin/lava-test-case
    2023-02-11T15:14:25.364512  <8>[   18.532760] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dspi-nor-probed RESULT=3Dfail>
    2023-02-11T15:14:25.364757  /lava-273068/1/../bin/lava-test-case   =


  * baseline.bootrr.at24-eeprom0-probed: https://kernelci.org/test/case/id/=
63e7b0e7236305f9bb8c871d
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T15:14:26.387517  /lava-273068/1/../bin/lava-test-case
    2023-02-11T15:14:26.390632  <8>[   19.566655] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-eeprom0-probed RESULT=3Dfail>   =


  * baseline.bootrr.at24-eeprom1-probed: https://kernelci.org/test/case/id/=
63e7b0e7236305f9bb8c871e
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T15:14:27.440262  /lava-273068/1/../bin/lava-test-case
    2023-02-11T15:14:27.440593  <8>[   20.585912] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-eeprom1-probed RESULT=3Dfail>
    2023-02-11T15:14:27.440771  /lava-273068/1/../bin/lava-test-case
    2023-02-11T15:14:27.440937  <8>[   20.601902] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drtc-rv8803-driver-present RESULT=3Dpass>
    2023-02-11T15:14:27.441102  /lava-273068/1/../bin/lava-test-case   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ac40d895dad9bb8c8678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7ac40d895dad9bb8c8=
679
        new failure (last pass: v5.10.167-105-g33398e62147f) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ac5b816fba64d68c8669

  Results:     85 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-efuse-probed: https://kernelci.org/test/case/i=
d/63e7ac5b816fba64d68c8694
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T14:55:12.831616  /lava-9123299/1/../bin/lava-test-case

    2023-02-11T14:55:12.842094  <8>[   60.558797] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-efuse-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7b24808e3598b9e8c8669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7b24808e3598b9e8c8=
66a
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7b287925292b2448c8659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7b287925292b2448c8=
65a
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7b210b8895c62528c86ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7b210b8895c62528c8=
6bb
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7b273d89417bf5f8c865f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-li=
bretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-li=
bretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7b273d89417bf5f8c8=
660
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7b1e510369714448c864d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7b1e510369714448c8=
64e
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7b205bc33f033388c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7b205bc33f033388c8=
63b
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ab3c85312d44018c8664

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e7ab3c85312d44018c866d
        failing since 9 days (last pass: v5.10.165-139-gefb57ce0f880, first=
 fail: v5.10.165-149-ge30e8271d674)

    2023-02-11T14:50:09.247232  / # #
    2023-02-11T14:50:09.349517  export SHELL=3D/bin/sh
    2023-02-11T14:50:09.350197  #
    2023-02-11T14:50:09.452008  / # export SHELL=3D/bin/sh. /lava-3327123/e=
nvironment
    2023-02-11T14:50:09.453068  =

    2023-02-11T14:50:09.554763  / # . /lava-3327123/environment/lava-332712=
3/bin/lava-test-runner /lava-3327123/1
    2023-02-11T14:50:09.555899  =

    2023-02-11T14:50:09.570738  / # /lava-3327123/bin/lava-test-runner /lav=
a-3327123/1
    2023-02-11T14:50:09.661709  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-11T14:50:09.662415  + cd /lava-3327123/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7aac3e4a7af31f18c866c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7aac3e4a7af31f18c8=
66d
        failing since 1 day (last pass: v5.10.167-97-g08e29bf32dce7, first =
fail: v5.10.167-97-g823a8dcef4738) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ab16493a9c3a3d8c865a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7ab16493a9c3a3d8c8=
65b
        failing since 0 day (last pass: v5.10.167-97-g823a8dcef4738, first =
fail: v5.10.167-99-g1ad87c7b6bae) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ac7a598134f2688c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7ac7a598134f2688c8=
652
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e7ade1132db2c9a08c8664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g9ff628d46886/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e7ade1132db2c9a08c8=
665
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =20
