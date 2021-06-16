Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA493AA5BE
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 22:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhFPU6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 16:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbhFPU6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 16:58:49 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC36C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 13:56:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mj8-20020a17090b3688b029016ee34fc1b3so2559383pjb.0
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 13:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xAhEM5XizIatNVEjXFXD1lqqVGnQ03U/+c6C00ppCsk=;
        b=MnpUdx0jDTWmX/CbonRstAWiChtiSAx77d01va6IQjZtzY4iZl1TiLkRZ08f7BypKb
         r8OpAlznfMmDpyd343MS/nAWl2ZyxsSVYFk4+AptO8rHivLd/uuxee1on5IgCMqr3fjJ
         X8Fc0bEaH8ikOCrZXkOFShxjBMnMZTKxiP7GHJ8D56GkCtXTC+mt9HpZ6SVZ+/4u3M1w
         CZ4sRdgw6Ah346IahhgHoeGJgk6sAtlAckcwGj0z0f8LRE+KCJcUNPWwxnyG9oh/YxIk
         zUhL0/9VwY2oqyjO8hBQYtjuvmbiDH8cRm1zP1CWsXFrhKuqEyv+QG0NxE+3Rzul0jVJ
         QOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xAhEM5XizIatNVEjXFXD1lqqVGnQ03U/+c6C00ppCsk=;
        b=gfRBVh/lM4ZY0Co46BvF6NQpCcyZOWsgqLB1MtMM6jKpeLJnQQeWEoDDjNqL13lXhU
         xQYhz0gPpA8zWlqSJcFEDROXx788LkJNKOOyAFyehsXvv6lohifMxImKDLa012qo/RwW
         FDCrhsoT7pXS0nW8oauiRlY5zh7XqF0VSEfuR2SLw9HIZf3aJGUR62ZletAl9Acn9SjC
         pq8216UBcScXFPOncRWZk/P2/VlBeJ5CmlQ9inaWOPOIC/356BhoLYdDDhJWbofY/7VS
         rGMdedsLvrZm9RCapz+cKKcLqH+gXsyoOS/jgLZclheNX3GIaUMg5Wlt+/n7tVvsInZS
         Iqow==
X-Gm-Message-State: AOAM533HEgl5gjdJd8YoR+/CqJcBIVn50v++B3b6WLa521m120qVTp+b
        pL23jw57PSIwcfnkGvhrIRv+EI0A9PIcjbnZ
X-Google-Smtp-Source: ABdhPJxucWK8sUmPad/tGxV0SSVBXodpcxRXncZuxAc9bBG/8HYuOWH578p4yfcs1tJQncApVjpj2g==
X-Received: by 2002:a17:90a:8982:: with SMTP id v2mr1743622pjn.171.1623877001327;
        Wed, 16 Jun 2021 13:56:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6sm3088319pfq.110.2021.06.16.13.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 13:56:41 -0700 (PDT)
Message-ID: <60ca6589.1c69fb81.d3ad5.8844@mx.google.com>
Date:   Wed, 16 Jun 2021 13:56:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.11-49-g3197a891c08a
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.12.y baseline: 104 runs,
 3 regressions (v5.12.11-49-g3197a891c08a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 104 runs, 3 regressions (v5.12.11-49-g3197=
a891c08a)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.11-49-g3197a891c08a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.11-49-g3197a891c08a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3197a891c08a4cf4c9300437e2747af3d5cb55e2 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60ca5cdf74c24a7329413266

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
1-49-g3197a891c08a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
1-49-g3197a891c08a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca5cdf74c24a7329413283
        failing since 1 day (last pass: v5.12.10, first fail: v5.12.10-174-=
g38004b22b0ae)

    2021-06-16T20:19:27.648326  /lava-4038006/1/../bin/lava-test-case
    2021-06-16T20:19:27.653504  <8>[   13.684520] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca5cdf74c24a7329413284
        failing since 1 day (last pass: v5.12.10, first fail: v5.12.10-174-=
g38004b22b0ae)

    2021-06-16T20:19:28.668031  /lava-4038006/1/../bin/lava-test-case
    2021-06-16T20:19:28.685730  <8>[   14.704176] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-16T20:19:28.685977  /lava-4038006/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca5cdf74c24a732941329c
        failing since 1 day (last pass: v5.12.10, first fail: v5.12.10-174-=
g38004b22b0ae)

    2021-06-16T20:19:30.097575  /lava-4038006/1/../bin/lava-test-case
    2021-06-16T20:19:30.114949  <8>[   16.132992] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-16T20:19:30.115255  /lava-4038006/1/../bin/lava-test-case   =

 =20
