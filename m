Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE05344B5
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 22:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiEYUMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 16:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236608AbiEYUMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 16:12:07 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EED410EB
        for <stable@vger.kernel.org>; Wed, 25 May 2022 13:12:06 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gk22so2238331pjb.1
        for <stable@vger.kernel.org>; Wed, 25 May 2022 13:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kGkL6rkwEfRKJ/6gMgHT6zoRuTmYZIN2z979buG+CCc=;
        b=iRg96swn51jCaPUeZ64Uaj4v/gOYFKWINlnPDGm69hXRYzKDKrJuzPYob2dUNUA6rn
         4U4Az3/1dNmbSqEGaUIdE4HYnSxCxV+hisTa2v0OpqJxKTNMkAqDDwzz6ah1Iyz9ILkB
         Jxcj+7uEFySc4YCsYs0FkwGF8Yurqu9XO1zmIATro2HdXVTImSwSFjiyZguBUBheNso6
         t/NRClu23hqWUrY+vyxln7a+bym2wVyIKav3dX+KcleqNFhpzBbtcPr5K9Qco1Zt0Zap
         M5YqejKJn2xo8j2J4GVr90YSRoMOd53KbelFLFHK/deaNlwsoQALBZpG/ivr+5YOIY1j
         PmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kGkL6rkwEfRKJ/6gMgHT6zoRuTmYZIN2z979buG+CCc=;
        b=gT6nOPPcpDAeWx3mS8X7HCzHlrRwbiP8eU/SlcSgNY/nXiVMDDAwESMk6X9+sRb6tP
         f2f8lmmoS1ZgVPkxSvkIxaJf3Kaz7AekkeEJr9A+gSgUp8mHuAuRtYH9xj/WXxAbh771
         NbLtJOcBKJzC3UJ3iyJwm/S86ffzVKvbtOflyFkheC2dp6FsiNObBNuSCWww2QqshZEL
         Jwt/GoF3VrxQtIY44JM8vGB2BVWfcaiEJ0vDtG+pnByqzMVQ9GkgGWegB+E1HmhoV4gP
         BQoIaqjMn6HpuDyIPHyOA6CZdQVD9C1DcmKCXKBydWBZHXMBt+II3N3egqx25v+6C6na
         Kx6g==
X-Gm-Message-State: AOAM5323v/woxvmGf4ZSP7afSEy1dDcuRPxrKOZEsPwfQhR2YgFlyqLE
        B5uQlA8pGnLjzOOGdUxBzwAeXZpyOL1IMe8WLvw=
X-Google-Smtp-Source: ABdhPJy5Wg+mmqy3sMsuGgfPWLzHTlqJHmg5A+XIAwF4TjhVM2UIApg/12eiCmvZ3aEmsLmork0dnA==
X-Received: by 2002:a17:90a:bb17:b0:1e0:ab18:4491 with SMTP id u23-20020a17090abb1700b001e0ab184491mr5347687pjr.120.1653509525614;
        Wed, 25 May 2022 13:12:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k2-20020a170902c40200b0016240bbe893sm4381757plk.302.2022.05.25.13.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 13:11:45 -0700 (PDT)
Message-ID: <628e8d81.1c69fb81.4a80f.a5ac@mx.google.com>
Date:   Wed, 25 May 2022 13:11:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 108 runs, 4 regressions (v5.15.43)
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

stable-rc/linux-5.15.y baseline: 108 runs, 4 regressions (v5.15.43)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-10   | omap2plus_defco=
nfig | 1          =

jetson-tk1              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig  | 1          =

jetson-tk1              | arm   | lab-baylibre | gcc-10   | tegra_defconfig=
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e5bb338bf471ec46924f744c4301751bab8793a =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-10   | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/628e58660997607253a39bff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e58660997607253a39=
c00
        failing since 13 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/628e5ead666e3ba601a39bf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e5ead666e3ba601a39=
bf1
        failing since 1 day (last pass: v5.15.40, first fail: v5.15.41-133-=
g03faf123d8c8) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | tegra_defconfig=
     | 1          =


  Details:     https://kernelci.org/test/plan/id/628e5b6835b92a4ca0a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e5b6835b92a4ca0a39=
bce
        failing since 1 day (last pass: v5.15.40, first fail: v5.15.41-133-=
g03faf123d8c8) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/628e577d419616ce8fa39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e577d419616ce8fa39=
bce
        new failure (last pass: v5.15.42) =

 =20
