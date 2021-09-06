Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5B84018F7
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 11:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241374AbhIFJhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 05:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241357AbhIFJhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 05:37:35 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96811C061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 02:36:31 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 17so6236912pgp.4
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 02:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ND/UxPYJ2REVTb8fWBzlqQ9EBZbGe99ONTnGYULgBQ=;
        b=EkYghln8VcOEPqQ2yCAvJtn8EHeano4NLCLl1m0aeo7T0Ji0eBojMHfy0iUHidGk7Q
         D8chzmyFlLX//Nku1wvI7hm6pk+BDvM4VjUajLhzD20SjduFiW1dI65T/AoVn90EAbFb
         ux15EpRtZumXyA9ne5B0pCpwiFHJxkuYxukZl9FYNVZHcaHe0qhSAUU33JIrg1gKa8tC
         JshTCjWP8ugWXfoxNGonRrFoD4EinqCYXri0e77dGT5di1UnTPFrWP5nLDnplBg5JotJ
         oYgSRFwnWbBMA7syAVBcvW07K+oEbqqZiOnxSXTyIZG2pVdByn+WmqqeHTktvucbJjrZ
         H3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ND/UxPYJ2REVTb8fWBzlqQ9EBZbGe99ONTnGYULgBQ=;
        b=HExpb3Xqy83rkIG6UtSOv3XxknQyB9EqAiS75y5TOEx52/CSSaG9ipvLSC4AahHNvO
         RkwIsZ2Dtm8t0Lpc+hJ5tOiZD7pcw2YX0R0UKXOpAxIzn1aZEwfqSAtXJy0buWl+S/NQ
         qkvIfYMMuX8IJXVdai2bwMtWcV0lFnkeC8N+vvgtLUGhVL6RsfKHXJi4jTUgOXemodV3
         1O/3DUpW3/FNFUto+BHvNO8fFFAslTREI38EauEKg/KBcEUG5j1qfUd70M0XbzaDKvXw
         umOWainresHw2YFD8RxIaxDXt5ai27NvzNIPHL/P5/L4C6FwqPdXhY86osO00mdfsOMx
         v95A==
X-Gm-Message-State: AOAM530nwgj5BA7zC5j4AwFHAhf6yd59LX1vtoyRtvBceZtizZd6uI8h
        HYxYUuLkqCjeUjv47J2vvTH6MthQ3PMFksPU
X-Google-Smtp-Source: ABdhPJwVmCXFGj/3oA93BSxog+3ynWsx4FBhDEmn3Yr96oD2uYipGWSNUfl53M6ia7VZcV+L7qZgGg==
X-Received: by 2002:a05:6a00:a10:b0:412:448c:89c7 with SMTP id p16-20020a056a000a1000b00412448c89c7mr11111807pfh.83.1630920990934;
        Mon, 06 Sep 2021 02:36:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m28sm9098138pgl.9.2021.09.06.02.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 02:36:30 -0700 (PDT)
Message-ID: <6135e11e.1c69fb81.eb316.9ddd@mx.google.com>
Date:   Mon, 06 Sep 2021 02:36:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-15-g5eec6ce4404b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 198 runs,
 3 regressions (v5.4.144-15-g5eec6ce4404b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 198 runs, 3 regressions (v5.4.144-15-g5eec6ce=
4404b)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-15-g5eec6ce4404b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-15-g5eec6ce4404b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5eec6ce4404bdf85a36dbf45d2bc9d3615c27eee =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6135adf237f5f7325bd596b0

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-1=
5-g5eec6ce4404b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-1=
5-g5eec6ce4404b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6135adf237f5f7325bd596c4
        failing since 83 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-06T05:57:46.053228  /lava-4455378/1/../bin/lava-test-case
    2021-09-06T05:57:46.063746  <8>[   15.136356] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6135adf237f5f7325bd596dc
        failing since 83 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-06T05:57:44.637860  /lava-4455378/1/../bin/lava-test-case
    2021-09-06T05:57:44.656152  <8>[   13.712178] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-06T05:57:44.656615  /lava-4455378/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6135adf237f5f7325bd596dd
        failing since 83 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-06T05:57:43.619086  /lava-4455378/1/../bin/lava-test-case
    2021-09-06T05:57:43.624217  <8>[   12.692574] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
