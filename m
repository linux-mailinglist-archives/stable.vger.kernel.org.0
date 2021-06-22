Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68423B02A5
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 13:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFVLZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 07:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFVLZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 07:25:03 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9507BC061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 04:22:47 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 13-20020a17090a08cdb029016eed209ca4so2065454pjn.1
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 04:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3w0wccwccsXQTw0xJWQTTpGWtf4LPM1sr/PYbEyMchU=;
        b=TuCKwIIGZdL01yJnNEhTBqql7QQJlmkbMfUEsTh1Al3g1U7M22geMDt/0uMsiILYb/
         Y3aKDyxYyqFCBE8/7t8ec1SH8uqGelynwP4yjZpQAajhWffVLTKcZQDhqw8vW+WoXINp
         zrIwe2e4d4kJnCDMB2E4FgB9kSfaN+WUaCBe1X4qEQaYg/X0vWxrmVOJw6GJ6tQeuxAx
         PfrptXp0QteUdxsCFnRI4bnaQnTkngSL+caMloydgdxCAGs/GjH8jaZ5o1h1FpS2OBPf
         YaW76kzDf6SxHWcayU6SpTvsNA0P5pwQR97MWWi3h9ySOAgr7M1t0dRxiSkUmArOK1Dy
         TzVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3w0wccwccsXQTw0xJWQTTpGWtf4LPM1sr/PYbEyMchU=;
        b=XYPF6a90eSvoyfFCyl+ZGO8NUFEQOqXMJlM+H9uuhFWt60Nc+Yb5HIXDI3iO1KwuRT
         eCx4DHQ/RNIO/8yhiR8ae/fxkAdeS1US7Sx3pAOhkw9cz+ENx79emuN3vMZbeoX3Bzza
         9co9qafZL60weR2zPKDKsGWOG0LxmLsej1Laxh2Ru5pL3AKrgqfCvdUCiVPyW4ZauEwX
         vmt67oApDX2zVQc+UkJn59nqLIf6cWdvlMwP+ay/etdTDPCoubvBAuAXgVkZbQw8WzGt
         OoWWaarH+xjlOaqJ1byNjrOTMsaIl2LNPaKn/PIDAH6XSbBBnyFxEEd3NXpLQRsdPDFb
         wPWA==
X-Gm-Message-State: AOAM533VAhaemXCZz/G/qT276C3RTLBUhn/VzyqunuEhmpePV8iumR/v
        T5I5pPJvfBPq/wDlfu6QNQJuM9KIoF+HWA==
X-Google-Smtp-Source: ABdhPJwtNgs0H7WCFkTFs4JZ0OltnkVhp9pyUoIMfimp+Ryo8NSQDTNSXqel1KLs2g03Vc1MH8131w==
X-Received: by 2002:a17:90b:3842:: with SMTP id nl2mr3576264pjb.227.1624360966966;
        Tue, 22 Jun 2021 04:22:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j79sm9570315pfd.172.2021.06.22.04.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 04:22:46 -0700 (PDT)
Message-ID: <60d1c806.1c69fb81.1c64b.824f@mx.google.com>
Date:   Tue, 22 Jun 2021 04:22:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.127-90-g27c44e52794f
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 175 runs,
 3 regressions (v5.4.127-90-g27c44e52794f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 175 runs, 3 regressions (v5.4.127-90-g27c44e5=
2794f)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.127-90-g27c44e52794f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.127-90-g27c44e52794f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      27c44e52794f6ee161379bd8da4c0a0cd7fa240a =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60d194d0bc85b427f6413276

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.127-9=
0-g27c44e52794f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.127-9=
0-g27c44e52794f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d194d0bc85b427f6413293
        failing since 7 days (last pass: v5.4.125-37-g7cda316475cf, first f=
ail: v5.4.125-84-g411d62eda127)

    2021-06-22T07:44:10.304355  /lava-4070563/1/../bin/lava-test-case
    2021-06-22T07:44:10.309699  <8>[   13.272578] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d194d0bc85b427f6413294
        failing since 7 days (last pass: v5.4.125-37-g7cda316475cf, first f=
ail: v5.4.125-84-g411d62eda127)

    2021-06-22T07:44:11.341673  /lava-4070563/1/../bin/lava-test-case<8>[  =
 14.292258] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-22T07:44:11.342246  =

    2021-06-22T07:44:11.342722  /lava-4070563/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d194d0bc85b427f64132ac
        failing since 7 days (last pass: v5.4.125-37-g7cda316475cf, first f=
ail: v5.4.125-84-g411d62eda127)

    2021-06-22T07:44:12.749510  /lava-4070563/1/../bin/lava-test-case
    2021-06-22T07:44:12.754599  <8>[   15.717233] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
