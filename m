Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A968D3BB7A5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhGEHTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhGEHTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 03:19:52 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3E9C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 00:17:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h4so17450851pgp.5
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 00:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zx2AubS1JGJErff7d6aI03kM5gcRcAu9f5CcBa0YSjw=;
        b=T4FFAaW6hcthxYiCULYwiX3wIdTFgTfHVLmZMgSGfGRKOVWH+a5WTtP72AgVp7hdrJ
         8IYbEcWWbM4Mc0HnPIsHYKwZVjYrAHV/AqgdlVI8zOFYh8ucZkbfl4sW94fKchC2LjM3
         GGSomP3Za1KPQS3JrfqhVTRT1b2MES75wdZka4SGcRzY7G0dJCok39Pxx7d/Hke75zeJ
         hq7UVVhf0lb0MsaxsTAz0ARtHXzIwflqUrjN988bluwtgPQ4lQmaGuO796YE+lFujrzd
         UE5zM6LBOzrMhd/XP+Jv+LCwkiSy+MlKKYCHUu1k1sOP+KT6eoRFKAMcFpthl6NGE7SL
         uL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zx2AubS1JGJErff7d6aI03kM5gcRcAu9f5CcBa0YSjw=;
        b=hlOmzjMawv4cilwwAc3THg68iHUUV33MNtesOCuxgLfsiEzcnTGW+mO9wTucymewQG
         kDlAFz7enMETCdp5ekcAMt8KjDoEyTkY1CQVyCdiCUc/ZOP3IQOKpKN3c5lWsbKLXJKe
         mzNBZHQ9ks7BSv+gX2lue0qfADj2KZDYz+dWTE1Cz0NBrcP4Gjt7PTh74OAaV3TXYSrY
         dzevqaI6+VBLyfIbQ4J/5ewDgF48p4ADBzZay2U0Uqia2PWsOmbKkyOAjbLKKFE7Ia/W
         6enpu/IlHNgG373YNQdp4j+DYCn7LW1dFC9wzHRmtXuEYuWmaCMiC97gidLhPtIGYMNI
         +hfg==
X-Gm-Message-State: AOAM530/ybkqKvGlQB0X8vq3FG5w3xLXWvkR81mQ34u+sNuLlNPDnGDT
        Wzh6J5F7vkH07yXDfSru9Tkcm921+1bvuTnZ
X-Google-Smtp-Source: ABdhPJywi+xizY815tmFEUdtDeAJv1WLliHfTR9WY5ysKgZ4VWOC9h/0J7qjb5+Hi7wrClmPOQkR6g==
X-Received: by 2002:a63:1d41:: with SMTP id d1mr14484394pgm.199.1625469433839;
        Mon, 05 Jul 2021 00:17:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i24sm9232879pfr.56.2021.07.05.00.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 00:17:13 -0700 (PDT)
Message-ID: <60e2b1f9.1c69fb81.e88d5.a3c0@mx.google.com>
Date:   Mon, 05 Jul 2021 00:17:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.129-4-gdd364368f0a8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 192 runs,
 3 regressions (v5.4.129-4-gdd364368f0a8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 192 runs, 3 regressions (v5.4.129-4-gdd364368=
f0a8)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.129-4-gdd364368f0a8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.129-4-gdd364368f0a8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd364368f0a8503e3782cafee6531d0223d3cb5b =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60e28dc5287bdacd2511796a

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.129-4=
-gdd364368f0a8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.129-4=
-gdd364368f0a8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e28dc5287bdacd25117982
        failing since 20 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-05T04:42:32.276049  /lava-4139084/1/../bin/lava-test-case
    2021-07-05T04:42:32.292427  <8>[   14.761794] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e28dc5287bdacd2511799a
        failing since 20 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-05T04:42:30.850948  /lava-4139084/1/../bin/lava-test-case
    2021-07-05T04:42:30.867764  <8>[   13.336841] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e28dc5287bdacd2511799b
        failing since 20 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-05T04:42:29.830655  /lava-4139084/1/../bin/lava-test-case
    2021-07-05T04:42:29.836370  <8>[   12.317309] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
