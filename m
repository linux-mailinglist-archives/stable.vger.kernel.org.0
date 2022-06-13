Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304BC54863B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiFMPIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 11:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386434AbiFMPIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 11:08:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0181A1059FE
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 05:18:18 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h1so4924639plf.11
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 05:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1pH5z48vb2ukDa7rtIlC2BBGHnA3V0UiFtbD3YggjVo=;
        b=D+2r1z4lZOSaQ/ro1i9X9VcORsbYdKHgiFP9OSCGCO67UZTbBEmj+SsYY/junMY9+X
         2Ro20vrjatRnVk/QcbgR+/PXCVHLmkA2kJAxARmK1ciB0l2Bhxy05lO8ajkYNiSKx6PX
         RKVaKy8l2/xor6zYnPt5FxLaI+nZoyFQbyy/stML+kAgQ5abi0YPfZUJQm3swkTSt4R8
         FTfsbsNhKqZ/UfgBEs+iE6kF4W4c442lWhOzV/v41mP27nuH0ZutoRbMcTTvO5mNKZav
         GQb6s+QpYc3dWCu5F+cdDT+31Xp4zLvuiFGiZ3ThBFKCqN22/cXUrBEa2OE3c5fzd7eZ
         a7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1pH5z48vb2ukDa7rtIlC2BBGHnA3V0UiFtbD3YggjVo=;
        b=LiOIDo8PzXA0sauiH5D64ORnZRkEM/92lU6DVMLMhEOmwQg1nPqEehd4GRhUEEFlLB
         1Ur+sfpJJuWECMwsaNEGt1l6IfTF/uBplJJAe2xLNNpqeJi7WE+1sK1GxJW1DNlkWNIi
         K7k9N6uuRvEr4u2PT3oUIfc1dAlXQ1GKkFhU776CQ1W4+sDJaVUqMqPavYRPWubPuETm
         b1R56Y2jKu997/12gjqtAun4LNaljRXEC8BHhA9DcF9gZ75bRgvhRTBhBD2nSKA9EAqJ
         O/SmNegxnR5zQtMl4b5lVqQm0sVEgnI/ZoxJ0beq6OzqCi+0hniDy2MeMK/ALrKZdWe7
         AgLA==
X-Gm-Message-State: AOAM5337fSXww3aNAJ32Nf3Ir+Un9ZBC8zudzO97J40HXy7vNuAOGSd6
        K+qJe2sWpuz3m8y3RNYFnj7sRWwn+K8z9LPMUT4=
X-Google-Smtp-Source: ABdhPJyr1SCpmVgimOYVJKXr10zA8O241N22M2kVi3eIm/3ucO52X7cpA7suHS4RRcPICt58LNt2Yw==
X-Received: by 2002:a17:902:d54b:b0:164:bf9:3e1e with SMTP id z11-20020a170902d54b00b001640bf93e1emr59793908plf.58.1655122697602;
        Mon, 13 Jun 2022 05:18:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902a3c800b0015e8d4eb22csm4963498plb.118.2022.06.13.05.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 05:18:17 -0700 (PDT)
Message-ID: <62a72b09.1c69fb81.7546f.57cb@mx.google.com>
Date:   Mon, 13 Jun 2022 05:18:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13-1037-gb6b19f82d1437
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 168 runs,
 2 regressions (v5.17.13-1037-gb6b19f82d1437)
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

stable-rc/queue/5.17 baseline: 168 runs, 2 regressions (v5.17.13-1037-gb6b1=
9f82d1437)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =

jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.13-1037-gb6b19f82d1437/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.13-1037-gb6b19f82d1437
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6b19f82d14370609cab3d4f454d29dbc541e852 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62a6f6a07cd408a1dda39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1037-gb6b19f82d1437/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1037-gb6b19f82d1437/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6f6a07cd408a1dda39=
bd4
        new failure (last pass: v5.17.13-1029-g0132bdf6be9af) =

 =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62a6f4a9a4d81056a7a39bee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1037-gb6b19f82d1437/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1037-gb6b19f82d1437/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6f4a9a4d81056a7a39=
bef
        failing since 2 days (last pass: v5.17.13-907-ga980fa631e355, first=
 fail: v5.17.13-928-gfe5fcee7b41f8) =

 =20
