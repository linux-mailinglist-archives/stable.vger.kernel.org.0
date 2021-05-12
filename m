Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F296737EDA3
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387885AbhELUkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381340AbhELTd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 15:33:56 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7237BC034606
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:27:56 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 33so632115pgo.5
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dhrh0pPnt3ufT4QNSsZJd+5bU82b+fUrj4+ObHB09zo=;
        b=kdA2sG3H2xVXM+a35If/+MpHeAfUZYoH10tHwDGtnk4tBCbEWteI5vZDfk9eVije/H
         crs0vnFkfFTb0Y3cFTrWGvoLbBcdG+GBbk/6kGNfVQkWe0XSQ7vaRZPeLuriMITD9Tqr
         kLYVT2adG7Vnrf/mI40D45npMu99GHvZB/X5thGcOrUGtYHXUMNU0a8+uTCRepcSpAqx
         B9Kwzuyrfgq2h3Ptbs01WlzXR6paKQ75uxLH4V574380ZE9F7W+KuntiaIl/UN4Vm4Kl
         wdgzyQ1tnJWScQivSdiqkjDf7L3pFhq75f5Z7F3ouaTE3+RgpIBBojIFKZwFZ6VurOX1
         wvBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dhrh0pPnt3ufT4QNSsZJd+5bU82b+fUrj4+ObHB09zo=;
        b=cxl1LZ/k60zTDkbsKNGk03y+vCrn3BkpgdyyE2W0LVrNfJACkXsTgZSCCGmU7SnbX3
         dYO5soMn96tSaVLFr9Eh4tXiD88PzmnUeTYlds41+jN3rOAwshwW1YMKF6ddrnI+Hugi
         cVsNTOFZH0qktu1F+LNTwcu/mgM8CpoVsFVE2U32gCm2D0A3BYogknT+rSgWUDRBQ6P4
         XqSiAwfLteOifhkuwFL5GDGtFkoaRZTqeqOFjEUYA/DU4W9IE+UcvJr+1KmovzNvMnrp
         mRmgIit2GIDGFu1ZaNVa6nOtRcceRgpOz7IcSq6zDIwSRHAAGdAgVeEveu7mPLMCgred
         V3PA==
X-Gm-Message-State: AOAM530aMfSiFfiJ30wRn0aPfRNzK4m1UjtAjUsUtn9MKFl2Kl2FH9Sq
        QOQDSaupudN66C79O+MaBg5dVFUVovTgCsOd
X-Google-Smtp-Source: ABdhPJyykqso2YRvCEZH1QHREzXBseSpr/zKQ7o9m4NHzRbkUAUt8OEPVzNZuYuocMmig3tKNfrRmg==
X-Received: by 2002:a63:df09:: with SMTP id u9mr36197716pgg.112.1620847675865;
        Wed, 12 May 2021 12:27:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm497928pfi.32.2021.05.12.12.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 12:27:55 -0700 (PDT)
Message-ID: <609c2c3b.1c69fb81.782df.2316@mx.google.com>
Date:   Wed, 12 May 2021 12:27:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.11.19-943-gc70453ce2ae1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 166 runs,
 1 regressions (v5.11.19-943-gc70453ce2ae1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 166 runs, 1 regressions (v5.11.19-943-gc7045=
3ce2ae1)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-943-gc70453ce2ae1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-943-gc70453ce2ae1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c70453ce2ae13e3e728134db5adde5687c5f44d0 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609bfc4b4a0f26cddb1992a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
943-gc70453ce2ae1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
943-gc70453ce2ae1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bfc4b4a0f26cddb199=
2a2
        failing since 0 day (last pass: v5.11.19-341-gbeb6df0ce94f6, first =
fail: v5.11.19-939-gb998056942228) =

 =20
