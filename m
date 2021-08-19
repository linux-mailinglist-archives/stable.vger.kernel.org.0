Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBA3F0F6C
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 02:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhHSA0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 20:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbhHSA0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 20:26:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F382CC061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 17:26:03 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j1so3779541pjv.3
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 17:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yoDXyuHy9wZ3IVuhL20p+M+L1pjLSSaJqoGq8J7Vbuo=;
        b=OEPhkgAgmVJm1rACHtrvGK/cpY+7prYBDRCs+3Hc0UPyi7Oq1gyNNSKxnjbEZOyUlu
         uoGTXZTsOODrljQKL0x6MVOTYUtQFVTDjjlj9wGs61ObdknWUoPM73Tvu/fuAP3TBenz
         tNNMZlpXfAxZNDnzsSgXVMXw7ycjKj7GIq/VBmOi8BJK0SUbRfuFf3ndxnwU/h6Hs9pC
         ZeKUFZlJ3fdTz5W63TiPIMoiyuT5Jx6InRPx3/cHkgDhiwyyUcuTos9hMe8z4PQRqhn4
         lV8X+7QoN8HJs6jrgIYniaTMp9EgQlwfHSXUFy/Fp9VM3MeWh5N94MCq5nSvniNiv3D5
         U9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yoDXyuHy9wZ3IVuhL20p+M+L1pjLSSaJqoGq8J7Vbuo=;
        b=TRaoltr3iFJ+aIb0mkuiA0LG2sOPAXa812O+KIvIhKf5DaxyjjvmvxUUhr9u2DA7io
         7HWM15posoDfpInJVKZM46pIokLdTpuRWUfwxB1VdFqZA75hhekunB6TzFGuP+ReYhdI
         C6eJcVDCKmz0BYKIViGMI++t1nbx33tSYUUb2Rn7llvr1AO5mIoZhF6LlGOcmtUCeB0x
         3H1HqeQwnorNN6swJpYwLihuYCB1F91zK54pgysG2mqd2tk8A/GHqVAvRB6vDr87DdUm
         TcgJPiigRrggJa+QHA3fS/07PHwqnLkWgNN0MTVE0XcZEOlEpRKdmySdF4itn49BMaS6
         j7eQ==
X-Gm-Message-State: AOAM531mYl0ZR4CAGDnceSvxzEkl8wFTKL7+AlO0hdxgFuG0O3+MoUPZ
        JCd2nS16mUlFPLDDX25kqzsqA0J6ECn375cp
X-Google-Smtp-Source: ABdhPJx+VuNNZSUz2n+otULMQ7KWGW1iU8kcmc9HDPdBjgwXXjLqfgpnbRyQmNjPL6+XxidY3QVZLQ==
X-Received: by 2002:a17:90a:128b:: with SMTP id g11mr11558702pja.25.1629332763430;
        Wed, 18 Aug 2021 17:26:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r92sm884167pjg.7.2021.08.18.17.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 17:26:03 -0700 (PDT)
Message-ID: <611da51b.1c69fb81.53f4c.4034@mx.google.com>
Date:   Wed, 18 Aug 2021 17:26:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.142-8-g6b12dce391f1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 155 runs,
 3 regressions (v5.4.142-8-g6b12dce391f1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 155 runs, 3 regressions (v5.4.142-8-g6b12dce3=
91f1)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.142-8-g6b12dce391f1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.142-8-g6b12dce391f1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b12dce391f159b4a91814a86061195a44bbf8e8 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611d7ce5124aba27dbb13681

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-8=
-g6b12dce391f1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-8=
-g6b12dce391f1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611d7ce5124aba27dbb13699
        failing since 64 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-18T21:34:03.878944  /lava-4380066/1/../bin/lava-test-case<8>[  =
 15.611700] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-18T21:34:03.879565  =

    2021-08-18T21:34:03.879985  /lava-4380066/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611d7ce5124aba27dbb136b1
        failing since 64 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-18T21:34:02.454969  /lava-4380066/1/../bin/lava-test-case<8>[  =
 14.187005] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-18T21:34:02.455515  =

    2021-08-18T21:34:02.455935  /lava-4380066/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611d7ce5124aba27dbb136b2
        failing since 64 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-18T21:34:01.417251  /lava-4380066/1/../bin/lava-test-case
    2021-08-18T21:34:01.423398  <8>[   13.167309] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
