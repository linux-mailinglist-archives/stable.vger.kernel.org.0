Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AD5440C85
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 03:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhJaCY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 22:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhJaCY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Oct 2021 22:24:27 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E85C061570
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 19:21:56 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id j9so5665655pgh.1
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 19:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=te8plfLCXMzuJvCRjlUnnZCZsVG+udxP7FjVWgPmfDs=;
        b=XE6D9iSjw058iBQQD+OagJRQ9aD+ogABEBNSA++LfXJtOg3b0dWQTD2R5/MZB84pEr
         CRFo/3JTsbiWKgZ2eu3kHOZCVg/mKrwtzXBVl4Pnl6wS5IxjnEQXrsnxHGlJNTQ/bZT2
         uJGLZ2r+ENcKeMWeU2MdcHPpXcE1J/2XCrJmBQmr+kWZth8FP3ugXHYSNn+QJqYWdzmr
         7dCM92eYDNlEz8YGM3/fq/uP8XRQzRQ1UwQCJA84wHZIEDWXFvZ5JML9YItK0yyKotwF
         H2ElafYwR6rIwL/+RjJmNdsPaYs6VYxIcnzY+ImBoW0lX+vnZIziZ3dF9wDHlY629lC1
         yXSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=te8plfLCXMzuJvCRjlUnnZCZsVG+udxP7FjVWgPmfDs=;
        b=fVcBtWj8kjd3Rd1VF94f2H6WxVgM+gTrU3QTxMmN7xOikBRjGPerRJTIiRzuRdyOCZ
         hdffLEe3mVnVLF/6xX3i/B5Jh852V4NE0m8rwLFEbWokVmtSmFGTbzl21YDlScw3OUmG
         68SQhTUIIKMQe7bstMx+m9cJf5hhJKLSBXM7T/QO4BQ7NZlWpag8gwygO2/NjXK20GV7
         HHBNXVTTM20JxiUxSrTdFhysIZVnyVUgkVs1ZWkFgL+idhNdlU+CJgiL0E0pOoX/yRwc
         u+Iku8oeZIYDbGJKJe+3/WB9n7mFl8a4WbpMu0C7Nz/6ioqEAlKT2gNw2RfftKFUcEIG
         aYjQ==
X-Gm-Message-State: AOAM530o02YEari/Qg8FQSwQ8O7+/N4P8TaVJXMKp/1B3xHzvnhCUB8i
        nmx5qDgCf3/RW2sU5pESdZX8NfljSZrJjf0u
X-Google-Smtp-Source: ABdhPJzxWYfJjfmERMExzw+bKDor0rZfg2RO6G4GhIyxoWHXQ9/u1XueeGmGNl2BHmm6Lr2vhqhVwQ==
X-Received: by 2002:a63:82c6:: with SMTP id w189mr2784280pgd.469.1635646915532;
        Sat, 30 Oct 2021 19:21:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1sm10564004pfl.133.2021.10.30.19.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 19:21:55 -0700 (PDT)
Message-ID: <617dfdc3.1c69fb81.93c20.e658@mx.google.com>
Date:   Sat, 30 Oct 2021 19:21:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.15-112-g5ce264a0127c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 142 runs,
 1 regressions (v5.14.15-112-g5ce264a0127c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 142 runs, 1 regressions (v5.14.15-112-g5ce26=
4a0127c)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.15-112-g5ce264a0127c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.15-112-g5ce264a0127c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ce264a0127c33b221d3ff3dea1858e80cf95e38 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617dccc69fbd7b1cfe3358e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
112-g5ce264a0127c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
112-g5ce264a0127c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617dccc69fbd7b1cfe335=
8e5
        failing since 6 days (last pass: v5.14.14-64-gb66eb77f69e4, first f=
ail: v5.14.14-124-g710e5bbf51e3) =

 =20
