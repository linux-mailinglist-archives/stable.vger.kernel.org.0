Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1C6389ACE
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 03:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhETBTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 21:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETBTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 21:19:24 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493CAC061574
        for <stable@vger.kernel.org>; Wed, 19 May 2021 18:18:03 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k15so10682449pgb.10
        for <stable@vger.kernel.org>; Wed, 19 May 2021 18:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UDoVhCdm2FeyIicthCTvKBrNsHq8NwZ8eR7yFq7bPiA=;
        b=EdoWDrAEtpVcHYFR8YNUi13ty5dhprJC00ilkaBQ+s9lgiBTiktVxg6bcR4an/wE01
         +vu+gsCForFJVP9f7MwMAjrarH0q4AFcEBLf6NDBt5fY0HaGeMwUzGOcBYmM2m0waKIs
         LBoEKCNxXLQCsPfnFAYYCZL9JuWIyfNWB3WyWON0Y304gPNmU3OIhCkTp6JNzY+qIWA4
         WW/fUHWMhNj/xPPtwCq9JDfJiYTmcAKvdgSRVx4YrIR2+vXX66q3T54CwIRjvbZWVoXG
         g0M1HP6IxP0fKAvWUCgmu5e/GG1+rAECtnfhk8W2dcw9qpv8K4cRu5E5Plx2H9iSrSmJ
         BsnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UDoVhCdm2FeyIicthCTvKBrNsHq8NwZ8eR7yFq7bPiA=;
        b=SR6vdiKvrbYmdt1ojo/h/3C6L3OGuj/xkliz+ehchbI8jqEJD8BFcFiS1gUMqm1peK
         g6dbTYVkimAE/W+Eez3LY02aGLhAQPA/Atq7QcSD4lCVkFBFZY1xQrtWjD3eZIuGQsVc
         FO475Cj0m6vrUw9xpFAcoiGf20WCkJnyfY4AMwHN2EFzJrZ04WFszqC8SmqZ1PBGE2et
         vstrz6CzM1PHFC/3xXtuzc00pnAXBQKgviy4FSqTHPFy6ExFmDFFjkklsbzADt8WAmfm
         4v9YzevP5Sp4yo7SSS6ARiMs8i+ha5lzl3hOuZDGIKMoOzqkcsdBFVkGbvrH6PU7XxCD
         VhiA==
X-Gm-Message-State: AOAM5332EpqBDdkRJNwA5+hGXf1a/XkMmKSw7/VvWr+6sMnKd26i+jw6
        F8xizaXUhc9rLHSIaAXwshv4AXNNYxv2zKYM
X-Google-Smtp-Source: ABdhPJw42CKK2rG8lwjSkiHLB0ENIQjgAkls3TXmfZUN4cVzmQIHthSxgvdKl1pm8+/CCdSCT1Rp2Q==
X-Received: by 2002:a05:6a00:15d4:b029:2de:a538:c857 with SMTP id o20-20020a056a0015d4b02902dea538c857mr1965791pfu.51.1621473482622;
        Wed, 19 May 2021 18:18:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t205sm480699pfc.12.2021.05.19.18.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 18:18:01 -0700 (PDT)
Message-ID: <60a5b8c9.1c69fb81.73da4.2ca0@mx.google.com>
Date:   Wed, 19 May 2021 18:18:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.38
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 159 runs, 2 regressions (v5.10.38)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 159 runs, 2 regressions (v5.10.38)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig | 1 =
         =

r8a77950-salvator-x      | arm64 | lab-baylibre | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.38/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      689e89aee55c565fe90fcdf8a7e53f2f976c5946 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/60a587e2f06aeac22cb3afbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.38/a=
rm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.38/a=
rm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a587e2f06aeac22cb3a=
fc0
        new failure (last pass: v5.10.37) =

 =



platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
r8a77950-salvator-x      | arm64 | lab-baylibre | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/60a587cff06aeac22cb3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.38/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.38/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a587cff06aeac22cb3a=
fab
        new failure (last pass: v5.10.37) =

 =20
