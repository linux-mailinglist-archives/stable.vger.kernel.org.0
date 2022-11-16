Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3264362C891
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 19:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbiKPS6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 13:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbiKPS6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 13:58:39 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111B425CD
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 10:58:34 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p12so17289058plq.4
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 10:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fPc+kwd0xjmiz9BZ4c0eRMka68LvoQoZlp5fS9rufyc=;
        b=r0kpeQjXddvfbfCHDJPoFTAAwNwHqGgmLanxGbdv5ZC1eRWQP14r8oACbj64cY5szT
         9YIzCPcUt6vzQNGHPvSOHm1CU8+GJMXrTIve2+ZHzbfAIbXX0e34Ivw02CXcy+wjpLYa
         QoHC1IFOEhN7a7OQcK5Z8FUQ4bj44DIz3k/qxrYQdKlk/LXiiUou8VDqensQuLsdSNXp
         a7Bi7oxFDX6kWCTAt4C2ULBs9u/zSVhwA4Ox+zs+h28HIGhkanuoU4iqplKZOiEMuZDQ
         cgR4wnh0r1XH3CiRtB+qxF/3OpQDyIWBpdruEprGL/ONFKifc36v/+XBnLHU24xXyJU3
         eWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fPc+kwd0xjmiz9BZ4c0eRMka68LvoQoZlp5fS9rufyc=;
        b=PTthhwPa79mmbDtmbYuljcWsYnB22BhzJ/kr+QjFYrlYpnI1wAUiswgM6oeJyQQ+wy
         I/M3ykRCR7l2szpHqN6M6LuPIZXMh6sP0VPlZGKM8zOa8XNl6q0EteZtwTbnbuZKFE7q
         KCbp8GGnWDFPD8bbpmiT3io7ltX5cSWpNrZx3qySZLaawCT6fy6yKnyFadS6o9uXbNx6
         JJXe23xWtfYZ1Tg8yXOFjOZFrYH7W8rXpGW6I9oLThqr5Fxr29aeYv+ZUOWks1Rw+xJX
         3/lCwfyV2xNr94giVLdEVwKq8QCfRm4hwfNCXYuU6BJcOGL64vLWRm6FWVLgNOltmYBf
         7qHw==
X-Gm-Message-State: ANoB5pmVUUe5oAL5CwKOjaUE7jOOGWALw4gtmYPvR6hGQRLl+xtJZvI6
        YE6cgmR7O23SbAcSZScy9MRIpb06QwgSDImQ9X0=
X-Google-Smtp-Source: AA0mqf7xs51h3EvDV8P4tRxs4v2CKQV0vKQv1Gy1c26PgmioevuEFvaNMXrxQwH7blsngAlclRq4OA==
X-Received: by 2002:a17:90b:4f84:b0:218:47f1:b473 with SMTP id qe4-20020a17090b4f8400b0021847f1b473mr5131125pjb.140.1668625114266;
        Wed, 16 Nov 2022 10:58:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 34-20020a630d62000000b0046feca0883fsm9866252pgn.64.2022.11.16.10.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 10:58:34 -0800 (PST)
Message-ID: <637532da.630a0220.65f7c.f006@mx.google.com>
Date:   Wed, 16 Nov 2022 10:58:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-33-gbb894c0ae2bc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 132 runs,
 2 regressions (v5.15.79-33-gbb894c0ae2bc)
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

stable-rc/queue/5.15 baseline: 132 runs, 2 regressions (v5.15.79-33-gbb894c=
0ae2bc)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-33-gbb894c0ae2bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-33-gbb894c0ae2bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb894c0ae2bc3d8dd1a9f99a82a01402fa136fbd =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6375015f8ef3fec90d2abcfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
33-gbb894c0ae2bc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
33-gbb894c0ae2bc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6375015f8ef3fec90d2ab=
cfb
        failing since 51 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/637503493443f5a8a42abcfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
33-gbb894c0ae2bc/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
33-gbb894c0ae2bc/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637503493443f5a8a42ab=
cfb
        failing since 52 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
