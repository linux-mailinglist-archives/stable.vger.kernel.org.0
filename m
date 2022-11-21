Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FD9632C52
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 19:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiKUSt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 13:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKUStV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 13:49:21 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB8BCE9F0
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 10:49:19 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 140so12150017pfz.6
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 10:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gIFzEaeeDUnFFQKQPpIRcsBCwyLlq/qzjBM6OXPaoVk=;
        b=ckDAsCUKlWod2pErpBWoVcTaT922rbDuONUZdi//IYPvrnM5ayIYIOaSUvXq23zNfI
         F7MEhaxBG2xYhRfSXQLh4rtebWvXLkz2lPvXbn4j5uL5dkFllZ+rB8UZxCx0W406V5SD
         AIBP3Kpe2Qg7n5O2vVTXUfTUZCYT6Jerg89p3U1TB0ymwQbcMlUBRBc6WQBs8fDA48YI
         bUz1JTFqHrqX+B08xFwS6ZRnxRI7mtiScF2aHGc8H/nzIeLhznf+e979TybuXzIuo6w/
         0MaPbmwqmILjP8D378d07CDn+8Wa5M1vPwkuVou9hf9/FHOr4gfmJmD3nQFk23Mq6EvQ
         WfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gIFzEaeeDUnFFQKQPpIRcsBCwyLlq/qzjBM6OXPaoVk=;
        b=aBHRACOtgsPQn5kIfnpy21Qf06Cml3tVRaKvQWHcD1nh4PyH+0ytH/QG4j8n7xk08L
         Epz5YyF8g+gb5fF6WeX1KgnD/mtmIfo09o28G9WCWhotzfI+I5zFcgsjE5sQQ+3ojaTt
         S4Luk7/4EzQOL6I10WHHXKRsyRNmoSXPFcqwysDsG6Hf/DMGAbiUL7toK7BZ6U0B04WB
         UJK4yJTtRyqxqOGiK0GHSlDbsQp6dtq39uO4mQCKAWTmPXLSlzZwDCEazVcFBETg1TvI
         undCcCCmFDM+NqbLiMph+KINWhN5gjRaOEYmfNsAIyU4dqyyjqkY0dGeb25/j2PVEg7H
         tYeQ==
X-Gm-Message-State: ANoB5pn2ZGsWyoc1VG9IvHSu0zhjsXCi9Po9VZKGEc4vCBowcLsxIcrA
        T4QGP05cCFATjxFPn64BSZLoRlYbpynbnz4n0Qk=
X-Google-Smtp-Source: AA0mqf7Flij7uzxN5oVHwRdSFOMaJ1+MmR4JzH//FMpgpxT118BfSPqOkCHA3lm2axX1z0YdpLYYQg==
X-Received: by 2002:a63:5d3:0:b0:45f:c9d5:d490 with SMTP id 202-20020a6305d3000000b0045fc9d5d490mr1237421pgf.392.1669056558422;
        Mon, 21 Nov 2022 10:49:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902694400b001891ea4d133sm3308625plt.12.2022.11.21.10.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 10:49:18 -0800 (PST)
Message-ID: <637bc82e.170a0220.c87a.4ec8@mx.google.com>
Date:   Mon, 21 Nov 2022 10:49:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.79-157-g816534d88144
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 146 runs,
 2 regressions (v5.15.79-157-g816534d88144)
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

stable-rc/linux-5.15.y baseline: 146 runs, 2 regressions (v5.15.79-157-g816=
534d88144)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.79-157-g816534d88144/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.79-157-g816534d88144
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      816534d881442d7d014ed2893d553979a094dda9 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/637b9422ccc75407492abd10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9-157-g816534d88144/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9-157-g816534d88144/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637b9422ccc75407492ab=
d11
        failing since 55 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/637b95a13c0363dc432abd0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9-157-g816534d88144/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9-157-g816534d88144/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637b95a13c0363dc432ab=
d10
        failing since 55 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =20
