Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374CE418D4B
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 02:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhI0AbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 20:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhI0AbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 20:31:20 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C784C061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 17:29:43 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id f129so16163754pgc.1
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 17:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Yihtctawdw9NxLGuzYw87Vm0V4D2qDzvGkoBT4+qQDA=;
        b=CNSzrOVy893nEW0dIxphSpoWIyCeaVmHv4ClbNSHtZQjCPfK3ohLcAUmZi1vXVTTBz
         14cUVyx2wfgInLKVxxlwEmffXEbfV0k+AZaP4Fn1VfF+wNWIzQtzzvijbi8Kpx9NJ3ud
         az5s1F642xaBx6SNVnqHHIyB6ipSwhVVgUbfra7q6p4ZgWB4xAZcCRXuzzmQ7HPNOxaL
         Y8m23wPx+CGc/Bnw5wqYFtx3UWIC3S8ZoQWG+5XlbATFNMZDAd6T/EOqM38xsFDj0ocM
         Bp0Czek+b5gxKlNzdqhmhBXkTQeHY0+bHuWEQCP/D0qY0u6On2LgC/I86ZDAzDAbEY47
         v/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Yihtctawdw9NxLGuzYw87Vm0V4D2qDzvGkoBT4+qQDA=;
        b=GSJfZCTIrNiebPE+f4eEO/Q2eEMIz1/ivaN6UVVqVcHyU04gNLTyZ++MguTArjF+QZ
         pMobGHALG/GkcFVAaiDtOZIOcGrNjmtl0Alnvo9xPDdY7gJc0gQLGhWegj/XNdQKBL7x
         zPaR409oj98RA5yNAB8kGXhQCEU3CEr93OloTG2kLh1axh/BAmN8ZH3BDX9AwCH8V7Cn
         119lAlfd8crRP+Hl8an4RpBTfQxPedLriuIJuSAXSj0AltBD3d/DGkjtoqCZ1spZ16Kh
         1yRWJJnimeEve1FEfoM3pJ+Dp7ypwQTqP8YNN/4tDVwfr5gPWBUkxtMKQf1vNTXLp6GQ
         +gvQ==
X-Gm-Message-State: AOAM5331KwPceoj+4V5dIEk8zEICcHe2dm9TLy2T10+Fdj6XprBodckT
        I+ej8JpIFikhfzRMBk8lviIsaXCixwumIVm1
X-Google-Smtp-Source: ABdhPJyGk4VeGDJzEzKNKwDcu7Ra+VNbvJyZ9rC8GLckdPrckoO/KBLyTFSIx7DnKPEuwjA0oQmpiw==
X-Received: by 2002:a63:f62:: with SMTP id 34mr14123596pgp.159.1632702583013;
        Sun, 26 Sep 2021 17:29:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b126sm16477510pga.67.2021.09.26.17.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 17:29:42 -0700 (PDT)
Message-ID: <61511076.1c69fb81.162de.704f@mx.google.com>
Date:   Sun, 26 Sep 2021 17:29:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.68-97-gf4fa91b1e2be
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 74 runs,
 4 regressions (v5.10.68-97-gf4fa91b1e2be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 74 runs, 4 regressions (v5.10.68-97-gf4fa91b=
1e2be)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =

tegra124-nyan-big | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.68-97-gf4fa91b1e2be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.68-97-gf4fa91b1e2be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4fa91b1e2be65690fbfca386576e33c9a1ab8bf =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6150da55f4493fba6699a31f

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
97-gf4fa91b1e2be/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
97-gf4fa91b1e2be/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6150da55f4493fba6699a333
        failing since 103 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-26T20:38:13.401640  /lava-4586334/1/../bin/lava-test-case<8>[  =
 13.433287] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-26T20:38:13.402214  =

    2021-09-26T20:38:13.402673  /lava-4586334/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6150da55f4493fba6699a34a
        failing since 103 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-26T20:38:11.976624  /lava-4586334/1/../bin/lava-test-case<8>[  =
 12.007690] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-26T20:38:11.977139  =

    2021-09-26T20:38:11.977551  /lava-4586334/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6150da55f4493fba6699a34b
        failing since 103 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-26T20:38:10.938917  /lava-4586334/1/../bin/lava-test-case
    2021-09-26T20:38:10.944858  <8>[   10.987968] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6150dfe6ba06ff513799a311

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
97-gf4fa91b1e2be/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
97-gf4fa91b1e2be/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150dfe6ba06ff513799a=
312
        new failure (last pass: v5.10.68-63-g964be936e732) =

 =20
