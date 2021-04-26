Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FFA36B38D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 14:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhDZMyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 08:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbhDZMyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 08:54:22 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A46C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 05:53:40 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h11so7846236pfn.0
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 05:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mrumb33BNeF65Z8bZYP6IiQtWx45LFfSgyaszbyorsQ=;
        b=Xx7QhmkAECApofmHvJRo1Oqa8wBHZ6sgo0kYJQvVst/j0y1XmJYKybKdX9ulBwK4fJ
         e8WGzdxmpSZ3SUP06QBcugkM2nJBWiKrMve1pTqdhCPeZwa6fiXR1JCtDDnih16LWn0h
         on4s9UX4StIRdcl/jFvZp3fp6+whCAHrsIaB41JTyPxVJb8XAZyjWSYoQ09LQJAiNc8I
         Rdwpn0L43oel44+iDdtxFzy5WHP+fihvMRZLjbotCsf71RKGssf5pw4cGSVHtUXsBUhQ
         2zYnYk25tthuHj+VIZe7atDKw4f0yODX0Db67bI7+lvSYr6eX1rHOlahk7EA50AyXuRv
         9LlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mrumb33BNeF65Z8bZYP6IiQtWx45LFfSgyaszbyorsQ=;
        b=fGcCSIH8X5zIL/fl24o8736rib71LWn+zzJMA4Ass5ZXLzgolpHWLotuXV+HiXj8+n
         p9gk246IjthOynQCi9T0P0Vqg0H8VVgXWc4h5TUiDECjGTnhGQfUtYFYRibmM1Wuh7Nq
         wGGIYMS4Xtc4u8YzA3dHAIgqAPJohLcj/r47M2dJ5Xfqd77SFEgkX7UGL4wxBR5A4VIb
         1gfKMqP+JhYgjyM6RqjzemPsmbQ2YXUe5qDqNaABhmcIDh67yfqrtCxIJ6JSEIPbU95r
         uFmgLsDsRWiVUJvtZ8L8vu5NuK6gWotxYjEBGlFi6EBCGIGKYP1K4eRGZ/rz/eamMLK8
         RS5g==
X-Gm-Message-State: AOAM531uwXJflrZgwUS8qRPP9YX+cV5AxMn+OjKFhhxMAsU8zCYo0m2L
        HFbQqsQTTpQueGsEY8UVtqs/K5plJJ+giExc
X-Google-Smtp-Source: ABdhPJzXUTwk6NrzjBBVfLno+Y8icIhgHPunCW3EYflZRkYuSkqRNDGYeoPOnzrMHHldbuh5afybfg==
X-Received: by 2002:a63:6a05:: with SMTP id f5mr16780873pgc.433.1619441619306;
        Mon, 26 Apr 2021 05:53:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k8sm1505417pfk.189.2021.04.26.05.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 05:53:39 -0700 (PDT)
Message-ID: <6086b7d3.1c69fb81.bf94a.2e93@mx.google.com>
Date:   Mon, 26 Apr 2021 05:53:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.267-36-g064ff8e64b6f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 98 runs,
 4 regressions (v4.9.267-36-g064ff8e64b6f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 98 runs, 4 regressions (v4.9.267-36-g064ff8e6=
4b6f)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.267-36-g064ff8e64b6f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.267-36-g064ff8e64b6f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      064ff8e64b6fc9ab2420a167d7770bc0ed2dd59f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608682a362d14d10db9b77a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-g064ff8e64b6f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-g064ff8e64b6f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608682a362d14d10db9b7=
7a1
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608682a062d14d10db9b779b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-g064ff8e64b6f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-g064ff8e64b6f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608682a062d14d10db9b7=
79c
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608682a562d14d10db9b77a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-g064ff8e64b6f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-g064ff8e64b6f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608682a562d14d10db9b7=
7a4
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6086966f2a486c58979b77b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-g064ff8e64b6f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-g064ff8e64b6f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6086966f2a486c58979b7=
7b6
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
