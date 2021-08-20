Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27AD3F24B2
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 04:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbhHTCTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 22:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbhHTCTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 22:19:08 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862EDC061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 19:18:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so931134pjb.0
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 19:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aBsXfKJ5t1mbnB3ssQxXHOMScp6DPId1Nks32aSW5vo=;
        b=suoAcUsvxn+29Jh2QkwoWQEbQB6u/qssyHVHxadpnAoLPE8BMHOWS0sTfX4YfHzbhZ
         ZrbzXQCdmVOiSFtG1QaFPbBmr+jgB0DQLjfPyjyGwRtzdsjh8LvrF4dD5A+X+wkOP91G
         id4rIGHih42w2dez5EK+/PvmknKUw4jjYNwpn1JGuK0ehLT1VJVT8s5/zdilrjSTMKFA
         3Dpg8UXLBcdZrkQCAvOt6EW3rTXTvMCp8JY8DDDOzxIxhL3LbAFqD+puteshzuAg9W74
         8tVETyqUItpP3BPE0necCMR2HPKNmlm7iuopTD7KDTMEpbbWEgTZgyhrnUTz2j6fV0L3
         HKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aBsXfKJ5t1mbnB3ssQxXHOMScp6DPId1Nks32aSW5vo=;
        b=s9gy8LDrO91/BlkOdYZbfJj4S7JHu7PSFXDQGhRioVEJkzVjeex3nvWvWYmS6sKnI2
         2XzB9nPW8MGlBKPYpMs11lvXiOtP0ilCK2UWJRmFFsqW82VIXZe8PzkHUZGzprTJtu8+
         cwDuDohY5ouKO4QswYUFHzCugGNxdYZu9AnUIm6d9ZwP2CyBkAW3UOqwbOfhwqReq2h5
         s4cD8b1eXhoOFIa0vSU7nm2DlLtFjLiUhaMJSlfoq63/gY/G9ZvgudM4rCy/L7HyNzHU
         s52QvtjUPeG5XUufXcNF4yicL9wRUkGB7GmzX6EFoio5gwd92qw+SU90eVwledTbPwll
         ho/A==
X-Gm-Message-State: AOAM5314GEJO4sgoCy7ygHIUc9jshaeiFwLDj1s/nXq6epdfH2dWdQWb
        l+ctMLWgXfOjEdReaj0r0bdmaK2o6XpY1bW+
X-Google-Smtp-Source: ABdhPJwB44h9eMZI0LBWUHLwlBgVeXHneXhdi08QC8yK58OrlK5wD1yN0FjVPTieDoVxfcpVG8FLcw==
X-Received: by 2002:a17:90b:194d:: with SMTP id nk13mr2088844pjb.179.1629425910654;
        Thu, 19 Aug 2021 19:18:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6sm4835051pff.74.2021.08.19.19.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 19:18:30 -0700 (PDT)
Message-ID: <611f10f6.1c69fb81.fe76a.0c27@mx.google.com>
Date:   Thu, 19 Aug 2021 19:18:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.12-25-gf29f45d3b056
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 191 runs,
 2 regressions (v5.13.12-25-gf29f45d3b056)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 191 runs, 2 regressions (v5.13.12-25-gf29f45=
d3b056)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.12-25-gf29f45d3b056/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.12-25-gf29f45d3b056
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f29f45d3b0564027f78cacbdc9caf6ca041eee4b =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/611edf9c6325efb94eb13674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
25-gf29f45d3b056/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
25-gf29f45d3b056/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611edf9c6325efb94eb13=
675
        failing since 1 day (last pass: v5.13.8-35-ge21c26fae3e0, first fai=
l: v5.13.12-1-g3b7bb0adff56) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/611edc40e884cca98eb1366b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
25-gf29f45d3b056/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
25-gf29f45d3b056/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611edc40e884cca98eb13=
66c
        failing since 22 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =20
