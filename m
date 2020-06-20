Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17961202411
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 16:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgFTOCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 10:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgFTOCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 10:02:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C010C06174E
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 07:02:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id jz3so5520745pjb.0
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 07:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CvSL1aMRevWoGKzF13QqyJ+f83qN0q5cEFZ9v/f/f6w=;
        b=ymIaVga/DXn0yPvgEjj+7LlgIsD2xi1+RkNJRS1WD+Y3Dl2+TwA2ikKZJ2yfjyLVX9
         /ytCMqHF1T9Ge80gLJqLuCUr2JYNnWiHytJjG2c4JqkSVONayaYOazLanwl0jsjF3S1o
         W34D+i476aAiHgip/vz3mPAQynd7JhhYjCuoCvaxFaHSywCz/FSrlAhmCrWIeQ4aEotJ
         w9bJoOuhSPnFrBeMYaZXixARflvZ68G83KADrr/o+WKS0mP2xh07LMJhSmsodifWrZ9p
         CVQdEpZpeX3KFaXzYFncB/eEZVIuAWSOI+H2JYp7/PNX8w8YWq/xCclbx/hb6Dv9q7g2
         g8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CvSL1aMRevWoGKzF13QqyJ+f83qN0q5cEFZ9v/f/f6w=;
        b=RFLfjtE9Yhw7d+iHoYsiShncxT6p46c1xsIwgUwVnOKY4X8dnFuEGgBttLfsm6PYGh
         ofO0oAmsLsywAiCiwM/EOXvElLikr+VVODKuJC0eDXhc1f5ZhWl5f2iHj49TWdH3PP9C
         gMHGj1B473n/o1NX5SX5NPzNc/DUAG2VXk3RI2+ArKq1EZ+iIQQOPXREFc2v5wKAbEOS
         KP8IBh081wBCxRTK0fdlb4SlvUbnaG6qXI/LqFbAQzHfYKVCfxjymjYsBbNbuFN/rK/9
         uwmygZLc3i7OsFAXW4Q5iU0v0DxbMPoLCs0OP+HbLCFP8Q2JCeKWpc3krov3kdMlF/zg
         qOQQ==
X-Gm-Message-State: AOAM532MV6JrgGlE9oo6IH3Rm9choIWX9yYoy9IDh+xTGwy3ytV8RAzm
        9bh7gHMKkghtdQWcJCNEi6ef7a0FF3c=
X-Google-Smtp-Source: ABdhPJzS3gARl9HTs8ERKSnZ3kIVIayRICEBIboU20HzzrwdVWNYCk3I/5F369pyByQBbVis8HpndQ==
X-Received: by 2002:a17:90a:8901:: with SMTP id u1mr9085870pjn.71.1592661772979;
        Sat, 20 Jun 2020 07:02:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v8sm8622890pfn.217.2020.06.20.07.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 07:02:52 -0700 (PDT)
Message-ID: <5eee170c.1c69fb81.bb730.a439@mx.google.com>
Date:   Sat, 20 Jun 2020 07:02:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.228
Subject: stable/linux-4.9.y baseline: 36 runs, 1 regressions (v4.9.228)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 36 runs, 1 regressions (v4.9.228)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 0/=
1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.228/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.228
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      45b83c1819d408f46ef4ac3d07b92ba61c86d1e9 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5eeddb51cf2472cc8c97bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.228/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.228/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eeddb51cf2472cc8c97b=
f0a
      failing since 8 days (last pass: v4.9.226, first fail: v4.9.227) =20
