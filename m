Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F382A29F9ED
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 01:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJ3Aos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 20:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3Aor (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 20:44:47 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EBFC0613D2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 17:44:47 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id j5so2136986plk.7
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 17:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5+e1t9OgSv87oF1Md3oFa16VMF0WOuvXzcUnBng+6XI=;
        b=lXPrUQImPrSmRs3UaLkFdznoCFRuOYJvjz2Y4IbvgiMo2vC8ga1wEmfim3p3pKGMBT
         6I24IlMal23NHnn6/sVcFcCCBKGXO4l9NDHkJX9g+cvRP1gdFmFFcap82Wfw+tNP1eQ9
         3cejyBqNTPyJCG47nGRPWpzjdgRe9GyWqfGJ9GzhySme2n2LiN6PrmWwZTlbeQyO1S+c
         G2Vba6pZXUMqMUUKf+GNQ9HYOszyN/TS9V9A4XQGhOTWOM75J8m0BpowsSBeX0K2YGM4
         ZfQtE1A/sHi76kF7oirLmLIcX7KLzTe/eV5kUKkjLf+Sq4Rf/XTOdnVZzAKeJ+JM4JT7
         BNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5+e1t9OgSv87oF1Md3oFa16VMF0WOuvXzcUnBng+6XI=;
        b=sZLbGhF9xWhE1jR2nzesjhBCo6Wv4XuAgDP9SEQ8dK92o0zb26LXUCmLVussSSSbF0
         v2nCvZhpltweaBktoih+ih7TE4MTZEDWLVQDXTWyKi/W5f2jifMWaBD/Qzkf1GO5ou5f
         aM9wEEs7xyLOkhc02D4g+QZ8ufUqkPp/VdN/zagTrlfMGiKidiYor/FnkDp2EPiBjs6B
         REJVhnDHLdi44n0M0qEKzcEWulIgHyD0lhDcvX7b5q9qCNzTrsuxnGX4ElRux+aXbtXm
         ZzYQihv6UtvDHkKLCDZDiphCIa9MsJ5p3OBDZWZUrauYV625ODPO0zzj+N+O+PElSy03
         GlPw==
X-Gm-Message-State: AOAM530sI2rY3RepJTOm2avowy2M1TJn3H5myf7aiWYDWKFuWdwMtCrT
        fhKbTHaFIo4onnmLJmMvwwE72J/ix6WaVg==
X-Google-Smtp-Source: ABdhPJz1W5inOr7UjtRDYkfwLLzrro+4YjLXuID4Cse/ldzUWSRi/fFwvO/N58XHLd4KBtj2Q4frCA==
X-Received: by 2002:a17:902:8502:b029:d5:b4f4:8555 with SMTP id bj2-20020a1709028502b02900d5b4f48555mr6374275plb.76.1604018686835;
        Thu, 29 Oct 2020 17:44:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x2sm3919327pfc.133.2020.10.29.17.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 17:44:46 -0700 (PDT)
Message-ID: <5f9b61fe.1c69fb81.fa224.9de3@mx.google.com>
Date:   Thu, 29 Oct 2020 17:44:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 144 runs, 1 regressions (v4.9.241)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 144 runs, 1 regressions (v4.9.241)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.241/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.241
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d69a20c91691be92364526ffb084d750e3e7f7fd =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9b31259e67b1653c38101c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9b31259e67b16=
53c381023
        failing since 2 days (last pass: v4.9.240-15-g726ac45a50a6, first f=
ail: v4.9.240-140-g97bfc73b33b5)
        2 lines =

 =20
