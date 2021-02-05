Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A546310DCC
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 17:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhBEOoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 09:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbhBEOi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 09:38:28 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B172C061794
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 08:16:33 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o21so3460556pgn.12
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 08:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UewXQ5GKYVqTJhRdyBCfkkPVjLYGMxPBO3Fvbs2pEgs=;
        b=SGHfHc7gQvqoxHqoff0ztGZRyUclXDdNTBpmjWs4ikugf3lc+nI6DqOVq4tiK8X2MV
         //wZUDCCFFBOHaHOBpy16DzwWmYbNgauCkO4wRik1ASZuSOExDKqWRO6QmyypPR+mjQW
         obtWN5vtGiKysfF1pckhwOVSAi9xOr20xxoHVNyzm+ux0RZEbVD49JRtvsErS8emPO5U
         7nyUdWzLT9dE8doHkloNXiPuDN8NKi9EQCPxpeO7VcrNZVdUI16lH6lCWsjol7d9CQLw
         2n9oDudaZYiitIXlKtoE6SzFy1O2qMdrUdPkpXAkBj6iH95sXutAaHB/+pIuv7vxc8pD
         hadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UewXQ5GKYVqTJhRdyBCfkkPVjLYGMxPBO3Fvbs2pEgs=;
        b=Jd+Bi3w7y6Bm/xu3UjsqcOryVSwTl0f+FtufGADzwUjhCXGcH82o7V9CZ26QKMyWkB
         OPy0zdfrcwIUtay+JeFYnPGYMeBy6x2eWilchs0ExuSyk0mBgZSTB9zv4goDAYFI2YnS
         ZuWkMZDJ+PVrIsO1Qz8FCQ6pztw+VEhgw2O32D/Z46bRnhxRGjp9cT0sbGnIZDywRIF1
         pa2StQFMjUflsUVrmcyxHwzuHqeFsxWjaSVwnVQwEe7Iu5exsxWiNBShszPebD2ZplhM
         ze8ltmhz8RKEpFGEFKIa+yGPVYZVzca+HxlXme3DhRyrIxwkCV86tOly5sLlrdP2vIqS
         KWwQ==
X-Gm-Message-State: AOAM532LvfrTJ/v3GqmNPHTam7EMjQ7YiY0AAIA/dM2QQMWaC8jm1VQz
        u/+3SPGs5Sri0YFieXA0TgsQkaOQ+WTPOw==
X-Google-Smtp-Source: ABdhPJyCMHUjjPQ8FHrBHwagYGk2GMoDNRIGldxB1b68SUZ+yXMllFCAAEmKEB5QSVygc4zO+HgiFA==
X-Received: by 2002:a65:55c4:: with SMTP id k4mr5162927pgs.435.1612541792262;
        Fri, 05 Feb 2021 08:16:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v31sm11361099pgl.76.2021.02.05.08.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 08:16:31 -0800 (PST)
Message-ID: <601d6f5f.1c69fb81.f879f.848b@mx.google.com>
Date:   Fri, 05 Feb 2021 08:16:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.13-17-g3805d0d4554ff
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 159 runs,
 1 regressions (v5.10.13-17-g3805d0d4554ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 159 runs, 1 regressions (v5.10.13-17-g3805d0=
d4554ff)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.13-17-g3805d0d4554ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.13-17-g3805d0d4554ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3805d0d4554ff36a669541a61326d69136d98493 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d3b706acd16eae53abe68

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
17-g3805d0d4554ff/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
17-g3805d0d4554ff/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d3b706acd16eae53ab=
e69
        failing since 0 day (last pass: v5.10.13-14-g1338c0e853471, first f=
ail: v5.10.13-15-g57e419dd2516) =

 =20
