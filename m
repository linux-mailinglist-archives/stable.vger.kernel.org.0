Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AE16724CE
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 18:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjARRZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 12:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjARRZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 12:25:51 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119A3125AB
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 09:25:50 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v10-20020a17090abb8a00b00229c517a6eeso3072539pjr.5
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 09:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3mYdpjNwurmnlpmE7Dw5D7Jf5pQXLU1mrtJtyKXwpvc=;
        b=3iJp5okYz43R+01FU4vhTlRDOeALfVMOMzFVEDeUhoxrbHWOI0V8ogVKXnkgMG5EED
         6FLwMtuOwakVyA9LpQfdgBU5ROCQ9bUGiGnxI+LLjRm0iKhKq6j7vnTcXCTK1y1kaAtF
         U4MNUAckywHXFurKhKhzATZXZQQIC5M0UJJE5e7jcgwwostfCulPRaYJ2OyRMypaD/dr
         pY+2u9tIS2XBfwA+wGKy7t1ukNdSvUfc4iHG14pHyr3xpEa4kn9/sd4ILT0tiZeyZLA/
         binu2fmrvo61uub3ssUbgPSZ9Qiq903WTeg4wYXqA6X0RjqnuWwQuUyhm0+YA5ud7mxP
         Ja/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3mYdpjNwurmnlpmE7Dw5D7Jf5pQXLU1mrtJtyKXwpvc=;
        b=HuOwHds3lDbj30p0p9NBdqQhrAoz81Omu3fTiWxvM1n2sw7wN0P40gGzDjGaFGfepU
         WrmSSqT7V5wvboWT5N6qN+vEGHHf2RaC476RBqU6yFqkCCuD7NTtznVTyJaHdP/coHGv
         rpVdHViL5NGpqrgavDcOfnznhLJSi36OcsXLwiZUDaEXJkY1BRtbbUf9rvakVE2Y68QM
         NeHIyqaX4xAA1yivvQQF7JwiiXSDfCmdnBh2oeUueRNL68r7ARtpMH2BKRuxB5o336rz
         RYXQJ8yBwpbnfVkTyH+bOvNpVDk1HtMOfbSV27zuX6pp/Iz/8+4GjiariLmYEIR0LZ6E
         g0Xg==
X-Gm-Message-State: AFqh2kr3qSHj4Rwa7ZlXOhjieUUu1GtV51C6f9tWUk4hMPxATgXl6+Zo
        dL5T3PplcN8vydoXE3qEriX649awNGNyH03USXyR4Q==
X-Google-Smtp-Source: AMrXdXuW45Ly+kt0rgDo/zZGHMbin5sXsiNnA5+V2vmaknx3bf7fu38YnHDCGAp6uJQmY4kQFQySaQ==
X-Received: by 2002:a17:902:ab50:b0:189:bc50:b93b with SMTP id ij16-20020a170902ab5000b00189bc50b93bmr7613589plb.3.1674062748655;
        Wed, 18 Jan 2023 09:25:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090301c500b00188fadb71ecsm23425757plh.16.2023.01.18.09.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 09:25:48 -0800 (PST)
Message-ID: <63c82b9c.170a0220.ab5a5.5a20@mx.google.com>
Date:   Wed, 18 Jan 2023 09:25:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.164
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 170 runs, 5 regressions (v5.10.164)
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

stable/linux-5.10.y baseline: 170 runs, 5 regressions (v5.10.164)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
             | regressions
-------------------------+-------+--------------+----------+---------------=
-------------+------------
cubietruck               | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig         | 1          =

r8a7743-iwg20d-q7        | arm   | lab-cip      | gcc-10   | shmobile_defco=
nfig         | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun8i-a83t-bananapi-m3   | arm   | lab-clabbe   | gcc-10   | multi_v7_defco=
nfig         | 1          =

sun8i-a83t-bananapi-m3   | arm   | lab-clabbe   | gcc-10   | sunxi_defconfi=
g            | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.164/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.164
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3a9f1b907bc434a91f0d295533d2c7e3758efe92 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
             | regressions
-------------------------+-------+--------------+----------+---------------=
-------------+------------
cubietruck               | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63c8289e75a597a030915f17

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.164/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.164/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c8289e75a597a030915f1c
        new failure (last pass: v5.10.158)

    2023-01-18T17:12:23.815919  <8>[   11.067961] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3158000_1.5.2.4.1>
    2023-01-18T17:12:23.923391  / # #
    2023-01-18T17:12:24.028185  export SHELL=3D/bin/sh
    2023-01-18T17:12:24.028759  #
    2023-01-18T17:12:24.131311  / # export SHELL=3D/bin/sh. /lava-3158000/e=
nvironment
    2023-01-18T17:12:24.131744  =

    2023-01-18T17:12:24.232893  / # . /lava-3158000/environment/lava-315800=
0/bin/lava-test-runner /lava-3158000/1
    2023-01-18T17:12:24.233580  =

    2023-01-18T17:12:24.238320  / # /lava-3158000/bin/lava-test-runner /lav=
a-3158000/1
    2023-01-18T17:12:24.314647  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
             | regressions
-------------------------+-------+--------------+----------+---------------=
-------------+------------
r8a7743-iwg20d-q7        | arm   | lab-cip      | gcc-10   | shmobile_defco=
nfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f70eb782d8fa24915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.164/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.164/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f70eb782d8fa24915=
ec1
        new failure (last pass: v5.10.163) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
             | regressions
-------------------------+-------+--------------+----------+---------------=
-------------+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7fd8aee79480c81915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.164/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.164/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7fd8aee79480c81915=
ed8
        new failure (last pass: v5.10.163) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
             | regressions
-------------------------+-------+--------------+----------+---------------=
-------------+------------
sun8i-a83t-bananapi-m3   | arm   | lab-clabbe   | gcc-10   | multi_v7_defco=
nfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7fa74e25f4d7a15915ebf

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.164/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.164/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7fa74e25f4d7a15915ec2
        failing since 14 days (last pass: v5.10.143, first fail: v5.10.162)

    2023-01-18T13:55:53.489154  / # #
    2023-01-18T13:55:53.601473  export SHELL=3D/bin/sh
    2023-01-18T13:55:53.602097  [   16.531198] usb-storage 2-1.1:1.0: USB M=
ass Storage device detected
    2023-01-18T13:55:53.602478  [   16.539964] scsi host0: usb-storage 2-1.=
1:1.0
    2023-01-18T13:55:53.602780  [   16.555285] usbcore: registered new inte=
rface driver uas
    2023-01-18T13:55:53.603083  #
    2023-01-18T13:55:53.707164  / # export SHELL=3D/bin/sh. /lava-381717/en=
vironment
    2023-01-18T13:55:53.707682  =

    2023-01-18T13:55:53.813282  / # . /lava-381717/environment/lava-381717/=
bin/lava-test-runner /lava-381717/1
    2023-01-18T13:55:53.815898   =

    ... (20 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
             | regressions
-------------------------+-------+--------------+----------+---------------=
-------------+------------
sun8i-a83t-bananapi-m3   | arm   | lab-clabbe   | gcc-10   | sunxi_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f7038b6d7ec597915eca

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.164/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.164/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f7038b6d7ec597915ecd
        failing since 14 days (last pass: v5.10.143, first fail: v5.10.162)

    2023-01-18T13:41:02.616126  / # #
    2023-01-18T13:41:02.718122  export SHELL=3D/bin/sh
    2023-01-18T13:41:02.718978  #
    2023-01-18T13:41:02.820503  / # export SHELL=3D/bin/sh. /lava-381710/en=
vironment
    2023-01-18T13:41:02.821199  =

    2023-01-18T13:41:02.922916  / # . /lava-381710/environment/lava-381710/=
bin/lava-test-runner /lava-381710/1
    2023-01-18T13:41:02.923862  =

    2023-01-18T13:41:02.936902  / # /lava-381710/bin/lava-test-runner /lava=
-381710/1
    2023-01-18T13:41:03.035368  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-18T13:41:03.035877  + cd /lava-381710/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
