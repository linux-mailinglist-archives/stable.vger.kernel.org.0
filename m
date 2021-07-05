Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550BE3BC24B
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 19:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhGERcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 13:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhGERcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 13:32:07 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E135FC061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 10:29:30 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b12so16090455pfv.6
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 10:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ra8vGY/N0azsKLLEQQgIrIhtBPm2YGeZ1BtB+VgltA4=;
        b=ShfToLTpfDMMuMeeZ+Zoe3WXR1yU5tIOFjY74rfe6i8dzyBXKOJ/99ceMKfqN/23NV
         CBh/qiGooa4eb31mbWDPeHtHiXAloS4cYir1B8RZGK4A1ajHD0ipxPz9yqK2N3A4LXv4
         uxBhBLdO7MJ0R4boVfi31H96ZfOspVSQEdysYtHyiew91H4AV2qTJ1ZYIj1XSQfUT4he
         wWcAKZl4G9Qr/hF3epb25a40nIYNrEJLn3ttIgLFFImeGHh50wrPkLp9OjRcmJEMNVmD
         Aq0XFsFxga5pcFLNh276CuaWm0K+k0jmGME490A8bMa4PHhN22GUSrIMJjH0O4a0/y2D
         ckEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ra8vGY/N0azsKLLEQQgIrIhtBPm2YGeZ1BtB+VgltA4=;
        b=jxWE7/u422M5Z2Po1fa2PfYU9LE8Pew5EiqFOErA2Ydcl/7rc1AvuW8gtImP1VtR6U
         OT6bwPzu/XUQHkuvJDsA8CLg4XPKBjUOnbxIv0ZXUkddWuxYCzH2ca3wx01myLGpy/Xy
         PAlBstrYYPWiGD1PobVljLyHybJCIVI9UU0kAzZLbmENlOZJqeiDs67N2fsPJaqzk9TG
         7wtFgb5OD/octgLcg1v8+1zPcYxCP/DQWbGQfezxt4+Fay6Ax9AjyVcXsctRxxkhLLA1
         Q1ZfykyUTLO6AZaN0OjftC9GJtSafPC3WGcvi6cFIjH1SfgEDX5jWhVaiYQoDTSJK5N4
         MuoA==
X-Gm-Message-State: AOAM5312w3iZKIAF6se1HbwWyhPkB0Q0x+oknlBiukHJvFGAGxTroJx2
        8C0m8C2mH5aX9BIZl+dVynCL1X0Jc6IN6zfo
X-Google-Smtp-Source: ABdhPJw1R+3L68yND8Segh0/rutoA4gr1f7oTV57xLJ7oVEVBlRKZ0+eSEn00iv6rCSUFerJ1gLLCw==
X-Received: by 2002:a65:6659:: with SMTP id z25mr16706327pgv.291.1625506170293;
        Mon, 05 Jul 2021 10:29:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o16sm8441472pjw.51.2021.07.05.10.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 10:29:29 -0700 (PDT)
Message-ID: <60e34179.1c69fb81.63e05.6847@mx.google.com>
Date:   Mon, 05 Jul 2021 10:29:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.129-5-ge7b0b94811df
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 166 runs,
 3 regressions (v5.4.129-5-ge7b0b94811df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 166 runs, 3 regressions (v5.4.129-5-ge7b0b948=
11df)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.129-5-ge7b0b94811df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.129-5-ge7b0b94811df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7b0b94811dfe4313ecc4916b5482d9daf0dcafc =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60e3385aae090474a3117973

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.129-5=
-ge7b0b94811df/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.129-5=
-ge7b0b94811df/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e3385aae090474a311798b
        failing since 20 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-05T16:50:23.788945  /lava-4142808/1/../bin/lava-test-case<8>[  =
 15.467844] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-05T16:50:23.789508  =

    2021-07-05T16:50:23.789887  /lava-4142808/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e3385aae090474a31179a1
        failing since 20 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-05T16:50:22.346812  /lava-4142808/1/../bin/lava-test-case
    2021-07-05T16:50:22.364778  <8>[   14.042844] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e3385aae090474a31179a2
        failing since 20 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-05T16:50:21.327661  /lava-4142808/1/../bin/lava-test-case
    2021-07-05T16:50:21.332969  <8>[   13.023393] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
