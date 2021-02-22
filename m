Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30AF321CC1
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 17:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhBVQVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 11:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbhBVQVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 11:21:08 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281E5C061793
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 08:20:14 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 75so10497789pgf.13
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 08:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N1V19RL2Qljl3NvDZTmLgfDW95BE8LDRZ8lcDwoJVMM=;
        b=X0kshPQoEE1OMwWNfBqrV3Q34Q8HC89HjB5WVc48e2Ih9NZy6lZArnAJQ/XIYSA8un
         V3Qtf4yghb2xXbyGXwRsw9VpLvEIfK7pHI3stZuglzEfSzyYNMDaBcCqGRnhmCIa7zmf
         44EjedBlnRjTYXHXNCAFMzYb5BHbAOQzhWAKz2S0bii3m9Tx3gwTsx9vtxvZ0t0pQQ87
         1jX+de58xZpozcUp07gAfhZ6Xiahfx9Fi0v7lWMbaYtY1lqWylOzE7eBh0Uk2iuIV7ip
         51A63e366wZfrLraIQHeYdkezY89G0bQZsSrf9lw0sBergu/C0aTwUyA6XhyViUU1LFZ
         GSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N1V19RL2Qljl3NvDZTmLgfDW95BE8LDRZ8lcDwoJVMM=;
        b=ZMdu72UPau5IgrNH4v7tzFv2wWzS9eCE3EIy/fXXaLcX3Csq/0QmdTkswql25M5S58
         oxiROzL5kFMVzpv1RthYsHbM/Fd6CybAP6oPhLoDF+mVM4pPAvcsRMuMvabHz6PNwr80
         zo7rl8BeL+ZH4pWTOQr/yWbHfrdm1Vj61/0mbBq9hdiiQZs5cUtaTWDU1iXwn/pt+2o9
         KC7j3iRY1KRe9TE0QuxnkCzXJrAjhYCvCuMce9P8tDD58c1z49qG+AQxGAlDIjzyv42y
         cAiK77RDj8j8yb3iFEVaK10ZgniPtD0bNntiTNn+eRf9yrH+sis3vBQPk4Dl6bdLgXur
         st2w==
X-Gm-Message-State: AOAM533Fn7szjZuEQSimHVmcpMlsx8gmK//kEOuQeCyhr1IjYPIt8Rl5
        u04EYqLvBJhR/9Nav/HLfaPkdXWncJNiuA==
X-Google-Smtp-Source: ABdhPJxBoIyaucBglFJmH/B6DH1fQj1E6bOvFzG9JC9p3jzE2odsKJlSTXJOS+fRuC4ZSZy4Yk8nWw==
X-Received: by 2002:a65:5643:: with SMTP id m3mr13022867pgs.91.1614010813368;
        Mon, 22 Feb 2021 08:20:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y29sm13908615pff.81.2021.02.22.08.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 08:20:12 -0800 (PST)
Message-ID: <6033d9bc.1c69fb81.5808a.dad4@mx.google.com>
Date:   Mon, 22 Feb 2021 08:20:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-57-gb8d5762d3e2b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 75 runs,
 1 regressions (v4.14.221-57-gb8d5762d3e2b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 75 runs, 1 regressions (v4.14.221-57-gb8d576=
2d3e2b)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-57-gb8d5762d3e2b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-57-gb8d5762d3e2b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8d5762d3e2b8f931b0abb2b6e538edccb139f5d =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6033af5eee4f4e7b90addcd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-57-gb8d5762d3e2b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-57-gb8d5762d3e2b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033af5eee4f4e7b90add=
cd7
        failing since 76 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
