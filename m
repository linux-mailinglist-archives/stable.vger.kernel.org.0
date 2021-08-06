Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2573E2BDC
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 15:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244024AbhHFNqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 09:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344426AbhHFNqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 09:46:34 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DF6C061798
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 06:46:18 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so13934194pjn.4
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 06:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S++IQ4Gk97al3+J1jFylgjgbojebLwc5wo/uWx9cKLk=;
        b=bharnP0rZIKUNDMwgDDHYYlO9Zd2vepWzRs11oful2dNsJ7sy1X6efKS8eRrbRb45p
         bMJTz6M2ZSiVhHvVJURlzQoQe7/2PxstslIi9/Rhrxnm+3WbaugXwLHl4e6JsBUgT6wj
         zEIvZPGTLVKoluYprYLGtlvlbJ0OvFk9+JXHWF3a7i/tOUXyC6xjhVOjSztN2kCfjoac
         jcDtyCjBoEEhQHt/fXJlmw2FaNtw1b68dNwVIVzj509xuR5iBl1kZz59JSDWbQnppGy/
         Ev+8GxGiduJU5P5V8nTDFGa/HnEsh8moG8MktiuhZVjzAnAj9f/5kFZLzFxgKImc9OZa
         JEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S++IQ4Gk97al3+J1jFylgjgbojebLwc5wo/uWx9cKLk=;
        b=BS+dguzaSKl2HkhKoXUYhg0csC9zyipG/njV708i2doD+Lkv3CplpIfJE36c9jypH/
         CaYmXQhDdopMjWh4sLgJkGKJPm0Jpl2P95nIKyTP4Hu+6mnv6/w8kFe+ZJ9ZH8ZlI4eN
         9CW605qtjLuZKUeFz8ng8Ka8EEA220khoRbnzh+c0L7KfnfaL8avLCCeFnqwqkuM7z1t
         FoA0ejswqtDRBvcJy4ldI45ja9x1GfWfuiAL2XbSoCs6WzgdeYnt2K9/o0wZRvclkKvV
         ULk8SZRc9pfJR1fkLyer8Jw98Oxo7NtvRfToMPvl2snG7P39l0PKYxQnaNlDo/s8kieE
         UAfA==
X-Gm-Message-State: AOAM533MUbEmszvU3HvCFWl4H1ub8BZjDOufsJinZJO79xyKTlOop1PV
        +hoxyomg5cp4w7KyrMMtPrvdv/FedcXOQg==
X-Google-Smtp-Source: ABdhPJwe4ePlJueRxONfgFxjB7nf+lJh8U0ysKOmAlSnJ7PAKlVYJCMzgqe0m8vjjyQSFKvcpsIEKQ==
X-Received: by 2002:a17:903:32d1:b029:12c:d4c6:6d2c with SMTP id i17-20020a17090332d1b029012cd4c66d2cmr8778244plr.28.1628257577445;
        Fri, 06 Aug 2021 06:46:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5sm11034398pff.97.2021.08.06.06.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 06:46:17 -0700 (PDT)
Message-ID: <610d3d29.1c69fb81.a8d64.07b9@mx.google.com>
Date:   Fri, 06 Aug 2021 06:46:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.201-16-g3a94daf1b735
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 103 runs,
 2 regressions (v4.19.201-16-g3a94daf1b735)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 103 runs, 2 regressions (v4.19.201-16-g3a94d=
af1b735)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.201-16-g3a94daf1b735/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.201-16-g3a94daf1b735
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a94daf1b735d03f517d49c055e7f2737cef87cc =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610d0c5269b4d68905b13680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-g3a94daf1b735/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-g3a94daf1b735/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d0c5269b4d68905b13=
681
        failing since 265 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610d060d826ca645dcb1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-g3a94daf1b735/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-g3a94daf1b735/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d060d826ca645dcb13=
67b
        failing since 265 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
