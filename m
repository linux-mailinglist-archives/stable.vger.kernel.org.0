Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BE6417B2A
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 20:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346024AbhIXSdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 14:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346007AbhIXSdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 14:33:46 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34FBC061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 11:32:12 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lp9-20020a17090b4a8900b0019ea2b54b61so823988pjb.1
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 11:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q8lCLX5fNqx863KMwkg+1cXtr4p1r4OePPM0DywnUms=;
        b=NPzncbb1JXyYFHh7dhaq4Tvm+4GBjVD0K74/GfTiG1twAd0P+XiOoXP1pepy8N5+wI
         75LKtN0LUy7qgub/MsGRBUE8WUjzEFVbFO+ti349BIYYSiZB6KRbXFaXCJ+VkkdzPLV7
         VKuPEcRFR7uFFhwWjjNRanVbcOye7Z777atGTXu5jcUFMfCOFgZxqz8zeNAAikSM0ND7
         hNwfeicZnEXhNaTyDlvH+CNfldYVmesvFB/expWPwK7LmtkFUmGYdLigX8vUHQoFxGEU
         cznk91JffxPOUeG6Nis0ltFHfHOpKuntCYByytSX9mOn0SS4xUfW2uvzPYu5bNLH87BI
         pLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q8lCLX5fNqx863KMwkg+1cXtr4p1r4OePPM0DywnUms=;
        b=UdBPM+q5Nl/eJF7k391wHSv5s74uRZkMVGsGj3JqR4oXrMTxYQ5ql/lNxo8z1bnrhe
         dn3VYqPWxSOBnPUva36aEdWU4BMNw2TaDLDBSNZPYf1tOclzgZsi1rzrnFeG9qR/alaK
         ndxDTKj4R6SxE4B/F7PXP2VlUKqlBIRKXV/GPD+XocnVIiCRKzUpShb9GJzoKrtDQdUR
         VDJxVoEx4hNIY5hx4czQRIAe7krYJK+xQXAzp7oR54n9mdtMgjM+cjao0NaDEsX/wKFx
         i/PNAjCR0P4QW26UxKecBzXJ9d1P9Vv+jysnlJZAK/4BoA/EAu7kgw1UF8dHnOA8XgPQ
         itAw==
X-Gm-Message-State: AOAM533HRtdMmAh4kHhu7uMI64n4NT4DdVSfys9hQq2LOYP5hXV8N2e2
        HT5q0tcsjFHyjWenybh20KazgFyIeM52LXD5
X-Google-Smtp-Source: ABdhPJwrhlYBTCMNGd6dk+ep0WS72c9ccXWM/RrbciuIsm0kwt0Gq3rsLnnAuXIymiJRE4/OKlkqUg==
X-Received: by 2002:a17:902:b490:b0:13d:588b:d857 with SMTP id y16-20020a170902b49000b0013d588bd857mr10219122plr.16.1632508332083;
        Fri, 24 Sep 2021 11:32:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm7236629pgv.82.2021.09.24.11.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 11:32:11 -0700 (PDT)
Message-ID: <614e19ab.1c69fb81.cf743.8285@mx.google.com>
Date:   Fri, 24 Sep 2021 11:32:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.68-62-g5f146c9b42a5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 86 runs,
 3 regressions (v5.10.68-62-g5f146c9b42a5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 86 runs, 3 regressions (v5.10.68-62-g5f146c9=
b42a5)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.68-62-g5f146c9b42a5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.68-62-g5f146c9b42a5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f146c9b42a50dde38d6fe30224290ee0be577a9 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/614e0a74eb636322f399a30d

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
62-g5f146c9b42a5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
62-g5f146c9b42a5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614e0a74eb636322f399a321
        failing since 101 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-24T17:26:46.723067  /lava-4579688/1/../bin/lava-test-case
    2021-09-24T17:26:46.739985  <8>[   13.221764] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614e0a74eb636322f399a339
        failing since 101 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-24T17:26:45.294772  /lava-4579688/1/../bin/lava-test-case
    2021-09-24T17:26:45.313046  <8>[   11.794873] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614e0a74eb636322f399a33a
        failing since 101 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-24T17:26:44.269463  /lava-4579688/1/../bin/lava-test-case
    2021-09-24T17:26:44.277504  <8>[   10.775067] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
