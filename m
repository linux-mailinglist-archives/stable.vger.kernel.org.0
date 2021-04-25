Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CF736A4F8
	for <lists+stable@lfdr.de>; Sun, 25 Apr 2021 07:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhDYF5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 01:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhDYF5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Apr 2021 01:57:06 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A664EC061574
        for <stable@vger.kernel.org>; Sat, 24 Apr 2021 22:56:25 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id p2so22538470pgh.4
        for <stable@vger.kernel.org>; Sat, 24 Apr 2021 22:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d2MqWHs66O5p5Kv1m5FZTn05xK3HZ/A4sHB51aeFFuM=;
        b=sPb9tfHz1gPI2o9aRJBlO2F80KstFrTGM1w/BOmJJl3DLBT+vpD1vBz1UeujEp9VJ2
         4hHxBs2sqYPrY0bSevxc2e6fGLWmC56nRf4KtU7bGzqOoMptBEWoH6gBpsJf5uga0F1b
         l6uxMeaD/lIVJLVkXWf7QC04Ta5bmT1wnTB5x7GE7A/XLfh+JnZEAHzZi0uk7THvpCgX
         PyOW432GWEHpWPoWAah25JCGMJSiXUPMm3xuYt6Y8UaaVqYGWFOgMDcRht8B5vQB/tX4
         yYwa8zMj0U8XbsYCL95B639muQh8V4odkLDVFxwHqaYLGVon6+kF/hQZTxUhAOEz7Wss
         4xpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d2MqWHs66O5p5Kv1m5FZTn05xK3HZ/A4sHB51aeFFuM=;
        b=RNJr30WT36AM2DdjZkExjyq8OvPciO2Azp1YQvFzPMsnSJ1IfL4o3NwYVlJ/P/mQVc
         jZrlZCZKBLYY9yoy8BVLu+0jXw9iRIbXOJMh4vbKcxmlA8YO4YZyu+h7V59KjQRaqi0F
         sD2L1nyGA7BPlmQgzSu4a9gJaBvQfp7xlD1LkVmQyzugEfkoH5UzFWhVua7Xpp1AUK+c
         IHyb/7NSnGhmUkeSWmXqfWVwxPPFVwYKMjJTwYNWGNSjGjejt/dTV0Y+C1QaM3BCgsuj
         NLZ+whwkx98UDQm52NjxvIlIrZyOYMw+oFGxyFOBQvq4NFoQUbQ/p4QVX+N4LB59p+hl
         MCrQ==
X-Gm-Message-State: AOAM5301FqepFkMVHEPBRMBvG/pZiZCnSiX/Y76qXwxdEksqzTqTYEIR
        u3guRQWpsF8hjEuiT1rD/8jXaQsnA8t6Odxq
X-Google-Smtp-Source: ABdhPJwT0F2g1v6cc0An3/c69lbmC2BpEMZvOFsdd9V/b0iLkNYjB1P6+DJpsNlhpngWTsCcM0R5Tg==
X-Received: by 2002:aa7:9f8f:0:b029:274:21e:fe0c with SMTP id z15-20020aa79f8f0000b0290274021efe0cmr2952896pfr.8.1619330184818;
        Sat, 24 Apr 2021 22:56:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mz20sm11262032pjb.55.2021.04.24.22.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 22:56:24 -0700 (PDT)
Message-ID: <60850488.1c69fb81.e277e.1682@mx.google.com>
Date:   Sat, 24 Apr 2021 22:56:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.114-4-g2676851752853
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 162 runs,
 1 regressions (v5.4.114-4-g2676851752853)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 162 runs, 1 regressions (v5.4.114-4-g26768517=
52853)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s805x-p241 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.114-4-g2676851752853/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.114-4-g2676851752853
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2676851752853b36c64f94cad6e9e34cfdc751ee =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s805x-p241 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6084d4eea50d31f2fe9b77a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-4=
-g2676851752853/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805x=
-p241.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-4=
-g2676851752853/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805x=
-p241.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6084d4eea50d31f2fe9b7=
7a2
        new failure (last pass: v5.4.114-1-g48c1f0d8683b) =

 =20
