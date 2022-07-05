Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0628F566A5C
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 13:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiGEL5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 07:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiGEL5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 07:57:45 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33DE17A84
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 04:57:44 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so8313967pjo.3
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 04:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/fxmj6kWSouuxb89z405xsRMSyMsovrJPrHSwLJ/9rk=;
        b=LmOsQc2H9LJp7i8/STxRmM4gs+zX0NXCRZi2iXCR6deVZkZkgUMmIdHoFPxx5sotrG
         VES8TiVQAZWosk++t1JwSx3qPmxwZE2iQyy73p710ZlnwCM3S6Op/vinEdnNdmnWNnd9
         VZ77fo/ollnb6Y1m613infSm1W7dug7WGmCY7Ca6wRkrgRQXdzhn4PlU+1FriSK3YrdM
         zZf3xKH0taqnK07PDR8IEGJHG2Dc0xYCI7vqnc+m3QK1hQWH8TaR/LzzEg7I80UpW9ps
         OBKmC1HCdbZC1po0a5DiRfbAfXKAXqYnTq6Nn7mjpUoDonM16QdHfR7m/P1CCK/i2uCz
         LMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/fxmj6kWSouuxb89z405xsRMSyMsovrJPrHSwLJ/9rk=;
        b=HivkR5VWvnKfrp/fo5I1chSaubqcVPq7To6Fou5JocsRorkqYH4RSSCF0NyH9wFDAg
         I3NCRGJmxnGS80ON7n2+2diteCWpxz5Zdf33x4RsW0Dz5EfFOC6VM0MymFDB+9QyAIqU
         2aawfPva0183bQgS8lPQ0Z0ymAztIiL4Vr2Pg1u7pwdR9VbG1mDjEQIHxStmhs5Xsr4h
         T2fw3VtyQEiEOWAeZ/xUUs/QLNB6Cu9KX0OWFfgjNq2uZ48+qXn473/S+ZYCEuOtGDSP
         tnfaWfKACWxdKSLcIOnII4v5cZVNjwvLCERSWgY6rJI1271JtM9WTwKh06rXDuLhTvhs
         Z5Mw==
X-Gm-Message-State: AJIora/XLdgIgIMjyRN1ssdGsdit8fQmxaDjnTDGK03gDRwO7wtd2qer
        gyuKqOQTmGWp96IcFGg8JZIriUjOixPoWdNi
X-Google-Smtp-Source: AGRyM1tiHDpYL7owZi4RgGTB8t/qX+Rq5GXfO9eF7skDJBiFjA+JGCVBGMb07EXRafBntIe7QpGROA==
X-Received: by 2002:a17:902:dad1:b0:16a:749b:16d8 with SMTP id q17-20020a170902dad100b0016a749b16d8mr41347353plx.61.1657022264018;
        Tue, 05 Jul 2022 04:57:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x65-20020a623144000000b00527d9639723sm13658502pfx.184.2022.07.05.04.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 04:57:43 -0700 (PDT)
Message-ID: <62c42737.1c69fb81.9bfb4.377f@mx.google.com>
Date:   Tue, 05 Jul 2022 04:57:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.9-96-g91cfa3d0b94d
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 192 runs,
 3 regressions (v5.18.9-96-g91cfa3d0b94d)
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

stable-rc/queue/5.18 baseline: 192 runs, 3 regressions (v5.18.9-96-g91cfa3d=
0b94d)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =

sun50i-a64-bananapi-m64    | arm64 | lab-clabbe   | gcc-10   | defconfig   =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.9-96-g91cfa3d0b94d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.9-96-g91cfa3d0b94d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91cfa3d0b94d30b8149caed803650ec2d8babdaf =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/62c3f2154d70748ff0a39c52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-9=
6-g91cfa3d0b94d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-9=
6-g91cfa3d0b94d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c3f2154d70748ff0a39=
c53
        new failure (last pass: v5.18.8-6-g365d872fd167) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c3f6c8cb4068409ea39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-9=
6-g91cfa3d0b94d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-9=
6-g91cfa3d0b94d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c3f6c8cb4068409ea39=
bcf
        new failure (last pass: v5.18.8-6-g1a24fb22be7f) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
sun50i-a64-bananapi-m64    | arm64 | lab-clabbe   | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c3f182953753d418a39bdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-9=
6-g91cfa3d0b94d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-9=
6-g91cfa3d0b94d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c3f182953753d418a39=
be0
        failing since 7 days (last pass: v5.18.5-141-gd34118475c49a, first =
fail: v5.18.7-181-gcfa4d25e33d8) =

 =20
