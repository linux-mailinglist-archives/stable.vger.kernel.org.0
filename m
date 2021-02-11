Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2B2319548
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 22:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhBKVnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 16:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBKVnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 16:43:31 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90249C061756
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 13:42:51 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id l18so4203042pji.3
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 13:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fQokEHaKHFBosQnjtzC7yqznaOIvf0BsU59JI/shsF4=;
        b=CPdy0+Wv1B/1E0mTHinji4F00wNktn5joUxRc87Zyxb/rq2re75gtvu3Nj7nbL449+
         Tb2/sr9cTv4rgM4YJ2RsJccmi37aqfC3x4zD1PjDxaTnxGqwWoCjIRHn1fbv9/jVoBrr
         nTrUvuTy1h3AgpElGwAsTN+Wok0LWQQmifaREHwSw6X/5vq2B2OUNzB4JuEh+uEcF3yC
         iLLxULihOSeQ8Kea2tfpwFs4PwdFesp4X+SPl4TlmlVxYh+zxuJBEqPkIFPeVp1q7p82
         vgxh9kcaaZRobnG9hK6fCSjZZZrh8l8FLL+8oKwxoENTn1CDrGcOgCTdU6kF8jLqGwqz
         Lw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fQokEHaKHFBosQnjtzC7yqznaOIvf0BsU59JI/shsF4=;
        b=feIhsd/w6yrKkKvMtvBMg7QfbCs3O7VIe2SuRbzRC8LEuX9vZk9OlXAHMys0Vj2wM3
         deberJZAQn9nQBv25tc23goD27hVcLPybXybZSYwdDBLVHVaLT1mQlcrvO38BeSgwL5m
         Gx0LZt5Q6LOUZJoTpsYVaSKUPnicekeP8MCB3+dPtg5iiFI6pWsBtQgo6uFOeOban0UP
         tObBisTUBu03jn1Sw5AngWQKPTJnjPPFhjcfN5UESBYeTqAelRyv21VGv4bOwUS4/M5T
         97eLPBlBuOeA+D0cknx4hlW8izFdEHjmy0X/jr66ucHcIFgh3ZdlW1WU8Ebbg0BszOcb
         +f3w==
X-Gm-Message-State: AOAM5300vIDeNq3Pzw55phTuKK9P0IeZEgC9TuTXb8wFwRWcvMdpOKYc
        RxUxHjvrIa3N7Uilauxq2Dwchx6vmVfBHQ==
X-Google-Smtp-Source: ABdhPJxj2O/4mKjg82vwZOR1G07SUj6L5TMcJQ0Il3DM+ZWzrBKxB+3wJFQckiQjyauwcvA0ktcA4A==
X-Received: by 2002:a17:90a:5a86:: with SMTP id n6mr5936174pji.65.1613079770901;
        Thu, 11 Feb 2021 13:42:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x28sm6687372pfq.168.2021.02.11.13.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 13:42:50 -0800 (PST)
Message-ID: <6025a4da.1c69fb81.401c8.ed37@mx.google.com>
Date:   Thu, 11 Feb 2021 13:42:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.175-24-gad0db72c5c728
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 81 runs,
 1 regressions (v4.19.175-24-gad0db72c5c728)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 81 runs, 1 regressions (v4.19.175-24-gad0db7=
2c5c728)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.175-24-gad0db72c5c728/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.175-24-gad0db72c5c728
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad0db72c5c728bab344f0c1a05309e249f64cda9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602572a56054588be23abeba

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.175=
-24-gad0db72c5c728/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.175=
-24-gad0db72c5c728/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602572a56054588=
be23abec1
        failing since 3 days (last pass: v4.19.174-3-g9df30fc2980a, first f=
ail: v4.19.174-9-g72c4313237ab0)
        2 lines

    2021-02-11 18:08:32.794000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-11 18:08:32.812000+00:00  <8>[   23.023284] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
