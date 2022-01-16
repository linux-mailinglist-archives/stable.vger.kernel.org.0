Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CC048FDE2
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 17:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiAPQc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 11:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbiAPQc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 11:32:27 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32982C06161C
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 08:32:27 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id t18so17824962plg.9
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 08:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0Au0QPLEID1wR/y7mk5s1SQN2AK3ok77NAvndt3dVQ4=;
        b=t19udNT+NnH3HSc0LI1UHMN6ZnY8MbMqimLLssKYNiwPH2ok6zJ0nAEjGAB9mRpdpO
         vHl9+9S9guGPZJLYyENMe7tBp9wznIkrk6ii6+PFlxNec/LZLXZopbfjqMhZfYs1Rr8d
         REuPYSaNbbpLuzJ7oCQank2sDDdYzegosZ7csGMY3jY4mrT6vXT/dILXj8DhPtuPAXBY
         az+tKRdpNPFmF39h1mvQsOB+XkTCZ+/YALTzx4fAFgcyVvbp9RfD40dwW/4yIHc/7teW
         lypATwifhlkcH6Xe+DGRQVvC9/qIysWKeKxzocdfboJAIEVp56VuWqENjFk17oqmcBha
         zLpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0Au0QPLEID1wR/y7mk5s1SQN2AK3ok77NAvndt3dVQ4=;
        b=Yu7EUXVTMq+9V4KrXQ0Xyx3mRr73PbZiUtfDELuWxfWTQVkvY78KxCT4Ca1d6P6hs/
         dBfhG+cUXV7R7C8Y0tQyRQ4DF+ZsfK95XA4+xCQT+XFPSMNsW9JncN5mv7oH8gJ23m0G
         G1oFTLGa5vTw5nggVi3wYjJUWRnjIZ3hmhkLfPQfH9mut7z2yqTLznPziCSM7XaSvImD
         lYdy7xeGQXWdUYYaOazM1nJNivNJG8IdmnuVmpiH1PptGJG30wC5hsxQ2Mz0fv8tu2L9
         3nTbOsT9eIT4bEpKSsH6OHNNSshY33Gw+iyPQXIQNgLW1yBYiV+uxs0zRRIq4W9i0sUK
         Lcrw==
X-Gm-Message-State: AOAM530gNh/VIbNPxrR7ySsoQPrLhMOeHRtQUSim1yW/ExiOUyjIWsRV
        kLmNTNyDKrD8IMSXsuWmHdQ4thFdUO27RQVm
X-Google-Smtp-Source: ABdhPJynf5/cIw+4uNioTGyhirH5Vn+tKiK8zd6QSYRUoVBq8a/S5p8fAQz9rWw3kZv724ohiS91eA==
X-Received: by 2002:a17:90a:bb05:: with SMTP id u5mr30167158pjr.64.1642350746597;
        Sun, 16 Jan 2022 08:32:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nl17sm8525585pjb.42.2022.01.16.08.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 08:32:26 -0800 (PST)
Message-ID: <61e4489a.1c69fb81.61177.6a9c@mx.google.com>
Date:   Sun, 16 Jan 2022 08:32:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 210 runs, 1 regressions (v4.19.225)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 210 runs, 1 regressions (v4.19.225)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.225/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.225
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e0cdb245b7c83cfa2939071bf0cb7a2ecd31abe =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ddfae688ef9e681def6766

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ddfae688ef9e6=
81def6769
        failing since 8 days (last pass: v4.19.223, first fail: v4.19.223-2=
8-g8a19682a2687)
        2 lines

    2022-01-16T12:47:02.835639  <8>[   21.239776] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-16T12:47:02.880405  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2022-01-16T12:47:02.889417  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-16T12:47:02.903223  <8>[   21.310089] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
