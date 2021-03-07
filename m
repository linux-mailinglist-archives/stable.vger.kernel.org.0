Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF47E3303FA
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 19:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCGSky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 13:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhCGSko (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 13:40:44 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2CEC06174A
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 10:40:44 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id ba1so3818095plb.1
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 10:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QGy85vsbS0wUaRNzEPwB5Eaf2hdSnSUq25MxqkJ4txQ=;
        b=z5K8tccAP7YhywAWI7MV5vOS/Y6+IqEo+5eNhbbX2kOXmSV4N2CXXbIucp+4Dblp90
         vGr07gwvCpFegaTEL2zRMbNkQepNR1FIDQieHTqyaH8qqBmIA03CaBpPUkKnSBiJTUCN
         kRvFg65B9crC+X918dcnMFbQ6XNv9lxOsZSW6HQhevU/MFDT79Es1yoX/aN/R88/XGsq
         1pi2X9NHacoxNTxRVTA/djDzSw/HjJM2Y7KADwKx5XI2rr7DJRbYx/+7GZ2XFJQUF5Sr
         FfqYTJxue6hFtufqiIbKkTT3T5zVJCME9Oa8JQYntYpk31Uo5p6GcBopJe5wu2l1FTa/
         RUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QGy85vsbS0wUaRNzEPwB5Eaf2hdSnSUq25MxqkJ4txQ=;
        b=extgLkD72s61rv15J9SP8fZu+Ut6x2VS0Hl0gfaii6ZbC78/EpwBP9QCW4FCzb/QB5
         ubQLB9Aj8EsigmfDQDy4mwn3OvyWKOmu+hFuNtXrt2B7upSWw012zClQM+Cg3PWA0hkz
         WUVaeQM4Hs0hJBxNRPESkqPUEOFb4++VcMi0Ze2oBPheUbT6/4qg171APKaoelza8nO/
         rbdKaeDXdYri3rmMQX+kxfQwUebsCkQXqFaNBHsYRrnXu+n6Geok+HtJJ9DfbfEQQGb0
         VYsDo2yS7YiLIjj2LW2feY78AalMt399vFpbtXF1w+NbMeGiTojX1mW1hbhUolN0bA2Q
         CrKQ==
X-Gm-Message-State: AOAM532H+O1zbIeKAjpLIGfZSNvFATh2HNw4S3+p4R5LWT/Ve0/8jJUw
        zlDqBmtOwiDGoGQzzc8xb+9EEGk+N1l48w==
X-Google-Smtp-Source: ABdhPJwJaq06TkhD1U/ZCn16S4xhS8nHqtFDP/Yg29jHK9CdyNXizhK+s1I81T52Xeh9PMn9mRtNqA==
X-Received: by 2002:a17:902:562:b029:e6:14cc:2828 with SMTP id 89-20020a1709020562b02900e614cc2828mr3932170plf.81.1615142443736;
        Sun, 07 Mar 2021 10:40:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j5sm7598582pgl.55.2021.03.07.10.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 10:40:43 -0800 (PST)
Message-ID: <60451e2b.1c69fb81.fba24.32c1@mx.google.com>
Date:   Sun, 07 Mar 2021 10:40:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20-123-g25125ad90d7a2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 178 runs,
 1 regressions (v5.10.20-123-g25125ad90d7a2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 178 runs, 1 regressions (v5.10.20-123-g25125=
ad90d7a2)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.20-123-g25125ad90d7a2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.20-123-g25125ad90d7a2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25125ad90d7a2a189f1bed72d9bd433732a4e0d5 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044ec3744da406539addcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
123-g25125ad90d7a2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
123-g25125ad90d7a2/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044ec3744da406539add=
cd2
        new failure (last pass: v5.10.20-100-g87c292c8c6558) =

 =20
