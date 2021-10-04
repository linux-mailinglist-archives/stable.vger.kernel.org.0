Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874FF4205A0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 07:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhJDFzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 01:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhJDFzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 01:55:24 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF720C0613EC
        for <stable@vger.kernel.org>; Sun,  3 Oct 2021 22:53:35 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w14so1019817pll.2
        for <stable@vger.kernel.org>; Sun, 03 Oct 2021 22:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A07XLiCTM5yTsvVK2jaiQqlIt8XWGabLw6IztzGVmGE=;
        b=ZtDPjHlIviJBvJ5DOGaSQ/7b7coDhLwL0smVDDvtgMGoa+atU2Ik6qJ1DHxRY0iRA/
         dsvAq1OyQzdXYkAPPRnCkzb//xE7pi9JhBF4eITz0KVXSzpLlL+EF6rcR1kGJHECWByQ
         oOYCpOtlMTUgCtYH1K51YhaJpe5DV9iHsU1bdR8qd4JCudj/dB9GFGmvZZeJVshb4QjB
         9X0qkOYF2PKi+IG7u1J3A+XDCRt9dSLChyF8xQiRVak5RBp76SFmU4mZsSRpZqAMm8BR
         VqcV5O7j4wzxYqWGB/KtwyXC8YLDQKRuQggs9Q7P+mOjsaWZRTQipF5SYIopvmW1ekox
         othQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A07XLiCTM5yTsvVK2jaiQqlIt8XWGabLw6IztzGVmGE=;
        b=15vG+OAmH151BROs3R2GWKpB1PkzI2AMLxoZof86T57qnPPfcfHvrwhK/O6Lq4bkxT
         So9YdTVsL00kkgx0nDE47cw/RnuCG18pqhpz4CA7l0sbEa8hLyJlHe/4MweUcBwoXK72
         4+Ei9oGN7xMOYAsQhPo2Z4qpgrx9y0Yk3J7R33g2EaZsPh28LusXoTOyJfMNjooWhwQ7
         Z1RJpiytCYY2evCxh6zuCjcoU0qTuxJgO/Yz08PysWVMl/DUnzk+LdhfRwXsKEC7g41a
         0zCRSSoorlWqAjG6cG8ZRBqD9gr/9xzOm8A01Gumf2VlASyhNVMn7380sKg8/iQswdj6
         FKQg==
X-Gm-Message-State: AOAM531IccTUCMOEq2HyZBIY9kSMNG7/Uns/EuqK9JKDrehF2X6I5Lsm
        iJhvXBVOfbDrlf/bXeKEZBTGGseEb/DXwNSk
X-Google-Smtp-Source: ABdhPJy69dE3uMhLFjd0pDYjeiqtp2c/Leki3khXlt1dg0fF0JaAiwbuR6TgVcPXWlkcmWRunG4w9Q==
X-Received: by 2002:a17:902:a50f:b029:11a:cd45:9009 with SMTP id s15-20020a170902a50fb029011acd459009mr21840257plq.38.1633326815257;
        Sun, 03 Oct 2021 22:53:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k35sm6239723pjc.53.2021.10.03.22.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 22:53:34 -0700 (PDT)
Message-ID: <615a96de.1c69fb81.f7d62.3ec5@mx.google.com>
Date:   Sun, 03 Oct 2021 22:53:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.150-12-gbcf15feed6a1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 198 runs,
 3 regressions (v5.4.150-12-gbcf15feed6a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 198 runs, 3 regressions (v5.4.150-12-gbcf15fe=
ed6a1)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.150-12-gbcf15feed6a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.150-12-gbcf15feed6a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bcf15feed6a1b2aa42957da73490ce2307ac5793 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/615a6bb23d8bfe4a4099a2db

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.150-1=
2-gbcf15feed6a1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.150-1=
2-gbcf15feed6a1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615a6bb23d8bfe4a4099a2ef
        failing since 111 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-04T02:48:45.017900  /lava-4637025/1/../bin/lava-test-case
    2021-10-04T02:48:45.035135  <8>[   15.814545] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-04T02:48:45.035360  /lava-4637025/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615a6bb23d8bfe4a4099a307
        failing since 111 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-04T02:48:43.592765  /lava-4637025/1/../bin/lava-test-case
    2021-10-04T02:48:43.609886  <8>[   14.389036] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-04T02:48:43.610173  /lava-4637025/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615a6bb23d8bfe4a4099a308
        failing since 111 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-04T02:48:42.572782  /lava-4637025/1/../bin/lava-test-case
    2021-10-04T02:48:42.578439  <8>[   13.369493] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
