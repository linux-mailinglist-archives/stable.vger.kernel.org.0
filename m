Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9393E3A8E51
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 03:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhFPB0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 21:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhFPB0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 21:26:15 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0733C061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 18:24:09 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id h1so285420plt.1
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 18:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9LRafpJgPpVIqg6t/cHFl/z1o1sXMdGELiq9UjbxGOE=;
        b=wuwSLSowK4E9R/pkVVgStm2Duuyi6JyRO0m9VL/auUZVsKeKFn22Cj/muXV40M7caw
         aCdU1mzgk+rtwnM8+nIaeUY2yFCkBoCyffkLVdI5tMb7g100J1LVMSfqyqyYeIg8a3Te
         FTFW/VijNKfsomNAVkjxIigCc0zEiV77uLrDHE2qze5YAMf1PEjL/O8DGqNyJF4a1z4I
         MTx62d0zfBCZewZHCX60aIPBTcckvVg5tnq9cKtuvR3IfU34DTbpga55rSLobCdPk6oV
         T3J9RdO6PxlzrfvySub4ooLx3B4HNf8i82EUA0zfVTYSpMBphIVBSCHmBGpjTd3fPBb0
         Ubxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9LRafpJgPpVIqg6t/cHFl/z1o1sXMdGELiq9UjbxGOE=;
        b=AcvpnguXyYgnoX7IwZxunjwRRysbuqvq3SytlOSB1BOh58Dy2CsX1T6GeYb817HoQt
         jo9MaCIQWXblaAZ7WIWMuCRJCN/wJtzxs9bRw9CNQnUov0vQPgZtU7pIrtC0yLngWfPM
         oXhQTqouzdqYWa6UxJvNayOEt77Tf+zAGfjgowTrOdgLL9U1vdjSh2HZfszj0fVT4xzH
         jMzb4LlA5872Hi9C9UuXN3iiwJsEcxrxcG/78DBPBu/RFbbeMeTvXPr2DJH5M9PfVFw4
         JBBRyCkC6hUkwryO7njNzDkfPBytwcOv2He2cA8aEMfrp9AKyjuTdAzWjMIcz6CgNVue
         OPRw==
X-Gm-Message-State: AOAM5331dAgv0wwyzkMKHcFNyLKB6LNwUQOs3Ih9a7XB8lqXdIfVqV78
        l8dqoo/eLWSaFy3wDBfxNglXe+roXYl6BhtS
X-Google-Smtp-Source: ABdhPJy20HO6/RJFlwZoxua0rDU4y9xE4NZqJVEDyesw0d46RLbSXLfBzzRyh2DOCA+VZyVMUxg5NA==
X-Received: by 2002:a17:902:9685:b029:ef:70fd:a5a2 with SMTP id n5-20020a1709029685b02900ef70fda5a2mr6896880plp.20.1623806649186;
        Tue, 15 Jun 2021 18:24:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n11sm316776pfu.29.2021.06.15.18.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 18:24:08 -0700 (PDT)
Message-ID: <60c952b8.1c69fb81.7333f.1beb@mx.google.com>
Date:   Tue, 15 Jun 2021 18:24:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.125-83-g766b4640cb46
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 128 runs,
 3 regressions (v5.4.125-83-g766b4640cb46)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 128 runs, 3 regressions (v5.4.125-83-g766b464=
0cb46)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.125-83-g766b4640cb46/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.125-83-g766b4640cb46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      766b4640cb46a4f83bc17477c8eb62db03ef3855 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60c92cc25ae07dc2ab413266

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.125-8=
3-g766b4640cb46/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.125-8=
3-g766b4640cb46/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60c92cc25ae07dc2ab413283
        failing since 0 day (last pass: v5.4.125-37-g7cda316475cf, first fa=
il: v5.4.125-84-g411d62eda127)

    2021-06-15T22:42:03.867065  /lava-4029265/1/../bin/lava-test-case
    2021-06-15T22:42:03.872266  <8>[   14.645342] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60c92cc25ae07dc2ab413284
        failing since 0 day (last pass: v5.4.125-37-g7cda316475cf, first fa=
il: v5.4.125-84-g411d62eda127)

    2021-06-15T22:42:04.886229  /lava-4029265/1/../bin/lava-test-case
    2021-06-15T22:42:04.904177  <8>[   15.664978] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60c92cc25ae07dc2ab41329c
        failing since 0 day (last pass: v5.4.125-37-g7cda316475cf, first fa=
il: v5.4.125-84-g411d62eda127)

    2021-06-15T22:42:06.310878  /lava-4029265/1/../bin/lava-test-case
    2021-06-15T22:42:06.327965  <8>[   17.089076] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
