Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06FA31D203
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 22:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhBPVYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 16:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhBPVYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 16:24:55 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EBFC061574
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 13:24:15 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id ba1so6228964plb.1
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 13:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+tR64mm7bMb91/vODZrIcMdbF6mqbVYi4r6Wsfrtth8=;
        b=PyBrHc2cVWLvsrD+g/6+luNCJAe8p8jaBMes9OkFz+zcG5pwEPHnKG01V6SAyngsfL
         pfEAm8u7dEKC9YYiPqhdCoxR83JBJu84hU2o5fx+iQu3vvHO+khLdaP+ioGsPPLJI0pe
         8eHqaLNF2Q4fAbxrSmYxYpCL90zIvzzSm9Aj0WJPdRFVkkqoACJk6blYCO5F5SDsTkFM
         hhnWtBGTDn1GHZlQGrpB4ARD3BftIZtyJ2Kt0p2vGs+UPD+ZUrjkfgZqxHpCzixtuABS
         9ut4/pzAGRZ+gtlKhu9WqjoEtF4O4qZctIGa7L0lkDFG446Mp8Rc4f+iqYZ9X0cBuODA
         YLyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+tR64mm7bMb91/vODZrIcMdbF6mqbVYi4r6Wsfrtth8=;
        b=JannrbGMhMD8JSELQQGvUXYPjpBf8mcLt4VNzPBVXmNnaOrhO8kJF1war/x2RB0GKC
         JfLm8EEBcYALNMeNQ4LX7U/OaFlbWK+GOD3tzsqE7kg/q7JvbuGNeWslZFKCw0k8CmZX
         6eLRNjjDQvmysBhaDXcedXkPYrZ975RCExaIZ8Cuj5TWvJvlyEEPlMciKgIW5lL0Wi//
         V3pwN3L7zoZUolaNbOv332yi3m/GOBb24nuQojq/K66wOM2OS0ExxT0v/pllXsC2DjG/
         L14wWfPchFSixiUW1yHGxAIkDD2mZjqT9CdZ9g1ZJ+FsIo8gQ+XsbHvXlqW8nyk7NTRg
         NYPA==
X-Gm-Message-State: AOAM530BpO9lHfcEvSniHIZP9fMcmK8OCf0E1dongK2pUSzomcQ0eCUe
        +Qm3o38cM1kCboBXRr1JvM44EWwYNR8Sag==
X-Google-Smtp-Source: ABdhPJysJpk/XwQyw6Xa+hE3y/EUqzisk8jhZZlRdUK25VD5fDLIPBFKLvRvq3LmcHPHto12lF/88A==
X-Received: by 2002:a17:90a:f18f:: with SMTP id bv15mr6125576pjb.51.1613510654335;
        Tue, 16 Feb 2021 13:24:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u15sm5895550pfm.130.2021.02.16.13.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 13:24:13 -0800 (PST)
Message-ID: <602c37fd.1c69fb81.3956d.bcfa@mx.google.com>
Date:   Tue, 16 Feb 2021 13:24:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-44-g2c371b544ba26
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 65 runs,
 1 regressions (v4.14.221-44-g2c371b544ba26)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 65 runs, 1 regressions (v4.14.221-44-g2c371b=
544ba26)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-44-g2c371b544ba26/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-44-g2c371b544ba26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c371b544ba26338d651db7eadf07f4129c59ea0 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602c07e7752dda54d4addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-g2c371b544ba26/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-g2c371b544ba26/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602c07e7752dda54d4add=
cb9
        failing since 70 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
