Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0861731ADDB
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 21:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBMUDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 15:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhBMUDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Feb 2021 15:03:33 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D90BC061574
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 12:02:53 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id k13so1717095pfh.13
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 12:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CIHIDdxLCf4rPfxuFC88Sm23P2UwgCP3jV/9QpWUNNk=;
        b=Lt8pOXJwP1T2PMgyhYybte+sU4nQIXOeiQe2taq34VUePSgPJsP69IvyJWl8qBa7ps
         4S1U1tX2Q8jicVMB9Vem/Ycf1ihrfqvXJhXZ1m65UJjvUVu6exzLPt5JJVQlAPKTd/7i
         Ftkp5KUoXHsIR/Pj3rqr96aRFwiuNqUE4Jo81zapTr/nErMs31Ghhef+EEPnP8PqFUaq
         i434jl9ScPqyhmLrBDVtaJv+stmlZEd0I/Zi6by7RP5pX6a8RMZEYQ8EBIH+ktjSwYQF
         QFcRCjnGlX+lFa76S3gBbZvW98tiWwu2EDcC2RMOQvB2skrF8B0J8rP9CHk7oJyzXIU3
         DfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CIHIDdxLCf4rPfxuFC88Sm23P2UwgCP3jV/9QpWUNNk=;
        b=PZBiC/uMlgI/BdCO9fTYuiw3aPTIw7qhabdyvD73EHfPc2152FRkzYeQNHPMLKZid0
         iM3Fv3OIWGbIbTTHTOrwZXALWTfFiz3LUzL936tpHxivFq/R1HfxIxH9ykKfunOrg9do
         0r16zis08T0nrqj/0Q/BfXUbrUGBBDDx/KVcPZ/dLNozF0xbspYR75PK3PTsvlQhjTqS
         RorkXBRco5xb8rw4xx4jELHBVbalNqG9i9vcbgHe51Xtj/SmuqwfWFZlgIt78CmRcJFx
         lAA2eX9T4a88wOKxd9OWuPJkGZ2rM09EGb9FjIrUDbfy88Q8TwCtAaB/DRhXv3M4UhCr
         RjhQ==
X-Gm-Message-State: AOAM532nNcUTtg9655hEp1N7Yd+Q04Svt7cvC0hfHcRTkfDJRA4KP0LP
        Px1HZZHQBsICK5pxDBOQVk/TBxCcShJPEQ==
X-Google-Smtp-Source: ABdhPJw1VVHDSYhAyhvryow479XHdoqrSaEmBWTg7dR+ac3A0PSRzwGXOVmlJdEwThPL2T3TcZQYAA==
X-Received: by 2002:a63:1826:: with SMTP id y38mr8621536pgl.252.1613246572634;
        Sat, 13 Feb 2021 12:02:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r4sm12808477pgp.16.2021.02.13.12.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:02:52 -0800 (PST)
Message-ID: <6028306c.1c69fb81.70f57.c663@mx.google.com>
Date:   Sat, 13 Feb 2021 12:02:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257-18-gc47680077630
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 39 runs,
 1 regressions (v4.9.257-18-gc47680077630)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 39 runs, 1 regressions (v4.9.257-18-gc4768007=
7630)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-18-gc47680077630/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-18-gc47680077630
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4768007763064ce807e7cf76a7e91e7d4c4034d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6027f6f09a95d496513abe6e

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-1=
8-gc47680077630/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-1=
8-gc47680077630/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6027f6f09a95d49=
6513abe75
        failing since 1 day (last pass: v4.9.257-12-g43f72a47dfce5, first f=
ail: v4.9.257-18-g5fd67f7a65f98)
        2 lines

    2021-02-13 15:57:32.749000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/120
    2021-02-13 15:57:32.759000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-13 15:57:32.775000+00:00  [   20.504119] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
