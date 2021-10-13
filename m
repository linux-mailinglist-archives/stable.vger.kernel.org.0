Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC94842B40B
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 06:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhJME0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 00:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhJME0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 00:26:50 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9647BC061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 21:24:47 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id t15so1289430pfl.13
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 21:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qiFcjincio53AUT2kk+QZlM0tl4bfKuNkMfI+sVrLro=;
        b=sd6AhL19rkqemW19UBhp5ZxSb91UUhCb+nl1UtOuX/4L/076WUqZwnQ+JBV2oTILBo
         lEDC/9pAuih1bc2utAxO2o34+Ya6HWK6PQP9Ij75DAWpZpy8V/F3PtVwytnmZA37E+NP
         sKhzAyoB20oADgDwGifEkSjr92nys0fb1gL16E9K69XfW93mEpLQSITs62z0H2qUMJu/
         3Nofh0afdZSirC9N2nh++fiFKPVqtB9gYL66yAenj4a6W2mX6y4JmGtpNXFH+Oltax2o
         SVEBQmMYUWEElUA6VHylDFMBh7EdCOcuad9T2m44cSIxBH5BPa57y3nLSGMi0NLvZ8NX
         A6EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qiFcjincio53AUT2kk+QZlM0tl4bfKuNkMfI+sVrLro=;
        b=qs1Hh2WULNrg1e9tq7ajt70/huGeXPihcG2GpQVbLj3Vj8EUxVxwNRljAjN57lVLXt
         c6UnazmFazICPAXeHZaJ3R0CTP/EodUgqpTfTTMrb0Y4cXzKU1jPOAghd2BIltxxU3+j
         gqMYXemuxHCERG7NEITa6BSbCOu6f0wTGKIea6ZcpuhEtLBEb9UChjjfh9NQoCz3Y3ih
         tiSjWF1svc+9sf8iIQvucCQugfOZpClNwKKwtvda5POiv7rDx4KDPXdtLzex/eMmDsHE
         kaMNTNBl+df4R6tzEb88BKKrkRm0ANouzaQQohdukq1ue+gD2I3TjqbNSgYOLB+KjNYp
         Qf8g==
X-Gm-Message-State: AOAM532BtR5m+uMc4UKMwyjuIwZ0saC6F9cthCr0544mDp+wWDh5ubbq
        YtdmQbrbSg15p+1fNIbKIdCafLVlFMIjq7Sc
X-Google-Smtp-Source: ABdhPJx2mcarVCNLCDHc62DweoI8U67K1Kn9+nQ4yE1S10bjZuGRPbl5950EDEsD2dZHt0fOPlZlxw==
X-Received: by 2002:a05:6a00:1352:b0:44d:4573:3ac2 with SMTP id k18-20020a056a00135200b0044d45733ac2mr5419279pfu.12.1634099086852;
        Tue, 12 Oct 2021 21:24:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oj1sm4678129pjb.49.2021.10.12.21.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 21:24:46 -0700 (PDT)
Message-ID: <61665f8e.1c69fb81.84d0a.e88b@mx.google.com>
Date:   Tue, 12 Oct 2021 21:24:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.152-52-gc20820e7fdea
Subject: stable-rc/linux-5.4.y baseline: 93 runs,
 7 regressions (v5.4.152-52-gc20820e7fdea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 93 runs, 7 regressions (v5.4.152-52-gc20820=
e7fdea)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.152-52-gc20820e7fdea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.152-52-gc20820e7fdea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c20820e7fdeabc34e2ebe5e74d37c8dfefe6ce27 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/616621ad65bf9d166908fab2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-52-gc20820e7fdea/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-52-gc20820e7fdea/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616621ad65bf9d166908f=
ab3
        failing since 326 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6166249bba18aeea4008fabc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-52-gc20820e7fdea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-52-gc20820e7fdea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6166249bba18aeea4008f=
abd
        failing since 332 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/616624a62f4f45595308fad7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-52-gc20820e7fdea/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-52-gc20820e7fdea/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616624a62f4f45595308f=
ad8
        failing since 332 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/616624b0ba18aeea4008fae3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-52-gc20820e7fdea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-52-gc20820e7fdea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616624b0ba18aeea4008f=
ae4
        failing since 332 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/61662dd082a0872ec208fab8

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-52-gc20820e7fdea/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-52-gc20820e7fdea/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61662dd082a0872ec208facb
        failing since 119 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-10-13T00:52:18.148899  /lava-4706256/1/../bin/lava-test-case
    2021-10-13T00:52:18.166287  <8>[   15.333230] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-13T00:52:18.166551  /lava-4706256/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61662dd082a0872ec208fae3
        failing since 119 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-10-13T00:52:16.725038  /lava-4706256/1/../bin/lava-test-case
    2021-10-13T00:52:16.725429  <8>[   13.907718] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61662dd082a0872ec208fb00
        failing since 119 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-10-13T00:52:15.703890  /lava-4706256/1/../bin/lava-test-case
    2021-10-13T00:52:15.709106  <8>[   12.888034] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
