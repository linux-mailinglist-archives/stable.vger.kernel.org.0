Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C93840878E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 10:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhIMIxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 04:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237996AbhIMIxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 04:53:54 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EF9C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 01:52:38 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t1so8820537pgv.3
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 01:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5X+PJbLoGITaGd89uqpRrrH/NIymTXZ76D5e3XthSjw=;
        b=wvrbVgdKRZTjD0jjEXU0WZIGP/csdihaAz1wzJuyDdzuPO6IgED5Je6pthdGXGBIs/
         8u6m6WyhNRbV3WKG4zLFn3EghqLAQSfQgWStH5InDWSX3YoBAsextv+axV57F+Ojr2RI
         RGOxfSA3VH5+qs48Y2atuUtZHJdQKgOBOeKfAEcsOlpRyrJcN8tmZ3J45YB8s/tLKH+r
         9HsPoUQ3ebLxDZ2ikUDqGfXi1tLl0a0iLY79namC0iwM8kmRVOe/s45P9XAdauUwGhJk
         t+ZiVyQ8G8vPaASy9GGejfTrRp9pGfAtlI6LMv3dtQ4ly7mMT6Fd0uxasXSOnYow8Moz
         YcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5X+PJbLoGITaGd89uqpRrrH/NIymTXZ76D5e3XthSjw=;
        b=XTQIQD4BQe8webhrpE2SIRgU4HowN/+9Ry0zd3VP1SY81itRD0w+RZ/5NvV1jaJ7SA
         L/B2OEu3NBgQQkkNFf1Yn6Om5kR+bwFqAxL3bvYX4amSTpOSTzWYOeistwYtgm1sXFjI
         dRx/rAnIqZ+Kc7BTLerd2539N2OnMloRxhUaoS3ibHFauukiRNtsrBQ6JB0YPMHs5cRt
         ntop8+DnFyEPnVhewP23zXESVvXoHk+DmrlG3kp6q+ABcHcT5xGZI0bg/AzJlk9aWi7h
         +whgUi6JzK1HCOXlhF0EHrCdn9xvpNlSoixD23Q6TI4FG6g60es9owAaind1dd1Y9o6q
         h56w==
X-Gm-Message-State: AOAM532h5RLzFPzT4OKdXoXR2zwUsxHOznfxBCPMzRjGPCXFzcTmoMIQ
        RBgNT0b98P1wDl/G39vkja+oj4ZBybBX/T+P
X-Google-Smtp-Source: ABdhPJwqXkDGtvUwWGaiuBYbE5NcB774anrzQE3pwhguycGqOHsr4ssdf6RQfjcebn4wpyZvife0IA==
X-Received: by 2002:a62:3887:0:b0:3f2:6c5a:8a92 with SMTP id f129-20020a623887000000b003f26c5a8a92mr10152112pfa.8.1631523158357;
        Mon, 13 Sep 2021 01:52:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w11sm7172909pgf.5.2021.09.13.01.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 01:52:38 -0700 (PDT)
Message-ID: <613f1156.1c69fb81.ee4d9.3bdb@mx.google.com>
Date:   Mon, 13 Sep 2021 01:52:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-84-g18813fd5c498
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 105 runs,
 3 regressions (v4.9.282-84-g18813fd5c498)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 105 runs, 3 regressions (v4.9.282-84-g18813fd=
5c498)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-84-g18813fd5c498/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-84-g18813fd5c498
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18813fd5c4982b3698c9a584886bf1ce72fec596 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613edd2111f8e3e651d59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
4-g18813fd5c498/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
4-g18813fd5c498/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613edd2111f8e3e651d59=
668
        failing since 303 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613edc72518fcbb72cd5967f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
4-g18813fd5c498/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
4-g18813fd5c498/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613edc72518fcbb72cd59=
680
        failing since 303 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f0f9b158e7f64b9d5966b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
4-g18813fd5c498/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
4-g18813fd5c498/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f0f9b158e7f64b9d59=
66c
        failing since 303 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
