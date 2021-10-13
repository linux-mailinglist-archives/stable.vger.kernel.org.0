Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2B42B5C6
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 07:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJMFnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 01:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhJMFne (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 01:43:34 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064C4C061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 22:41:32 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k23so1365261pji.0
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 22:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WbKBe91YyrZjnlNz+OtYtVGkIjtIL33cgUkQ25WWn3U=;
        b=QZQZeJU6E3eMinltbAtdg2/dk7VV1+wZIN3JeErPHHPyOruqprm9KGXEEcs4GwCVs1
         Lob4EAp528v7FWGjTCL8pEg0EipCPnp53DTuuj344VHmOAKEvvveIkChXLfXFOMaYDQT
         1JKhoxLUWjqjMYLAQ6n2J82GWqatRtM0Pp4N/vPvlFnt4yut4vY4d5SLGFlUbAKcELUo
         2u/xne71hkLKl8boTh5cAyWwjOwtZMKdObLJ9QFxhyCIxOILlNMdBWV5WbKHGP2/C6gp
         zSocqQpLDkRk9IBLGxKWXCMO1gH2vjoD4ogLdVtcOgouK0fw6y1TXQxDImIxQEbccVDd
         diEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WbKBe91YyrZjnlNz+OtYtVGkIjtIL33cgUkQ25WWn3U=;
        b=spEjcP5MZ9CZw4qgQ0FLU/jWRpDCTrd7xsvTX4JAZP1oOrVy668BmhV/y7d3fwijkC
         7fa/8piYDzQKNmOUfc/s+CjNmlVl5PecyqAlWN26kLuLC4tbe69nX76vfJEG8J56LEaw
         ai1dL732A9SOcUpKNN/cUSQI/uc0JfVJrwfkuBaBM/h5EdRHXcGOshaT1UgwulSlqbKd
         GbWSb0t7LK3PT/G7/+EK/Vh8C5gYCnoPKYELJHFtDsDeamX2+QHP51ada4yoeXDrqSkf
         A2J3sf00m8pDDKXUy02xvqFttqmczE/n2eL5zjPy/N2EfeoDuhsnovfl9g0ffCRSWVWa
         866w==
X-Gm-Message-State: AOAM531xBzaOUI6nez3cC7tCcyQr4whuzd8g1YAo5HSdJZXzaMmWCOGX
        bIINv4oPKRbFtmxPP8muzshQISrrg52MpyI9
X-Google-Smtp-Source: ABdhPJy5LVxUmO/XQ9OTVLQhE9ms++Wwl5VLU0V9RL1WHFUQPwYmDijy/GkX445tGyCLM6hgH1fOaA==
X-Received: by 2002:a17:90b:4f88:: with SMTP id qe8mr10919810pjb.223.1634103691276;
        Tue, 12 Oct 2021 22:41:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s8sm4470912pjm.32.2021.10.12.22.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 22:41:30 -0700 (PDT)
Message-ID: <6166718a.1c69fb81.cea80.dac5@mx.google.com>
Date:   Tue, 12 Oct 2021 22:41:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.152-51-g1d632587e428
Subject: stable-rc/queue/5.4 baseline: 105 runs,
 3 regressions (v5.4.152-51-g1d632587e428)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 105 runs, 3 regressions (v5.4.152-51-g1d63258=
7e428)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.152-51-g1d632587e428/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.152-51-g1d632587e428
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d632587e42814019ed68fbe2fe70290cad8c238 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/61664b9c800271c86d08fab7

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.152-5=
1-g1d632587e428/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.152-5=
1-g1d632587e428/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61664b9c800271c86d08facd
        failing since 120 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-13T02:59:34.160799  /lava-4707140/1/../bin/lava-test-case<8>[  =
 14.280746] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-10-13T02:59:34.161133  =

    2021-10-13T02:59:34.161329  /lava-4707140/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61664b9c800271c86d08fae5
        failing since 120 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-13T02:59:32.717103  /lava-4707140/1/../bin/lava-test-case
    2021-10-13T02:59:32.734161  <8>[   12.854922] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-13T02:59:32.734443  /lava-4707140/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61664b9c800271c86d08fae6
        failing since 120 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-13T02:59:31.697195  /lava-4707140/1/../bin/lava-test-case
    2021-10-13T02:59:31.702892  <8>[   11.835242] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
