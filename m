Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9692ED6C3
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 19:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbhAGSfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 13:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbhAGSfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 13:35:46 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248F9C0612F5
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 10:35:06 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y8so3991585plp.8
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 10:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XQRNOt8GJX8E1yeIsI5scIFtdf71D1HWkXUZYA1vbvY=;
        b=gQk01p9AzpCsqt0NL4YazyDPP5RpxwteImBudU5dkiIeszFi7jXBnesqtQyX+UeR9g
         1j1pcD9zKqgIsPnbnr47gP+CD2wyGWYMVSvfIRLE/Tj3crOTCRimOqP+YTtB7B2tXkzU
         0hNM+uNDyS/2VYV5ivg3DxMb5zZaR+4yXza3UMbIJa2UYUhwUcjpkO08Qs/VCnfWZgzK
         swEFPnjkBMSFhVPtE//STn/QW6jLoxRYKHDXVVl7OPvQOXLpTYLbQuOCnSRBXE/2E5ZO
         ps6A8YiTVVUFe9yi5lMrzK5ib9CzaTPqfeYF+c+qyMM9nI96VyM8gvrDQ8B02et1Cfv4
         dwkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XQRNOt8GJX8E1yeIsI5scIFtdf71D1HWkXUZYA1vbvY=;
        b=ja3JpQKE/L/6eB8F8NdgIscoCagG2f7XA+0PzSrhrqOCqpVNWuLXMKr6GPRf/w1veH
         GOwA43ljGUlgsnxNft60XjkXpr9b+3Dmdz6talkouWyM1Tw2QiuNT8Z3ELMg0TAu9J4A
         gZ6WxYskDZdu2DhcmdL1+TD/xzmWmXjkhwYYDOvgNM6xqVEHEamJzOoN99VRBiQV17iW
         hmZyaavgEIJZdNTPu25AO2YLv/NyuUmN6pwLeIsuoP42n1Oop+fIW8+2u0nI/ok3JtEU
         YJG5a2a3cU8PCIaapL9nXN43VYXJD1bBJg6mRg2OTmmVJlWWGYD3XCstK/Bn+2QR+211
         KoGQ==
X-Gm-Message-State: AOAM530+q0Mlk6T10UM1T1CoHZwbWWByV/kNxJKLcQ8zvri4M6mRiUXC
        tpvbwHMmvsRCXfbtjhB1eAY7WRaqWqpcuA==
X-Google-Smtp-Source: ABdhPJzC6ixXzpKMzxz6jxgzLmsT34eVxq11X+6Sqs9sUMpD+cbEwuPP/96q14KJNzAGKQpapIubSg==
X-Received: by 2002:a17:90b:1983:: with SMTP id mv3mr10808197pjb.211.1610044505290;
        Thu, 07 Jan 2021 10:35:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11sm6422241pfj.191.2021.01.07.10.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 10:35:04 -0800 (PST)
Message-ID: <5ff75458.1c69fb81.88478.f19a@mx.google.com>
Date:   Thu, 07 Jan 2021 10:35:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.249-33-ge127e4c3999d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 4 regressions (v4.9.249-33-ge127e4c3999d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 4 regressions (v4.9.249-33-ge127e4c=
3999d)

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
el/v4.9.249-33-ge127e4c3999d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.249-33-ge127e4c3999d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e127e4c3999d23d964d268007e668b520d398565 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff720f60d8c6b9457c94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
3-ge127e4c3999d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
3-ge127e4c3999d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff720f60d8c6b9457c94=
cc5
        failing since 54 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff720fc4d48536fa9c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
3-ge127e4c3999d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
3-ge127e4c3999d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff720fc4d48536fa9c94=
cc3
        failing since 54 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff720fc0d8c6b9457c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
3-ge127e4c3999d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
3-ge127e4c3999d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff720fc0d8c6b9457c94=
cc9
        failing since 54 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff720a39cd14edd94c94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
3-ge127e4c3999d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
3-ge127e4c3999d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff720a39cd14edd94c94=
cd0
        failing since 54 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
