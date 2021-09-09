Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627E5405C33
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 19:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241579AbhIIRjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 13:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237224AbhIIRjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 13:39:23 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE87C061575
        for <stable@vger.kernel.org>; Thu,  9 Sep 2021 10:38:13 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q22so2430738pfu.0
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 10:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8NgWJCJ5cnQZjnpZuBUiEL47LQWz5POYbU8f3IolVFI=;
        b=adTh9VssOxVC274tF5vKBf2tgTjPrFRc1vCmBUCoejyKCc2raFD9W4vnzoCHvVM7/s
         CJ4i0ys2TxOivRJ9vSBLDr6ddrQpTsB6NjHOapjjpb7xTmInVucVCkT8ghTsG3MCHQna
         ePf7bzA9XLNckSJBbmpA9KJozJ93pG4jy3hfF7EPwdjSWGqpDcugVCs5uck/d5ZOFEMT
         ciV23PYEZ07/g+grOJHfkTgbNrlkcPsUdIQjjLzZpGLc6o4Km6Hfj+IzCrtzbAiO/TaG
         quBCnQxIS7iJXmzONqzKLM/bVQ9OBCH4z95gQA3QyA8nImdC4ZLMaEQiwracfesHt5Z3
         cCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8NgWJCJ5cnQZjnpZuBUiEL47LQWz5POYbU8f3IolVFI=;
        b=FddGxAjgEG7JMrWpWQCFVw69Rxo3leFWWSoewH+4Q2QqktB1f/DyNHIXtdw4/HGbeh
         U8C8L6L4Zm41JAI++ksR8aQf13nPzLK8Eblsm9+r5uIxs59rq1sdnojL0/2DrWlZiSZ+
         oZLaflie3nrgVm559lKj5o1+euYox/4nYF2CLLvnbGxK+2GYEUcXp71q2orYox8/VXN2
         Uq70qZrSom9wi8I/j922rd0r58JI38QCG4NFUNCqFPCswxNQ3LwCiq2sfZ4EkieSIhbj
         rFuejSUBbnbY4hcxWc143eMp6yQzPFZKtfdMU+TQOMxbBFtM5ql8EKnVHaZ9qHE1u3Oc
         5KZQ==
X-Gm-Message-State: AOAM532nZHTeta3y0nTlNPNYv2lYfX++6lddsvFhSS5hWvQtpJMUGqCn
        y8ITh/nyLN36Bx5/fq2eHvy0CRj7//NMLRZ8
X-Google-Smtp-Source: ABdhPJw2snKCobpsXpCAyGTargvtuhKNKt42nUU7uEpgIXzq6CV2WjxEls6qtl+91c9qi7iufIhb4w==
X-Received: by 2002:a63:385:: with SMTP id 127mr3699467pgd.343.1631209093342;
        Thu, 09 Sep 2021 10:38:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14sm2924934pjg.40.2021.09.09.10.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 10:38:13 -0700 (PDT)
Message-ID: <613a4685.1c69fb81.cbc15.74c8@mx.google.com>
Date:   Thu, 09 Sep 2021 10:38:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.63-12-geb725290fd0a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 213 runs,
 6 regressions (v5.10.63-12-geb725290fd0a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 213 runs, 6 regressions (v5.10.63-12-geb7252=
90fd0a)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.63-12-geb725290fd0a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.63-12-geb725290fd0a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb725290fd0a46121efbbb9d57705a72ea92f4c0 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613a149702bcd3d373d59673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
12-geb725290fd0a/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
12-geb725290fd0a/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a149702bcd3d373d59=
674
        failing since 70 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613a13ceb38ae73ab0d59687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
12-geb725290fd0a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
12-geb725290fd0a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a13ceb38ae73ab0d59=
688
        new failure (last pass: v5.10.63-1-g56ca228bc595) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/613a242e675ba25f0ad5967e

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
12-geb725290fd0a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
12-geb725290fd0a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613a242e675ba25f0ad59692
        failing since 86 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-09T15:11:34.579858  /lava-4483148/1/../bin/lava-test-case<8>[  =
 13.359383] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-09T15:11:34.580195  =

    2021-09-09T15:11:34.580393  /lava-4483148/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613a242e675ba25f0ad596aa
        failing since 86 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-09T15:11:33.157224  /lava-4483148/1/../bin/lava-test-case<8>[  =
 11.936783] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-09T15:11:33.157807  =

    2021-09-09T15:11:33.158179  /lava-4483148/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613a242e675ba25f0ad596ab
        failing since 86 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-09T15:11:32.119375  /lava-4483148/1/../bin/lava-test-case
    2021-09-09T15:11:32.125318  <8>[   10.917358] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613a1329c9448f77f0d596a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
12-geb725290fd0a/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
12-geb725290fd0a/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a1329c9448f77f0d59=
6a3
        failing since 1 day (last pass: v5.10.63, first fail: v5.10.63-1-g5=
6ca228bc595) =

 =20
