Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D27B3B7C58
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 06:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhF3EFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 00:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhF3EFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 00:05:05 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D68C061766
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 21:02:37 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g24-20020a17090ace98b029017225d0c013so2104216pju.1
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 21:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lrUwdvmx46wCV6abv5gSkq6BTqU9zOYhxW+OSrr2Q4g=;
        b=pzKh64kpnu1kwC/r2/Bui/7/k0cP+Yk1Y8YzSc37/AQMHEEq9fYpQ5I6HHhYDCnvXe
         OiS/TMNDNsS46/PVdlgMQ5bsZdXVYkZQAZH0ULde6sNMe4oy95+4Pr3Gib72t+Hm52XZ
         2sxHcmMqFQbcIHe/ByuXhLooh7bDV8dXTK/fMbJIPDtwgLtlAx/7SEUf7i+OuFT5XFUK
         WqeYwzfTUw6AMBX55aH6vdmtc4wRerFPuST2tLq9KRCGj9lv+UYQfzIbdQhJVfCSC89X
         4f3MxCt1H5/zgdUXOAmYXyOQhf8n7aeCHK+OZzBKPnGIMhBuM5q6TJm2IqXFGw3k/+tn
         AiNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lrUwdvmx46wCV6abv5gSkq6BTqU9zOYhxW+OSrr2Q4g=;
        b=CdD7nHj+EehzIu/u7uvf5+hToFQAPe50Fs6XkwbFyzjJ/M53LNEuPiztXgibWleD9A
         zYcYCb8z+3xxnUF9sad4DjZMLjnvgAX0zsUELFvCcLLhte3H8iJGzFrx7gGe2+nRk+0J
         AZ+L4uk4G+2aJMo5dL8A4JvRHh2X+Qx9MD/4oav+K9vmgDstjZcp6wbRSGDcvca6apWz
         Gpya5VEhEd+bT6W1InV9OKBfTyzOipmjpiQJTLNV1YpTrq0vEPvWWhB/F+IwwyCb3xdE
         zax9OwdhiQ1pHMeuVLKsRemzS241PDJy6BfozCq01kUzuaQzMg6M1r0c2FW7h+w8/GcW
         nE1w==
X-Gm-Message-State: AOAM530p4gIZbGm2n6Y2HbmSVIBJ80s/GWfkzjgxgZOx94RBt7/wUvZ2
        5ORdUzguEXmE9lFJeFmWn6b38ZMRTINBx8xl
X-Google-Smtp-Source: ABdhPJw1/3VVJ3tzOzXG4NMg4V/KK1wd5RYvnbJd0UIInxGJoGfTbPbO/squ5GtybTNKTcEvbFWXfQ==
X-Received: by 2002:a17:90a:d58f:: with SMTP id v15mr2309168pju.117.1625025756483;
        Tue, 29 Jun 2021 21:02:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j20sm18641620pfc.85.2021.06.29.21.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 21:02:36 -0700 (PDT)
Message-ID: <60dbecdc.1c69fb81.5f119.73b0@mx.google.com>
Date:   Tue, 29 Jun 2021 21:02:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.128-70-gaa878d9f4438c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 158 runs,
 3 regressions (v5.4.128-70-gaa878d9f4438c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 158 runs, 3 regressions (v5.4.128-70-gaa878d9=
f4438c)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.128-70-gaa878d9f4438c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.128-70-gaa878d9f4438c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa878d9f4438cbf1ed47cc4826d5753d9d3bb0fd =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60dbebbb295b42fce123bca0

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.128-7=
0-gaa878d9f4438c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.128-7=
0-gaa878d9f4438c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60dbebbc295b42fce123bcba
        failing since 15 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-30T03:56:56.349642  /lava-4116272/1/../bin/lava-test-case
    2021-06-30T03:56:56.355078  <8>[   12.252546] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60dbebbc295b42fce123bcbb
        failing since 15 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-30T03:56:57.369589  /lava-4116272/1/../bin/lava-test-case
    2021-06-30T03:56:57.386514  <8>[   13.271974] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60dbebbc295b42fce123bcd3
        failing since 15 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-30T03:56:58.793720  /lava-4116272/1/../bin/lava-test-case
    2021-06-30T03:56:58.809932  <8>[   14.695759] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-30T03:56:58.810200  /lava-4116272/1/../bin/lava-test-case   =

 =20
