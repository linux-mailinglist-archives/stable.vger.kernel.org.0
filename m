Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E00438DF2
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 06:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhJYEGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 00:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhJYEGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 00:06:13 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52671C061745
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 21:03:52 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v1-20020a17090a088100b001a21156830bso3860826pjc.1
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 21:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nvApBofLdQefrVRJwkoUMOC91kCgXwGNT/pu3QPQNnM=;
        b=GRD4Ge0MQ4iOQD6m9EFgLB4taJiwQMTnXS8+/lKtl8nJCz4U6dbCQSzr/1aRSHLLR4
         9Q9TV5It7nfwUuVv7bIC4KrZ6wG9wfeVQkgKyQXUYWspTZF9K3NjXmKY3jIWLZA4HS3C
         Drr+uZMCgJjCCmk0lwa0o/CaGb4baSUtU/molIs+q9QGRM9KBIrFcXh+pbP7Zpebt36U
         p3WeFTLOAOuArZFmOd4mioTC6X/aUN7pRYW3g831EOHejpCHy2CFvsyBTfsSXw5enr9j
         1DWtpvo3Lg2FXGp7aUGGDROhfyXHMd2pwiG7XUB3o5t1ScctDFuwLlA3EmSeOKRJUogs
         oDcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nvApBofLdQefrVRJwkoUMOC91kCgXwGNT/pu3QPQNnM=;
        b=o44InRI5AzlRJpTwZMpwmPUl7tXvg7+Q/X6ij/BqcRVnSHnVtYXgfHMCbNts2blW54
         NhoA9L9RD9T7nmxMEn4UZreHxHArwvYCWz6y/Lk+x+xkHmAeAo1o/eMRKjEWHOCpGWoS
         H1eUquWiqNm9Aw1LuwjQEVI80BplTfOnSQu8uEa4kFRAE0RHzyNVGdi9naozwBFJIdQW
         Gxy/NG3XQGfAQWLWaNfSKYeRlaMoW7BoHk5nXLhwjqdJMjJEBv2IyS4EY16b+F9STsOu
         /+NK7I4GJuObm6ImyduGc/aOGKPGv2LhFc1hqkCUEOhWj40P8tB+6UYJRp+9sOBPiX30
         UwIg==
X-Gm-Message-State: AOAM533HcLwuUV3tsdraCVzvHlytzSWZkXrXrmsAIi+v0hM14IwWF8Gh
        0r1TtgK+MTLEIAf/d8vtMJaL2rP83crcs1oO
X-Google-Smtp-Source: ABdhPJwg9oGrudKjvpr71pSwl0JbLhlxMoy3rLjkCXxCVNfFKlDLV7aMOowqX5X4eBV95bfMMYilFA==
X-Received: by 2002:a17:90a:fe03:: with SMTP id ck3mr21947151pjb.212.1635134631743;
        Sun, 24 Oct 2021 21:03:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14sm3454556pfg.178.2021.10.24.21.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 21:03:51 -0700 (PDT)
Message-ID: <61762ca7.1c69fb81.41019.9757@mx.google.com>
Date:   Sun, 24 Oct 2021 21:03:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.287-46-geb744111da99
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 139 runs,
 2 regressions (v4.9.287-46-geb744111da99)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 139 runs, 2 regressions (v4.9.287-46-geb74411=
1da99)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig           | regres=
sions
-----------+------+---------------+----------+---------------------+-------=
-----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda      | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.287-46-geb744111da99/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.287-46-geb744111da99
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb744111da99ebb900cbab32d6d7bd01bf0d65c9 =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig           | regres=
sions
-----------+------+---------------+----------+---------------------+-------=
-----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61760a4e77acadbb1233596b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-4=
6-geb744111da99/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-4=
6-geb744111da99/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61760a4e77acadbb12335=
96c
        new failure (last pass: v4.9.287-42-g103268c38f6b) =

 =



platform   | arch | lab           | compiler | defconfig           | regres=
sions
-----------+------+---------------+----------+---------------------+-------=
-----
panda      | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6175f8a78af37ea199335915

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-4=
6-geb744111da99/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-4=
6-geb744111da99/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6175f8a78af37ea=
199335918
        new failure (last pass: v4.9.287-42-g103268c38f6b)
        2 lines

    2021-10-25T00:21:35.396029  [   20.100280] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-25T00:21:35.439138  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/128
    2021-10-25T00:21:35.448673  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
