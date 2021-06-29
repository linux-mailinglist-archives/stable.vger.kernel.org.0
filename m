Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737AD3B76D8
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 19:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhF2RGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 13:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhF2RGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 13:06:03 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F3BC061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 10:03:35 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id w15so14538977pgk.13
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 10:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lVM2gFmU/Dd+PsHcRSl8GdUh11fKPyBCPDupMh4Um/Y=;
        b=HXN8f3b+VedvWEuAsFBgiJnNRhuVZg+4R9D2f1bZiVNrU85qZ443QPgh0KlDWyIIzj
         6hMzSw0xKqpXnjWdU4chxqb38HsnNMtiGr0PZIzie1QJNBORxPOdFII1/RIKWezlsojp
         379uF3y4PHcqmFEemm4Q7l9mTB4Qggkg6r6e9ejpwLf57eDEnpHL3Qxcd1SXUHmxGow8
         H0hkRmLvvvH4Ocit0k5ntJ/Xl6jMHcDco0fCZDWUDCbzAnz41nKwFInEfzlhRk5x+xR1
         wwOYi3QepM2kqqawdN1gDL54yL25pHk8JtZlZrCi8Oi2QPFTCyjyB4Ntfp4QAHG2xaFe
         9rNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lVM2gFmU/Dd+PsHcRSl8GdUh11fKPyBCPDupMh4Um/Y=;
        b=BPfs48U88pggqSSDV3tyUwvwc2ERj+QOwCALzd++x2uxfQsZ5csPpWG6yjL0km8kB+
         yAs2Tl2S/mVpuvq5heR0Zfhp1R/lFq9VDkS/84SKvl1VF/P8FiQZBoF3kicdYbKB9Apk
         RigLhNcrAA1YpCH9Pyv6UV6IJ95pE2JQ7ocZWDAcSvYDSJqFbMupKSIZZ0PD8M4vPFoT
         xVNisSRmG6yvkXbDZ9EDhQTkG2MyyvBjR5UjkBROeH4qegX7v6hHTQPORfc0qzsYk+Km
         bSJR3iDo0NIymU51Ws04cQ4OqbpjxVH+Un28E5KSBgio+kmZWw1sg/kLRU+/MwmGx0SJ
         RZ8Q==
X-Gm-Message-State: AOAM531G6ra1jdMReneUHT2C9Dq8a5HMFwvrghs8FmfdmUBC6kFwo9ST
        fMbx0qrEROmXaLZk1tM5SAn3HWtRa3yMLTl6
X-Google-Smtp-Source: ABdhPJyAmYg2nRp7NyZde/ZIKyUC6uuuNj5BZo+7otmZALV/0UYQ1Rg/Gt27jRfvNeBF2bY5usvD5w==
X-Received: by 2002:aa7:86cd:0:b029:30c:2b9b:2a77 with SMTP id h13-20020aa786cd0000b029030c2b9b2a77mr12271336pfo.47.1624986215112;
        Tue, 29 Jun 2021 10:03:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6sm19402452pgh.34.2021.06.29.10.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 10:03:34 -0700 (PDT)
Message-ID: <60db5266.1c69fb81.58307.80b8@mx.google.com>
Date:   Tue, 29 Jun 2021 10:03:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.128-70-gadfcfd8ba7bb
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 162 runs,
 3 regressions (v5.4.128-70-gadfcfd8ba7bb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 162 runs, 3 regressions (v5.4.128-70-gadfcfd8=
ba7bb)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.128-70-gadfcfd8ba7bb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.128-70-gadfcfd8ba7bb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      adfcfd8ba7bb60890aa9b8247b068c434ff89c3b =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60db2d9ad0cf5849b823bc18

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.128-7=
0-gadfcfd8ba7bb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.128-7=
0-gadfcfd8ba7bb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60db2d9ad0cf5849b823bc32
        failing since 14 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-29T14:26:25.307580  /lava-4111772/1/../bin/lava-test-case<8>[  =
 12.440322] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-29T14:26:25.307944     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60db2d9ad0cf5849b823bc33
        failing since 14 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-29T14:26:26.318280  /lava-4111772/1/../bin/lava-test-case
    2021-06-29T14:26:26.336317  <8>[   13.459804] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-29T14:26:26.336590  /lava-4111772/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60db2d9ad0cf5849b823bc4b
        failing since 14 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-29T14:26:27.760898  /lava-4111772/1/../bin/lava-test-case<8>[  =
 14.884728] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-29T14:26:27.761263  =

    2021-06-29T14:26:27.761486  /lava-4111772/1/../bin/lava-test-case   =

 =20
