Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D662A689A89
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 14:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjBCNzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 08:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbjBCNyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 08:54:49 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A801F92D
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 05:53:14 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o13so5081672pjg.2
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 05:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HMN/O3/LxxzqfJHv/XEJ7Oa8asyo0UplzQ0CpioRBvc=;
        b=NXFj5XOqOq0vI6U3OpubZ/AlyrNjIMEtkKEC22wdnmtsCWJhBXWNjUmCslPMOZhw9Y
         H8L5haGMpk5czuukcc/ukOV8CXmpcmR4j23SOScr98NbVtzvB3KMdLtnS8BogeVMaDpl
         CbeAqROC3R5DT2a6srPTvq4LdK+7mKQ328AbYNCAtXc1Snh8OuZ/shSpUn49H6pqDMKZ
         qfBMhE1/OhEh4wrxFPtEvHhqV2RjixFVmFStW1DthxeSDW9ln9uG+Wtm+JJ8AYmVTZfy
         NFJac0SmZiithk6CZIUbXOvs/d5JDyOZAgXcY+OF36t6epw5URV0NigjMY897YtkDviC
         URgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HMN/O3/LxxzqfJHv/XEJ7Oa8asyo0UplzQ0CpioRBvc=;
        b=26G1vYgUuKjORxMeIHXcK/j7Q+KuMFTxgnANNxAa0bgzNtCcnEetAOLUHkQxVypUaG
         OURVZZNtWF/h+e5U5Ulle4IzmKWWRPBwYzL4oypTjVPylFcS31zllxNGQEIQNYR2pFsM
         MPfCobMFfH3eOsGxbl5KPhEn9SSaWV1O3CFFiYGTjrQHSzblZrPTnFsT1HHCtXfz1quG
         eF+hYWuMZUWnPsj/csE8HgZb8sE0Y3dnTAomn/sTN831/iYURNb0/R+FGQo5l1jJG+UK
         iF8e2xSwlzuq6sZFo2z+sOAm8SWR8JcaWx6AztOED4OkHjRkFTb4VZ7DWLN67F6f11GR
         Uwzw==
X-Gm-Message-State: AO0yUKVOFKmzfeYeiu0UgJ0M5LSUoTEWqkrIfdH/l4anTHuIwn2L6URz
        0hbHrP3+G9eTh+o3N9HQBf5xcsuwrXfv/e9WTrw=
X-Google-Smtp-Source: AK7set9XjkuFcNDXTlGUWDLd+HFjSxDS65ZO44UuuD1YqwHbeCw7YRgiCeEU9PfN5XFYRT9RLy5JaA==
X-Received: by 2002:a17:903:32c3:b0:196:a07d:7a9c with SMTP id i3-20020a17090332c300b00196a07d7a9cmr11635884plr.28.1675432391489;
        Fri, 03 Feb 2023 05:53:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id je6-20020a170903264600b001899c2a0ae0sm490793plb.40.2023.02.03.05.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 05:53:11 -0800 (PST)
Message-ID: <63dd11c7.170a0220.28aee.0c58@mx.google.com>
Date:   Fri, 03 Feb 2023 05:53:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.91-18-ga7afd81d41cb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 179 runs,
 6 regressions (v5.15.91-18-ga7afd81d41cb)
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

stable-rc/queue/5.15 baseline: 179 runs, 6 regressions (v5.15.91-18-ga7afd8=
1d41cb)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =

cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =

stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.91-18-ga7afd81d41cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.91-18-ga7afd81d41cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a7afd81d41cbe7703ff4090a920d7ec479a441e4 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcddcd0b028c76c5915ed6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcddcd0b028c76c5915=
ed7
        new failure (last pass: v5.15.91-12-g3290f78df1ab) =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcdd03f4de95dda2915ec0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcdd03f4de95dda2915ec5
        failing since 17 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-03T10:07:35.043291  + set +x<8>[    9.967668] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3280445_1.5.2.4.1>
    2023-02-03T10:07:35.043569  =

    2023-02-03T10:07:35.150266  / # #
    2023-02-03T10:07:35.252008  export SHELL=3D/bin/sh
    2023-02-03T10:07:35.252436  #
    2023-02-03T10:07:35.353746  / # export SHELL=3D/bin/sh. /lava-3280445/e=
nvironment
    2023-02-03T10:07:35.354200  =

    2023-02-03T10:07:35.354434  / # . /lava-3280445/environment<3>[   10.27=
3652] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-02-03T10:07:35.455697  /lava-3280445/bin/lava-test-runner /lava-32=
80445/1
    2023-02-03T10:07:35.456299   =

    ... (13 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcdcc0a14d1619df915ed7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcdcc0a14d1619df915edc
        failing since 6 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-02-03T10:06:33.773374  + set +x
    2023-02-03T10:06:33.773616  [    9.335917] <LAVA_SIGNAL_ENDRUN 0_dmesg =
897031_1.5.2.3.1>
    2023-02-03T10:06:33.881400  / # #
    2023-02-03T10:06:33.983070  export SHELL=3D/bin/sh
    2023-02-03T10:06:33.983727  #
    2023-02-03T10:06:34.085015  / # export SHELL=3D/bin/sh. /lava-897031/en=
vironment
    2023-02-03T10:06:34.085629  =

    2023-02-03T10:06:34.186965  / # . /lava-897031/environment/lava-897031/=
bin/lava-test-runner /lava-897031/1
    2023-02-03T10:06:34.187755  =

    2023-02-03T10:06:34.190784  / # /lava-897031/bin/lava-test-runner /lava=
-897031/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcdcc4a14d1619df915ee9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcdcc4a14d1619df915eee
        failing since 1 day (last pass: v5.15.72-36-g3886958cda706, first f=
ail: v5.15.90-215-gdf99871482a0)

    2023-02-03T10:06:48.751973  <8>[   11.685759] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3280438_1.5.2.4.1>
    2023-02-03T10:06:48.858896  / # #
    2023-02-03T10:06:48.961070  export SHELL=3D/bin/sh
    2023-02-03T10:06:48.961831  #
    2023-02-03T10:06:49.063894  / # export SHELL=3D/bin/sh. /lava-3280438/e=
nvironment
    2023-02-03T10:06:49.064524  =

    2023-02-03T10:06:49.166216  / # . /lava-3280438/environment/lava-328043=
8/bin/lava-test-runner /lava-3280438/1
    2023-02-03T10:06:49.167633  =

    2023-02-03T10:06:49.172011  / # /lava-3280438/bin/lava-test-runner /lav=
a-3280438/1
    2023-02-03T10:06:49.237959  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63dce128ae4c06e34a915edc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dce128ae4c06e34a915ee1
        failing since 16 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-03T10:25:20.164198  + set +x
    2023-02-03T10:25:20.168294  <8>[   16.109408] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3280494_1.5.2.4.1>
    2023-02-03T10:25:20.288513  / # #
    2023-02-03T10:25:20.394094  export SHELL=3D/bin/sh
    2023-02-03T10:25:20.395663  #
    2023-02-03T10:25:20.499027  / # export SHELL=3D/bin/sh. /lava-3280494/e=
nvironment
    2023-02-03T10:25:20.500542  =

    2023-02-03T10:25:20.604013  / # . /lava-3280494/environment/lava-328049=
4/bin/lava-test-runner /lava-3280494/1
    2023-02-03T10:25:20.606686  =

    2023-02-03T10:25:20.610042  / # /lava-3280494/bin/lava-test-runner /lav=
a-3280494/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcdf2e54c727889c915ecb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pin=
e64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
18-ga7afd81d41cb/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pin=
e64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcdf2e54c727889c915ed0
        failing since 16 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-03T10:17:06.702578  <8>[   16.013444] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 243246_1.5.2.4.1>
    2023-02-03T10:17:06.815386  / # #
    2023-02-03T10:17:06.918156  export SHELL=3D/bin/sh
    2023-02-03T10:17:06.918733  #
    2023-02-03T10:17:07.020783  / # export SHELL=3D/bin/sh. /lava-243246/en=
vironment
    2023-02-03T10:17:07.021524  =

    2023-02-03T10:17:07.123546  / # . /lava-243246/environment/lava-243246/=
bin/lava-test-runner /lava-243246/1
    2023-02-03T10:17:07.124613  =

    2023-02-03T10:17:07.128933  / # /lava-243246/bin/lava-test-runner /lava=
-243246/1
    2023-02-03T10:17:07.174392  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
