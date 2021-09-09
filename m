Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CABA405E06
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 22:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344530AbhIIUae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 16:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343998AbhIIUad (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 16:30:33 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E51BC061574
        for <stable@vger.kernel.org>; Thu,  9 Sep 2021 13:29:24 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v1so1846226plo.10
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 13:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I2IG/GcMbGKwu84XEGvaPs3bPfhImRmnxLS6xm52HiU=;
        b=mfTIT8TTs4sDo59DWdjp4S2xlRGCMQ5VbooQ7+ZIT/3MAIZimrOGxgoCeSdgXZq0tA
         mghDow5Gd+gO2CIUwykAEvLmtCLL8FTZWnybjiGaBtdHHDFgdv4ERJsLa1k0DaFOY48Q
         QgstXmgVhF9D5FVSdYP6pII5tsPVZNRiiP2gmlTGKI0Ln6+qs2QWoBDiX65SsNQGJlQR
         QprYe2NAUisctMOcAp6egKq2znwhVjghsdSTy3+xWdn9auiYOKdIZLrWNUjxJ8KOlGQD
         WqMNoMN2f70SbSsYADfdURHycB5w2o3bbpZIbDiBO35QyseFIS0DuWMpUluH9MoTMWtW
         /2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I2IG/GcMbGKwu84XEGvaPs3bPfhImRmnxLS6xm52HiU=;
        b=sorcRccI8ei+w9z3jRAcZLTvnZ9JHpQWb5eEDladwnqBZBMFETxwFvStsbJ2fdoabj
         UchAUrK1IG6qRj1Hv1T7uuw9x3oLGsvuacOG6cnMgTU06mGxxe4CQBuD1OgZASFzmsjg
         /eOCvX+2AUGJ5zRIY4g3nghQaQ1fOrPeeZ3q9DIQzpoGosNc1PC58GCc2EkIPJVY8Yb3
         5CWw4NDnefD2cbjdb26J2ywopb9g3odVZuDdJOfa+7vDM7tKzdep107Wb506chm/KW3R
         EwIR1clMxJZPIHuxwVOhel6Ew6k949AnCu3SpJ2JuUrbGBfRMS281qO6frdxsLaMSnrZ
         SdiQ==
X-Gm-Message-State: AOAM530FXevz73kSXiTcXFY+lMBs4ntqZjPIcrgdEhksRJuAVNfUSoVy
        s+FWABZNMdUkh7Z+LcxZhWPUjHRD2rzvN++h
X-Google-Smtp-Source: ABdhPJxYN2nFoSWFVk3lozmQu+fa6vkvRjBQUxmGLeKuf8iXwMIcg+W+iRWh7V8ES82Bt5Nzvh9zOQ==
X-Received: by 2002:a17:90a:2dc7:: with SMTP id q7mr5490033pjm.231.1631219363433;
        Thu, 09 Sep 2021 13:29:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y2sm3180175pfo.1.2021.09.09.13.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 13:29:23 -0700 (PDT)
Message-ID: <613a6ea3.1c69fb81.206c2.8ec0@mx.google.com>
Date:   Thu, 09 Sep 2021 13:29:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.2-4-g7e05d47c1c8d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 211 runs,
 2 regressions (v5.14.2-4-g7e05d47c1c8d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 211 runs, 2 regressions (v5.14.2-4-g7e05d47c=
1c8d)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.2-4-g7e05d47c1c8d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.2-4-g7e05d47c1c8d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e05d47c1c8d53bdf391f223d871476594ee1621 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613a4001e8625f0db6d596a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g7e05d47c1c8d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g7e05d47c1c8d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a4001e8625f0db6d59=
6a2
        failing since 1 day (last pass: v5.14.2-3-gbf9435541571, first fail=
: v5.14.2-3-g5e3461135fe5) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613a423420c17dd35ed59677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g7e05d47c1c8d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g7e05d47c1c8d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a423420c17dd35ed59=
678
        failing since 0 day (last pass: v5.14.2-4-gdaa4b4126de9, first fail=
: v5.14.2-4-g1551ad39a829) =

 =20
