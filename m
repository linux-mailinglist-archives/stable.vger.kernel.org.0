Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642D52A1F4D
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 16:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgKAPxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 10:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgKAPxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 10:53:21 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C65C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 07:53:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id az3so2011785pjb.4
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 07:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TQxOtYRKW81Xk+x+wQmkvUI9YhFlsSEPTYQROY9HCWo=;
        b=Pt5vYm+E2Mrrwk8bj500Sm+a9SEZBgUw7xdJNQKL6boMRe5Tyr22KQziPNQJmGkNp7
         SKSKxrRpeJTsdW4O+1zJ1ghhX4LWvbXCtS+0pVC296V4ZKby3JbO5NJYKt2FR6pSRh+h
         AxPCUWGLU9MeVwP8lfLMUF/HzVGAamQRRuqwRV1AfLAx5vUboe1UZ1noDg24feDLOhcW
         xUC/d8FUFhObrG8pU1+pNnfiMUyH0MZNYHuJXD45cxaED6ck/YTSxi7XREMuW9fjAMOS
         22xsCSbhdDiCHZmk0LC2wvCo7E22ACZafvzlkfXFNRLTy5EBvK9muStJjobg78uuoun3
         op5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TQxOtYRKW81Xk+x+wQmkvUI9YhFlsSEPTYQROY9HCWo=;
        b=BRFbmz4OBZZWnSC1HFbIog26PXnWjfuWtav6F7lCoA/vmxHtPSmaZYg+tvKUXVgB3G
         2u7NNrjywJDZ+8pkWgcGMCkFk6wOFgGtnFHHQNR43z9Uay6dbbhayij3w3P6f4OEJ/qN
         TWTfwXHea7NuRGRx9vjW87DWaTxn8zzrjw8KbL+zEPkB6Hld4RxT63T3myOFZ4KETbAg
         JWRAvgeAF1UIVHkJ9pGeopDOMRdzeOU1Sk5DU/ZdD4L96Ljp/1u0eSWPfHOBUg1ZXAH5
         Jb3d7mH+H7FcqtHNsTxtxEIsg2hV9FWiOK0GDTtvUFm2rS01tHnoKwJFSXY6SWKx01tv
         Vpjg==
X-Gm-Message-State: AOAM530zA37hw6tc+5tN4inCkS4yxSErmv9TF4Zxkvc5EAkzlSGg4lsp
        UaepFnO8bbPd6AQxsoJT6yCoGH+3izpFCw==
X-Google-Smtp-Source: ABdhPJxP2A+c17Hm1yKdNFWLkLLfLqP/2qWttwLwRj33zYm64EB68y9aePLfqFLfiwt9hsOZOLmr5w==
X-Received: by 2002:a17:902:8a8b:b029:d5:f871:92bd with SMTP id p11-20020a1709028a8bb02900d5f87192bdmr17489195plo.10.1604246000348;
        Sun, 01 Nov 2020 07:53:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r8sm12035194pgn.30.2020.11.01.07.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 07:53:19 -0800 (PST)
Message-ID: <5f9ed9ef.1c69fb81.804e4.d8db@mx.google.com>
Date:   Sun, 01 Nov 2020 07:53:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-10-g5dfc3f093ca4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 128 runs,
 1 regressions (v4.4.241-10-g5dfc3f093ca4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 128 runs, 1 regressions (v4.4.241-10-g5dfc3f0=
93ca4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-10-g5dfc3f093ca4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-10-g5dfc3f093ca4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5dfc3f093ca422f3a555fcfe497902641012c7fb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9ea716c4517526403fe7e0

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-1=
0-g5dfc3f093ca4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-1=
0-g5dfc3f093ca4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9ea716c451752=
6403fe7e7
        new failure (last pass: v4.4.241-8-gd71fd6297abd)
        2 lines =

 =20
