Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D3768AC16
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 20:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbjBDTXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 14:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbjBDTXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 14:23:31 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751AC2C679
        for <stable@vger.kernel.org>; Sat,  4 Feb 2023 11:23:29 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id bx22so5192506pjb.3
        for <stable@vger.kernel.org>; Sat, 04 Feb 2023 11:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Uahn0/6IKWZVPkDikehrPAB02VG2uXS9/78I/8UVRU0=;
        b=vPw6hUl9S+7re3MncBfGnLtPZh+H48rkpY0DXhWynlqpfRE++kMSCEBGam/OYib9AZ
         WPOpDSCIcNxzDaSjCfZw87zRkwdzfT1D1IYQyxFS9OxxnRKo3+8qspXOH8z/JeB0At6x
         qpizbZz4Wc7i313VVz5/l9WduX95uUT/5a9parhTEOLwBx/KEnHni5f9UG7Rdau/UmNo
         9j9UbqycDeQdR1XnTUvMkNK2Eohi1ig+6TBzYQJNKaVb/DO60jE7lz6zQoXu5n2Sv9U8
         CmujqKbMu2fX/VXottQIuDU0z8NEo6vdQgcHWGFCbPHg7GL5bm35/KNcveTtjzyPaKZ6
         xdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uahn0/6IKWZVPkDikehrPAB02VG2uXS9/78I/8UVRU0=;
        b=etO0bIeAH7mvjzzfKmKLMbHjVrhZLYszUYtRv7+IEbt5IB+k8uZ+fq/jUbZ0ubjPFD
         N0WQdpMMgKjGn2zChdEc5jnaL2RetNGGSv5x6o6ZL9wQ1pTMhmwjR7My9zvxfsnprfeY
         vJbXgAA1QxqIvxOtEraF9qECnYmEDc4rt8x+YDnl5WmLixcYCYbWU8zQjEQwJ76cvtYR
         Rbn4+WVAKfTLesQ+7PHbNlIAaqAQs97TzS7Y4UyZLdlghm8cZeWCnUOQFfbKKirmdFqL
         mpsW/Z+qibU4QMN/gAGsvIhQrk7jMD0r/a3P+vyyUqoFjYVwL7Zm9QMHWsukMs8txe8w
         fl9Q==
X-Gm-Message-State: AO0yUKUJyHV3UHzJDcTu2S7lvpp8u1sdg4NK2yGZcI+oNaa+YqlVzXgy
        SNSKSaMSI0R0crMihEct0IuC6WBWohA+7PEu7qkAhg==
X-Google-Smtp-Source: AK7set9t9oFXy6DOAEQRZPAHKa49Pw1AAzoETPKjH9fJovUwkQz7wFYQUXt4BeHwfaaz1T1LuiK58A==
X-Received: by 2002:a17:902:e883:b0:196:f00:752b with SMTP id w3-20020a170902e88300b001960f00752bmr18010056plg.66.1675538608717;
        Sat, 04 Feb 2023 11:23:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n19-20020a170902969300b00198e03c3ad4sm3582151plp.278.2023.02.04.11.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 11:23:28 -0800 (PST)
Message-ID: <63deb0b0.170a0220.5d50a.5b4f@mx.google.com>
Date:   Sat, 04 Feb 2023 11:23:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.166-9-gd99f7f9c5a48
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 174 runs,
 3 regressions (v5.10.166-9-gd99f7f9c5a48)
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

stable-rc/queue/5.10 baseline: 174 runs, 3 regressions (v5.10.166-9-gd99f7f=
9c5a48)

Regressions Summary
-------------------

platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =

stm32mp157c-dk2              | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =

sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.166-9-gd99f7f9c5a48/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.166-9-gd99f7f9c5a48
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d99f7f9c5a480cfbebcd7049231ecf34ce94ef64 =



Test Regressions
---------------- =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63de7e15ae53e62974915ed5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gd99f7f9c5a48/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gd99f7f9c5a48/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de7e15ae53e62974915eda
        failing since 9 days (last pass: v5.10.165-76-g5c2e982fcf18, first =
fail: v5.10.165-77-g4600242c13ed)

    2023-02-04T15:47:17.279718  <8>[   10.997150] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3288182_1.5.2.4.1>
    2023-02-04T15:47:17.390217  / # #
    2023-02-04T15:47:17.493787  export SHELL=3D/bin/sh
    2023-02-04T15:47:17.494946  #
    2023-02-04T15:47:17.597528  / # export SHELL=3D/bin/sh. /lava-3288182/e=
nvironment
    2023-02-04T15:47:17.598730  =

    2023-02-04T15:47:17.701160  / # . /lava-3288182/environment/lava-328818=
2/bin/lava-test-runner /lava-3288182/1
    2023-02-04T15:47:17.703147  =

    2023-02-04T15:47:17.707590  / # /lava-3288182/bin/lava-test-runner /lav=
a-3288182/1
    2023-02-04T15:47:17.784984  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
stm32mp157c-dk2              | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63de7d80e999a2d33d915ec2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gd99f7f9c5a48/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gd99f7f9c5a48/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de7d80e999a2d33d915ec7
        failing since 2 days (last pass: v5.10.147-29-g9a9285d3dc114, first=
 fail: v5.10.165-149-ge30e8271d674)

    2023-02-04T15:44:57.701921  <8>[   12.598852] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3288185_1.5.2.4.1>
    2023-02-04T15:44:57.807833  / # #
    2023-02-04T15:44:57.909620  export SHELL=3D/bin/sh
    2023-02-04T15:44:57.910049  #
    2023-02-04T15:44:58.011464  / # export SHELL=3D/bin/sh. /lava-3288185/e=
nvironment
    2023-02-04T15:44:58.012143  =

    2023-02-04T15:44:58.113788  / # . /lava-3288185/environment/lava-328818=
5/bin/lava-test-runner /lava-3288185/1
    2023-02-04T15:44:58.114439  =

    2023-02-04T15:44:58.119023  / # /lava-3288185/bin/lava-test-runner /lav=
a-3288185/1
    2023-02-04T15:44:58.185064  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63de7d9ead907d4bd2915ecb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gd99f7f9c5a48/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-gd99f7f9c5a48/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de7d9ead907d4bd2915ed0
        failing since 2 days (last pass: v5.10.165-139-gefb57ce0f880, first=
 fail: v5.10.165-149-ge30e8271d674)

    2023-02-04T15:45:11.518163  / # #
    2023-02-04T15:45:11.619939  export SHELL=3D/bin/sh
    2023-02-04T15:45:11.620398  #
    2023-02-04T15:45:11.721751  / # export SHELL=3D/bin/sh. /lava-3288178/e=
nvironment
    2023-02-04T15:45:11.722141  =

    2023-02-04T15:45:11.823244  / # . /lava-3288178/environment/lava-328817=
8/bin/lava-test-runner /lava-3288178/1
    2023-02-04T15:45:11.823913  =

    2023-02-04T15:45:11.829409  / # /lava-3288178/bin/lava-test-runner /lav=
a-3288178/1
    2023-02-04T15:45:11.917252  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-04T15:45:11.917528  + cd /lava-3288178/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
