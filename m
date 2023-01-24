Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0F8679C5D
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 15:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbjAXOrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 09:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbjAXOrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 09:47:21 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0246BA
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 06:47:19 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m11so3299702pji.0
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 06:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=L2CidybujJ9Wzl8QwpJqMqhI9dsLVzBX3nfcXxqcfds=;
        b=x9+LWWBBRT/e8dcU7nU1F4+z8pj6URsmSSMFXVVrlJB2d7Th3rDSE+ODdq/drWCAMm
         T7nODBNVGLo8YltVUq/dSgbPGJvc2G7N6PqqVoPXBis6Zb2zYZbbIgBi2U8TZYp6a/H4
         LXivdqyB8Z3ahPwIZxCwvL69LHG0JhpoQ16IbOzTM9XmFfigcszcWnjgeqrtZnUgu1il
         q7Ewxmyym3xfQOvjQBXdd6YA689VpxP+/Bn6rvpxWtQcltU9re59NuvNtSV/g24jEHu5
         1WLqMLZgF47eEqvz0JQSGKAv/SHz+syb6qIKhREGFJmaOFyUqJC8xksRs3+GkPC/ry+Q
         a0qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L2CidybujJ9Wzl8QwpJqMqhI9dsLVzBX3nfcXxqcfds=;
        b=KJKZsVEXLCDQ2bhlcWB7KgXek1poZzORm768FdxTKSpG/ER6iSK1nJDRtuiraP9VRY
         KeKih+tqE9Bqiow20TZfSldaO1x8aTmxOtwcQekArdS2YZbY0aVdJ+fbAnjuOh8LpQIQ
         MhpvWSi67nhP//Yd4KIqMWcRxr9txaqpCo/FZJ8pk89sr9y7xFVZoacDuypZzXu7g6Xt
         ZvTR3Rq9LDXLYjYxGdEt3Tw8E9WV2Dr+6tjKIoNnwqzPbuHBy3r2bLCbrWd7Ad/Z8kHA
         AJF4L5IyhSN3uKFH5Z9yGIbbH6xxgRgqL0n4OEruyIUzQhS1FOvbqNDLIyis9TFz4lQR
         e/Yw==
X-Gm-Message-State: AFqh2kqeFbJ1yNNw6BtVEyt+LuwUuHH0BlEtqbxQJL27Zhd7PXqvQgib
        LAMvBHz6OgtaZbXe6XIXbSY3RS6rS6Jd9s6/Kw0=
X-Google-Smtp-Source: AMrXdXtJ2+t2ftI8dw/bKpFB2BLArHFkx2wJ/J0PJiWPViQJW3aI2TbI2zl/EY06xr1ls0xgwOHPDg==
X-Received: by 2002:a17:902:8a98:b0:194:9c0d:9732 with SMTP id p24-20020a1709028a9800b001949c0d9732mr28278165plo.46.1674571638984;
        Tue, 24 Jan 2023 06:47:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18-20020a170902ea9200b00194706d3f25sm1292767plb.144.2023.01.24.06.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 06:47:18 -0800 (PST)
Message-ID: <63cfef76.170a0220.d9ad5.1aa8@mx.google.com>
Date:   Tue, 24 Jan 2023 06:47:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.165
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 181 runs, 5 regressions (v5.10.165)
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

stable/linux-5.10.y baseline: 181 runs, 5 regressions (v5.10.165)

Regressions Summary
-------------------

platform               | arch | lab          | compiler | defconfig        =
   | regressions
-----------------------+------+--------------+----------+------------------=
---+------------
beagle-xm              | arm  | lab-baylibre | gcc-10   | omap2plus_defconf=
ig | 1          =

cubietruck             | arm  | lab-baylibre | gcc-10   | multi_v7_defconfi=
g  | 1          =

r8a7743-iwg20d-q7      | arm  | lab-cip      | gcc-10   | shmobile_defconfi=
g  | 1          =

sun8i-a83t-bananapi-m3 | arm  | lab-clabbe   | gcc-10   | multi_v7_defconfi=
g  | 1          =

sun8i-a83t-bananapi-m3 | arm  | lab-clabbe   | gcc-10   | sunxi_defconfig  =
   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.165/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.165
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      179624a57b78c02de833370b7bdf0b0f4a27ca31 =



Test Regressions
---------------- =



platform               | arch | lab          | compiler | defconfig        =
   | regressions
-----------------------+------+--------------+----------+------------------=
---+------------
beagle-xm              | arm  | lab-baylibre | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfb8c5cb7be44d73915ee6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.165/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.165/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfb8c5cb7be44d73915=
ee7
        new failure (last pass: v5.10.161) =

 =



platform               | arch | lab          | compiler | defconfig        =
   | regressions
-----------------------+------+--------------+----------+------------------=
---+------------
cubietruck             | arm  | lab-baylibre | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfbb22bddc4a5008915ee6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.165/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.165/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfbb22bddc4a5008915eeb
        failing since 5 days (last pass: v5.10.158, first fail: v5.10.164)

    2023-01-24T11:03:35.399989  <8>[   11.019193] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3198151_1.5.2.4.1>
    2023-01-24T11:03:35.506722  / # #
    2023-01-24T11:03:35.608423  export SHELL=3D/bin/sh
    2023-01-24T11:03:35.608840  #
    2023-01-24T11:03:35.710103  / # export SHELL=3D/bin/sh. /lava-3198151/e=
nvironment
    2023-01-24T11:03:35.710524  =

    2023-01-24T11:03:35.811839  / # . /lava-3198151/environment/lava-319815=
1/bin/lava-test-runner /lava-3198151/1
    2023-01-24T11:03:35.812550  =

    2023-01-24T11:03:35.817891  / # /lava-3198151/bin/lava-test-runner /lav=
a-3198151/1
    2023-01-24T11:03:35.829139  <3>[   11.450331] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform               | arch | lab          | compiler | defconfig        =
   | regressions
-----------------------+------+--------------+----------+------------------=
---+------------
r8a7743-iwg20d-q7      | arm  | lab-cip      | gcc-10   | shmobile_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfb5a6931dd03fa7915f2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.165/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.165/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfb5a6931dd03fa7915=
f2c
        failing since 5 days (last pass: v5.10.163, first fail: v5.10.164) =

 =



platform               | arch | lab          | compiler | defconfig        =
   | regressions
-----------------------+------+--------------+----------+------------------=
---+------------
sun8i-a83t-bananapi-m3 | arm  | lab-clabbe   | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfba88320fbe5e7e915ec4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.165/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.165/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfba88320fbe5e7e915ec7
        failing since 19 days (last pass: v5.10.143, first fail: v5.10.162)

    2023-01-24T11:01:18.982248  / # #
    2023-01-24T11:01:19.087102  export SHELL=3D/bin/sh
    2023-01-24T11:01:19.087833  #
    2023-01-24T11:01:19.189423  / # export SHELL=3D/bin/sh. /lava-384760/en=
vironment
    2023-01-24T11:01:19.190192  =

    2023-01-24T11:01:19.292131  / # . /lava-384760/environment/lava-384760/=
bin/lava-test-runner /lava-384760/1
    2023-01-24T11:01:19.293402  =

    2023-01-24T11:01:19.299951  / # /lava-384760/bin/lava-test-runner /lava=
-384760/1
    2023-01-24T11:01:19.416172  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-24T11:01:19.416531  + cd /lava-384760/1/tests/1_bootrr =

    ... (17 line(s) more)  =

 =



platform               | arch | lab          | compiler | defconfig        =
   | regressions
-----------------------+------+--------------+----------+------------------=
---+------------
sun8i-a83t-bananapi-m3 | arm  | lab-clabbe   | gcc-10   | sunxi_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfb61448654d02bf915ece

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.165/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.165/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfb61448654d02bf915ed1
        failing since 19 days (last pass: v5.10.143, first fail: v5.10.162)

    2023-01-24T10:42:20.117013  [   12.958830] <LAVA_SIGNAL_ENDRUN 0_dmesg =
384741_1.5.2.4.1>
    2023-01-24T10:42:20.222388  / # #
    2023-01-24T10:42:20.324416  export SHELL=3D/bin/sh
    2023-01-24T10:42:20.325081  #
    2023-01-24T10:42:20.426703  / # export SHELL=3D/bin/sh. /lava-384741/en=
vironment
    2023-01-24T10:42:20.427336  =

    2023-01-24T10:42:20.528976  / # . /lava-384741/environment/lava-384741/=
bin/lava-test-runner /lava-384741/1
    2023-01-24T10:42:20.530087  =

    2023-01-24T10:42:20.546079  / # /lava-384741/bin/lava-test-runner /lava=
-384741/1
    2023-01-24T10:42:20.610273  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
