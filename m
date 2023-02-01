Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04126870CE
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 23:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjBAWEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 17:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBAWEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 17:04:53 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5F76A73D
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 14:04:51 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cq16-20020a17090af99000b0022c9791ac39so3683235pjb.4
        for <stable@vger.kernel.org>; Wed, 01 Feb 2023 14:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mqNmfFxYwb/7qnCYEVYY/Cp3q4yJ0UxY4pjCSIcKuew=;
        b=pU9kHNkXXQmEWdw23hCejBV4RSKI9KRVRDazLhx08cmdq3zeVljc6FZRMdhz87J1Hc
         KPh4Wj8cP40q/qdPbJltdQk/DNcHFnJotOuCwXe1K7k8Dk1LxqDV0HKKksOVnOxdxiuH
         OudOeB71OpKZgC3kXz0heKS6Qp3yM7uCoXYtijnRWRMtcskTrHzxsPNVTdUTbocjMHmS
         0TzZi4grRGGNbI4qOeIyU8zlORwFQafsDtUrI3MDrVSZQoUyYzPnBmrtOOW2zSdu3M13
         b54CpXluAgxS+l6eF90zjHKWww0oL3Xbh5iRertRk+uCsZqf/QSvW5OhYADP6UreVRxh
         GIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mqNmfFxYwb/7qnCYEVYY/Cp3q4yJ0UxY4pjCSIcKuew=;
        b=GjDikVQ2L+bkTYPW1Ba4KF6x+Ksjn0E6ULoRAdnF/UDlSPPooG54nR8BlprnFX/l+p
         3SYQXmz2jEM/iT+StUoX020iq5TsMDQ4Ne/YQwyW92jWMN8PaxNwRfzpHjgm2NZVN1hu
         NUScDUNW91bCVrPmfuqiyrN1SIofS8SabV3GuGan9+IImZ0MHyXtCl4vHqWGrQlRQrSE
         MtQJLTdGAUavtR4Z+jsLeoCwsmmtbkaA8wSjKQfVj9PzT62T4aR/drGk4b6ytUWA+hZB
         m8wsEAg7YUP9OTkgqq0rJTHZb0gbqo5MAtvfmcQoDjAZun6ju2ozk1ppTdVZHmRtgmxD
         wHUg==
X-Gm-Message-State: AO0yUKVHAaSi4Z5gC+kGsXMLEc9pHqLY2lDHmcEZbzBfuxZ6m5Eb21p/
        T2H15NkwvmgWhjHV7VasJ+VcQxcxt7M6WQILFo/X0w==
X-Google-Smtp-Source: AK7set88iv8v7obCTFL9/y7At/G3vVMhjUAh6hogVO/Th286lskg326REJsqfdbjivo3dS+R7kVbmQ==
X-Received: by 2002:a17:902:da92:b0:196:6226:94c3 with SMTP id j18-20020a170902da9200b00196622694c3mr5368334plx.7.1675289091006;
        Wed, 01 Feb 2023 14:04:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f11-20020a170902ce8b00b00172cb8b97a8sm12287773plg.5.2023.02.01.14.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 14:04:50 -0800 (PST)
Message-ID: <63dae202.170a0220.53cce.7082@mx.google.com>
Date:   Wed, 01 Feb 2023 14:04:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-215-gdf99871482a0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 123 runs,
 6 regressions (v5.15.90-215-gdf99871482a0)
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

stable-rc/queue/5.15 baseline: 123 runs, 6 regressions (v5.15.90-215-gdf998=
71482a0)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =

rk3328-rock64          | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-215-gdf99871482a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-215-gdf99871482a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      df99871482a0a41a1eb3cb2cc1fdc163cc57ac19 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63daadb929661ebeb0915eba

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63daadb929661ebeb0915ebf
        failing since 15 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-01T18:21:28.952899  <8>[    9.945229] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3266420_1.5.2.4.1>
    2023-02-01T18:21:29.060977  / # #
    2023-02-01T18:21:29.162544  export SHELL=3D/bin/sh
    2023-02-01T18:21:29.163007  #
    2023-02-01T18:21:29.264077  / # export SHELL=3D/bin/sh. /lava-3266420/e=
nvironment
    2023-02-01T18:21:29.264488  =

    2023-02-01T18:21:29.365637  / # . /lava-3266420/environment/lava-326642=
0/bin/lava-test-runner /lava-3266420/1
    2023-02-01T18:21:29.366167  =

    2023-02-01T18:21:29.370981  / # /lava-3266420/bin/lava-test-runner /lav=
a-3266420/1
    2023-02-01T18:21:29.457469  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63daac0199a651d5c8915ecb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63daac0199a651d5c8915ed0
        failing since 5 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-02-01T18:14:00.250250  + set +x
    2023-02-01T18:14:00.250472  [    9.375398] <LAVA_SIGNAL_ENDRUN 0_dmesg =
895069_1.5.2.3.1>
    2023-02-01T18:14:00.358115  / # #
    2023-02-01T18:14:00.459620  export SHELL=3D/bin/sh
    2023-02-01T18:14:00.460158  #
    2023-02-01T18:14:00.561381  / # export SHELL=3D/bin/sh. /lava-895069/en=
vironment
    2023-02-01T18:14:00.561753  =

    2023-02-01T18:14:00.662969  / # . /lava-895069/environment/lava-895069/=
bin/lava-test-runner /lava-895069/1
    2023-02-01T18:14:00.663436  =

    2023-02-01T18:14:00.666263  / # /lava-895069/bin/lava-test-runner /lava=
-895069/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
rk3328-rock64          | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63daaaef38287a4c8d915f13

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm64/defconfig/gcc-10/lab-baylibre/baseline-rk3328-rock6=
4.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm64/defconfig/gcc-10/lab-baylibre/baseline-rk3328-rock6=
4.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63daaaef38287a4c8d915f18
        new failure (last pass: v5.15.72-36-g40cafafcdb983)

    2023-02-01T18:09:35.570822  [   16.021142] <LAVA_SIGNAL_ENDRUN 0_dmesg =
3266324_1.5.2.4.1>
    2023-02-01T18:09:35.675719  =

    2023-02-01T18:09:35.675929  / # #[   16.095699] rockchip-drm display-su=
bsystem: [drm] Cannot find any crtc or sizes
    2023-02-01T18:09:35.777544  export SHELL=3D/bin/sh
    2023-02-01T18:09:35.778214  =

    2023-02-01T18:09:35.880100  / # export SHELL=3D/bin/sh. /lava-3266324/e=
nvironment
    2023-02-01T18:09:35.880569  =

    2023-02-01T18:09:35.982002  / # . /lava-3266324/environment/lava-326632=
4/bin/lava-test-runner /lava-3266324/1
    2023-02-01T18:09:35.983429  =

    2023-02-01T18:09:35.986699  / # /lava-3266324/bin/lava-test-runner /lav=
a-3266324/1 =

    ... (13 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63daaba5cb683b5de9915ebf

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32=
mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32=
mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63daaba5cb683b5de9915ec4
        new failure (last pass: v5.15.72-36-g3886958cda706)

    2023-02-01T18:12:43.543443  <8>[   10.475202] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3266417_1.5.2.4.1>
    2023-02-01T18:12:43.650538  / # #
    2023-02-01T18:12:43.752387  export SHELL=3D/bin/sh
    2023-02-01T18:12:43.752970  #
    2023-02-01T18:12:43.854641  / # export SHELL=3D/bin/sh. /lava-3266417/e=
nvironment
    2023-02-01T18:12:43.855134  =

    2023-02-01T18:12:43.956559  / # . /lava-3266417/environment/lava-326641=
7/bin/lava-test-runner /lava-3266417/1
    2023-02-01T18:12:43.957702  =

    2023-02-01T18:12:43.961633  / # /lava-3266417/bin/lava-test-runner /lav=
a-3266417/1
    2023-02-01T18:12:44.029502  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63dab658d9b6544c0b915edf

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dab658d9b6544c0b915ee4
        failing since 14 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-01T18:58:09.701152  + set +x
    2023-02-01T18:58:09.705354  <8>[   16.097020] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3266341_1.5.2.4.1>
    2023-02-01T18:58:09.825482  / # #
    2023-02-01T18:58:09.931060  export SHELL=3D/bin/sh
    2023-02-01T18:58:09.932561  #
    2023-02-01T18:58:10.035949  / # export SHELL=3D/bin/sh. /lava-3266341/e=
nvironment
    2023-02-01T18:58:10.037441  =

    2023-02-01T18:58:10.140930  / # . /lava-3266341/environment/lava-326634=
1/bin/lava-test-runner /lava-3266341/1
    2023-02-01T18:58:10.143668  =

    2023-02-01T18:58:10.146837  / # /lava-3266341/bin/lava-test-runner /lav=
a-3266341/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63daaba6100c43d826915f49

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
215-gdf99871482a0/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63daaba6100c43d826915f4e
        failing since 14 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-01T18:12:41.748097  + set +x
    2023-02-01T18:12:41.752167  <8>[   16.025004] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 231411_1.5.2.4.1>
    2023-02-01T18:12:41.860854  / # #
    2023-02-01T18:12:41.962553  export SHELL=3D/bin/sh
    2023-02-01T18:12:41.962899  #
    2023-02-01T18:12:42.064237  / # export SHELL=3D/bin/sh. /lava-231411/en=
vironment
    2023-02-01T18:12:42.064753  =

    2023-02-01T18:12:42.166712  / # . /lava-231411/environment/lava-231411/=
bin/lava-test-runner /lava-231411/1
    2023-02-01T18:12:42.168253  =

    2023-02-01T18:12:42.171406  / # /lava-231411/bin/lava-test-runner /lava=
-231411/1 =

    ... (12 line(s) more)  =

 =20
