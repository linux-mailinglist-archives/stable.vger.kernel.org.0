Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0953149FE
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 09:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBIIJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 03:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhBIIJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 03:09:19 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8D4C061786
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 00:08:38 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id z21so11988751pgj.4
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 00:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KzjoJRq9T9LgYom7COB9NeazIYadDZRV/Rv34aVulb4=;
        b=FRN60T8Gk9yimN04egfhLSg5vu5rHBUdcO1yVeKU+Nij9uXkfCrB1E+8wLvMY+X4xf
         OFKrp2mWIxD6+h1nzxx5iLLJQk/B2j3zMVAS9avwveLMFBEZW5Yxg/xT8cfqrRcj3g0z
         fYTBpV+3FiNEqRmXaL4Bz7rLjBANe+fF8oa+/F+i6P6I80SkUHyOdV8fGAoVGERbtZIS
         Jy99vMFFnIKoUQNQtIbIrKXCi3uR15lbR+L+lJfSZk2rdqdxw8FwNJ4bx/CU4+xr6fii
         oe+ObcN0dvVKPiBTx3iSvMlZ9DO/t7Shlool4ecxhViuQ+IslDiL820Q76+J4lW23SxD
         HWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KzjoJRq9T9LgYom7COB9NeazIYadDZRV/Rv34aVulb4=;
        b=i591YPZpiSYkk2F7AnEGIiiMRfUftVdK0MamTyzTPIT7+1Pn5v4UckB5nV3/zH00it
         Rhh6CT0j/u7PHRmlplwLxgpHdLNpTvtpAHaYuL6GrIVifwrB5/KvGcR4OaMgqPz17cPS
         XlqHgXrKdear14S0LFSpL6xlkrtDot3hfDStA9aCsg2seLbAp/lfOUYWqNOcqSReS1Wb
         HiKL117+ZHAZsiO3SpBxgLxNJ2dy+l/mtViEEhrhrZDY1b/X4P4UUaLiDyiNshrBkqoZ
         H2rDx6qun2c3wn9CLxWd9PgQHpyt6GTRTeUwxfXDLiApjcXM2yEQ+CuB91q4Ma2Wigy9
         xWxA==
X-Gm-Message-State: AOAM533v2Gr+jkyp5HOCu4Gm937A0yQ3xK5jnMsez+n5qibpoOpI6xak
        HB8rkv2FEi7rMhPTGYvEzAiFXZQ4S9bN1Q==
X-Google-Smtp-Source: ABdhPJxMw6UHbw57Tym0TzlP3kh8+flppqQtUI8iKRN+13aMJsWinh5c/pHY4PG3t4IhGBMsZrzWyw==
X-Received: by 2002:a63:1f21:: with SMTP id f33mr21430805pgf.31.1612858118200;
        Tue, 09 Feb 2021 00:08:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k12sm15048224pfh.123.2021.02.09.00.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 00:08:37 -0800 (PST)
Message-ID: <60224305.1c69fb81.ed822.28f1@mx.google.com>
Date:   Tue, 09 Feb 2021 00:08:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.256-38-g45c896919af8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 32 runs,
 1 regressions (v4.4.256-38-g45c896919af8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 32 runs, 1 regressions (v4.4.256-38-g45c89691=
9af8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.256-38-g45c896919af8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.256-38-g45c896919af8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45c896919af8a230e1036ecfa19dc459db83ab78 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602212218e2df010a33abe69

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-3=
8-g45c896919af8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-3=
8-g45c896919af8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602212218e2df01=
0a33abe70
        failing since 3 days (last pass: v4.4.255-14-ge5269953cc26, first f=
ail: v4.4.256-14-g2d58dd4004a4)
        2 lines

    2021-02-09 04:39:53.211000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-09 04:39:53.227000+00:00  [   19.187591] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
