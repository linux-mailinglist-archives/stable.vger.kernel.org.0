Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64A42B31A7
	for <lists+stable@lfdr.de>; Sun, 15 Nov 2020 01:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgKOAlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 19:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKOAlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 19:41:09 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C9DC0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 16:41:09 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id t21so3500598pgl.3
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 16:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h00FxrEIMciNpY+mVLfZA9FVWHq92d7sNg3JZYLaN7k=;
        b=AysggGzgzQixwqvjzprMjVGU2PdcRTa1BQdWBRfnNbc0+fsxAd3TQ8PzVuys0wwMX2
         Jy3mD7U66KpduTM3wMppKncQodHLinytTKEqLpyp8urWUBdeM9+E/hAptFUwxO1U94Ib
         sC0DahUjmHRPoVJHtHueROVI/v9DCjR/C27JLxwc+l0nXrUEjdhyiDldIR13gTOX6K1O
         at+pAYZ2uY23IfEXoO0c9rrTvX8u4cXyYmpXqmmSzG/L3xeuAJbF8B8y4Gh61AvssZh4
         Ydfv76u9B+84veUvz/m19W0/dCjSrBlfIp800iwOOAml9m+xX3xokknnt6G0L4dVH47F
         +Rmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h00FxrEIMciNpY+mVLfZA9FVWHq92d7sNg3JZYLaN7k=;
        b=K3RG5qshaTR6TsuKToBR2ImhzcpF+fgHt7dNpeQoTuZwpezUJnmUrUgxnxSualQf5+
         N9TPUZdw+6vHS6kUsYqC4o6wNOeimNpX8tdSOU2kp+GZQwXPX4MU4yZZk6d7CUY5X+88
         Fja+QyGDfgj4qhjNLEI3YncEV2aaLMOL9fi+cqlgdOI2vO8DAglkWl8MYraFaROuZSH3
         BfQnZWb4eaUFGidOzug2xl5aF+5AaWwT2+vPVL0osZAI8eGXKdPm9l3dS3KbwCDzmZ80
         9dcsLd/RbIQJNt2OBF2QBrN5EOKwetF+96JUFwV7/K8s/IHBvnAnlkZHc3io8F72gErV
         IY5w==
X-Gm-Message-State: AOAM533F34yGCo27r1vJMjGSiH4PllcWlY4DxQAGZU9gtUwQLew+eD1J
        YQwM654nJeaUeyCFjsC8Jojt80V67AQXkA==
X-Google-Smtp-Source: ABdhPJx4CtqnwMkvnjvInFTGHq/N1muU+StVnLiMeW/e/P8a04QHLg61U5l9iXbP5PHUlsjKej9NJg==
X-Received: by 2002:a62:924e:0:b029:18b:c60a:aaed with SMTP id o75-20020a62924e0000b029018bc60aaaedmr8424692pfd.52.1605400868630;
        Sat, 14 Nov 2020 16:41:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a3sm13740272pfo.46.2020.11.14.16.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 16:41:07 -0800 (PST)
Message-ID: <5fb07923.1c69fb81.4307.dba2@mx.google.com>
Date:   Sat, 14 Nov 2020 16:41:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.206-22-g2ec7a9bf443b0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 118 runs,
 1 regressions (v4.14.206-22-g2ec7a9bf443b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 118 runs, 1 regressions (v4.14.206-22-g2ec7a=
9bf443b0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.206-22-g2ec7a9bf443b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.206-22-g2ec7a9bf443b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ec7a9bf443b058eace68b527caa1ac691a8ac7d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fb0385caa321c3ff079b8a1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g2ec7a9bf443b0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-22-g2ec7a9bf443b0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb0385caa321c3=
ff079b8a8
        failing since 1 day (last pass: v4.14.206-21-g787a7a3ca16c, first f=
ail: v4.14.206-22-ga949bf40fb01)
        2 lines =

 =20
