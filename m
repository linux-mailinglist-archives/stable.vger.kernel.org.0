Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B912B389AF6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 03:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhETBk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 21:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhETBk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 21:40:28 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ED6C061574
        for <stable@vger.kernel.org>; Wed, 19 May 2021 18:39:08 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id c17so11184394pfn.6
        for <stable@vger.kernel.org>; Wed, 19 May 2021 18:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Lr4pMj3sFFp3dT0S+MA7Vdr6i4CG53jp6mEDF85usuE=;
        b=d19tF+FJlNhED2M4xaNTo5dPNB4d119lwCRwmX8BZs/1DcJmQWB0CCva/MvMH7iNCj
         ll844hqcAd/R3PMcaiw7PNez/g94/+ACkI2Wq+HPUFxdUI017o8SY3wJn5o559DmQNgl
         MsIRT7LgScoTCNHLIEqma0dxV5A7z3HWmh72zem+uRIN2FknLaXq4v6zkaCzc8nLIlaf
         rHw2C7vBkpwIo16wtqGX0nspB8e9Gg0gzas6WbG2EUu7ucZcbv46cKwC7e/W9Wc5IFSv
         jWZugLg1yLEAhduG/cFrQHZ4LJ1NbSmCUJuj1OiZedY0tzadjQ79zEyd4uXu9fQFW5+3
         PjGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Lr4pMj3sFFp3dT0S+MA7Vdr6i4CG53jp6mEDF85usuE=;
        b=XJNmyOsjvYspWv60p2qE3NrAVvQS57ne4thK4ADwBJtLHkWOMMjVXyQhwYfc9BOQlZ
         P4CoZvNuXGj3qCTxUoOiPU9N4VxhBOpAqNGGEzXwMHL9JuUoFfmwzq8pqn2PFd0YlhkL
         RjQuYcsQyjBCeXu8OrlM85p4tlPu3c5znd1N/IveLZhF78gJRjXxhF8aHZ+XGi1VGJG9
         Ctp4KIQ0nxsLLSDFOiiKqBOV/LCwNR2G/rccyfuxbiAGjmhG4+yDo1nZEMxozvnKehTb
         mhVW+PpGZLsalJ7rDswxMu5RqNg2ZEEY8N0kVyx+wfi/W5VIynP0250mufdO2DtjMu+l
         EplA==
X-Gm-Message-State: AOAM5302CQq0cn7rjbEGM3Hrw/RjGxT4Z0BmFMtkmBp/4xt7le986mUp
        TYJp2+zLittbwHBGfMHe4kIMJitPsnoKeOf1
X-Google-Smtp-Source: ABdhPJw3T4Bcu/crqD5IGg4jBDHvkHmXcMSgbgSKy32JPBzTBHfVmz79mMxwGo5JJEhU/zZks4PwVw==
X-Received: by 2002:a63:e709:: with SMTP id b9mr2036338pgi.153.1621474747628;
        Wed, 19 May 2021 18:39:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cc2sm542936pjb.39.2021.05.19.18.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 18:39:07 -0700 (PDT)
Message-ID: <60a5bdbb.1c69fb81.7e0c4.319b@mx.google.com>
Date:   Wed, 19 May 2021 18:39:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.5-5-gd7347eee5d7b
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 177 runs,
 1 regressions (v5.12.5-5-gd7347eee5d7b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 177 runs, 1 regressions (v5.12.5-5-gd7347eee=
5d7b)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.5-5-gd7347eee5d7b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.5-5-gd7347eee5d7b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7347eee5d7b6766373ecf60b88267c020f9c7aa =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a58b9c5382511538b3afb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-5=
-gd7347eee5d7b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-5=
-gd7347eee5d7b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a58b9c5382511538b3a=
fb4
        new failure (last pass: v5.12.4-363-g893c8b1b923f) =

 =20
