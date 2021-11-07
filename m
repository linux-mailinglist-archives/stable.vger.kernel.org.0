Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984934475E6
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 21:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbhKGUqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 15:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhKGUqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 15:46:31 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0757FC061570
        for <stable@vger.kernel.org>; Sun,  7 Nov 2021 12:43:48 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id np3so6649942pjb.4
        for <stable@vger.kernel.org>; Sun, 07 Nov 2021 12:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NkeCpq0pGsEi0d2/d36g/xDyLQEFuMjddgCGNE946rQ=;
        b=XDpfhjLGDAxg9AZBGQU3eDvPP+bZkMgkAgo7gpeGpGl2FkQk+q05GQPD+bbRo4ujAX
         cE+0+A5AZkpiYvphhPRaD9nep6Q4j60R5e1O/62MZuSddRJS5R0bcJJnmXCWOYoUOy9X
         5HBuzg9aWqxJVWeR5Xhgp/jiJCUFzssP3McD7yLDCjkxVTcmU4lzqXukmD4+s4GibzKT
         t8KkkyOm6bbDTvdpOqZKp++eAPx0D+LQpaVnyPVS/TcFogfJXp0p2zqr8Jp+AHSc5OQO
         Ryv0ELLhryjoM4TuxEnj5/SYeDm/sR9HkwtDbvkxD9rBNkzgZXSS/RVdwCn/EzwDmOm+
         soTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NkeCpq0pGsEi0d2/d36g/xDyLQEFuMjddgCGNE946rQ=;
        b=J/1rR054poJ0WSnY7gg8sf1dw/NnH01VKYRlPTns/xb4WNpYpY/6O8UdvIw+X+7o6M
         +MbfJLIp+Mcu1YYssH/9/xNEYaJEYPU/cnyR+71hnl7af8DdUBv6LTj8IFrxsieZx5EB
         bW69Ax2djvc7ixLWlE32yOIL7jtNn+zDTmvk0yjrs52GazXSopwXX4c4AtMY+0F09N4r
         otW1wMtZh3OTCgtpsuOdxrjDd1rY3gFxBQRPPrjzExm5LCdkvkLjkUwgzK+rNf7e3sR3
         EyYW89TtlKxQbDu8jOhxJJWUHiSbtKxlcf1WhvxdTo/8A/P+jk45x7XUUUvwb7BKJ0Ou
         1kaA==
X-Gm-Message-State: AOAM533OmJJ55L7dNrBZgHNk4aZOez1AVXzXgpfbQJmODkrSyi+k/J+O
        5DLvqGwOnRR5gPzVaFhxV3C+CnrGO3/7YoHy
X-Google-Smtp-Source: ABdhPJzLtHx2IN5bXDAWkZ1EAXY86KNoqMahvfoF2vhHVofs4IS1amroWAQNwWb1vXkOQza11Kizgg==
X-Received: by 2002:a17:90b:1b0a:: with SMTP id nu10mr46257132pjb.35.1636317827479;
        Sun, 07 Nov 2021 12:43:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z30sm3164282pfg.30.2021.11.07.12.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 12:43:47 -0800 (PST)
Message-ID: <61883a83.1c69fb81.c9c54.8cab@mx.google.com>
Date:   Sun, 07 Nov 2021 12:43:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.17-2-g2267159da2ce
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 171 runs,
 1 regressions (v5.14.17-2-g2267159da2ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 171 runs, 1 regressions (v5.14.17-2-g2267159=
da2ce)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.17-2-g2267159da2ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.17-2-g2267159da2ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2267159da2ce648a6be5bd95233a6ca07143b254 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618807895fd4e758033358de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
2-g2267159da2ce/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
2-g2267159da2ce/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618807895fd4e75803335=
8df
        failing since 14 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
