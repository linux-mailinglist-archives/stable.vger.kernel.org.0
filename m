Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FCF427EA3
	for <lists+stable@lfdr.de>; Sun, 10 Oct 2021 05:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhJJD7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 23:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhJJD7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 23:59:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63F3C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 20:57:44 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v20so1754756plo.7
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 20:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qb4kjoyqn828cyOlKFmGuMz0jotpuVnVAzbItK52FuM=;
        b=MFO1LtbunsIDhl0x/d9A7Tvt1/e8JDjuS72SrOGwIDgQ/x67y/yOs54i4v3rHR/EzB
         camUTXf3mhGh+9yAqnM7o8JbNhrEZe64EriOOxFzLufskVKaaAh72bjfN1XKOqeiSTw3
         5PFZdPTGcLBsaPTCohgezZDUEXaMaUwgUm5YiZsaz4o7bVWRjx+lRjpkpPKCU0zfhs+Y
         3zUQWxZaivd0InHH9y0e2whMsW2N+A8LQl5unfb779adEbiUzi30NzCq9s+U+uDmETnA
         /7jyX8ClOyJguG+HKHZIWvtQ1vJSegzqOWvDYjzL6IWSGrwPXlMltjkB7HReAdvOnhIx
         PgCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qb4kjoyqn828cyOlKFmGuMz0jotpuVnVAzbItK52FuM=;
        b=6tVQrW0x+wXAKYzXtwukHQyxT3T1sm41PkFEmMBKccoX8+2nnqWMM7dYuhrxwBRkSE
         oei6vaQdDjxnTQuXuEV0vhvQb/oDJkCTmW03T/eTdrlQfmx+q/Y+g68OudlqfVVW/tN4
         aV284c/qU4oAY5t7OhtlZ8kW9nbS5KywDS4wF7Kj7rO85SfYSN/adfMw8Rjo5ZcK6VuE
         3xGIE7i76qqPpceSQ+bUKF4uInz496vx7cDZpRIlgUDgWgxFGjPcOCmUHIR1wZJZL/Z6
         WEdwzEquQn7TqtS2ofKz3Fxlwoxafgy4EuSWjOtFBcbdTAcCdtfr58/muVFIhU2kKEyg
         nfyA==
X-Gm-Message-State: AOAM533zkLxcaDqY2P3JqTOUDhZQHP02x0aSmjvo2fzDzvPqHfzZ5kTA
        m0vW2/ibTG62lFJrax7tyV/FY2SKVOjK1oNT
X-Google-Smtp-Source: ABdhPJw65/mT8yIDfash1ScK47BSS5Es9z09IP9uiKhisv8o2Gs0MguRyvznNO1+MkiBfyFIw+hbBA==
X-Received: by 2002:a17:90a:af86:: with SMTP id w6mr22117517pjq.8.1633838264033;
        Sat, 09 Oct 2021 20:57:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x35sm3773393pfh.52.2021.10.09.20.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 20:57:43 -0700 (PDT)
Message-ID: <616264b7.1c69fb81.4298a.aec4@mx.google.com>
Date:   Sat, 09 Oct 2021 20:57:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.72
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 115 runs, 3 regressions (v5.10.72)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 115 runs, 3 regressions (v5.10.72)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5aa003b38148d584f20455ecac85c51187d0b71e =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/616233793fa895307399a2f2

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/616233793fa895307399a306
        failing since 116 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-10T00:27:05.154618  /lava-4687984/1/../bin/lava-test-case
    2021-10-10T00:27:05.171706  <8>[   13.712048] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-10T00:27:05.172201  /lava-4687984/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/616233793fa895307399a335
        failing since 116 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-10T00:27:03.731344  /lava-4687984/1/../bin/lava-test-case
    2021-10-10T00:27:03.737044  <8>[   12.288920] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/616233793fa895307399a336
        failing since 116 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-10T00:27:02.717277  /lava-4687984/1/../bin/lava-test-case<8>[  =
 11.269539] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-10-10T00:27:02.717858     =

 =20
