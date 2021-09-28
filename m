Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD41A41B350
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 17:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241565AbhI1Pwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 11:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241523AbhI1Pwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 11:52:53 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DD7C06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:51:14 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s11so21598323pgr.11
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p3BPvDmg0eXpdcapJuY/YrO1Buq7JqUbwOB8R5b9R50=;
        b=aVkUhrR/VRF3bDz3BZchlbaXZrsAzuKijT2B1uu9S7ry7QgkVsU9+l0XxR1vP4SJ0e
         hNzlMNTbFijxKbN9rYSSUNtp+Yz4uPK1Us67mbYRzU6LQ6Njl1ptUEQZFcBBNi8rO1hA
         7/BY+fX4QDqgDInSdD0nT3Yup+v1ppxtm+rKfFLGBgv1I8hkvcQdOMOQjKCExWE1Md/M
         JoNqgWKwN6btCOgFMwVe6XRZdx47PLA0yrxZWo58+RtfELTDUH9z5Bv5FezepLiHxZ93
         1CsxVow647HKH0T7z72HbMHqkzFCFIajnpxU1MQAe7gKXvtOsC7UGfq0DLHc60N3gNw9
         jdkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p3BPvDmg0eXpdcapJuY/YrO1Buq7JqUbwOB8R5b9R50=;
        b=GsYx8+9uBMbUNSOeOkIWfy0ft3xVa09989jpCGDBmoVaYJSfa4NYP81/gzzWBmoJZ5
         XCwucJpbD5EJXNqh6a9Bu4ntI3hHMPpaBWonFKP/b7G7EVm7CMD4YegKNvVn7Zxz7kTm
         hdtq2/xUtH135ducwPXHabYf8kOHBcxDb6QikINTNRr3I7HCGF3ouG6f2u6+L30+aqxM
         mU6p2daIh/As2VZ6UGONVzI2g93W3o2idNJJWPx6kRLP8kzHcP2JbVLZBDXravZjDK9X
         KlYEtOZtjNt0bXU5ZZk207NEWJcW2lBYhxwdoXG9SLDtoNW1SBvfRUSItSXRaeG5cP7u
         9LwA==
X-Gm-Message-State: AOAM532UrMJDd61Xq9qYHM9lTzISijkM8/DTCeca6jrdZmrn83wK9yg2
        Im0nhm0zMOjLhJavp10KgB/hKIKiKkO+xIcm
X-Google-Smtp-Source: ABdhPJw2RANsek+d9NsaXExfZeFp7V1zJX6h6T/QdzB8B/mqboKTFV4QglS++FhWxjiMBxQ22KFk/w==
X-Received: by 2002:aa7:8ecf:0:b0:43d:5046:2085 with SMTP id b15-20020aa78ecf000000b0043d50462085mr6399219pfr.48.1632844273380;
        Tue, 28 Sep 2021 08:51:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm20895123pfr.33.2021.09.28.08.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 08:51:13 -0700 (PDT)
Message-ID: <615339f1.1c69fb81.f1c5d.3afe@mx.google.com>
Date:   Tue, 28 Sep 2021 08:51:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.69-102-g20a383e29735
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 120 runs,
 3 regressions (v5.10.69-102-g20a383e29735)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 120 runs, 3 regressions (v5.10.69-102-g20a38=
3e29735)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.69-102-g20a383e29735/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.69-102-g20a383e29735
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20a383e297357b38eab5746358c0f50166ccc65c =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/61531a27ff2644758699a358

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.69-=
102-g20a383e29735/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.69-=
102-g20a383e29735/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61531a27ff2644758699a36c
        failing since 105 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-28T13:35:29.177670  /lava-4593493/1/../bin/lava-test-case
    2021-09-28T13:35:29.183065  <8>[   13.260169] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61531a27ff2644758699a384
        failing since 105 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-28T13:35:27.751016  /lava-4593493/1/../bin/lava-test-case
    2021-09-28T13:35:27.768633  <8>[   11.832861] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61531a27ff2644758699a385
        failing since 105 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-28T13:35:26.737032  /lava-4593493/1/../bin/lava-test-case<8>[  =
 10.813171] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-28T13:35:26.737358     =

 =20
