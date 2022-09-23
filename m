Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C830D5E80C6
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiIWRdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiIWRdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:33:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4758E14D30F
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 10:33:51 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w20so777194ply.12
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 10:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=gc9DD81phvVavPqc7tW2o8HbZduyVvn8F5tToxAvHLU=;
        b=3vYyLuYoSqkUDwbWvt2QAsWyiOsmQaUUNDUrI+BxH7pYLA/y+ptC31MML09/uS/vJb
         1Fmm7sYLUDOsW778nSC1r3T+tqiSx7hqXzwXmOXnDYC2BlNglDoSjHvLUD9LCMJWrF97
         jwSWayInBASb9taIyzV9691sDUc9gyM+0Gm/MzbDCzvFA6oEjLv3zl3gJVOk4uakr0j6
         GWxLZhKRomTIZBc3PQxezBnHm6ZrsdG830heItVq6wIBNpVqaqMFbgQtU+524e0HfJES
         Ek6NdqG1xB8dhhAR+DJde4u5XBV0zzhOr+EoCIpoSUGaAX78slIza5uvnKKUAINgKHl/
         8WiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=gc9DD81phvVavPqc7tW2o8HbZduyVvn8F5tToxAvHLU=;
        b=OZ//RDo3angXhdjFlp3ovY6Gl71E8mF4hd/8NiLS4bVbZzSM9ouTEWLPSLZPr8z44Z
         nKDXrmfy7sgx1QoC5jVsqFCqRBWXC8DIKoEg56H2O6nfPIfZh34PA/k1kFAhRUd5sBOr
         M+obej8gdLqAC8916r6gV8QXfxJjHRkLCl4ShWKdgzVc6JW8Pd3qAR3hFPK6IhXWJY5t
         l0y20WKpkOpKrOLAFl5en+Nj422beX4nNG6b9z0cvrcl+5EZy2q9P3uEn4K0+bdTfXDu
         IGpTRlXoM6H/khF3TgDg/KXtD6CNrdlvcgoI0qwZ9sKoAS5/eCuyaYohIfcplk5zxRUc
         wdEQ==
X-Gm-Message-State: ACrzQf2mJDRA48lS+ZEq3Zi2Q079qFGO7GCf5ohw6/I264bi66dw7AJi
        EAlSz4dx8U2Jy42fedVAs2Mh3VxNUkVD02DJcM4=
X-Google-Smtp-Source: AMsMyM4bTuF8fOy18c6fS1zKUI/lomUwkcLro3S++vnrcyLV2UYfBVpIkkNl9CoMKe0LmWZSOZdr3A==
X-Received: by 2002:a17:90a:8906:b0:202:d763:72ab with SMTP id u6-20020a17090a890600b00202d76372abmr10651538pjn.56.1663954430661;
        Fri, 23 Sep 2022 10:33:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 207-20020a6215d8000000b00537a6b81bb7sm6878099pfv.148.2022.09.23.10.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 10:33:50 -0700 (PDT)
Message-ID: <632dedfe.620a0220.1bf29.dea6@mx.google.com>
Date:   Fri, 23 Sep 2022 10:33:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.69-44-g09c929d3da79
Subject: stable-rc/queue/5.15 baseline: 131 runs,
 3 regressions (v5.15.69-44-g09c929d3da79)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 131 runs, 3 regressions (v5.15.69-44-g09c929=
d3da79)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =

panda     | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1       =
   =

panda     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.69-44-g09c929d3da79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.69-44-g09c929d3da79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      09c929d3da79f2afbe426846f7573a6c3f9b3380 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/632dbbdea392fcc554355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g09c929d3da79/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g09c929d3da79/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dbbdea392fcc554355=
643
        failing since 1 day (last pass: v5.15.69-17-g7d846e6eef7f, first fa=
il: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
panda     | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/632dbee41098d227bd35564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g09c929d3da79/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g09c929d3da79/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dbee41098d227bd355=
650
        failing since 38 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
panda     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/632dbc4f1867f74bed35564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g09c929d3da79/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g09c929d3da79/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dbc4f1867f74bed355=
64c
        failing since 31 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
