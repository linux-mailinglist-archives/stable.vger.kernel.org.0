Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8025D41B68F
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 20:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242060AbhI1StE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 14:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhI1StE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 14:49:04 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8519C06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 11:47:24 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v19so15626302pjh.2
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 11:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pK8oU025AW1T0oVJKM0Tj8xt/fd3nme6kkNdwkKOQAs=;
        b=7vPkqiPU7uExAiRV5bAieoBqKlJ8YSM+rn6o8BxDQ7KrE8YArqQW7gu+neg4/LvPVf
         yn6oqF+vsIOjr0aRm+9XStw2n+5hmvSB0xO2wqm6ngM2IDIM7am+iri66Sf/1OdRu3Wy
         BUx8EE1OH2CEyvZlFGHYrnKsaZGubqMqu/Unv0KlDuhetU5JiJWfUtiBSnxYNK9fYKPa
         oSE1T9It0FuzhsmcPQ5syF6BLjCw2f8T6bV2e8jsKtYKC832fKkoEL/SUXhYEBbVOLLc
         lJwEOMWvoA9Qy/r4xh74YHWruXYRW+OGXksWEP/mNqrfqz+XWpZjz8qTJCDEH5S/EBKL
         DUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pK8oU025AW1T0oVJKM0Tj8xt/fd3nme6kkNdwkKOQAs=;
        b=7JPTe33DfztvXpGf6ClHFLmmtKO9WzMj+kF4cK6ktlDmJ6gEjNEWa4D/Q+0cruSuNA
         JiD50sLpMDAbZOi4za6HftV0W3I3LXnTU1NJDWz6cdEhGt7uh4MwepYAceTkvTDXbHCv
         JfZ07n8yeDlLi3GIhrzqvG12cJXeKzkZkrRcLEtYSmTIS555JL+a0ZI64Z2QgwgxUSHa
         JSWCVpa7lnd16XJGhb3ScYigtpNC1TF/Ozcf1IkGppbBmGzJjDLO3ELiRBQHMNsAvHN5
         copqbZTAL4x3ZOLzUPx0AadFG8Il1GJRHq7jqQEYl4cjgjN/srhYNyjiGqoJiUWW2o/A
         YuuA==
X-Gm-Message-State: AOAM531Phz1Uef7OaOLeMWnxkhNf3jItqqcjj6L19ue7P0rD0JE6SMbQ
        qHHBhlawQfy/hPjpcOPG+KGqHe7cLfWY5s0P
X-Google-Smtp-Source: ABdhPJxM9lkfWaFr0UTctQ1ll22GyufJwuv5z1ue6/QJsDaRdavW/LFYC9YlkS/9yAgOznI5SlwDPA==
X-Received: by 2002:a17:90a:fe8b:: with SMTP id co11mr1607634pjb.65.1632854844015;
        Tue, 28 Sep 2021 11:47:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t2sm3157174pjo.4.2021.09.28.11.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 11:47:23 -0700 (PDT)
Message-ID: <6153633b.1c69fb81.2568d.a059@mx.google.com>
Date:   Tue, 28 Sep 2021 11:47:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.149-68-g92554538507c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 162 runs,
 3 regressions (v5.4.149-68-g92554538507c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 162 runs, 3 regressions (v5.4.149-68-g9255453=
8507c)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.149-68-g92554538507c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.149-68-g92554538507c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      92554538507c6e18fbd629f1ac666b724fc63090 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/615358008afe322ddb99a2ee

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.149-6=
8-g92554538507c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.149-6=
8-g92554538507c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615358008afe322ddb99a302
        failing since 105 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-09-28T17:59:04.818144  /lava-4594963/1/../bin/lava-test-case
    2021-09-28T17:59:04.834927  <8>[   14.887989] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-28T17:59:04.835281  /lava-4594963/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615358008afe322ddb99a31a
        failing since 105 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-09-28T17:59:03.393070  /lava-4594963/1/../bin/lava-test-case
    2021-09-28T17:59:03.410021  <8>[   13.462534] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-28T17:59:03.410487  /lava-4594963/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615358008afe322ddb99a31b
        failing since 105 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-09-28T17:59:02.372692  /lava-4594963/1/../bin/lava-test-case
    2021-09-28T17:59:02.378351  <8>[   12.443099] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
