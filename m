Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA6641869C
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 07:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhIZFhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 01:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhIZFhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 01:37:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C90C061570
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 22:36:17 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id bb10so9445274plb.2
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 22:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eU9BcCDxtdgTvBDb62WkKT2N3b/mld669pdZB6jgW44=;
        b=4pU67B/NytKy6b8K0FbNlfV6u4JRoXhxlbA76e3hPrqKOOnJXEkuVrdULZpKhV2sSt
         fyrbX7s1Q/J0IGshmy9CUdgDp/Ty+sKG6Tr9gawWBzTlVc35TVoA2ZfWB00w3We6cw1J
         U8NTxY5l6sFPZftn40nyKcU+zhOs4UG5Uh13frxH7Bdvb/33bu+JTMPBSe0B5REepy10
         vTtXiouMgJ+Z9dTG/duyp5WyS5Oa7++77dkG2ZXroNtc7/2fpU6VMmGoscy1F2PGUniw
         Xo8biZQT/q4Bexn3DYmWxdJBdmtzucudT//1P8SbuULUIhToqncHeUxq3ap5WxqZWvjX
         JAUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eU9BcCDxtdgTvBDb62WkKT2N3b/mld669pdZB6jgW44=;
        b=ItMeVvxQ24tRMZSutIlL7GCmxM4yMgGJx21BX8eZb/1SFT6cPFUdq4swkv3fauSMSc
         3ysVUcpHohvWjizt4SN6ibxqT3o7vqg3bYOkOs92OQLF0gg9cXICGdBEhNv6vVtlh9ry
         tq0xrBbuCTgg7gGK+xpq5ZYZQ6Qw/h1K4V+DY39QHSaqN037mngM9IztZkmK2NBbB/hY
         /2zQuEVAcJqGQWiFeTusFJXGzYnMdbaSQNbUQ4atOpXkrUn7blUzO4XK8SYRur6FwmU2
         ZWye5uvbCKrwlsOoYv+fID4js5dZ+Uuz8qshPflfbbdWnskFuvR4dFbPCVWJtSoFrMjI
         ZqdQ==
X-Gm-Message-State: AOAM532z4Ss8WFSUd0o79CNfmTR8vvt5oIHgH/1cfbto0/51mekxBMfZ
        CSQXZ9JAkecdDBkW9HeDHpZG0P34iI9dKkKV
X-Google-Smtp-Source: ABdhPJwDit3rh2skRVO/KKgEOpgw+zihShg3Zd0TCyNOXaW0R/jL9fPV+fVUXCWyimyDkZWgUhol+A==
X-Received: by 2002:a17:90a:a88b:: with SMTP id h11mr12001188pjq.44.1632634576750;
        Sat, 25 Sep 2021 22:36:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d19sm13195807pfn.102.2021.09.25.22.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 22:36:16 -0700 (PDT)
Message-ID: <615006d0.1c69fb81.286f.a14d@mx.google.com>
Date:   Sat, 25 Sep 2021 22:36:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.247-27-g79e28eba79c6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 58 runs,
 3 regressions (v4.14.247-27-g79e28eba79c6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 58 runs, 3 regressions (v4.14.247-27-g79e2=
8eba79c6)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.247-27-g79e28eba79c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.247-27-g79e28eba79c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      79e28eba79c6ddd0403c4d2433bdc46eca3c7224 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/614fcfe1ba1c996ecc99a30a

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47-27-g79e28eba79c6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47-27-g79e28eba79c6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614fcfe2ba1c996ecc99a31e
        failing since 103 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614fcfe2ba1c996ecc99a337
        failing since 103 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0)

    2021-09-26T01:41:33.600725  /lava-4584331/1/../bin/lava-test-case
    2021-09-26T01:41:33.617749  [   14.517262] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-26T01:41:33.618131  /lava-4584331/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614fcfe2ba1c996ecc99a338
        failing since 103 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0)

    2021-09-26T01:41:32.583080  /lava-4584331/1/../bin/lava-test-case
    2021-09-26T01:41:32.583507  [   13.498559] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
