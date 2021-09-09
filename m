Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEDA405E94
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 23:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244755AbhIIVIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 17:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345722AbhIIVH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 17:07:59 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F356AC061574
        for <stable@vger.kernel.org>; Thu,  9 Sep 2021 14:06:49 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x19so2873791pfu.4
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 14:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ASFHuCCPeRM2K+GzExKLqpMn8u3xtOq5kurOTBJFnd0=;
        b=cT1TS/mXAqQ9K9GNRsn3MkdD4Ebts2eCG/VOQgSwI3FMmU2GDvWDz2hLLvGJHGW3BU
         vpcOvffrN5vF2oCK0PrjNELKnlJ+/r/PuWb96Hy6B0+fCLef9TlXgbU4P3chBr09iEwG
         PD8z7N9Zu9E2p4fefnnU2TDnFqHpBRSGEo80ihGneA+aAkjaBSOMJxCdWggqQ/3Inocp
         VzEAj+SfTXcki8EALsORIxA3mILboYUwYNm3bFi35RZgVqomxygOiKoapw/8vwTDREe+
         IK6TlP0pQQ4MTsJRY1gs5PL75xrdXn9EinthppqcUE+P+TIWRIUKCGIpI72Xa/F1PlDL
         VvmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ASFHuCCPeRM2K+GzExKLqpMn8u3xtOq5kurOTBJFnd0=;
        b=2auoxen4HkQA/ir2wD+ezmRWFP0EwDs8B66EQSgXcG+A2NR9bK1LEQ/lgc58FV1DbQ
         7TwH0+F2o9wmn5AJfeD3gczEnA3l+DbAsdl6OwVjCHCqVEkmidv/pVLrhF6FRdIwUSp6
         uSD8O1u/58kQDOzmg/jpFPNi61bHxdQcRkVZOpliH3WUn5swOEb30eOimMTm+ago2Ww2
         WVOwFjB/gOB/nakuFafsogCkOx6sdPIMaPqqCbBhxkUR2B2znGhIY/SogKURBV67Gem4
         d1Dnm9q69gG6QQH3UagDOef+6iU1fdcDaHqIy3TIdICcpZ+rAr6JdPBhiW9v9QmDTuy2
         iwcA==
X-Gm-Message-State: AOAM5331FZBNcHz9e0aAQZUAZOiP2OLU7T1XqqjJp28LceFNj8XEiOUH
        OB4FhxkA+hFw9H2FVZUoVF1tVmIfOqeW9/ny
X-Google-Smtp-Source: ABdhPJz+5qE1SGMyPUEgG/C2hkfr8yCeqKlb02pITtLOCZcZMOQSaJW2r+b3oI9q/a46aXt5ZJEB1w==
X-Received: by 2002:a05:6a00:1823:b0:42a:ee71:d74a with SMTP id y35-20020a056a00182300b0042aee71d74amr3350885pfa.63.1631221609332;
        Thu, 09 Sep 2021 14:06:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20sm3065593pfn.173.2021.09.09.14.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 14:06:49 -0700 (PDT)
Message-ID: <613a7769.1c69fb81.61b69.8a6a@mx.google.com>
Date:   Thu, 09 Sep 2021 14:06:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-30-g65e0d5635b11
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 205 runs,
 3 regressions (v5.4.144-30-g65e0d5635b11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 205 runs, 3 regressions (v5.4.144-30-g65e0d56=
35b11)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-30-g65e0d5635b11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-30-g65e0d5635b11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65e0d5635b11be356ee650cc434ec1dadd11c700 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613a6a02ed3e79120ed59696

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-3=
0-g65e0d5635b11/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-3=
0-g65e0d5635b11/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613a6a02ed3e79120ed596a9
        failing since 86 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-09T20:09:23.755052  /lava-4484737/1/../bin/lava-test-case
    2021-09-09T20:09:23.772001  <8>[   15.021427] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613a6a03ed3e79120ed596c1
        failing since 86 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-09T20:09:22.330184  /lava-4484737/1/../bin/lava-test-case
    2021-09-09T20:09:22.347220  <8>[   13.596294] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-09T20:09:22.347450  /lava-4484737/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613a6a03ed3e79120ed596c3
        failing since 86 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-09T20:09:21.316072  /lava-4484737/1/../bin/lava-test-case<8>[  =
 12.576688] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-09T20:09:21.316330     =

 =20
