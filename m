Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B503E27E3
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 11:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242756AbhHFJ5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 05:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhHFJ5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 05:57:20 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83D2C061798
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 02:57:04 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so18741373pji.5
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 02:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iZZLL4HLpI73tmtiSN11UwB+S5H5pgyIu3FanvhAzuI=;
        b=KokfCuUhL0lz694MBT95tU9LWwLwthHwcUwLaB25jXVLZfFF3aNeF1sBswJks22485
         1KohsnUd5nFe3EsOs+f8/VeF1NID+viKuvwdWk4+zU0VvAvJAzePVV7HEQl+NkjE9LsO
         2EUTVfVBiyvbK186zToKKW+nJ/4/xc4JMTn6ej0mn7xOsfRLmWwSrfoRrnXiR+ROMpBd
         BgUDdTXmZd3GXMu3DWeELvchFLgTj8d7nHQUTQAWH+qxfupdSRXJjxkhO0YlJ0B4xZSe
         E+od2DVwHVDq9wVjpAYRJDK+eBhs4fXM+6BmTqCthN9M8C6v8De89k0YPAN1n7JbygH3
         dd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iZZLL4HLpI73tmtiSN11UwB+S5H5pgyIu3FanvhAzuI=;
        b=cTulMWwsNw5YtGF00n+DkgiXscSnUydK0K3eNSNnBUfTLBglCAzmTiTxkM5hlyNjUO
         UTfzdRJYgfWK91NnuG50GmrIcPKAb4xFzaLdnz+uxVcwNkNhEYYSkxtpFBexYmm+zJxx
         COek1kwNdbsfDGIyPAjwPhy672p0HxO2ePH8OxmCJ/uGtPpkN/Xji5AIqaj8Fc50iTOd
         XxKiQ521cLmTCgduV/DZDt320SzW3bY1yRnqtKWLlbYrvVxyDHRZ5Nt6lyQxw8EsjMxD
         FuNTRJc43yrpNcjfpULgK32xypVvR+SHSkqZqqM6GgnFXVNDuOVGI30vtTW7DaDzNwXC
         efBg==
X-Gm-Message-State: AOAM531x4mOXXG76LobH9x9YDNMIi35YfmWcHuo3nGtPwyFq/xVobyuO
        KN8nBl1ogo6Ja2ii1xvSUy1hu+hekLkdgg==
X-Google-Smtp-Source: ABdhPJypzOSKC03AWjw8b6pPWeFUSITOHx3Ul7hxJaUxeur0GFXbp0WLg2B0nGIUXtPQhTWR8XeJlQ==
X-Received: by 2002:a62:1489:0:b029:336:162f:3417 with SMTP id 131-20020a6214890000b0290336162f3417mr4054367pfu.14.1628243824087;
        Fri, 06 Aug 2021 02:57:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm11121386pgs.23.2021.08.06.02.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 02:57:03 -0700 (PDT)
Message-ID: <610d076f.1c69fb81.8eaeb.14c0@mx.google.com>
Date:   Fri, 06 Aug 2021 02:57:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.201-12-g0bdb8864dde6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 90 runs,
 4 regressions (v4.19.201-12-g0bdb8864dde6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 90 runs, 4 regressions (v4.19.201-12-g0bdb88=
64dde6)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx7d-sdb            | arm  | lab-nxp         | gcc-8    | multi_v7_defconf=
ig  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.201-12-g0bdb8864dde6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.201-12-g0bdb8864dde6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0bdb8864dde6b2db63f99eb5d537fbe125d9e119 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx7d-sdb            | arm  | lab-nxp         | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/610cd3927a91b87a81b13691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-12-g0bdb8864dde6/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-12-g0bdb8864dde6/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610cd3927a91b87a81b13=
692
        new failure (last pass: v4.19.201-9-gca95c1892f35) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610ccf8f14e9bf1fd5b136b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-12-g0bdb8864dde6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-12-g0bdb8864dde6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ccf8f14e9bf1fd5b13=
6b5
        failing since 265 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610ccf8a14e9bf1fd5b136a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-12-g0bdb8864dde6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-12-g0bdb8864dde6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ccf8a14e9bf1fd5b13=
6a5
        failing since 265 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610ccf395cd9e77e9cb13671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-12-g0bdb8864dde6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-12-g0bdb8864dde6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ccf395cd9e77e9cb13=
672
        failing since 265 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
