Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C7D5F77A6
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 13:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJGLrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 07:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJGLrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 07:47:47 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EB79E0E7
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 04:47:45 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c24so4330509plo.3
        for <stable@vger.kernel.org>; Fri, 07 Oct 2022 04:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=R1Nvm8ub4Ww9IjiChsikZmjbWeWYy9ZM+gGZAOd9j/c=;
        b=7I9yAW4LIOuZSGKNxq+g1qiALJO71NOH6o+8QMnXtyn4URih071YwBx7E5Em3XgD4B
         O3j+s50ZIr+80vt3g7LnVTLpi0skIcOZnKCNY5Ek2FBYnQT1hFwOBHHwxrNzaVuf+55p
         RknaOcn94FwHTzjaPThCJ2UFfmGrMPg0Wy0oDG0i3O5roPlZEWzzN0/51cntvFq2Ebhc
         bleIQR/HkHTdkSDc6gkbx66PVWb9t+dpgGSKQ+7S0h5bFsBkL14wi4aeAp0ZwwG/j320
         EP7klpkDNiBb9n0X1VLoxhphjNRmTmwDiW+Th6pXhRI14Igp5KgdEjnIZNXGGtXj1JDz
         Cynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R1Nvm8ub4Ww9IjiChsikZmjbWeWYy9ZM+gGZAOd9j/c=;
        b=x3ifyQQdsnqZ5rShIaByiSx7vHXDzwHO6LAkDr15RmLS1zJxMvo0M4CV9nd6L1I9O/
         Nf1WowQszxXpGHZeNY1LlnKZPEuWPhDO8lMrYBJs0n5d2mcRhD9V+4ShU8c0/7h9S4Xp
         nrDYmCPAory6BiikWyPJxb6BdEvpL1zN0IFZ4q4AfFFg6f5FP1lIYqY/NikCVcCZI1Qi
         MPIykYYk+qnjSO/Rym5v2Z5G29UrofA9ExMHquARfnim5Ibt7/J5uGpiqIPcB7BpuvsQ
         gHUIf5TabDn4qyvzy2nBOjuN6BsN7nkEQ00mXBOyNx1xZJ8sHmmNR1T0onefFXio4TmR
         p+iA==
X-Gm-Message-State: ACrzQf0cSFP6ziCY3yTgOaMYRucPZVY104KXMKNPdeXADO1z/re41Ndq
        9oClgXv49HeewECuL8qz0Adf0XKdeTPkhkLZx2c=
X-Google-Smtp-Source: AMsMyM7sE9e5UHdM5yDA5QyPP7Yqj2rh3AWHXBue7g8zKOpp8C0Dg4F1ufsaqnictR8OZWzm+k6zng==
X-Received: by 2002:a17:90a:66c9:b0:20a:f78a:77e4 with SMTP id z9-20020a17090a66c900b0020af78a77e4mr11593665pjl.214.1665143264747;
        Fri, 07 Oct 2022 04:47:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2-20020a1709027b8200b0016dbe37cebdsm1319480pll.246.2022.10.07.04.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 04:47:44 -0700 (PDT)
Message-ID: <634011e0.170a0220.ab383.256e@mx.google.com>
Date:   Fri, 07 Oct 2022 04:47:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.71-78-g20df32151b6fc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 173 runs,
 5 regressions (v5.15.71-78-g20df32151b6fc)
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

stable-rc/queue/5.15 baseline: 173 runs, 5 regressions (v5.15.71-78-g20df32=
151b6fc)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.71-78-g20df32151b6fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.71-78-g20df32151b6fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20df32151b6fc154147304b80139b3c080089211 =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633fdd8a120e682f2fcab5f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
78-g20df32151b6fc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
78-g20df32151b6fc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633fdd8a120e682f2fcab=
5f9
        failing since 15 days (last pass: v5.15.69-17-g7d846e6eef7f, first =
fail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633fe0260b9b104450cab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
78-g20df32151b6fc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
78-g20df32151b6fc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633fe0260b9b104450cab=
5ed
        failing since 11 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633fe1a24542ea2568cab63e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
78-g20df32151b6fc/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
78-g20df32151b6fc/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633fe1a24542ea2568cab=
63f
        failing since 11 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633fe18bea2edaf41bcab5f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
78-g20df32151b6fc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
78-g20df32151b6fc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633fe18bea2edaf41bcab=
5f8
        failing since 52 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633fdda2120e682f2fcab623

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
78-g20df32151b6fc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
78-g20df32151b6fc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633fdda2120e682f2fcab=
624
        failing since 45 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
