Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400FF2DC3CF
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 17:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgLPQOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 11:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgLPQOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 11:14:20 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56852C061794
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 08:13:40 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s2so13186380plr.9
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 08:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pIZgZL2L9kzsv+qkBSN8r0YKvFNJvWLpFU6jkX94Xcg=;
        b=EsSuCPVDZ4SJofu+DrOCIiw48NhsnsOzj00Gun+7QsqUXejaOLdGE4uiME4ye+Cl8s
         WqfXjFvTmgxK1n9DukIZtKFogKfwfqGCShucG01besHhDc9Hvx4naUmR4shXN9jwH9Mk
         bIbU1YJW4GscbB7cW2WnSc/AYGLjRU/FNa1n5bUZWFU7fkdyh1AEbdDNbmg9Dd01Tik1
         NFwWSW2ScXIcc72T84Efdn3U9n6MK/pX0KX/QZLcAj4WT9RdYHCpKvC3Igtr7hXc8/wF
         Aixf3+id8KWoI+OLV+wq520yyfH3TvB/pynq6vsH6NqHFV9DWuFqJQLEVWnKsiB4OqfT
         FnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pIZgZL2L9kzsv+qkBSN8r0YKvFNJvWLpFU6jkX94Xcg=;
        b=myIzl96D1O1BXnGbC97jR9qXQwKTzdbyxHCCnIB/eJXE0sbGL4Ug/7M22RkK6rZ707
         k/plV4O/bs8IQ4Fr/js/7WB8KXnwEABzVzxd09Td1bxj0B48lI89HNllEfdovhnYfF3G
         KLB6w3sLXwp35OU+WI3dFtp9YkpUjHSsYmQMjC+9crW5WJ6RRdW2WI7q6lSP5o6XNyZ/
         CtXL7GlzWTBVbeSCzQMDaqWGIwvMgzGPXvvLkgYBbbkspMc5UH5cHlskoUqjpGf6mK+f
         hXjaDwmGIgU/t0IYTqsF0xusPYBQKHgHVHkNa6cUVwd867c7cPu5y0XUjpFNI29T0VIE
         lY0w==
X-Gm-Message-State: AOAM531CQ0X8KiBgeuyhqo9fLbUtyqnZViTdyxMdZg6DwZYEdYxCnhKW
        zvixqr487KPqXsz+xJEmR7rQcPBFrT4lrg==
X-Google-Smtp-Source: ABdhPJy/pnwWfsLClCB+zSd6lIr+KJsxA5tdckpifeayMtviDn6thwm1m5EOjvd1G0LJjZdkhICpmg==
X-Received: by 2002:a17:902:7689:b029:da:52:4586 with SMTP id m9-20020a1709027689b02900da00524586mr31792134pll.47.1608135219544;
        Wed, 16 Dec 2020 08:13:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s7sm2340031pju.37.2020.12.16.08.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:13:38 -0800 (PST)
Message-ID: <5fda3232.1c69fb81.c1fbe.50a6@mx.google.com>
Date:   Wed, 16 Dec 2020 08:13:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-11-g0b04c41ccb63
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 92 runs,
 3 regressions (v4.9.248-11-g0b04c41ccb63)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 92 runs, 3 regressions (v4.9.248-11-g0b04c41c=
cb63)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.248-11-g0b04c41ccb63/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-11-g0b04c41ccb63
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0b04c41ccb630da2450d554c52a14c7ebaa428d9 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd9ff630c1fe4f476c94cbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g0b04c41ccb63/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g0b04c41ccb63/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd9ff630c1fe4f476c94=
cbc
        failing since 32 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd9ff6b0c1fe4f476c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g0b04c41ccb63/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g0b04c41ccb63/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd9ff6b0c1fe4f476c94=
cc1
        failing since 32 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda1961813cbf60afc94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g0b04c41ccb63/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g0b04c41ccb63/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda1961813cbf60afc94=
cca
        failing since 32 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
