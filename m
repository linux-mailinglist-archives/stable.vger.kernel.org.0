Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA8C3C95B2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 03:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhGOBtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 21:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhGOBtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 21:49:10 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2425DC06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 18:46:17 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s18so4392602pgg.8
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 18:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L97DiSlEt16DRc5DSL8pKI/3iwnc8iM+E9G6ykS5Ny4=;
        b=u3/8HyjDQUDEW1jrgrhl3gCx+fDvlvOcU33wHU9IIRwGeo0VJKumk4XcwewWzm0+1E
         72jWg4pQceB6zwmvkWQypPYQDLG2MOcJkgw80iCUJbwEZ1ytw4YHVR7gC5vmkcRbHrgc
         39vhQsCeqRi7/0gjtd9oQDA5fcdf/q1Glv3ud/PyiP5kTTNRTWWPFSMqr7PDEZy2AEA5
         TQSYqgSRxeRqRMsJEynZEsiFgAMXke/L7zs6HqMsJ3sk2vlFcXSjBCrQFhAWFqlshKz3
         snCoZp9Wjxyp3e0WXc/cQw6u7ngGl8cuMPoQgVAZLX0Er2plRBoO3xW6j9p5iYY352HX
         kqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L97DiSlEt16DRc5DSL8pKI/3iwnc8iM+E9G6ykS5Ny4=;
        b=Jd45LCVja3S0pXssO8jD7khEfMqWETPN+ih3VwFZDHOWkC4uIJrF6dPi6njvD+ky2w
         KUf+Pg5arNcN3LsyP4Xu2nySSrjO696yeJm6kEA1oPqDvvstZHgMsDIjwmBcjJfziPbW
         qbAudRz/ReJlEb9fPEk+GdVHVKp+lWnibgq+onzYqMfzSdnXWiZvL8BaR0F+6t+1GEXJ
         egQQ2B0lGJv9J/qirwgyCbHd9RdEsUgyLGR4eVOW2FT1jiOwndrTGgqOIPPW/L4sVHzN
         oL/XjhwvZjUdo3ZONMYiymRN03siEMdfTBQnc01hOfjUz5DJf4T3Da2WWkM+tQMADu8K
         TvEw==
X-Gm-Message-State: AOAM530nVXI47fipqGs0GTwQIAjEw/IYndPoZvKIUfd5FRaLCUTbX73F
        oa7sf5iNRccr6nfByLI1nhOBC7JRASCdtObe
X-Google-Smtp-Source: ABdhPJwDU80m7s79UYFWtURkNb7S7e+gWR6NPlRqP1RKoc3TjZEWaXHlN8H35Ggyd9q+m3b6g8d/FA==
X-Received: by 2002:a62:2942:0:b029:2f4:e012:fb23 with SMTP id p63-20020a6229420000b02902f4e012fb23mr1259383pfp.55.1626313576512;
        Wed, 14 Jul 2021 18:46:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm4388873pfy.153.2021.07.14.18.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 18:46:16 -0700 (PDT)
Message-ID: <60ef9368.1c69fb81.b862f.e701@mx.google.com>
Date:   Wed, 14 Jul 2021 18:46:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Kernel: v5.12.17
Subject: stable-rc/linux-5.12.y baseline: 179 runs, 4 regressions (v5.12.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 179 runs, 4 regressions (v5.12.17)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      72e0aab10d2c35cd136fb842ad4cf1dc0f451df1 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ef6e60227ddcce3f8a93a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
7/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
7/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef6e60227ddcce3f8a9=
3a8
        failing since 13 days (last pass: v5.12.13-11-g6645d6f022e7, first =
fail: v5.12.14) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60ef873ab3ebce8b848a93af

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ef873ab3ebce8b848a93c7
        failing since 30 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-15T00:54:03.350246  /lava-4200404/1/../bin/lava-test-case<8>[  =
 13.180612] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-15T00:54:03.350604  =

    2021-07-15T00:54:03.350794  /lava-4200404/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ef873ab3ebce8b848a93de
        failing since 30 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-15T00:54:01.922217  /lava-4200404/1/../bin/lava-test-case<8>[  =
 11.752911] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-15T00:54:01.922562  =

    2021-07-15T00:54:01.922760  /lava-4200404/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ef873ab3ebce8b848a93df
        failing since 30 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-15T00:54:00.885141  /lava-4200404/1/../bin/lava-test-case
    2021-07-15T00:54:00.890588  <8>[   10.733053] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
