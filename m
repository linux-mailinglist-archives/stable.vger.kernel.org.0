Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C00C32DAD4
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 21:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhCDUGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 15:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237860AbhCDUGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 15:06:30 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB362C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 12:05:44 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id kx1so1479258pjb.3
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 12:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CHgJbZu+SCRGPqcLTmBb8WooiGFqmm2N6y2DSuJXj3w=;
        b=k+oeYEWibq9vdA3YpFR6PRjJ4QGXjVWdW84mHAuyj9SVtRc6n71PTWqonl6jlRUSyp
         kw7X2co/iyIuYbQXx+nIBau9b0YQgYsvf2niZC4vCkPsywvd6qXv/vOz+T8QAcenbTKi
         ZLMLG72qL1VFrH7ly0o27r8Jfv+kQ7opP4TSfixggi97v+xY6fwlMYhqRIHF2QFLxDtg
         aRcctL3sTF4E3nqcHLSfGknZ9IMqjXG4FOmA/6rZJthzfU4OEc0IlcwwafgPHHM/mcF4
         AKN/o4AFz9EZ/pQfNypIpDVjMd7kuRlDgdv9kU2xPk/wuRMbsnzlU3MmI4qzY2PrxDPA
         7hXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CHgJbZu+SCRGPqcLTmBb8WooiGFqmm2N6y2DSuJXj3w=;
        b=fjuBJqgt6LmIv1T+7L4ES7od7lLDRflt8u44pnckS0L//FF6eQR9HbMUuzjiwRQeMa
         Wxz3IoxhZrd3RLUDDxp0ECCIeCiAFrG4aQwiifPvFep2RwIG2F6ai3hIhWiTNf1d/ASQ
         /ieXL9pFnP4Cmei/Tp5iOryqGaTqGsZiqPbTGh04MJxY/QN+axtSWekc0VDQxgptXbcg
         ky51yY9F98wsebhWjvwx72pJkeZ8VIJWdkni56CpjFtoTwWu77lZoekSafVCqe3KhZJC
         wov2BvMsuKcU19uor2TltXALdlu/XC2EKN+xdt4o2BKzyBEjSgjSRBGW/vphC9X2AGTH
         C6Mw==
X-Gm-Message-State: AOAM530I7TaDM0uBCbz9/dns1fnLPf+tH2u/baI81zStpRiksyUUyGzB
        WoRhW/bT0EbJS+6hBPvODbyWxhvva3N/0OIg
X-Google-Smtp-Source: ABdhPJzmeB0yr+o4StPEhAqW1IUWNtTncig7eh19qPxDOMwCrDQlFUuuuOJQnEbvL8dImfASgGWY0w==
X-Received: by 2002:a17:90a:eac7:: with SMTP id ev7mr6358782pjb.158.1614888344249;
        Thu, 04 Mar 2021 12:05:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c25sm210872pfi.78.2021.03.04.12.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 12:05:43 -0800 (PST)
Message-ID: <60413d97.1c69fb81.427e0.0e3c@mx.google.com>
Date:   Thu, 04 Mar 2021 12:05:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20-37-gea669ef474fab
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 118 runs,
 2 regressions (v5.10.20-37-gea669ef474fab)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 118 runs, 2 regressions (v5.10.20-37-gea669e=
f474fab)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.20-37-gea669ef474fab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.20-37-gea669ef474fab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea669ef474fabc6757fea7ca162b993278995bb2 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604103f83fc6c1b98daddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
37-gea669ef474fab/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
37-gea669ef474fab/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604103f83fc6c1b98dadd=
cc7
        new failure (last pass: v5.10.19-656-ga3c8a24e1f5e3) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/604106f5a7bf833b8baddcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
37-gea669ef474fab/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
37-gea669ef474fab/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604106f5a7bf833b8badd=
cb5
        failing since 0 day (last pass: v5.10.19-655-g2acc6a4ae931, first f=
ail: v5.10.19-656-gd3a7334586025) =

 =20
