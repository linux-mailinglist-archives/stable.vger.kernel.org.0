Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1F0564287
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 21:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiGBTha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 15:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiGBTha (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 15:37:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E60DA467
        for <stable@vger.kernel.org>; Sat,  2 Jul 2022 12:37:29 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id m14so5245387plg.5
        for <stable@vger.kernel.org>; Sat, 02 Jul 2022 12:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4Rsz0vy2k8qld4F4rCpI8jOTRn4VVnTgvdZGYWTxduU=;
        b=p3lrJByAc8ZdIWUqbF1rum66cDjVv7sBf/syBij1YqhoWtYs25UvtUOPJ/umX4APSu
         Alx1gWvoK4EPAZQLyH6YoHE4ZLK7DsyEtTE6+IUXFL0zZ/o8oFNDq9MpxRMGqBFEB7N7
         d9haf4tlhMXAWqbdAyYMgiuKOrRCLErxH/491gadjmhaiGaIF40845Id1DKVdIfxCzQr
         4HinIua1CJzxUW59pHXNIS3iT+6X+ftKSTvXPVv3g1wjO0ZUkDW87ulC7Bp2K9BBsGUS
         wtuT8WHn71S9itVBtxYCWRx0OcWsKs3ogW/hCdyryu/5+JWTvnihxfrolyPvuTejiF5H
         ycdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4Rsz0vy2k8qld4F4rCpI8jOTRn4VVnTgvdZGYWTxduU=;
        b=J0dVn3FPBLwnBDVxIV3XeHHrHXm3pkwli0NX4NHzbez7d3WKUUO+ROX48Fy8er07Jr
         WWt/Jg6BeTH8CfsUArO5Egq3M1i0rLXDHBzezivHLsT90MfZUsgPJaZnczTXSm0Qv26n
         yC6iTcVdzxDhPwYQUDMQQbHraEa+By321M1uFtMZ9Vrm3te/T5PoRWMEJ78Xuh9960wc
         vowewoh3p3sHn0fIsTgpmojw0b94Y5Mqj/xbOeSr9yt79omlgfCR9K7CBkSpbGlV4nLm
         D9w2psjRqQzz7NmXNtwmOzy/XZwZo2Q8mVqGg5ksAJ5NTNoNlAq2sFMx50iiTCTpKtP7
         JteA==
X-Gm-Message-State: AJIora/vIMJQK9D3vSEDRpBiERIVi50BlSuIeFgbaB5hQn5d65TNzMD8
        L2678g3FxSXMUNJNjyo837s/s4U8A3lCP3MX
X-Google-Smtp-Source: AGRyM1sl0Vmz90fa7bTd3CrrOQu5fU54vygDpGYyzhwhzJTAlgMc0UVtefzTT3CefTCAtJuwABhGXA==
X-Received: by 2002:a17:902:7e86:b0:16b:bcde:7cf3 with SMTP id z6-20020a1709027e8600b0016bbcde7cf3mr10104824pla.88.1656790648317;
        Sat, 02 Jul 2022 12:37:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b0015e8d4eb1b6sm17994420plp.0.2022.07.02.12.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 12:37:27 -0700 (PDT)
Message-ID: <62c09e77.1c69fb81.7fe37.a17e@mx.google.com>
Date:   Sat, 02 Jul 2022 12:37:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.8-6-geb0ff807eecf
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 183 runs,
 4 regressions (v5.18.8-6-geb0ff807eecf)
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

stable-rc/queue/5.18 baseline: 183 runs, 4 regressions (v5.18.8-6-geb0ff807=
eecf)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =

tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =

tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | tegra_defconfi=
g    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.8-6-geb0ff807eecf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.8-6-geb0ff807eecf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb0ff807eecf270aae4465980533f24e0ab5965b =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c06b9a1addde07d6a39c02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-geb0ff807eecf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-geb0ff807eecf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c06b9a1addde07d6a39=
c03
        failing since 11 days (last pass: v5.18.5-115-g6f49e54498800, first=
 fail: v5.18.5-141-gd5c7fd7ba94c0) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62c064a5134db8dec6a39bfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-geb0ff807eecf/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-geb0ff807eecf/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c064a5134db8dec6a39=
bfe
        failing since 4 days (last pass: v5.18.5-141-gd34118475c49a, first =
fail: v5.18.7-181-gcfa4d25e33d8) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c077fb42e46059d5a39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-geb0ff807eecf/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-geb0ff807eecf/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c077fb42e46059d5a39=
be6
        new failure (last pass: v5.18.8-6-g1a24fb22be7f) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | tegra_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c06ede077fa6892da39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-geb0ff807eecf/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-n=
yan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.8-6=
-geb0ff807eecf/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-n=
yan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c06ede077fa6892da39=
bd4
        failing since 4 days (last pass: v5.18.5-141-gd5c7fd7ba94c0, first =
fail: v5.18.7-181-gcfa4d25e33d8) =

 =20
