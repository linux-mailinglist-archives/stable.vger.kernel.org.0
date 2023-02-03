Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE746689162
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 08:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbjBCH6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 02:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbjBCH6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 02:58:07 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DCDC2
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 23:58:06 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id mi9so4257171pjb.4
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 23:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MvILLGq4jeIR5DO+BvP3jugrvdk2ERCURhEJIX7WOrc=;
        b=lLVNHSAI5DWR5PdFPlgC0R+lnkNSLgeDQyWcB/F/t+kaFWYjFT2Bo3jlMxuwG4AyIK
         DnR3oxJJ3KsqP44MIr46PhnexGkDeij6QGxN65fpUKJoSykUpDawAj9MTysQsu5j6SKC
         Tax1sr7C8BuLjE2pzznEm7cRzQ69Z0+/OEFv0L94wJg14ZxWt+aJNpGs77/RJRSWUKeF
         VN2Gpu/dtT4iK1Z14NdVFtrCHWjg6iSJvDi5c8EBC3CrKCUx/VyFFpD7FRkduuCGexIw
         zzQ3rGVUg45vXCXrccd+4wc4G6OsCEFOB9QshQkYTIkCTfDjM4LyDWMhqWpSXRvb8TrB
         JWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MvILLGq4jeIR5DO+BvP3jugrvdk2ERCURhEJIX7WOrc=;
        b=huW4Ex89LALK1VDET75mVa0UqAoBd4BeZSFr/8PqHPrl2odOQ+J60D9yn3XyzHBbAT
         7HFsGXpYnBAqsgVVL3RWfVCVO6sg8YDO6fVxbymmTrY+Y6qRWLczqftmTvMolmSbN78K
         yL+KChvh/fyameDcwJjb6HEn95gISjKLR55J+HGtap9MN3B+FKlaomafuPnbJiqZMtwG
         21DmRKgf8ksv+O1w1oxYvoymbH37ffjgyuuP+xyqM817ZMPskfaTd4zj2gy/bfBnCvoB
         vZrBxWn2tvyF7q/P3d6GW4lHOSqtse2itEkIIoLEW6mGSuK6cHsZOatZP5Nz6M0Ic/l5
         ritw==
X-Gm-Message-State: AO0yUKV5gFl4jypGjCOJxLULn3ZR1iokuo/oqoYzPxYAvcfTLVIitbNn
        E/QOZwgStrt9dOff5Q8Aay9uk/55cXKW6dIevQ0qNA==
X-Google-Smtp-Source: AK7set+WkdxUYUmYi2uM6S2/2/gtY/CdR3o+ME8QKpa93nffgOM2FJq2bXXsTW86IEZfJnMpPQmZxA==
X-Received: by 2002:a17:902:e3d5:b0:196:7b8f:e6bd with SMTP id r21-20020a170902e3d500b001967b8fe6bdmr2881357ple.24.1675411085467;
        Thu, 02 Feb 2023 23:58:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902edd100b001896522a23bsm953869plk.39.2023.02.02.23.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 23:58:05 -0800 (PST)
Message-ID: <63dcbe8d.170a0220.f2226.1bb6@mx.google.com>
Date:   Thu, 02 Feb 2023 23:58:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.166-6-g538645e35f86
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 152 runs,
 3 regressions (v5.10.166-6-g538645e35f86)
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

stable-rc/queue/5.10 baseline: 152 runs, 3 regressions (v5.10.166-6-g538645=
e35f86)

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
nel/v5.10.166-6-g538645e35f86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.166-6-g538645e35f86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      538645e35f868ded0ab85fe750afdd264744970a =



Test Regressions
---------------- =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dc8d823d5efff229915ece

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-6-g538645e35f86/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-6-g538645e35f86/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dc8d823d5efff229915ed3
        failing since 7 days (last pass: v5.10.165-76-g5c2e982fcf18, first =
fail: v5.10.165-77-g4600242c13ed)

    2023-02-03T04:28:35.989053  <8>[   10.967319] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3279531_1.5.2.4.1>
    2023-02-03T04:28:36.096622  / # #
    2023-02-03T04:28:36.198339  export SHELL=3D/bin/sh
    2023-02-03T04:28:36.198784  #
    2023-02-03T04:28:36.300082  / # export SHELL=3D/bin/sh. /lava-3279531/e=
nvironment
    2023-02-03T04:28:36.300540  =

    2023-02-03T04:28:36.401763  / # . /lava-3279531/environment/lava-327953=
1/bin/lava-test-runner /lava-3279531/1
    2023-02-03T04:28:36.402486  <3>[   11.291914] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-02-03T04:28:36.402703  =

    2023-02-03T04:28:36.407622  / # /lava-3279531/bin/lava-test-runner /lav=
a-3279531/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
stm32mp157c-dk2              | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dc8c6a47673084a2915ec2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-6-g538645e35f86/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-6-g538645e35f86/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dc8c6a47673084a2915ec7
        failing since 1 day (last pass: v5.10.147-29-g9a9285d3dc114, first =
fail: v5.10.165-149-ge30e8271d674)

    2023-02-03T04:24:05.775211  <8>[   12.622254] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3279527_1.5.2.4.1>
    2023-02-03T04:24:05.882195  / # #
    2023-02-03T04:24:05.984569  export SHELL=3D/bin/sh
    2023-02-03T04:24:05.985111  #
    2023-02-03T04:24:06.086710  / # export SHELL=3D/bin/sh. /lava-3279527/e=
nvironment
    2023-02-03T04:24:06.087240  =

    2023-02-03T04:24:06.188677  / # . /lava-3279527/environment/lava-327952=
7/bin/lava-test-runner /lava-3279527/1
    2023-02-03T04:24:06.189502  =

    2023-02-03T04:24:06.193307  / # /lava-3279527/bin/lava-test-runner /lav=
a-3279527/1
    2023-02-03T04:24:06.260468  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dc8c85ab4a8ebcdc915ec6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-6-g538645e35f86/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-6-g538645e35f86/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dc8c85ab4a8ebcdc915ecb
        failing since 1 day (last pass: v5.10.165-139-gefb57ce0f880, first =
fail: v5.10.165-149-ge30e8271d674)

    2023-02-03T04:24:26.555052  <8>[    7.395130] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3279515_1.5.2.4.1>
    2023-02-03T04:24:26.673512  / # #
    2023-02-03T04:24:26.775789  export SHELL=3D/bin/sh
    2023-02-03T04:24:26.776348  #
    2023-02-03T04:24:26.877748  / # export SHELL=3D/bin/sh. /lava-3279515/e=
nvironment
    2023-02-03T04:24:26.878341  =

    2023-02-03T04:24:26.979780  / # . /lava-3279515/environment/lava-327951=
5/bin/lava-test-runner /lava-3279515/1
    2023-02-03T04:24:26.980794  =

    2023-02-03T04:24:26.985664  / # /lava-3279515/bin/lava-test-runner /lav=
a-3279515/1
    2023-02-03T04:24:27.049824  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
