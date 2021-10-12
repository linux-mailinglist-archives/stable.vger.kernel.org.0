Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3A1429D57
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 07:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbhJLFtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 01:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhJLFtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 01:49:03 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A2AC061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 22:47:02 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so1052730pjb.5
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 22:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9hHR9/20/o/KVVwWTVheMvg+vOyL22Js9zWigs0kjpQ=;
        b=rm9/9XiMQvQrTClRbAzDThR5EMKWgegoo8zXczyVcYcy6DIisoXRq3+rSG/B3/i0s+
         FEc9SZYA7J+VXt6l61xyf/z/7kgHBys6d4eu+m/jZdyuDhY23r9Rv5WcN0/aEL4O5LF9
         Qv5ifp30YmfHNEn07g+eqGa+HVid7lbkxrBvfiSfvjvtRw1OTnLH1sFZO4JfyDym5/pV
         SQnTHPeTx471iRyd2sxgBxS64hggwwq8dTPus+6+hs1usHDeYFA1l8QvVlrCo7NA7KIR
         XWbpHax/bWivSMLFZiXWGq0MHJN0PJI5r99luJbDTlLzrXCsIfwGiPeqy0nRXRPRE/YZ
         WVgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9hHR9/20/o/KVVwWTVheMvg+vOyL22Js9zWigs0kjpQ=;
        b=pbts7Bd9A1G9N/WpzgTlbnDhp0cS0zcenQX3GMn25uYmzbHjzK6XMvqlrIicra750X
         6RBQw/pjEDm7vI6FCnhzMf2arzgKuCphuTPae9FtoFiccKOhSBDZJ5iGOtMQHTkKZVZy
         P2gVrgVkUQcmqqA5VblfPcIKzwd6LtZJ9Oaqv23o8mqUpLqAjiiAo3viUaEOqwjLHGhr
         MSvEfzeBRW0ZEeK4RmVBCqfHtHGeXYFV6MzkwF7vJkSAjf5HH086kMCQUXTl+dFH1YRz
         WJQDv9RLzapcQI+JCsRU87mQM4XqCwHvEtC8Kq1uGN93K4HYF1Vtm/NHSmItCIGmIg+x
         5Vog==
X-Gm-Message-State: AOAM532x8eRGICFo36mHT0fu+j9LuYacw3N2VqVF8ndEIV80My3C+om7
        G3T3oQ03xym6rjM3IFJeER3MOqoisHg7t83g
X-Google-Smtp-Source: ABdhPJzY+ZFyhAV94D/RFlSktnMdKwYu21cbV0LDEYJcsumP5iYvpHH4SohfxTpdhZQVHAxB14Mz+g==
X-Received: by 2002:a17:90a:e7cc:: with SMTP id kb12mr3793948pjb.182.1634017622185;
        Mon, 11 Oct 2021 22:47:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id me18sm1251157pjb.33.2021.10.11.22.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 22:47:01 -0700 (PDT)
Message-ID: <61652155.1c69fb81.416a1.52b7@mx.google.com>
Date:   Mon, 11 Oct 2021 22:47:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.72-82-g9e85b06887cd
Subject: stable-rc/queue/5.10 baseline: 100 runs,
 4 regressions (v5.10.72-82-g9e85b06887cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 100 runs, 4 regressions (v5.10.72-82-g9e85b0=
6887cd)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
imx7d-sdb         | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig | =
1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.72-82-g9e85b06887cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.72-82-g9e85b06887cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e85b06887cd492a8aa45ef729b3d5115d6dfa47 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
imx7d-sdb         | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6164ed111e4f05ef3208fab3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
82-g9e85b06887cd/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
82-g9e85b06887cd/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164ed111e4f05ef3208f=
ab4
        failing since 2 days (last pass: v5.10.71-29-g7067f3d9b27d, first f=
ail: v5.10.72-19-g2ca9b8bdb28b) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6164ec4454e866aea908fb10

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
82-g9e85b06887cd/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.72-=
82-g9e85b06887cd/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6164ec4454e866aea908fb28
        failing since 118 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-12T02:00:25.726487  /lava-4697826/1/../bin/lava-test-case
    2021-10-12T02:00:25.743629  <8>[   14.550429] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-12T02:00:25.744033  /lava-4697826/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6164ec4554e866aea908fb56
        failing since 118 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-12T02:00:24.301222  /lava-4697826/1/../bin/lava-test-case
    2021-10-12T02:00:24.306716  <8>[   13.125571] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6164ec4554e866aea908fb57
        failing since 118 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-12T02:00:23.282167  /lava-4697826/1/../bin/lava-test-case
    2021-10-12T02:00:23.288017  <8>[   12.106175] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
