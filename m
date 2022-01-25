Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC2A49AB4F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390132AbiAYErn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 23:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3412735AbiAYElh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 23:41:37 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5A7C02982E
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 19:18:49 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so1317453pjb.1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 19:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hSjKOJjx4EnpKwmhtw+q7BjCwi5CilW2PFg943+Mqg4=;
        b=su4IrDUgVh2Lb79fY6Uro3kBUMF2oABZ0PSf/3PLggq2q/0D6n//rX86UHGJPGhZn1
         TKNZ6QOkSX+CjH44yRIl55safYMGfilO9f/VSdOF77s4ebbUy6iGUpfxxwxK4DDIJIzI
         G5Q7rfccyuXp2X0pDw2hr395vjsgwMU/Wbw5BLRU5ScNpVSnP/Em4G/J6IW2w4w3OYuv
         SyBlsunHO8my68Zl1Yzw47V7gr1ERiH7dG1faa/JbeWFhxcVtataAIJWJbEpvpjq/8kF
         8yx1B41t2SRXmRZycrfN/bCF+1iQbMQBYm+X7MzhfZKOCPzZQpF3/OMN4ay3BeesPM80
         xOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hSjKOJjx4EnpKwmhtw+q7BjCwi5CilW2PFg943+Mqg4=;
        b=CoF/hOFY1Wj4frmvKT6DukA0luDLBJ7SKs/xGVhjcNh8zcnuiwN9xjisNauoMl+96n
         Wjb6T2f/XZShK0P1RxxunRbTNYPMwn/zT8SOlBFfm6FgETbCpglY8rMhTsm+XGEahdv9
         SRfveFZpETvq/LXHrqIh2C5Rk5mG5UkqN/z+DMLuZ8vdnYX0B1cSSXK7xD2G/JPSkCe7
         DYnnjbSnks4XCfw9hxTvI2i12ZPYQgPRMnUmFMm8x0CbC1DLmf6+NRj5d2Q/gZ/W/6eE
         x8IXuo+rlNbDCsxq2MeP8TgqZ6A18cYiUAztaXx/F+DSsdzII/U2fENZ1eSVQ0uv5JbB
         SD8g==
X-Gm-Message-State: AOAM530a7JflzDwkQBVNNniWyJda9AX628CWO0E6YZCe2tXRBL4ljDwp
        Bx4K5UAVNS7H7Awno7ePwKEVtk6Tpk8Fhj61
X-Google-Smtp-Source: ABdhPJzKL6rDSYtpXEI6fHM2k8EhxKVfDM1WQfTzFUgzWa7KuKyvFn7Fzd5vNCebXXLlTcFY2huUpQ==
X-Received: by 2002:a17:90a:5e0d:: with SMTP id w13mr1407650pjf.235.1643080728973;
        Mon, 24 Jan 2022 19:18:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13sm16741252pfm.161.2022.01.24.19.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 19:18:48 -0800 (PST)
Message-ID: <61ef6c18.1c69fb81.60688.f160@mx.google.com>
Date:   Mon, 24 Jan 2022 19:18:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-158-g12144c253dc9
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 113 runs,
 1 regressions (v4.9.297-158-g12144c253dc9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 113 runs, 1 regressions (v4.9.297-158-g1214=
4c253dc9)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.297-158-g12144c253dc9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.297-158-g12144c253dc9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      12144c253dc9bce0a1f5fbc0969ffab0ad8b5a0f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ef32d44332f7ff31abbd31

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
-158-g12144c253dc9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
-158-g12144c253dc9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ef32d44332f7f=
f31abbd37
        failing since 21 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-01-24T23:14:11.210021  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2022-01-24T23:14:11.219640  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-24T23:14:11.236114  [   20.389923] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
