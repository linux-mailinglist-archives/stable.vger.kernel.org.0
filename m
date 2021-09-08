Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA5E403B5D
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 16:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351880AbhIHOS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 10:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348439AbhIHOS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 10:18:56 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D971C061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 07:17:49 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k24so2747507pgh.8
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 07:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7QOd7pczU8L7Zv6s/E39uJ748+a2jHSHrIT54wucCrY=;
        b=JveufTqQ9/Lmrk+TmDR3oU1wPZeUiAKEkqEGdc4olMASVREkvWie7SHlFes9Cabv1f
         DZ7YKV5qqFRS0KzETvF0w9Jyrzl6FnC2ODnH1hv2gEHtNHFCiRA7DnEgJUH6irPV2T72
         EVfJVfsPFqqsSrLdgbsm8zGuf5cXu5FcO6s33hl6E2L9i/0IagFPkanN1HnPl95F01d/
         tvfmwfsMCocpc31QD+SS3o8cyZcsxIYApwlkjRiecqh+cHDlPMvEWLQAWcHABMzFsDlY
         /DxLImoQZPlFQyaZ1TPU+kAAbrtbr9H7qU9X+yJcXeLp0FD5IKyFa/QksfDJLrc+Zd8q
         NK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7QOd7pczU8L7Zv6s/E39uJ748+a2jHSHrIT54wucCrY=;
        b=kzA6rz4mlGk+lyS7yCaaWl6Qq5sTG5pxWum4fLpEtLNl/+EaDECg+mzTV5cSTMdZYc
         naELzvqT1Vwxbl8rqM2TG7d+cORfKKygOg4xou42H2wjVlgJoRPx4/e+VMi43jVKvGWY
         o6zdZMRLrjMdFc1pWhay6psK63QaJ/zIrIDgQGPDEBFFgqXRXBm1TRIntJ5rqd1kBwRc
         /D+qQ0WtBZGeLFnkjSIrSOISdJ7CXqWhFajPsGLHuypft95zcRfOfghkI/WK1OWWK+RB
         W535wzTE+dcfvQx6RDt0sshqltaAAaJW9p1w5Yjn4LQxHN6Vwpduu5G9Whdb9zn7fdZI
         H9tQ==
X-Gm-Message-State: AOAM530DoeRopa229H3UnxuMiAFWEhuoI40P3NmtfKOPVDMfnilpfzlX
        7gg3CoI7ZefFNiEGDR6WQj7xZ+LZy1MTWWdQ
X-Google-Smtp-Source: ABdhPJxIhN/LaLsJuYOCrEG5R5tc6sTpOTALnp7+mWbcPYSX4pCfcyLWPQddVvySU1fC/REvnVFfvw==
X-Received: by 2002:a63:20f:: with SMTP id 15mr3879327pgc.319.1631110668299;
        Wed, 08 Sep 2021 07:17:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm2626283pfl.41.2021.09.08.07.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 07:17:48 -0700 (PDT)
Message-ID: <6138c60c.1c69fb81.3579d.725a@mx.google.com>
Date:   Wed, 08 Sep 2021 07:17:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-21-g692317af57b4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 198 runs,
 3 regressions (v5.4.144-21-g692317af57b4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 198 runs, 3 regressions (v5.4.144-21-g692317a=
f57b4)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-21-g692317af57b4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-21-g692317af57b4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      692317af57b4ee03fff87b8338f1dc7c0a0c0d96 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6138aaadb881ee494ad5966e

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
1-g692317af57b4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
1-g692317af57b4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6138aaadb881ee494ad59682
        failing since 85 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-08T12:20:30.994056  /lava-4475484/1/../bin/lava-test-case<8>[  =
 15.001400] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-08T12:20:30.994640  =

    2021-09-08T12:20:30.995067  /lava-4475484/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6138aaadb881ee494ad5969a
        failing since 85 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-08T12:20:29.550152  /lava-4475484/1/../bin/lava-test-case
    2021-09-08T12:20:29.568463  <8>[   13.575253] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-08T12:20:29.568960  /lava-4475484/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6138aaadb881ee494ad5969b
        failing since 85 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-08T12:20:28.532367  /lava-4475484/1/../bin/lava-test-case
    2021-09-08T12:20:28.532945  <8>[   12.555633] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
