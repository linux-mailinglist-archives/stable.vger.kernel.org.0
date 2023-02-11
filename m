Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81DF6932D0
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 18:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBKRSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 12:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjBKRSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 12:18:35 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5B8193D1
        for <stable@vger.kernel.org>; Sat, 11 Feb 2023 09:18:26 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id on9-20020a17090b1d0900b002300a96b358so8641000pjb.1
        for <stable@vger.kernel.org>; Sat, 11 Feb 2023 09:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kbXqnIHkflX1rEYp4vlf8zteHhLniooOY6ij1n3YvK8=;
        b=fA1vCedP1jON/fUgG/9UZUInleg54/hNrT2tlefV7PYWNg/L4EDb4Q8yI3vwdoLvIb
         VM1N3zjJEbqjGlN4E4ntfccfSX/uHPAAquG4/hSUegE4iERVwQUnwrkDGic8lKFABBAI
         uwKJMHz5LCHE4OoA4ElYttnBt8wjzNrfJuX0ut/Nh+1Ilsi3rCb4baQi+57oxK4tdPn0
         TotN3BZaUM8da195FkpVMRrju4ga3RL/TNd4Mp4IWm1z3ekuCSQ3cUSQ8BHAmvtJ5/Rs
         m4VyNgEEADFKzGEYtE1racN0bBD0r3NuVi6qAKenDMSiFjGgqRVqy63o++pAcs7hYPq9
         c2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kbXqnIHkflX1rEYp4vlf8zteHhLniooOY6ij1n3YvK8=;
        b=7BKBEQoYDgP9l0K3v+EXk40agXd/baOGRLCGjFMvhk4CRhzOfRZeDlhy6sZqTfSNAD
         KK28nyMgQ7fHgeM/Pxrf3mHTf7oISrUbWAonZLtyA9jpr9avgItjgOLmJkg2F1YJtm4b
         kWn+Ssd5RSDidNt3QAon1NteCXEcY1Pzt4l1RVRmCx3CzCLaA3538vYYNpfW7BA9UUFy
         5Na4uF9pR+tC51UgPJAYXKUVuC5oxCK2VJPQBMWATtpfySZiqG0+dDRe8E6pt+htfWhK
         b+P6NuPXmL1jnA3Cu6CgwGIb/L1Zahwm76joYEtWWaeo7PF3CzQSEIL6FOeO6OSvOO2l
         Gvtw==
X-Gm-Message-State: AO0yUKV68gaqssjYCOwQefowHaTrRpHjb4HuotEgTzHoIa8yNIqrTqAt
        GTXuX+DIotmBuBBJfre35RZ0XvMin5DsYivTKxm6JA==
X-Google-Smtp-Source: AK7set95nGaCGbt2D9Douo1wQx77qViEdGQsImfoFPr0zAnqz20Ex2lbrHlG9zCQNekGvfTifjQQXQ==
X-Received: by 2002:a17:90a:350:b0:230:ddd8:2d91 with SMTP id 16-20020a17090a035000b00230ddd82d91mr19989624pjf.22.1676135905133;
        Sat, 11 Feb 2023 09:18:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ne20-20020a17090b375400b0023124c0667asm5599063pjb.19.2023.02.11.09.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Feb 2023 09:18:24 -0800 (PST)
Message-ID: <63e7cde0.170a0220.17a48.b7ba@mx.google.com>
Date:   Sat, 11 Feb 2023 09:18:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.167-105-g33398e62147f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 148 runs,
 29 regressions (v5.10.167-105-g33398e62147f)
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

stable-rc/queue/5.10 baseline: 148 runs, 29 regressions (v5.10.167-105-g333=
98e62147f)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
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
ig                  | 3          =

kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 5          =

meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

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
nel/v5.10.167-105-g33398e62147f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.167-105-g33398e62147f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      33398e62147f98125122db9e1eaf5ebda33d9233 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79b07b61620280a8c8656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79b07b61620280a8c8=
657
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79a7af13151415f8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79a7af13151415f8c8=
631
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79abb3e2a1dd0168c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79abb3e2a1dd0168c8=
63f
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79bf72d3fb173238c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79bf72d3fb173238c8=
640
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79ba7f0d9e0727d8c8689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79ba7f0d9e0727d8c8=
68a
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63e79b1ab61620280a8c867f

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63e79b1ab616202=
80a8c8682
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)
        2 lines

    2023-02-11T13:41:20.234009  kern  :alert :   ESR =3D 0x96000004
    2023-02-11T13:41:20.235007  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL =3D 32 bits
    2023-02-11T13:41:20.236017  kern  :alert :   SET =3D 0, FnV =3D 0
    2023-02-11T13:41:20.237155  kern  :alert :   EA =3D 0, S1PT<8>[   21.44=
8816] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D2>
    2023-02-11T13:41:20.238229  W =3D 0   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63e79b1ab616202=
80a8c8683
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)
        11 lines

    2023-02-11T13:41:20.227168  kern  :alert : Unable to handle kernel pagi=
ng request at virtual<8>[   21.422827] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D11>
    2023-02-11T13:41:20.228281   address fffffffffffffff8
    2023-02-11T13:41:20.229348  kern  :alert : Mem abort info:   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-kbox-a-230-ls        | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 3          =


  Details:     https://kernelci.org/test/plan/id/63e7999bc9327a5f518c865e

  Results:     78 PASS, 10 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox=
-a-230-ls.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox=
-a-230-ls.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63e7999bc9327a5=
f518c8662
        new failure (last pass: v5.10.167-99-g1ad87c7b6bae)
        21 lines

    2023-02-11T13:34:43.149808  kern  :alert : Unable to handle kernel NULL=
 poin<8>[   42.050901] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3D=
fail UNITS=3Dlines MEASUREMENT=3D21>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63e7999bc9327a5=
f518c8663
        new failure (last pass: v5.10.167-99-g1ad87c7b6bae)
        4 lines

    2023-02-11T13:34:43.189064  ter dereference at virtual address 00000000=
00000020
    2023-02-11T13:34:43.189359  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 00ffff002006a0a5
    2023-02-11T13:34:43.189615  kern  :alert : Mem abort info:
    2023-02-11T13:34:43.189846  <8>[   42.074209] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-02-11T13:34:43.190074  kern  :alert :  <6>[   42.084211] VDDH: dis=
abling
    2023-02-11T13:34:43.190295   ESR =3D 0x9600000<8>[   42.089152] <LAVA_S=
IGNAL_ENDRUN 0_dmesg 273055_1.5.2.4.1>
    2023-02-11T13:34:43.190515  6   =


  * baseline.bootrr.caam_jr-driver-present: https://kernelci.org/test/case/=
id/63e7999bc9327a5f518c8696
        new failure (last pass: v5.10.167-99-g1ad87c7b6bae)

    2023-02-11T13:34:46.630274  /lava-273055/1/../bin/lava-test-case
    2023-02-11T13:34:46.630634  <8>[   45.523131] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcaam_jr-driver-present RESULT=3Dfail>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 5          =


  Details:     https://kernelci.org/test/plan/id/63e79973a3ea3c24e38c8640

  Results:     92 PASS, 8 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28=
-var3-ads2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28=
-var3-ads2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.spi-nor-probed: https://kernelci.org/test/case/id/63e79=
973a3ea3c24e38c864f
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T13:34:28.003995  /lava-273056/1/../bin/lava-test-case
    2023-02-11T13:34:28.004396  <8>[   18.562890] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dspi-nor-probed RESULT=3Dfail>
    2023-02-11T13:34:28.004639  /lava-273056/1/../bin/lava-test-case   =


  * baseline.bootrr.at24-probed: https://kernelci.org/test/case/id/63e79973=
a3ea3c24e38c8651
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T13:34:21.672707  /lava-273056/1/../bin/lava-test-case
    2023-02-11T13:34:21.673112  <8>[   12.203119] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-probed RESULT=3Dfail>
    2023-02-11T13:34:21.673367  /lava-273056/1/../bin/lava-test-case
    2023-02-11T13:34:21.673598  <8>[   12.218949] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dwm8904-driver-present RESULT=3Dpass>   =


  * baseline.bootrr.spi-nor-probed: https://kernelci.org/test/case/id/63e79=
973a3ea3c24e38c864f
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T13:34:28.003995  /lava-273056/1/../bin/lava-test-case
    2023-02-11T13:34:28.004396  <8>[   18.562890] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dspi-nor-probed RESULT=3Dfail>
    2023-02-11T13:34:28.004639  /lava-273056/1/../bin/lava-test-case   =


  * baseline.bootrr.at24-eeprom0-probed: https://kernelci.org/test/case/id/=
63e79973a3ea3c24e38c869d
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T13:34:29.027701  /lava-273056/1/../bin/lava-test-case
    2023-02-11T13:34:29.030844  <8>[   19.596839] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-eeprom0-probed RESULT=3Dfail>   =


  * baseline.bootrr.at24-eeprom1-probed: https://kernelci.org/test/case/id/=
63e79973a3ea3c24e38c869e
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T13:34:30.079199  /lava-273056/1/../bin/lava-test-case
    2023-02-11T13:34:30.079582  <8>[   20.616330] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-eeprom1-probed RESULT=3Dfail>
    2023-02-11T13:34:30.079827  /lava-273056/1/../bin/lava-test-case
    2023-02-11T13:34:30.080053  <8>[   20.631640] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drtc-rv8803-driver-present RESULT=3Dpass>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79aab2b39eb6b5f8c865d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e79aab2b39eb6b5f8c8666
        failing since 0 day (last pass: v5.10.167-97-g823a8dcef4738, first =
fail: v5.10.167-99-g1ad87c7b6bae)

    2023-02-11T13:39:31.897768  / # #
    2023-02-11T13:39:32.000065  export SHELL=3D/bin/sh
    2023-02-11T13:39:32.000710  #
    2023-02-11T13:39:32.102266  / # export SHELL=3D/bin/sh. /lava-3326731/e=
nvironment
    2023-02-11T13:39:32.102945  =

    2023-02-11T13:39:32.204549  / # . /lava-3326731/environment/lava-332673=
1/bin/lava-test-runner /lava-3326731/1
    2023-02-11T13:39:32.205599  =

    2023-02-11T13:39:32.224700  / # /lava-3326731/bin/lava-test-runner /lav=
a-3326731/1
    2023-02-11T13:39:32.333435  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-11T13:39:32.334213  + cd /lava-3326731/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79cb9e04f7f9d7c8c86c9

  Results:     85 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-efuse-probed: https://kernelci.org/test/case/i=
d/63e79cb9e04f7f9d7c8c86f4
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-11T13:48:27.355877  <8>[   59.586580] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-efuse-driver-present RESULT=3Dpass>

    2023-02-11T13:48:28.387001  /lava-9121870/1/../bin/lava-test-case

    2023-02-11T13:48:28.397944  <8>[   60.629924] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-efuse-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79a5e5508874e6f8c8678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79a5e5508874e6f8c8=
679
        new failure (last pass: v5.10.167-99-g1ad87c7b6bae) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79ac03e2a1dd0168c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79ac03e2a1dd0168c8=
64a
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79ab77d2ffd5be78c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79ab77d2ffd5be78c8=
64b
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79a6c5508874e6f8c8691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79a6c5508874e6f8c8=
692
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79ab5900dd6c7a08c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-li=
bretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-li=
bretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79ab5900dd6c7a08c8=
630
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79a5f5508874e6f8c867b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79a5f5508874e6f8c8=
67c
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79a7600492d75028c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79a7600492d75028c8=
631
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79aadeaa437dc138c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e79aadeaa437dc138c8638
        failing since 9 days (last pass: v5.10.165-139-gefb57ce0f880, first=
 fail: v5.10.165-149-ge30e8271d674)

    2023-02-11T13:39:29.829357  / # #
    2023-02-11T13:39:29.931147  export SHELL=3D/bin/sh
    2023-02-11T13:39:29.931735  #
    2023-02-11T13:39:30.033137  / # export SHELL=3D/bin/sh. /lava-3326736/e=
nvironment
    2023-02-11T13:39:30.033667  =

    2023-02-11T13:39:30.134881  / # . /lava-3326736/environment/lava-332673=
6/bin/lava-test-runner /lava-3326736/1
    2023-02-11T13:39:30.135646  =

    2023-02-11T13:39:30.140627  / # /lava-3326736/bin/lava-test-runner /lav=
a-3326736/1
    2023-02-11T13:39:30.238539  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-11T13:39:30.239155  + cd /lava-3326736/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79a19229f908a5d8c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79a19229f908a5d8c8=
635
        failing since 0 day (last pass: v5.10.167-97-g08e29bf32dce7, first =
fail: v5.10.167-97-g823a8dcef4738) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79b4d8b0b1413718c868a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79b4d8b0b1413718c8=
68b
        failing since 0 day (last pass: v5.10.167-97-g823a8dcef4738, first =
fail: v5.10.167-99-g1ad87c7b6bae) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79d09749ccfa9068c86a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79d09749ccfa9068c8=
6aa
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e79ba2f0d9e0727d8c8667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-105-g33398e62147f/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e79ba2f0d9e0727d8c8=
668
        failing since 1 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =20
