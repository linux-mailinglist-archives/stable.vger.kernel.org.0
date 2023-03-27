Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A444E6CA9B9
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 17:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjC0P6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 11:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbjC0P6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 11:58:06 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D895A3A8F
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:58:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id ja10so8863189plb.5
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679932684;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MtmnXfqxvTp8b7u84DOHgJz7gYMWz8Oc0qilY8dluVA=;
        b=NBvbsZBlpt2qgiRf0cgglu7l2btWHQfPgatpZrr0N77TtnNm984Ixf4HEGJPNFRDhn
         OVJ4134Lwld/et2ItkExBBGW+e7mCy1xKzCHMUxnkbQFAPExn2W57rgfIlyXzSV9SrXn
         sNjT06Fhc2J3OcY94ehm4LF9voN6fVTRpxz+idRt2CLuwQGsb4TS2itfLM8Vfs0//JXr
         f67E3ZSAb67v/vY3fu9DAUyIRgpkM5wg3x55cB2X98mfy5qXp5czgtvEGOW0F1dieb4A
         fLZaK2G3NE3wKr+w50PXUUhSqBZseAHqxeKgq56F4lQzhPPckBNugJY4PtqY1DQiPSDg
         hMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679932684;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MtmnXfqxvTp8b7u84DOHgJz7gYMWz8Oc0qilY8dluVA=;
        b=ZZCv7x9sLaxSE1nTrEGz7nbdl+vmuxlgkIUwBQU0B6MdgGWb4XVkYy2etjEe5UdAH4
         Idsc9crqi0paO7SaRsnFlxGVmOfxQXgCXPmHjZwxusEcCIbQ7Wq047x1zqDpIgzCceIu
         sxQ50WXoErnMqfCr0VXF5i9SrpcyATfRCywUhivoWS9Csdj4pYBYyD4xRN+yC8xGa5Nd
         jQ7Aa17eAOqCU4zU7svVFOzC0zC1iZ6A57j2wAZHIcKF/EjE6M7kqa+fvqpQdcSRaXYs
         Zf8bExxUCCC5OjfL3snhNVcEtUdGMXzrwq0N/aeJQTlswLbGWguX4cHGFbCl7W5KH6Pi
         jFuA==
X-Gm-Message-State: AAQBX9f5bvw6+yklSerNDWb6Lvp4NqIWuqIUXwe+bl/1r38qJrfOJ5sa
        RGpcGeRcwaFepuXDETFiLDqIi/kXzjCbdxFO5MZ8cg==
X-Google-Smtp-Source: AKy350YP/Ib2AeH3Vmeox9/bl4S6XFkvO/5kPHin6ZIGPxysREwba6kffo6inIiQUi+14nbxtaN2Mg==
X-Received: by 2002:a17:90b:314e:b0:23d:286:47d3 with SMTP id ip14-20020a17090b314e00b0023d028647d3mr13875904pjb.40.1679932683706;
        Mon, 27 Mar 2023 08:58:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mn13-20020a17090b188d00b002372106a5casm7717926pjb.44.2023.03.27.08.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:58:03 -0700 (PDT)
Message-ID: <6421bd0b.170a0220.6c8c0.d375@mx.google.com>
Date:   Mon, 27 Mar 2023 08:58:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.238-29-g39c31e43e3b2b
Subject: stable-rc/queue/5.4 baseline: 120 runs,
 3 regressions (v5.4.238-29-g39c31e43e3b2b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 120 runs, 3 regressions (v5.4.238-29-g39c31e4=
3e3b2b)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
cubietruck                   | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =

hifive-unleashed-a00         | riscv | lab-baylibre | gcc-10   | defconfig =
         | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.238-29-g39c31e43e3b2b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.238-29-g39c31e43e3b2b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39c31e43e3b2b8f6c1df6976c97d96a9b707aa94 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
cubietruck                   | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/642181daf25d6123749c9505

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
9-g39c31e43e3b2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
9-g39c31e43e3b2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642181daf25d6123749c950e
        failing since 55 days (last pass: v5.4.230-81-g2ad0dc06d587, first =
fail: v5.4.230-108-g761a8268d868)

    2023-03-27T11:45:12.708725  <8>[    9.899705] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3449208_1.5.2.4.1>
    2023-03-27T11:45:12.818853  / # #
    2023-03-27T11:45:12.922635  export SHELL=3D/bin/sh
    2023-03-27T11:45:12.922976  #
    2023-03-27T11:45:13.024094  / # export SHELL=3D/bin/sh. /lava-3449208/e=
nvironment
    2023-03-27T11:45:13.024518  =

    2023-03-27T11:45:13.125737  / # . /lava-3449208/environment/lava-344920=
8/bin/lava-test-runner /lava-3449208/1
    2023-03-27T11:45:13.126257  =

    2023-03-27T11:45:13.131242  / # /lava-3449208/bin/lava-test-runner /lav=
a-3449208/1
    2023-03-27T11:45:13.208719  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
hifive-unleashed-a00         | riscv | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/642184314b5fff6a0d9c9505

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
9-g39c31e43e3b2b/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
9-g39c31e43e3b2b/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/642184314b5fff6a=
0d9c950a
        failing since 159 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-03-27T11:55:13.394890  / # =

    2023-03-27T11:55:13.406409  =

    2023-03-27T11:55:13.508901  / # #
    2023-03-27T11:55:13.518406  #
    2023-03-27T11:55:13.619734  / # export SHELL=3D/bin/sh
    2023-03-27T11:55:13.630386  export SHELL=3D/bin/sh
    2023-03-27T11:55:13.731557  / # . /lava-3449243/environment
    2023-03-27T11:55:13.742408  . /lava-3449243/environment
    2023-03-27T11:55:13.843658  / # /lava-3449243/bin/lava-test-runner /lav=
a-3449243/0
    2023-03-27T11:55:13.854619  /lava-3449243/bin/lava-test-runner /lava-34=
49243/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/642181828774b0430f9c9514

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
9-g39c31e43e3b2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
9-g39c31e43e3b2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642181828774b0430f9c951d
        failing since 54 days (last pass: v5.4.230-108-g761a8268d868, first=
 fail: v5.4.230-109-g0a6085bff265)

    2023-03-27T11:43:37.530081  / # #
    2023-03-27T11:43:37.631838  export SHELL=3D/bin/sh
    2023-03-27T11:43:37.632207  #
    2023-03-27T11:43:37.733539  / # export SHELL=3D/bin/sh. /lava-3449215/e=
nvironment
    2023-03-27T11:43:37.733916  =

    2023-03-27T11:43:37.835300  / # . /lava-3449215/environment/lava-344921=
5/bin/lava-test-runner /lava-3449215/1
    2023-03-27T11:43:37.836021  =

    2023-03-27T11:43:37.841123  / # /lava-3449215/bin/lava-test-runner /lav=
a-3449215/1
    2023-03-27T11:43:37.928959  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-27T11:43:37.929268  + cd /lava-3449215/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
