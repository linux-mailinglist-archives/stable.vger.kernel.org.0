Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9482481C56
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 14:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbhL3NEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 08:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhL3NEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 08:04:08 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9827C061574
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 05:04:07 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id u20so21343788pfi.12
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 05:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I+JU4Vzl9+yalGUVYWI5RpvTHd1adre4LFUUWGExWyA=;
        b=6mKnRIbqMEo/BRNpy7ONyPGhO8ndBEljdmBI6M8F5HAQwzQzKzkZrJDGBajc/IY01n
         k6bRrO/77A5gCK1rPFcyd3Xu97f69C/LhHOYp1nGLaUKr7/ccFQQ+0qW2j6EV6hcCPS9
         07hDEgxqmA11f2qSljC/wtoiO1ah2qqG8K911b+Faas8Z6pOtSV3gUxhgt1WpzrxI8N5
         Oy3EX06YOth4OWlcykSP4hI5yHLvqpXNxIVd2xjMB+aAdKIWrt/eFhyxFqIJMj0lvnsc
         R0puoY5m7T1b3JnIUF4UO+Y+kOIhJaoxmoHFFnA9cmbhOj6sd+wHP9E5f97aFCR8FzEh
         VxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I+JU4Vzl9+yalGUVYWI5RpvTHd1adre4LFUUWGExWyA=;
        b=3M0Dsg5QHa00/E6p8gOZJKQr7hq/nXqFhuINKpOVo6EiGOwYuDDCsRBikBfCWnsK+S
         bFHMYSb3/Lw2IhKYFlVJ9/cUV4PtCuNdFzwZ9SgbbbpAIFUCNuMKQAcf+eIsItmqtrKk
         +lScXhDodn1e+m5R1k7H5d8LxpH+m6N7vFzAiJOnSbyxxZUfIGijCrtxCj/R/MwDhqkb
         j8tP2zacu0xQcK5zkcrR3Tc9RiLzMkW2QyHGyt01PN9l1A+cV2iryonlJV8pgfx48L6r
         uLh59eOU55cCNwf2WRM9px4B2UUE2KznX0SrzwIqLyQK6GGpSAPD06gSbsFsrZcQp2qI
         7q8A==
X-Gm-Message-State: AOAM530IwH46U2gwGOCg9S/ze2Y1iJQPAH/sK9YxqRTIQxs3gxf+3l1L
        m0KpVCJrS3BysEXh+vyDIp5+A/e5Qw+4b1Np
X-Google-Smtp-Source: ABdhPJxvCG5uVDVkyx/PS5Gk95IPlUmAAUK9psuF+QHg+fCWBsO1iJYWDSR80NRvN0zZy3zzOa1ReA==
X-Received: by 2002:a63:2b05:: with SMTP id r5mr27623286pgr.0.1640869447294;
        Thu, 30 Dec 2021 05:04:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s35sm21534093pfw.193.2021.12.30.05.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 05:04:07 -0800 (PST)
Message-ID: <61cdae47.1c69fb81.dee2a.bed1@mx.google.com>
Date:   Thu, 30 Dec 2021 05:04:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.260
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 109 runs, 1 regressions (v4.14.260)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 109 runs, 1 regressions (v4.14.260)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.260/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.260
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6ca7c65b1376f7bb14979cb745d3da73c8de948 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cd74ffb07e2c14b2ef673d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
60/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
60/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cd74ffb07e2c1=
4b2ef6740
        failing since 7 days (last pass: v4.14.258-46-g5b3e273408e5, first =
fail: v4.14.259)
        2 lines

    2021-12-30T08:59:27.127151  [   20.159454] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-30T08:59:27.170207  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, rcu_sched/8
    2021-12-30T08:59:27.179504  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
