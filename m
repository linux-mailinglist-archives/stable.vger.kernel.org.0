Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E613BC35D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 22:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhGEUZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 16:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhGEUZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 16:25:32 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579E6C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 13:22:54 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cs1-20020a17090af501b0290170856e1a8aso232728pjb.3
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 13:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2lfjGWb4fVUJTZFb2S7FYRHn3ftxIrvsCzkcgrRyix4=;
        b=K2P3BIYD/B6RmqScfYGc5d9xHNCxGOTgpFE6MjKrIflz66o9RuQVMOA5wquKbIDAjI
         TxeThzesOF4aW1WGNib7+urYXTZsarm8M9ammbPqBS2Lx/DfUwOTxbMQNjKqZtv38s1q
         R0t+Ou5LN+o4TTwe7sU2aRfxqdGlAF7T5irG2U7PCegOxbxVWFLOyIDQ8M3DhDiS5PzX
         4Cwx1rMhM6eawiaYdN4X3p5uqMAct224oTrzbXgUL+UF7A2z/HURh9Ff/pNpiFcsdcEA
         M3G2+LGofplQULK5OUWhEWAzSv8vQ2Le9TR/7jLQaggEpwDeoL2k2+l6uicB6OFenCtQ
         BsXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2lfjGWb4fVUJTZFb2S7FYRHn3ftxIrvsCzkcgrRyix4=;
        b=N/BYu1TNvNbQaknmt5snm8GETjy5OhQHuoWUOnRYVtplBCeaxYgs9+/adyEHVTnCi4
         pbZtWH7xk5zKk89utCuGTBWToKzJ6TDMaiROX3JDt0JjapcBBHnVCIrRDjZlHk6Hnek9
         Rz1fHrjLCs0JhqkWD0BpwKKuboPnCV2ygxsHLI0p5T+2u0DY3HCjGwIpMBLIzb5RyG31
         8fSNbNc7OAbFylSsXEUkW9+c1KdAehvFl3owvv6207+C+M7soONFZcDmSVnTasm08y6q
         Lp5gPV8PJ4toPmuuPy+o2wcirqSR/r0h8uyRZwRU6CGv2NLkUd2nzI5pXXRn1yStKGJm
         qo2A==
X-Gm-Message-State: AOAM533rYLau+73VN+hdWG0Vg86ILr0yACDnYyRytHQisSoLOro59Vhc
        jRlyOIcGUdQA8Ti4LoqyGciYm+PrwxV1y5Dv
X-Google-Smtp-Source: ABdhPJyTfNEEAFBDeg8hRSE5APhPU22UTWvqYaj++yN0HFKvBEm3VOLiQ5x3QbpV+8aL8sqHr1B74Q==
X-Received: by 2002:a17:90a:bd06:: with SMTP id y6mr17180747pjr.6.1625516573586;
        Mon, 05 Jul 2021 13:22:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x19sm5644489pfa.104.2021.07.05.13.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 13:22:53 -0700 (PDT)
Message-ID: <60e36a1d.1c69fb81.ca1d9.f5c0@mx.google.com>
Date:   Mon, 05 Jul 2021 13:22:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.47-6-g209c9d1f6abb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 178 runs,
 2 regressions (v5.10.47-6-g209c9d1f6abb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 178 runs, 2 regressions (v5.10.47-6-g209c9d1=
f6abb)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig |=
 1          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig         |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.47-6-g209c9d1f6abb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.47-6-g209c9d1f6abb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      209c9d1f6abb00cce11edcc0e57dc9cbbce269dd =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60e336e060d0185bf0117988

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
6-g209c9d1f6abb/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
6-g209c9d1f6abb/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e336e060d0185bf0117=
989
        new failure (last pass: v5.10.47-6-gbe997714814b) =

 =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig         |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60e3485faa316ea4d6117988

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
6-g209c9d1f6abb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
6-g209c9d1f6abb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e3485faa316ea4d6117=
989
        failing since 4 days (last pass: v5.10.46-100-gce5b41f85637, first =
fail: v5.10.46-100-g3b96099161c8b) =

 =20
