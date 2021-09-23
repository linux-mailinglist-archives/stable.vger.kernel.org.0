Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71320416439
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 19:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbhIWRSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 13:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242402AbhIWRSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 13:18:08 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5397DC061574
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 10:16:37 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g184so7020744pgc.6
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 10:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=96fX1PidG7mh8Bf8sdfLENEOtoH1PZw6Az0s08sBuFY=;
        b=oCvQ5n5LkmjQP3Md2MK18+s+87eas24gXGVKi8zyBPS9vkrMeuHbn5GijvhSm8tezH
         U1AjLU5EZK9hrb5a67GsQ9plKBgaDF+/ART5haGFcKjDjVQiN2t9fOn83WIgEsddKTXX
         77EVXrd1sAqVtvtIzMDLUuy+Rzn88XkFzhT7WwZE9Z6aEbwWbU5VCwbAwPTBvRjI6bPL
         z5puiqZnutXKGTP32w378+UHmKKwGQ75RmTAMKM1Bc759dJWMjyktpJVd4TkJs+9Hsmu
         coBgrUDi2SxXW8gkyux3QUFGplybf50kV88DsyzFsda9HLJWdx1p3glUkSPg/cjH4x57
         UNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=96fX1PidG7mh8Bf8sdfLENEOtoH1PZw6Az0s08sBuFY=;
        b=jSjqQab/zafcB/S44mPSNjMpZeEyZ8zB8UTMQi8wEB4Iwz3jMx1N0oGL0P1aw4lodo
         QEDZGRIw6n2n/uxFOUgy7500E3jR8awFMSGVaGzvZU2bMn4iutd+fVLhoh3ALR51KlDc
         S5mrk5yGXXQjGCx0s0zKbGbexjOtCu0s7NRm+PDUvIEKt8LKk/ue53e5VixgKaDpdimu
         ukQwEEYZ7ExTn6BbspfA29anKF+HjI8LJvmENta5RclfGuHvMp/HkO/k90nadsb84hLD
         ylujOb2Xa6FTomRmEBOZaDTpp6K0bSQQyKtUg6sL5gIiz62cybJCAx7ia3Ean/oGop4c
         K43Q==
X-Gm-Message-State: AOAM533EWk2egzyvZG6jLSPKQgTbUQKbigyynA12Xqj3XgBii6tnLe/G
        xkYJTY/jvVIJqPDmep/k5cZq4vqWxoCMxMc7
X-Google-Smtp-Source: ABdhPJxOANXzKLGYePWw9n4uDVIgUYRh/rqiIDSnQ56mRwYKdFK5aN+2t8OES8zY4quDoA3PwaRRGQ==
X-Received: by 2002:a63:b94d:: with SMTP id v13mr5252178pgo.361.1632417396614;
        Thu, 23 Sep 2021 10:16:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z17sm6441076pfa.148.2021.09.23.10.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 10:16:36 -0700 (PDT)
Message-ID: <614cb674.1c69fb81.5c2ec.2f9c@mx.google.com>
Date:   Thu, 23 Sep 2021 10:16:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.7-3-g11f9723f1192
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 152 runs,
 2 regressions (v5.14.7-3-g11f9723f1192)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 152 runs, 2 regressions (v5.14.7-3-g11f9723f=
1192)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.7-3-g11f9723f1192/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.7-3-g11f9723f1192
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      11f9723f1192b1a76f33fe8a12ba283f9c201861 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614c8591a3e321940999a353

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-3=
-g11f9723f1192/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-3=
-g11f9723f1192/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c8591a3e321940999a=
354
        failing since 1 day (last pass: v5.14.4-395-ga49a6c3da2c6, first fa=
il: v5.14.6-170-gb1e5cb6b8905) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614c849f5d45742dc399a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-3=
-g11f9723f1192/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-3=
-g11f9723f1192/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c849f5d45742dc399a=
2ec
        failing since 0 day (last pass: v5.14.6-174-gc4109bf2a31f, first fa=
il: v5.14.6-177-g87f5e30b4e8d) =

 =20
