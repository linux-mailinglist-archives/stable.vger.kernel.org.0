Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDBE405BC8
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 19:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbhIIRLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 13:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240834AbhIIRLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 13:11:18 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC209C061574
        for <stable@vger.kernel.org>; Thu,  9 Sep 2021 10:10:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so1996156pjc.3
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 10:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nXO94WPb98SuyIu9eEODwSJG7gRY+/hQJf4os6sTovY=;
        b=M9J3hTm9knXvXmWPjBJcIOP2vHjVoQ/3sCDLVDbHQ7Z3VxrczjvtFqR7EfT+a8VQkE
         KUWkeRWxK9E4inpE6ESIlarJMvBJWFNYVOsNFnywYsG2yO1o390ZCuQy7Hra+nKcEM+h
         XeZx5x6duD6YnNElrv2c1ZqqfscJ6Tn3sLHhYUIRmVH9pKN4ovxlhDJOlI7G4B/Xuhlu
         PS+qbfP/a/IdXA5bBGMwHgwzzYp7+/niTZjkeMwf0dTLlfQ4sB8J3vy3LxPnX5OoPOBf
         1pHmwCbvpUlNxsjYq9xk2dXCK+DPJklciheospPEqz3dCfh/aVFs+CX01QvOy3YPBNCF
         d+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nXO94WPb98SuyIu9eEODwSJG7gRY+/hQJf4os6sTovY=;
        b=t/2FyAtAHr7MzFUXy8DhTbx+ezjpRII+9Jo51PN5LBcWMwxlKLNHNKFtG1gjIwrJYj
         te/guikOmZ9ceP9pBEW1tjF3nM/fxM46I8VBdUnNXVuSDyVCgi7AQbvDocyYkapianbh
         LurVgBU2IJQlcGViz4wKZGlwHXkIm9Fdnf73adrrzAEERwzBoQQWvzvRlwjtuSoY8ZXb
         maPclOmMQdQWzDMzIh7uE+/0pw/Pw6SNRzrNFDbwmwNCAat8Hz5CnsxLdyelw0lXDrBy
         PaXlEeyJCBhaSu2XGYUjmjqMO9CSyZRUW5pvQWBm0L2nddCD8LFVqPDC5AS7TemNbijx
         gh+w==
X-Gm-Message-State: AOAM5311CYBWg6Z0xhMUWRyBj4srWU9ANt9VUOo5p9Nq6Atcdw6CkJAP
        ksdnxv3bkYc11QnoZkGIGzoL1K/G09PhJ5hf
X-Google-Smtp-Source: ABdhPJzUhp7hHNhkq9CUPo1a0ND7b45feZRI1ggm4AkeYdYj78Lc1XgJ77+/VUQ3LcNMe0O2aINbAg==
X-Received: by 2002:a17:903:185:b0:13a:7ef0:8f43 with SMTP id z5-20020a170903018500b0013a7ef08f43mr1012805plg.32.1631207407975;
        Thu, 09 Sep 2021 10:10:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b20sm2880197pfo.3.2021.09.09.10.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 10:10:07 -0700 (PDT)
Message-ID: <613a3fef.1c69fb81.9c99e.7a44@mx.google.com>
Date:   Thu, 09 Sep 2021 10:10:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-29-g3bcfbf9c2333
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 208 runs,
 3 regressions (v5.4.144-29-g3bcfbf9c2333)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 208 runs, 3 regressions (v5.4.144-29-g3bcfbf9=
c2333)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-29-g3bcfbf9c2333/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-29-g3bcfbf9c2333
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3bcfbf9c2333f617834c10c87a17d17cdea60331 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613a1449fab6649e81d5966f

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
9-g3bcfbf9c2333/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
9-g3bcfbf9c2333/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613a1449fab6649e81d59683
        failing since 86 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-09T14:03:41.970158  /lava-4482791/1/../bin/lava-test-case
    2021-09-09T14:03:41.987644  <8>[   15.604504] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-09T14:03:41.988190  /lava-4482791/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613a144afab6649e81d5969b
        failing since 86 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-09T14:03:40.545539  /lava-4482791/1/../bin/lava-test-case
    2021-09-09T14:03:40.562771  <8>[   14.179414] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-09T14:03:40.563286  /lava-4482791/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613a144afab6649e81d5969c
        failing since 86 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-09T14:03:39.531442  /lava-4482791/1/../bin/lava-test-case<8>[  =
 13.159921] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-09T14:03:39.532011     =

 =20
