Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552773EBD98
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 22:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbhHMUsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 16:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbhHMUsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 16:48:12 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC152C061756
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 13:47:44 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q2so13553163plr.11
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 13:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5mDQubpjU9Xq2GkyuNWqhH/TkmX2IqKgK0v852Ly+GY=;
        b=XsLgqw0mlzN6DQ0s3jK+bvnbfQToSYysGGetokteKUCAHYb4cYBjqHYoESgixBHN6K
         pX2UNqJNM/EciLclfzvbmK8N1Cb+iigKesKEs2aHWpXmO/JJCLDhGJiNSBX+KyXTeIEe
         ofOcxDfCRrUJFeu7L/Y/PpLZum2+PfDTa2kyg8OkKm0pMJ2bYHWYKPlkXa42SlTaig1h
         01JmZVfrrg7j2PJGrWFbBcuRcl09a28d8uBnr2uAdBvwkHk9TId5BU0uZRCDMssP7JYc
         hXU9wobbyj9DVSnTFOS9LO5kxCpb90sV/BK3yCkPC/tD0YFJlsABfkRpJsZMWQrpzr/7
         G02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5mDQubpjU9Xq2GkyuNWqhH/TkmX2IqKgK0v852Ly+GY=;
        b=lHSN6aZsGv1TIwxjm+gZW2EWUt7hqgVXsOPul+CA80a/PGFPJjXAVSmbr//Vn7lINr
         WN8J/Gv5IrOznYAQp3iCPrckly9fNr90SLGXLVQtVPJDuKallru9+X31g4hAmsAgjauH
         o+RJNKzM5CUoVFzTDc3GoYpMHTPM6zk4dIfletbTnpAd/pJJCyMfu0XOARXzKgqQfQVd
         89/3bQEbCmZxJtFlNB+h0ZsYBRX5XmVudfBLX5t1NCLjmM3iRP3CwxNi9tf/66nzNTrH
         YDvSfAETGu3hqEa37bvltaxIqfuslwo/Tsthfc+btm1spwlgRAQpLbis2cyIz+VdD5TX
         vgIw==
X-Gm-Message-State: AOAM5337v5g8NNca/Mo9iACA4REusFCYzwBzrJptXWqydMNG6JFer+gK
        X4jucM3cwUXB7JfmawMOz94GEr+fbx6cblbc
X-Google-Smtp-Source: ABdhPJyziYKTA4n8uf/cKRlt86fMIY8hT/Xig7tVG1iBhbRLLsDQ+F9/pOGLdvoAaGjztnB3YDqppw==
X-Received: by 2002:a17:90a:f696:: with SMTP id cl22mr4204201pjb.23.1628887664197;
        Fri, 13 Aug 2021 13:47:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nn18sm2200851pjb.21.2021.08.13.13.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 13:47:43 -0700 (PDT)
Message-ID: <6116da6f.1c69fb81.e4f1f.5354@mx.google.com>
Date:   Fri, 13 Aug 2021 13:47:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.139-113-gd967abf3a245
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 154 runs,
 3 regressions (v5.4.139-113-gd967abf3a245)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 154 runs, 3 regressions (v5.4.139-113-gd967ab=
f3a245)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.139-113-gd967abf3a245/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.139-113-gd967abf3a245
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d967abf3a245ccd654a69449742d3793b41dd674 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6116a6cd6a52286126b13666

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-1=
13-gd967abf3a245/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-1=
13-gd967abf3a245/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6116a6cd6a52286126b1367e
        failing since 59 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-13T17:07:08.044519  /lava-4359277/1/../bin/lava-test-case
    2021-08-13T17:07:08.061975  <8>[   14.964606] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-13T17:07:08.062261  /lava-4359277/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6116a6cd6a52286126b13696
        failing since 59 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-13T17:07:06.619830  /lava-4359277/1/../bin/lava-test-case
    2021-08-13T17:07:06.638191  <8>[   13.539703] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-13T17:07:06.638508  /lava-4359277/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6116a6cd6a52286126b13697
        failing since 59 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-13T17:07:05.600471  /lava-4359277/1/../bin/lava-test-case
    2021-08-13T17:07:05.606026  <8>[   12.520073] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
