Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B503F52DA
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 23:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhHWV0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 17:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhHWV0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 17:26:46 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6C7C061575
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:26:03 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t1so17841093pgv.3
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YbdbwX4qw0u0zcynQbBDjzxifg3JmislkXySssw+NHc=;
        b=MmzjyQma1XlmQt+LLr4TMq3VHD1GZPpTrJ27vimlNXDMpsEFL0Pc+R3+FaRTmAhzFG
         iksmwGiGTP/VZtavO4Q7PKkvcfExwoB1gmub2EyXGksDoirVrKjqdANkQ1hsGhfGLN4l
         30Gjw1bo3+vciJe7houORWPk7lWTCmMR3YksYfWDUAlB08NV+IAdLyaK6GncCm2Fbg5y
         Otto87FdRjTOs1P/PZl/8lSCLsiBYDn/boXJGku2QCTEREU3KEFTmuqS0tdrCj6pc3SY
         i7tNyRy6KfvjNeA1U6nQyJQRWUL6/FMGuXBxnoQYTb3zRYD7zz5LVJQNaoD3qg3bd7yC
         6i1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YbdbwX4qw0u0zcynQbBDjzxifg3JmislkXySssw+NHc=;
        b=J/Wr7RB/alVXFpZgwTFPWdJJ8axARJSgof+GZSul6rgV4ccfh6SO9iPpi0QsffVZTd
         FTqIY/XOzhyMuIcFON8sAOO1gmq3Sztz08lKC6xtZpt0uJbB9u38Mg3/spLQZpYg8omJ
         UY6c+WqvBAKxfgNQ/xB3RUjemPmaGKWg9yOTJg3J9jKlQyc/thS877i5/HE07wVc+O50
         0pCCb61fQpqWmLecd6WR4Bf4Y7RDEWBxaZ2erX0dT3gyUZRLDb859xG+dCrV4dS2B/3V
         TZvtGLxwpEgFvgwzerQ4OFicP2yl2kzIbLdMvp5SvIrUoJCQD+yfuR456Ydrwzy8frMy
         ExPg==
X-Gm-Message-State: AOAM5330634TPFwLkdPc7NT2pPBGuRocMTSH/Uewg4NMOtyNHLvF070K
        4S0HNBXPNXSMJHh0s+icW6bCs9/6InR/G02r
X-Google-Smtp-Source: ABdhPJyNZWlIU170s4OBh9TEwgohzAiB6ac/P3xFx/+SL4PdjMUz9/+ws8NicE8TK+lVT1cbrA5rTg==
X-Received: by 2002:a63:e413:: with SMTP id a19mr33681854pgi.408.1629753963025;
        Mon, 23 Aug 2021 14:26:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b17sm19022411pgl.61.2021.08.23.14.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 14:26:02 -0700 (PDT)
Message-ID: <6124126a.1c69fb81.93f7a.8f51@mx.google.com>
Date:   Mon, 23 Aug 2021 14:26:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.12-84-g256f791101fb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 216 runs,
 2 regressions (v5.13.12-84-g256f791101fb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 216 runs, 2 regressions (v5.13.12-84-g256f79=
1101fb)

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
nel/v5.13.12-84-g256f791101fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.12-84-g256f791101fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      256f791101fbd5e8a6a98d0cbcd82b2ad4bb3c3a =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6123de3ad1256c530b8e2c9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
84-g256f791101fb/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
84-g256f791101fb/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6123de3ad1256c530b8e2=
c9f
        failing since 4 days (last pass: v5.13.8-35-ge21c26fae3e0, first fa=
il: v5.13.12-1-g3b7bb0adff56) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6123dce648e618d0ff8e2cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
84-g256f791101fb/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
84-g256f791101fb/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6123dce648e618d0ff8e2=
cda
        failing since 26 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =20
