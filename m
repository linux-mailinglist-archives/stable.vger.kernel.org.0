Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603223D30AA
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 02:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhGVXdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 19:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbhGVXdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 19:33:41 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A65C061575
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 17:14:14 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id e10so1343801pls.2
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 17:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gKRdliC8VNAgnhwGemKQCvOqqpdjmu5Y77jtgR82Cl8=;
        b=Z+saEenRTYz1+g+YDyg0bgJBOaFenQ6q4IzfSl3OYsv4FmJOOHegUtj+iiGzg/wUIE
         ERRBis05dk20Z6AKUXRenHlNrDOgNPBW6TIUcl1kCSm4T3UhPpEYXsJAXQFlndbW2737
         6KlO/LtVerGSihbyNIjc1wq7BPJEi4jO21cwb2hQDzfRW2LZo2O2J6pPNc//BfxqKG4k
         JOXTZf9BR6TxsAkdbo7zcauonoxKJwjbVi/51HzyfqkIddkvLxIpw5JmdzpOGV7qdPVS
         g/zH6NcV4quMcvpcqJK9STfdJw7ebXLXOCVCofrl5kwRF01GUTSzm7i86JtxAgAjNP9k
         KSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gKRdliC8VNAgnhwGemKQCvOqqpdjmu5Y77jtgR82Cl8=;
        b=sP36baEbK96vVdcvdNHirAURrxgbijnxH/l63NHCpGGFWTIvOULgfOxA5tjZGOPtdt
         fymTXX2xXaPCfvtk+4m0vnNCCWMhEuhndKOebDyaR2wWLttj35gUwJ3RsSoLwlQIP5rg
         pWvt+l6YHjUsHKzRFRTqOkwyTsrszkTZKpbRtDT6ithd7lEP/zBX49AMus/TgWDKhINx
         JmQ7zSDZdaJBPRQ/a6BkqZLgvGoy06+E1wmcQbrj+cgX/YCE9rkeoT/4cuxBQ2hay9Tx
         Oq/RDdh4r8E2dlE9hwtbRxnZ2tCQCIlhbWFKqTgxIMahKkVVFv26WKqgSDWlUMYjqJwF
         XuEg==
X-Gm-Message-State: AOAM53051/iUqx1DXT35/dtcrXfNibKuafjdnxL4ilANv37zBhcAzTpe
        BNtbsP45B8omdNnEWZsuvy44BMr/MzdvIOS4
X-Google-Smtp-Source: ABdhPJzl5mE8vGSrNBPZ/JYR83907zxhTfa7e+cPuKrLcbbTBzdi5vfUPZYWn3oeYSq0JkyeFRYyJg==
X-Received: by 2002:a17:90a:7bc3:: with SMTP id d3mr11426093pjl.145.1626999254044;
        Thu, 22 Jul 2021 17:14:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15sm35638501pgc.13.2021.07.22.17.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 17:14:13 -0700 (PDT)
Message-ID: <60fa09d5.1c69fb81.7fdfd.d2d2@mx.google.com>
Date:   Thu, 22 Jul 2021 17:14:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.51-363-gc7603cd6c337
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 125 runs,
 3 regressions (v5.10.51-363-gc7603cd6c337)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 125 runs, 3 regressions (v5.10.51-363-gc7603=
cd6c337)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.51-363-gc7603cd6c337/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.51-363-gc7603cd6c337
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c7603cd6c337d1b563b97d9ddab73e157bb4b724 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60fa004e04d307385885c262

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
363-gc7603cd6c337/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
363-gc7603cd6c337/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60fa004e04d307385885c276
        failing since 37 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-22T23:33:26.942580  /lava-4230956/1/../bin/lava-test-case
    2021-07-22T23:33:26.959809  <8>[   13.758717] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-22T23:33:26.960039  /lava-4230956/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60fa004e04d307385885c286
        failing since 37 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-22T23:33:25.518685  /lava-4230956/1/../bin/lava-test-case
    2021-07-22T23:33:25.519039  <8>[   12.332314] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60fa004e04d307385885c287
        failing since 37 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-22T23:33:24.495690  /lava-4230956/1/../bin/lava-test-case
    2021-07-22T23:33:24.501340  <8>[   11.311529] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
