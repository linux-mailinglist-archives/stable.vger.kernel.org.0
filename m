Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8E9550790
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 01:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiFRXun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 19:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiFRXum (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 19:50:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606C3B7E9
        for <stable@vger.kernel.org>; Sat, 18 Jun 2022 16:50:41 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id g8so6779560plt.8
        for <stable@vger.kernel.org>; Sat, 18 Jun 2022 16:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SA2HAjP0pfoi7ch6Gh0IzsKkdC791e/ZlignLCqNEao=;
        b=BMB3hbyAIT4+02Tf4k4WMbo7W++Vim2UhEJjJBLmMPhE+rv4z3mPd199986WkZ++Dz
         MD9zv6yC/5NPkPCHNBEm7lumPEzkAITVEJwo5PYafki/8G2O28oiRQdEowpolFkXFdxr
         tBmHKNVAgj307aYVQAcWa5a827UTs7Z4UzLHKMNrj3jie2r6YTjNivGP2mzjYW5iOKqM
         AIDhoKzp+L2W+jrzdGh2LbYjUx6IhK4XwrLqo3nWio+8YnUxMglMjjsC8rR6JTU2OU9O
         kJ83671qhwuCAEWmZJEFZLMOZzCw3CoeSg5j1BTnTKO2Vve+L+KVHsGMzT70OL2h9SJW
         1MHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SA2HAjP0pfoi7ch6Gh0IzsKkdC791e/ZlignLCqNEao=;
        b=khfyZ9F1gwONeAOiQa/splxzMGj9Fe2Ldqp8vtwvevw6G1XW2hAOFk5gN0ofJ3Kdb5
         HtCtQHNEw6ouRmtiqJ8GVFXxUxpKvSsdMlFszu2G/NIgv5cZhh3huP+M471sysQ3IjB/
         62z5Yr+2Plmt2qbvUTBUTSifgciDxewZJRxU9l8GACZHAGY0sNmCOcqBgpnTfml/vpnE
         Tl2aNcdHE5997wNneS4D6yjCbnwKBMf1Ov8DtXooKVE1cbSQTJJ4hHsHpSOfhBtp+wfH
         JVQpVefUObNd0WNb2YEjnQQZ29dHLpaLTpwMR8e/wOsQ+xUMzM8aoO7nBivtAen9jbDA
         tB+g==
X-Gm-Message-State: AJIora9S13cUBJYjjOWbdQXWVMqFE3FAdZlqoSvB6LRf5VAMwAjHrijl
        lULij9yIwYj+tD+iaOHIjRPP276Lz9mGbKTl4h8=
X-Google-Smtp-Source: AGRyM1sHb6BmL3yFIGFG/Zocvkn8eiNzSxxxb8mEw6CNI//rtbtP7ctqXSpuKYtzPGKqJGF11mdLjw==
X-Received: by 2002:a17:90b:1b41:b0:1e8:4e69:e735 with SMTP id nv1-20020a17090b1b4100b001e84e69e735mr29307982pjb.9.1655596240644;
        Sat, 18 Jun 2022 16:50:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mr11-20020a17090b238b00b001cd4989fec6sm7670743pjb.18.2022.06.18.16.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 16:50:40 -0700 (PDT)
Message-ID: <62ae64d0.1c69fb81.a20b1.abf9@mx.google.com>
Date:   Sat, 18 Jun 2022 16:50:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.48-44-gaa2f7b1f36db5
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 185 runs,
 6 regressions (v5.15.48-44-gaa2f7b1f36db5)
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

stable-rc/queue/5.15 baseline: 185 runs, 6 regressions (v5.15.48-44-gaa2f7b=
1f36db5)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.48-44-gaa2f7b1f36db5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.48-44-gaa2f7b1f36db5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa2f7b1f36db52d4e0567e7a0bd11e87cbfd3edc =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62ae2f88b9bfc3cd7fa39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ae2f88b9bfc3cd7fa39=
bdc
        failing since 80 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62ae356786626dc600a39bea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ae356786626dc600a39=
beb
        failing since 7 days (last pass: v5.15.45-667-g99a55c4a9ecc0, first=
 fail: v5.15.45-798-g69fa874c62551) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62ae2d98818132cf88a39bed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ae2d98818132cf88a39=
bee
        failing since 5 days (last pass: v5.15.45-833-g04983d84c84ee, first=
 fail: v5.15.45-880-g694575c32c9b2) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ae2cba6a3abf6bf3a39c58

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62ae2cba6a3abf6bf3a39c7a
        failing since 103 days (last pass: v5.15.26-42-gc89c0807b943, first=
 fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-18T19:51:16.037650  /lava-6645098/1/../bin/lava-test-case
    2022-06-18T19:51:16.047808  <8>[   33.802248] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62ae3c5cb2b14076dba39c15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ae3c5cb2b14076dba39=
c16
        failing since 10 days (last pass: v5.15.45-652-g938d073d082af, firs=
t fail: v5.15.45-667-g6f48aa0f6b54d) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62ae2da2d54b8669a2a39c0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
44-gaa2f7b1f36db5/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ae2da2d54b8669a2a39=
c0d
        new failure (last pass: v5.15.45-915-gfe83bcae3c626) =

 =20
