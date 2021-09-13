Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9B840886E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 11:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238696AbhIMJlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 05:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbhIMJlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 05:41:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3A2C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 02:40:33 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c4so3870111pls.6
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 02:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lTMcP+aXXB3lgOoOy3NoRr3bP1jJ+GIKfodsuwO5nzI=;
        b=SJwxp0N1K2WgFd422WTVr2U8I87KF3JeQV9PrFVRNKCp8CT7oCJAtGUFdJMEOv8ZeT
         ARJtFAsoiqKeEFzc/Yxhx2ed51V8SZxtp69l9s7EQn08jTiR9ldGonIXseq878uJXJUm
         fuOVYWXDtGKJpaKKG69pidk0FikK8zWckfbtVE5OLQjlGVk/FX34wnB7zrJuJ9ogDT3p
         4Yc5L4d12DKQ8GgY6uJWDEfRFU3M/Nrsg00q/jpunVZlaTT0lCp0iZFTxKGFBqRMVmnX
         4L7c0dyxwoNc3t1cpwx2vNjglkesofMUg1DUh7bzt7cytaezGlHtqv/i3PJbMxF+TNKc
         G1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lTMcP+aXXB3lgOoOy3NoRr3bP1jJ+GIKfodsuwO5nzI=;
        b=taDAgXatyfKrfAlKt0CWai5PFEyElByOMmC6J/WYDQe1t9OA5ujZKh6JNjsFx8HUhO
         D6VDc85dBgEYGEp8MBpRF1fDRly/poI31cZDgeGKHe03hZx2d+7pMeDqhKSCT9lOcQff
         FSA+cmZksUnHxZz0G/44wr9/UxhWBWgZFuM0vbkSswsUI6vsSOQEPjhOWsWwZmiFqJ5M
         JMB0arB2qdyHrKJIB40dhVNt733HITUONQ0NyUN0DoNYAZJs/KOEW2jB+OAT9M2SLRW7
         qepZn/91jqt4iUcncdccNqqs2nkStU26pmr+xBCMoQ+2xt1QKyNuRerl93H4/kc8NDa7
         9g3Q==
X-Gm-Message-State: AOAM5315G7KH8aLnAjndadfSaR3okiENnrk4MYlynja2NuF5dow8+yK8
        Wdq5DAyv53eHDOZ+8brE+x1HdJT0UZiGV3YN
X-Google-Smtp-Source: ABdhPJyYLlMKg3BgtZ6u2oU5DOQRFPQWoX4day4/cGEK2N2WEJGTYpHIrLNTFcnrRAlM/gff59u5qw==
X-Received: by 2002:a17:902:a3c1:b0:13a:47a:1c5a with SMTP id q1-20020a170902a3c100b0013a047a1c5amr9749893plb.13.1631526032967;
        Mon, 13 Sep 2021 02:40:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x64sm6433380pfd.194.2021.09.13.02.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 02:40:32 -0700 (PDT)
Message-ID: <613f1c90.1c69fb81.87a2d.0ee8@mx.google.com>
Date:   Mon, 13 Sep 2021 02:40:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.145-125-gbb54ffd2964e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 170 runs,
 3 regressions (v5.4.145-125-gbb54ffd2964e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 170 runs, 3 regressions (v5.4.145-125-gbb54ff=
d2964e)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.145-125-gbb54ffd2964e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.145-125-gbb54ffd2964e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb54ffd2964e62ffc9e36e48c54d6d60f4e10e38 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613f1b5fac0bf5462499a2e9

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.145-1=
25-gbb54ffd2964e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.145-1=
25-gbb54ffd2964e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613f1b60ac0bf5462499a2fd
        failing since 90 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-13T09:35:13.342301  /lava-4507565/1/../bin/lava-test-case<8>[  =
 15.427649] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-13T09:35:13.342870  =

    2021-09-13T09:35:13.343276  /lava-4507565/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613f1b60ac0bf5462499a315
        failing since 90 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-13T09:35:11.900491  /lava-4507565/1/../bin/lava-test-case
    2021-09-13T09:35:11.918614  <8>[   14.002706] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613f1b60ac0bf5462499a316
        failing since 90 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-13T09:35:09.866467  <8>[   11.963526] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-driver-present RESULT=3Dpass>
    2021-09-13T09:35:10.880597  /lava-4507565/1/../bin/lava-test-case
    2021-09-13T09:35:10.886369  <8>[   12.983216] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
