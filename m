Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613E02DF084
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 17:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgLSQt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 11:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgLSQt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 11:49:27 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2CAC0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 08:48:47 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id s21so3453962pfu.13
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 08:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cZ/I40sy8yIVxLC89ybvDLXUc7d2H0pBTiT9q12qwJU=;
        b=LGwnPZkynV7uiUJZ5FhGdTAg2e16XbZ6iAAY3wHGdqAdQ7HiTqLRHp23zlWhc0vCs5
         eYWAoWotDNu/u1oTpWtUMkXMO0mllokUq2qmwiLZgrQ7fzXk+wpjUJFRunbmGOnfL6i+
         pqAox/wtvIaDRN2hiUKja65OZj0bHaFb1jQ3k1a+SAxOpSp6OYgZcUGIXfe/ZTtHrXmz
         jI3JQv65VMahwXCV46LazNclEx/1jsfO7IuYAeLsK8zc3/9r22THR9jGHD+/7KaHGpae
         DbZ9yNiz0UsxVzdCCnnqCDQZfulCNnOm38fk60g1Gs0ixaOOjbNQlxSc9VXNQWcDO8o5
         dMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cZ/I40sy8yIVxLC89ybvDLXUc7d2H0pBTiT9q12qwJU=;
        b=kHfd7vCzYA9KbUlqBgBTp+WyqeMTe0WXaxoaL8bSNu6buyMjS5h4mltj8coGf5B67u
         L9zBmLYo89bjkpKVr3uWnDoyQf60G2AXq+VnozQA8nE+mLza4DPeisMC1lvxsmGFSrs6
         E0xYna2BbZI6WKsLRE2ePPsgJyg8ava3sGH+iy2d3LluHPg6qwJ8AHm8gJdnVxB5BGZN
         /CQReuVWF8Vou7AiHKRhwTtrcO/jaZp9EzKZLEOiJmLQmyVx80idP0mVxzWhdWWz0iKm
         ucQI/2FBkt1+Bes580WYlr89vwokrLiDfQmGs8QDgSe/4ON3pZadu06IzDH8G+h9d2BL
         vmYQ==
X-Gm-Message-State: AOAM531JgnU7YG1VoxATQhBTQvZjHwdKgmvfih9LoFyiwyJ+IlzkJKbL
        2n+fUljPhzj3x/x94MySbrDYPnylJX6cAA==
X-Google-Smtp-Source: ABdhPJywXp4HxfSGoidX7dWpXvBUKnUbB7P4DsfAtIbU+45qFOwLWq+MvHszukl/Zl1T+bhNNnofTQ==
X-Received: by 2002:a63:e4a:: with SMTP id 10mr8844069pgo.343.1608396526367;
        Sat, 19 Dec 2020 08:48:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w1sm11977638pfn.151.2020.12.19.08.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 08:48:45 -0800 (PST)
Message-ID: <5fde2eed.1c69fb81.d99d9.019d@mx.google.com>
Date:   Sat, 19 Dec 2020 08:48:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-25-g21c08444d8cfc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 109 runs,
 5 regressions (v4.9.248-25-g21c08444d8cfc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 109 runs, 5 regressions (v4.9.248-25-g21c0844=
4d8cfc)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-baylibre    | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.248-25-g21c08444d8cfc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-25-g21c08444d8cfc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      21c08444d8cfc4818a3a8ab8cac4c1fee49352fd =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-baylibre    | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddfc93244af4e26ec94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g21c08444d8cfc/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g21c08444d8cfc/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddfc93244af4e26ec94=
cbb
        new failure (last pass: v4.9.248-11-g2d7336c9921d) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf98d3545b826a3c94cfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g21c08444d8cfc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g21c08444d8cfc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf98d3545b826a3c94=
cfb
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf97e20d779e606c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g21c08444d8cfc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g21c08444d8cfc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf97e20d779e606c94=
cc6
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf949ba19d428e5c94d4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g21c08444d8cfc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g21c08444d8cfc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf94aba19d428e5c94=
d50
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf94dba19d428e5c94d55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g21c08444d8cfc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g21c08444d8cfc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf94dba19d428e5c94=
d56
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
