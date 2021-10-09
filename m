Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A89427D96
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 23:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhJIVUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 17:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhJIVUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 17:20:32 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FEDC061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 14:18:35 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t11so8466668plq.11
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 14:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yOZ0h9//zfRscGsk6V9nxG1bqaN/+Q/lDCbw5pOwRrg=;
        b=Rts5cZXw6DH8uIpe9XDm8PK2CJkmGKM4OdBOvtHe3Son/kh4n6gGGKRu58uUSbnrUj
         4cyuYkz2VIScLJerz+KQ2tavnRSLgIzCTYSWMa2D6SHjagKKCt6X0GdYaIkguOWiYKQl
         /z5qGaDilN65WDBekKdb4C8mQStK1rQqodZ+UHXMgyKf/LxDKzqiCbTZnIeTSRGsX2WK
         EvG9k9R7cERHJRj+YtUF4lXCSaBW8iFEXuK/x5jPjC4IdxEEhJGxsMLTldPF2ldRpUTG
         lEt8HWBAMJQ6dS6ND/UaRcZiPKtEeKM9numGGwQzMw9xKspoIkevGgYffvK0vVhZIIfC
         +CvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yOZ0h9//zfRscGsk6V9nxG1bqaN/+Q/lDCbw5pOwRrg=;
        b=UYLSlTZtaKV4lgKTgQQsVqL/qne/JcTNLH039a8mM5gXz6+O8o+G1se6OCgWBP/OPN
         +J24JzWuOd5UZe5P53p5+71NQPAcQLx96xqdZFNTogiYvKTwSlwvJH9iJWVh2uKTFUlY
         HU0Ow+T0e3X81i8JlgwDVBsmRjcJr53reBz4c9x4uJr0/O8Chi2d3eA2tq/tIN1YCs2M
         FQidFvvKAdZztcNbvS/xIoWs1C7VBYN1yoakXTudNW31Vxqza9NG7kqY3sY0esJUBBIZ
         asQZYCU7uvQIClSQf/3y2r4xuMfE7VR1oJx2dSahs+GlgtEo0JSj3NvPedLD5LFK8TjS
         LRhA==
X-Gm-Message-State: AOAM5313bTUMp+8IRHXG37CNx9lVuC5e7Oa6kpakT9Q0IqUpTt8VlF1+
        CSYNqb3OzPMhvz/9O0G6+539CKRA6een8nhR
X-Google-Smtp-Source: ABdhPJw2mIn8DDeeQJrqsulxjh6BjZ31j2bX57798MgCAIouuDxYAjLlr8O+SYWaWsoJXlJoi7qCuw==
X-Received: by 2002:a17:90b:388f:: with SMTP id mu15mr20015382pjb.28.1633814314523;
        Sat, 09 Oct 2021 14:18:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23sm3106381pfq.146.2021.10.09.14.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 14:18:34 -0700 (PDT)
Message-ID: <6162072a.1c69fb81.17e03.8dff@mx.google.com>
Date:   Sat, 09 Oct 2021 14:18:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.152-14-g3879bbfc90cc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 109 runs,
 3 regressions (v5.4.152-14-g3879bbfc90cc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 109 runs, 3 regressions (v5.4.152-14-g3879bbf=
c90cc)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.152-14-g3879bbfc90cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.152-14-g3879bbfc90cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3879bbfc90ccb86b82204dbe8ed35f7de280009e =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6161ed09602c4fb70999a2da

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.152-1=
4-g3879bbfc90cc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.152-1=
4-g3879bbfc90cc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6161ed09602c4fb70999a2ee
        failing since 116 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-09T19:26:48.428391  /lava-4685613/1/../bin/lava-test-case
    2021-10-09T19:26:48.445736  <8>[   15.155341] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-09T19:26:48.446201  /lava-4685613/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6161ed09602c4fb70999a306
        failing since 116 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-09T19:26:47.022437  /lava-4685613/1/../bin/lava-test-case<8>[  =
 13.730676] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-10-09T19:26:47.022961  =

    2021-10-09T19:26:47.023392  /lava-4685613/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6161ed09602c4fb70999a307
        failing since 116 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-09T19:26:45.984062  /lava-4685613/1/../bin/lava-test-case
    2021-10-09T19:26:45.990218  <8>[   12.711000] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
