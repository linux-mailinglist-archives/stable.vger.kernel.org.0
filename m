Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E946E6CF6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 21:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbjDRTeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 15:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbjDRTeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 15:34:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9AAA26F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:34:12 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-2472a3bfd23so1392612a91.3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681846451; x=1684438451;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5deqqWMroTKOfZZNDtVcrWbW/HZ1P4hnV+8MNVg/u48=;
        b=iY0G6JHz5qiARX6fmYHo5ksCAZnmZZhxuv1WH8cNmnRifPHzBA3RTrwmJxSAVFdTEE
         C/siipyNHJTRRkUXObwrzk7fqeBWF9R7zyJ3t2o/1kh+4aBdBO/ICl/mBSRX3zTV9a0X
         ipedpMiOvJCmgXmYoJNhhJmN0SKS0BYVShJmfjx1FFbh+VD/SOu51uAYTXYv8acd7154
         4h60b+d0f3dioGIWpkqZSNMydYLOY7QGqhZqjgV8m/JeaSq6fJEcDxvh2NW/W044EVEP
         i51emEQzGg3EXgR9NrXwcLEjbRUEonAFzuKNqcUt2sQS9O+HMrc1utuNTV+qSnH9f6M/
         j4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681846451; x=1684438451;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5deqqWMroTKOfZZNDtVcrWbW/HZ1P4hnV+8MNVg/u48=;
        b=kwRxtrIPnklv4dTqHl+goAHuzT8U/2BKI9TVLbDjgOJUlJn2L4iQM97EUIjV8wU6ub
         oVMUX0XkHc5WNvIqDLUQk3kzAGEpwENPrDeZU9KsaJ5pVq2QwPBK0YMKyiHpBGBl1Zzv
         tuw9h4D+xGNyB4piOJdF4DnN2Vdj8SOTkNZkk/Gm0iSvvT/vLExdjqlGOw4h0t+xY3ap
         fC+CchTDeS27EH0Vu37llGazvC+qWS33BVItMO+bGsZh53bYA6ctxj/uWIc2I7PedNAs
         UYz/d7p+kKGiVThoPQpU8glZD+oIY2YOM2xASVZFRzDr8pefaUwUvcf5lVlt/hQBXgd9
         f17g==
X-Gm-Message-State: AAQBX9dhRtYhlfclcM04jpTMbqZ/qR/uUw1zlUBqjj27slKUg/77z56O
        2SzMd3Vbt+U8gMffmxObtomwKADA0FTYqd0gK54H3b39
X-Google-Smtp-Source: AKy350bcenZpgLnUN1dp9y4QfhAqduechbY11qSITDwVFAbHQ4AaGgVVn3wY2oIAuiWn378WoHALYQ==
X-Received: by 2002:a17:90a:448c:b0:247:1de8:8263 with SMTP id t12-20020a17090a448c00b002471de88263mr750212pjg.4.1681846451414;
        Tue, 18 Apr 2023 12:34:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902aa4600b001a221d14179sm9804207plr.302.2023.04.18.12.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 12:34:11 -0700 (PDT)
Message-ID: <643ef0b3.170a0220.f6c0e.5a5e@mx.google.com>
Date:   Tue, 18 Apr 2023 12:34:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-297-gc0ed808650c3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 76 runs,
 2 regressions (v5.10.176-297-gc0ed808650c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 76 runs, 2 regressions (v5.10.176-297-gc0ed8=
08650c3)

Regressions Summary
-------------------

platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =

sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-297-gc0ed808650c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-297-gc0ed808650c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c0ed808650c3637b7892c5d89139a658bdf7b7bc =



Test Regressions
---------------- =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebb9a2f595b1bef2e85e6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-297-gc0ed808650c3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-297-gc0ed808650c3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ebb9a2f595b1bef2e85eb
        failing since 82 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-18T15:47:18.292826  <8>[   11.035339] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3508252_1.5.2.4.1>
    2023-04-18T15:47:18.400148  / # #
    2023-04-18T15:47:18.501838  export SHELL=3D/bin/sh
    2023-04-18T15:47:18.502214  #
    2023-04-18T15:47:18.502389  / # export SHELL=3D/bin/sh<3>[   11.211062]=
 Bluetooth: hci0: command 0xfc18 tx timeout
    2023-04-18T15:47:18.603564  . /lava-3508252/environment
    2023-04-18T15:47:18.603952  =

    2023-04-18T15:47:18.705200  / # . /lava-3508252/environment/lava-350825=
2/bin/lava-test-runner /lava-3508252/1
    2023-04-18T15:47:18.705813  =

    2023-04-18T15:47:18.710393  / # /lava-3508252/bin/lava-test-runner /lav=
a-3508252/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebb820b43d902622e8607

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-297-gc0ed808650c3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-297-gc0ed808650c3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ebb820b43d902622e860c
        failing since 75 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-18T15:46:52.971911  / # #
    2023-04-18T15:46:53.074118  export SHELL=3D/bin/sh
    2023-04-18T15:46:53.074647  #
    2023-04-18T15:46:53.176061  / # export SHELL=3D/bin/sh. /lava-3508265/e=
nvironment
    2023-04-18T15:46:53.176588  =

    2023-04-18T15:46:53.277996  / # . /lava-3508265/environment/lava-350826=
5/bin/lava-test-runner /lava-3508265/1
    2023-04-18T15:46:53.278758  =

    2023-04-18T15:46:53.283064  / # /lava-3508265/bin/lava-test-runner /lav=
a-3508265/1
    2023-04-18T15:46:53.346851  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-18T15:46:53.381527  + cd /lava-3508265/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
