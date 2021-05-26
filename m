Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D39D391B8A
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 17:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbhEZPUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 11:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbhEZPUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 11:20:11 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC32C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 08:18:39 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k5so977223pjj.1
        for <stable@vger.kernel.org>; Wed, 26 May 2021 08:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pezrmisYXK8hEGI8/7gHZXBciY4Wj1jjjmR9yiPJnGs=;
        b=RTNsHeQ3J2g7ts2Neu9nZqoVqop9j2ZmgJUYwaxxk8mGb/YD5bOSYl/hljT9BMRz9s
         UMG8qdRvfYo9yP5TCw/CmmcRAswj8G+gbnKwIVS3IQQps9sCWOEU9R08KeIYoRxzN3Iu
         8VPjHqnhj8Ytesla7TZNQ+75hLP2LZC6hlJvYevNB/aq6aMqIT2w8DyFaIBRHzdH95mz
         ux92ZWeiGZb0X/YvKBgg3LY1MZL2XJ4tMUjm9eb9ZkksR5Xj7xY4Jaf0eEmMqvZO3pK7
         GHkSEDmggGM3UKTQG1t+khENZDVE9TaCpaA5kpnzU5xEql0dsWhb701uvXxxWp/Zh2Vj
         Bgkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pezrmisYXK8hEGI8/7gHZXBciY4Wj1jjjmR9yiPJnGs=;
        b=YFAkfEtknh/5LHuFZdg8eFPC1OJzIMRExMPONWCQcXFA9gzzDfPTW9yHRvHTW4F3R7
         gYEgJi4TRhp3dP6Ayf7vXSo2wOlDsqbthfnnNVjbNueB9Hu+GWh07Kteqkas1LUYhkZ5
         i2R5zfwSX3b4UiP4BtL9Gcq5Dxou7J3+XvMN3dj1gbfD3kOQ5qn17MZAxnOva27PKDWJ
         yQ4nEufurrosZxo25UAcam0vg3qkvqXubBVN+XGnZQsGxX0AvnQxRHJ9XB6cYv1ielbf
         rA4p5gMD5iBCLJ/KoWSGjDyJCpHWH3m5X01p+wCiH9sG9Vxl0ASiiLFXmt2k1Tb18+nS
         3qKA==
X-Gm-Message-State: AOAM530wKQtTfi8eCJMY9g0NH23vyWfaMDTDbkLijcI5gAYx84OaBut2
        j1yQFcD6nguCjI3Bt7/I6AFxkNGOSFV+hGZI
X-Google-Smtp-Source: ABdhPJwH4c+MwDkAeMWOnaMn5TDKgbMjj12/5ghYsZSIJ3GSl3TpyZBHl8Nbcf2YME77rARZr6Tryg==
X-Received: by 2002:a17:90a:390d:: with SMTP id y13mr4336048pjb.133.1622042319046;
        Wed, 26 May 2021 08:18:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8sm15833056pfu.111.2021.05.26.08.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 08:18:38 -0700 (PDT)
Message-ID: <60ae66ce.1c69fb81.93f91.467d@mx.google.com>
Date:   Wed, 26 May 2021 08:18:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.39-106-g6aa0c3142e08
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 119 runs,
 1 regressions (v5.10.39-106-g6aa0c3142e08)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 119 runs, 1 regressions (v5.10.39-106-g6aa0c=
3142e08)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.39-106-g6aa0c3142e08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.39-106-g6aa0c3142e08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6aa0c3142e08437373d200f9b5b3959c4b041f51 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60ae2d3b68cd52f67ab3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.39-=
106-g6aa0c3142e08/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.39-=
106-g6aa0c3142e08/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae2d3c68cd52f67ab3a=
fa4
        new failure (last pass: v5.10.39-106-g0f7327dbee2b) =

 =20
