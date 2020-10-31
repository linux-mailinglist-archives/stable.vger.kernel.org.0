Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40272A18DA
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 18:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgJaRAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 13:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgJaRAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 13:00:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5573C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 10:00:11 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mp12so953811pjb.2
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 10:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UE0jZvDNKbn1ZUJpYFBeFH4sZ24wjBpYug4wD4x+so8=;
        b=R+3DpJCecieMK7q+XhB2gLI9/zuvpxq6TOXdFkcZ8YnyZwAb+ieG3Qy/3r1osPOovq
         Lw8BdW69G+nr2mRGoyanU64XaNLtvKIk+IuXOm7t5WSeZlOCa5loGHBWMvCvzQvmAg+P
         oWwi0CojZjjlpfd81oo83aa2yzPovAJknYgjrnweuIcx7Ygid78FwDXkdisfkJ+mKFT6
         zohxS92d3fExogMguo0Wd5F5mQ2lW9IKPKSW48LSiu6gG8Y+l2c2br2CeGtquqQ/AN3Q
         i4PlA4Gvq5MnOmaaHuxrPcjKGCEYbAJDAmDUIAxGO+EV1dOsHCCHyhFe+bThmFvYsskR
         Cb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UE0jZvDNKbn1ZUJpYFBeFH4sZ24wjBpYug4wD4x+so8=;
        b=lDe3ZnWZeoOqW/DujDpRPZ5GIPBsuabh3R+YFDOG6rO4HHCPSkusLG1CzYutKkH/Kr
         CxFEA0bAuWRdjsBswcKWAGGSFvWZcziipHyNs57jHcDdDltLprAizHCprd/BpIjdhwQS
         h2bjmuTe6H91la2aiUugPRbmawArHRSRRzkHjLcaDl7wyZHQYLtFvdhpyozOhpZGXHM9
         C1LgGlBLmK38zRLLvgN84tqNX3Xrcs1ggM1DoIOmMtftvpkkb7VS2Fkfe7RYToQVk5qi
         PSDaIBYmgKMB2XIatGhEC4XRhNIDDezmzvVziONz/evDUSvWTrnuhudNLAeF5UyjoY/a
         6lGA==
X-Gm-Message-State: AOAM530mwF3yH/7O9ry3fGTzH/c4QMEbCKBKJTbHvXyBa5Q4y+nqpzWc
        IusN026GqcB5Yjucux/dvBxUG540AkDRDw==
X-Google-Smtp-Source: ABdhPJyWtE0HuBLOisAYhvZi0LhOQ/lp+pxWs//FwZsTPmHgZrvtDI3u9ifoYCTCCWNsuQcdpvZqTQ==
X-Received: by 2002:a17:90a:f314:: with SMTP id ca20mr4329961pjb.191.1604163610902;
        Sat, 31 Oct 2020 10:00:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13sm9395246pfc.1.2020.10.31.10.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 10:00:10 -0700 (PDT)
Message-ID: <5f9d981a.1c69fb81.b23c0.7251@mx.google.com>
Date:   Sat, 31 Oct 2020 10:00:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-12-g1c724983025d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 136 runs,
 2 regressions (v4.14.203-12-g1c724983025d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 136 runs, 2 regressions (v4.14.203-12-g1c724=
983025d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig  | 1       =
   =

panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-12-g1c724983025d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-12-g1c724983025d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c724983025dc9fa21987d05f9510b7622b59171 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9d5f457fc8ddbed53fe7fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-12-g1c724983025d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-12-g1c724983025d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d5f457fc8ddbed53fe=
7fc
        new failure (last pass: v4.14.203-3-g5f7b19c77be8) =

 =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9d5d43473752ced93fe7de

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-12-g1c724983025d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-12-g1c724983025d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d5d43473752c=
ed93fe7e5
        failing since 0 day (last pass: v4.14.203-3-gd24321bfc541, first fa=
il: v4.14.203-3-gad7f808825a3)
        2 lines =

 =20
