Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AEF6E981C
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 17:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjDTPMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 11:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjDTPMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 11:12:02 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483AB59C7
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:12:01 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b5fca48bcso1038334b3a.0
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682003520; x=1684595520;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CRpKX6wM9q4sgz7waPzqMATYIJFA7FyjwTz4R9YnHW8=;
        b=CfpSet7WahtjAeGjahlA6zNcoqu6W9hToNntiFDrt8hRKl2x9vJJTv/s3QB/ndv1LG
         7OWCdd2KaXODjVixoLpmjuxblkDndB5KUkVsRt8ZSbaCVpVdI322yrGU7UEqg2GnT6+I
         JMm6r/VuYg29mZkjRD+kcMbwTfk3ZtUlP7t6aJsx7QT9//TsOfv4G0jZM+GM7NV50me3
         qa2/ZXApTpWV3tkAc8U/POJR4ETXJpTX4Zq/BBNM6i6IBXtprrZqeEI6ynmgANVlMeSC
         RXiNUsvoDSnBhP0DbD8D0DeIt33UJ0h9yz2uUn/7prKCI+/iU6AN6sW06wuC2XQpaBRx
         jB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682003520; x=1684595520;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CRpKX6wM9q4sgz7waPzqMATYIJFA7FyjwTz4R9YnHW8=;
        b=O6rTBrv4QC8eU+0NQpiY8tRWwDaNFVdRlcHsuW0emFqMFuRong25yZyCkTV9DlypFA
         pSnpxJHT3GPG2OEQrxB8Er9+Yi+7vPg8ucYmTrn5ib5awGMWcZ+vyWX4cgK6xBgORldM
         sm+ERl0zlL1pjcGMUVmAQO54uaQYXn9NoaW4k82+oAMC2H95pN7b8VRfXkiGSNKvDg53
         Jkz5Zo0b1Dm/RDZ5YSHgYTOt0YCj9DTRr6oYpHzrn/5uWVA4WRWtCSsANegp7rN0mq3v
         K2Pe54TWEMb5TPyTDaa1riiuCty4p3LH9RPcfa3LNvcZBXg1pCDF4pfU9HqgpMG3707+
         otfg==
X-Gm-Message-State: AAQBX9cHwVJgrE1XboZ9637aqiCBXf2cyK10mIZjLmwi4YuoATI/XEBa
        XdzSjp1tZJKH23asU9UJk7lLJwP76INEWQiaTWGxFfh5
X-Google-Smtp-Source: AKy350aTqD4Egk74LzUvEc57UADdF/a3+rDq2De0fT8n1kJGpkzTZWHroGylL82gGMK2RzLWW6GTlg==
X-Received: by 2002:a05:6a00:188e:b0:638:f0b1:4df1 with SMTP id x14-20020a056a00188e00b00638f0b14df1mr1931799pfh.24.1682003520489;
        Thu, 20 Apr 2023 08:12:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h69-20020a628348000000b0063db25e140bsm1386139pfe.32.2023.04.20.08.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 08:12:00 -0700 (PDT)
Message-ID: <64415640.620a0220.fb3a2.292f@mx.google.com>
Date:   Thu, 20 Apr 2023 08:12:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.178
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 140 runs, 6 regressions (v5.10.178)
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

stable/linux-5.10.y baseline: 140 runs, 6 regressions (v5.10.178)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =

r8a774a1-hihope-rzg2m-ex     | arm64  | lab-cip       | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.178/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.178
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      791a854ae5a5f5988f1291ae91168a149bd5ba57 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644121c383b0cc38662e85ed

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.178/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.178/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644121c383b0cc38662e85f2
        failing since 91 days (last pass: v5.10.158, first fail: v5.10.164)

    2023-04-20T11:27:43.432849  <8>[   11.127164] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3515745_1.5.2.4.1>
    2023-04-20T11:27:43.544686  / # #
    2023-04-20T11:27:43.648359  export SHELL=3D/bin/sh
    2023-04-20T11:27:43.649396  #
    2023-04-20T11:27:43.751563  / # export SHELL=3D/bin/sh. /lava-3515745/e=
nvironment
    2023-04-20T11:27:43.752683  =

    2023-04-20T11:27:43.855083  / # . /lava-3515745/environment/lava-351574=
5/bin/lava-test-runner /lava-3515745/1
    2023-04-20T11:27:43.856761  =

    2023-04-20T11:27:43.863217  / # /lava-3515745/bin/lava-test-runner /lav=
a-3515745/1
    2023-04-20T11:27:43.915758  <3>[   11.610889] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644121d6be377530802e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.178/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.178/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644121d6be377530802e85ec
        failing since 15 days (last pass: v5.10.176, first fail: v5.10.177)

    2023-04-20T11:28:09.642764  + <8>[   15.116248] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10060620_1.4.2.3.1>

    2023-04-20T11:28:09.642876  set +x

    2023-04-20T11:28:09.744776  #

    2023-04-20T11:28:09.846082  / # #export SHELL=3D/bin/sh

    2023-04-20T11:28:09.846312  =


    2023-04-20T11:28:09.947274  / # export SHELL=3D/bin/sh. /lava-10060620/=
environment

    2023-04-20T11:28:09.947513  =


    2023-04-20T11:28:10.048417  / # . /lava-10060620/environment/lava-10060=
620/bin/lava-test-runner /lava-10060620/1

    2023-04-20T11:28:10.048689  =


    2023-04-20T11:28:10.053039  / # /lava-10060620/bin/lava-test-runner /la=
va-10060620/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6441201afe890c67fe2e8618

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.178/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.178/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6441201afe890c67fe2e8=
619
        failing since 28 days (last pass: v5.10.175, first fail: v5.10.176) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a774a1-hihope-rzg2m-ex     | arm64  | lab-cip       | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6441206ac2ee345eea2e8600

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.178/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.178/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6441206ac2ee345eea2e8=
601
        new failure (last pass: v5.10.177) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64411e6404eca869962e85f6

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.178/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.178/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64411e6404eca869962e85fc
        failing since 33 days (last pass: v5.10.174, first fail: v5.10.175)

    2023-04-20T11:13:20.880021  <8>[   61.163955] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-20T11:13:21.902710  /lava-10060379/1/../bin/lava-test-case

    2023-04-20T11:13:21.913160  <8>[   62.199480] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64411e6404eca869962e85fd
        failing since 33 days (last pass: v5.10.174, first fail: v5.10.175)

    2023-04-20T11:13:20.867375  /lava-10060379/1/../bin/lava-test-case
   =

 =20
