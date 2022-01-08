Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57ED3488647
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 22:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiAHVhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 16:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiAHVhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 16:37:16 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA00EC06173F
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 13:37:16 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id x15so8759234plg.1
        for <stable@vger.kernel.org>; Sat, 08 Jan 2022 13:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FoJ8/Lg7jVUQK8dmXHfrf3VVfD8FUzDUlnIVXeDjxpA=;
        b=ZTlEjKkBvXTI9zEDULYJrclYy90GM8RW784nRU8EyuWAv7W6P2RTKk2jBnhguGPeQS
         mOrsE28F2eyzfFT5PyH2JkGMh2rVPtuAKk1SCEF1b6zmF+Q38krmfrRceSV4EBzKxk/h
         t9KEfq9fV3N7BW6pM7Yxd5J+tmSEN3O66ck+nwXdqMKWCmU1DzfhUB4qcYA7FC9m0hJ3
         DaBo4z3e3cmBygZHjmdr7ZI5ho2qSuusNEoVv3XNTDtB3yErZeqDpOhl97IWzYMDD/+Q
         cThoicQEFZi1wzqVXJX7ZTEY3KAppS8AYns2xNN89DJOILfIanG7lO5xW4Qjakmtijac
         NWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FoJ8/Lg7jVUQK8dmXHfrf3VVfD8FUzDUlnIVXeDjxpA=;
        b=psZrFFgkQ1M6+xlJmUztO5Ol+PxHDxbnWV1x30T12N+uyaqPjfK6KFlxpvDZntr9wu
         V77fZ3+TMuTngaDh2QHsb57kHRhPZrpd1+pSpBxQHybm0jhbYfFCpyqDtTHnhwWcnCCq
         7mqN6oKTLcaLXCKIaSy1cN3Pfv4o8Cq/gyP7KVoyfjzDgV2fyCKXT9a6y3Oq7CSw3uFP
         n+1cdTic1nwot8wlmeRF5Vi4u37gFYezRP3GmKNfjh+yaL0k85cWrte5E6qJ4Hmo3yQC
         jR91xDqtwdI/XHlNOLk9kXnqxNvfpgD/4Pflj9M0ovdziBzBG/aJEULIpyoFd3bJBUlI
         ywCA==
X-Gm-Message-State: AOAM532vrlfVKtWaG2d/soJ9PUSjnlE706OS3HG1kmyvZFiinhbTXIMN
        pEiHustkYl8Y4rJtE/RCYPW3/6LeAgORIh53
X-Google-Smtp-Source: ABdhPJxNkDtM+53rGXGsiZ8Hu3mPG+jTJp6Bg4YyT6/t4tJ/TJp2ZmXWCVJgBZ6vJzOMceqd0pflJQ==
X-Received: by 2002:a17:90a:d144:: with SMTP id t4mr22458759pjw.218.1641677836021;
        Sat, 08 Jan 2022 13:37:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u8sm2734482pfi.147.2022.01.08.13.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 13:37:15 -0800 (PST)
Message-ID: <61da040b.1c69fb81.d803e.684e@mx.google.com>
Date:   Sat, 08 Jan 2022 13:37:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.90-25-g9e8cfbc1c8c9
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 168 runs,
 2 regressions (v5.10.90-25-g9e8cfbc1c8c9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 168 runs, 2 regressions (v5.10.90-25-g9e8cfb=
c1c8c9)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
meson-gxbb-p200         | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.90-25-g9e8cfbc1c8c9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.90-25-g9e8cfbc1c8c9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e8cfbc1c8c9bdccb45eee196b28456d7e6c6e78 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
meson-gxbb-p200         | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61d9d49ffc0f0b8a80ef6744

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
25-g9e8cfbc1c8c9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
25-g9e8cfbc1c8c9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d9d49ffc0f0b8a80ef6=
745
        new failure (last pass: v5.10.90-25-g1e147306777a) =

 =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61d9d332f8c17b9d0aef675e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
25-g9e8cfbc1c8c9/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
25-g9e8cfbc1c8c9/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d9d332f8c17b9d0aef6=
75f
        failing since 0 day (last pass: v5.10.90-5-g7575d2506fb1, first fai=
l: v5.10.90-25-g1e147306777a) =

 =20
