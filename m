Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FEB409B79
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 19:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbhIMR7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 13:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344413AbhIMR7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 13:59:51 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF491C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 10:58:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w6so6360998pll.3
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 10:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VKqa+755YisdWu5cr9R7qQdlgQLrg2plfGQIN8rvWNw=;
        b=KBjhlB5O9TSKM8uagT7jrl4Zd5EhRr6pf5bOqJUjWnyY5NJX/SaposJKoMMrWP/v93
         1WfHpi5+63okml3MNtSJUHpMMlStSNZL3MaGVmfUbnnCk8Bkb0KW1KFbLn74lY/mFKFj
         e6iT9+yvH6L+Hqvbv2yT0O8wMababokd+hYKk83sT4fIOrlqzDb10wiMRqO71RfOHaNk
         K1XUsbDxPfkPS/BaQc6MXkuLhmYdc32v+AQEpnmONuBAEsQKE8reDjVIBeswj8RVmHM+
         AcTSnI4Ta0O9z+MJMbaZtF9SOu7ZMDKoxrIz86vaThPMNveSGPBRhwHs4FNIp2MollZD
         aDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VKqa+755YisdWu5cr9R7qQdlgQLrg2plfGQIN8rvWNw=;
        b=ZK61Wp0f7HjblOzyBVR5DNhYWizPgxYFVZaHpiamWQZlqkVzv4+SJJOKHyGig8OEff
         9XecFloN785H8q1eAHrtnZNBiZo8xIpcv5gvRB5fojiKTeY8UcOJx3ul5n5aAMcdHDQE
         xsCt/fvz/chmNOKOx/JzQM+x64dpGWyH71OWltp16V/7aQTNBXboLMLWNZXMwdGP7bqB
         2jTSDhEeTy7JLRLlmO5KznqqKCtByA+fc5xr3FiLsgOW3vKAppJETOxyw0l6Tb+NOUV8
         50symaAkB/0DzjZHqIeqFNS6AiohFZ+t3DEydcj2sdHwE+7J+f/+/q8IgAVWXQE8tXeb
         F0Ig==
X-Gm-Message-State: AOAM531G7N86nrSjgEPbwXSQIZGFknAW+WQB4vMOKZ+2mGhwqte4vGtI
        aChG/+3+Ffy50fekNYw9hUdvGKQaOpX70oD9
X-Google-Smtp-Source: ABdhPJwfvnQzro7JCHhP00zuAGzvBT8bsry/oFB/0zMWKq5NzbR1M2tKf6Z9Vof04L+KfjNSjBwI/w==
X-Received: by 2002:a17:902:a407:b0:138:849b:56f6 with SMTP id p7-20020a170902a40700b00138849b56f6mr11630638plq.0.1631555915079;
        Mon, 13 Sep 2021 10:58:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h16sm1743579pjt.30.2021.09.13.10.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 10:58:34 -0700 (PDT)
Message-ID: <613f914a.1c69fb81.7cc07.594f@mx.google.com>
Date:   Mon, 13 Sep 2021 10:58:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.64-236-gd7380ddf0a86
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 123 runs,
 3 regressions (v5.10.64-236-gd7380ddf0a86)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 123 runs, 3 regressions (v5.10.64-236-gd7380=
ddf0a86)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.64-236-gd7380ddf0a86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.64-236-gd7380ddf0a86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7380ddf0a86f26d31c0ed3340be78b2d6a92516 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613f6ff22c919c7f1899a310

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-gd7380ddf0a86/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-gd7380ddf0a86/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613f6ff22c919c7f1899a324
        failing since 90 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-13T15:36:06.006440  /lava-4510091/1/../bin/lava-test-case<8>[  =
 13.413955] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-13T15:36:06.006733  =

    2021-09-13T15:36:06.006900  /lava-4510091/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613f6ff22c919c7f1899a339
        failing since 90 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-13T15:36:04.561669  /lava-4510091/1/../bin/lava-test-case
    2021-09-13T15:36:04.579787  <8>[   11.986725] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613f6ff22c919c7f1899a33a
        failing since 90 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-13T15:36:03.541857  /lava-4510091/1/../bin/lava-test-case
    2021-09-13T15:36:03.547246  <8>[   10.967140] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
