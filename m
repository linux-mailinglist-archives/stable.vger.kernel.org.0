Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A9128CA7C
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 10:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403952AbgJMIsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 04:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403825AbgJMIsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 04:48:40 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475D4C0613D0
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 01:48:40 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h2so10296236pll.11
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 01:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6o8mXPAX+g2hXailFzLPWtWDcs75Oy4grkSRSUoDjTw=;
        b=BaGBbLT7cYvVx1d3YnR+F3oQnt+Gduy89vjES6NXaZdwlOsaNFxwGvl7ratV29WGPR
         NFKl3bDCDzQ3W4rpjrn86epo78i15V//VA77CCK+mU55tKoKRPAv6aFVE/Nzfk/6+aah
         4aabXekeYKMFbD4rxaPw1YBE+6bH870UUZLqY4ihBfV9Y6Z4j0eD9hYng8Lb102IHizF
         iqE3IlnUS18ROV9PZ4Hw3iaJGdMFxx69sseyLfMmWUX6jRLcBj8aChbe5/6wmrdaicOG
         JjpVNNuyacz2XjVmW5yTVpGOn2ajf8vHVHYB0D9qGOedezx27ijIETs45tNeiqK0k9Su
         LO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6o8mXPAX+g2hXailFzLPWtWDcs75Oy4grkSRSUoDjTw=;
        b=JNKwoYmy2xgAv/jJJvai2cBJlb4TJ5IMdYB2pUuWVw5GVHcS2g052DQ1OpIadsPM7K
         52qsv0tXjIP9KNmPxbfkpNUtcFv3PJHLQbVynsUQ1fD/2chKcSa3cBUXjyAoaJpu76Ua
         asttVOH/29hTLdjRZMWauDxfUQbQOlEUPzrXx0UTWoAiFiVXrBUY6bQWGQHWL1ZFY6yS
         iFyiS9lEJB0F1I30luhZcMxWT0sVvhEi9N/g9Up5LeSKGeWCFZRs+rOeN+FQb5C+zUZb
         n6QC4WALMLjs1HXTX3x6U6zBm/vsLKQQElib78f3Za/bQsRRSdJgjweYxPyGJriBNJFy
         jE4A==
X-Gm-Message-State: AOAM533ItEjGez5R1yGFzbIc/vI3z3OcC1+5Rk5gkpB3fsiI8v+pXo4L
        eFcLz6PJPVgynuuNAbZXmCQthPSnE1949A==
X-Google-Smtp-Source: ABdhPJxjZGrPzoowBZrVYWXBr6C8TF8hFW7MO+4Koo6TBszudvFRpjTNtPamwjOqRacW+Ke4HNUgPg==
X-Received: by 2002:a17:90a:65cc:: with SMTP id i12mr24558273pjs.193.1602578919422;
        Tue, 13 Oct 2020 01:48:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11sm22427576pfl.58.2020.10.13.01.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 01:48:38 -0700 (PDT)
Message-ID: <5f8569e6.1c69fb81.5dda2.c37c@mx.google.com>
Date:   Tue, 13 Oct 2020 01:48:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-70-g143a37943654
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 165 runs,
 1 regressions (v4.14.200-70-g143a37943654)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 165 runs, 1 regressions (v4.14.200-70-g143a3=
7943654)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.200-70-g143a37943654/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.200-70-g143a37943654
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      143a37943654a79742fab0222b8ef51b4d88c4d6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f8528de8ee1548d7a4ff3e9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-70-g143a37943654/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-70-g143a37943654/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8528de8ee1548=
d7a4ff3f0
      new failure (last pass: v4.14.200-68-gdb4c16496395)
      2 lines

    2020-10-13 04:11:06.350000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
