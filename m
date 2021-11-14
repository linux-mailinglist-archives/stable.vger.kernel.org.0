Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FB144F9EA
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 19:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhKNSXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 13:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKNSXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Nov 2021 13:23:02 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6665BC061746
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 10:20:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so11144321pju.3
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 10:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7H+xuxHvVF0caC5OD/Ni2J+pndHYpwI+BuhYS6RRntA=;
        b=tf+wvEmrsA9V1z0Qt5suMAZRKn3ePks5bIJEsYLiJECCEPIg4lNOpTbqjC+VzU6FD3
         W0RyXlIQencT1YkaLrH2MCCO4A4P3GtZqB3apbSI6dn+IPyOlIqIFuA5HU7MEydBlJE7
         du6/icpsNtfwqalhvgpeYVtEXXq9baw483HHv98z2zxlDE/Ho0raIJ7vs0GjDJEsUYOU
         0HPvP9LLHI+eU5y/zWQ9vywWcpP55OHh3HcuQ8CDDRlVmUMxC78ISP9SUrCbZShjnA4G
         Od9Ss5NyFP90hZf+JWRqm9erS0ARYYGFua19UUqulWAGBs0/20aKVXQ2VMY8zS2FX1LJ
         KGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7H+xuxHvVF0caC5OD/Ni2J+pndHYpwI+BuhYS6RRntA=;
        b=VYbxd5gyim09LjRXLHb9mm23P4w1koj8RrqQ48vbqFQNd5tgxf/xrRgqtM3zjDysMo
         JnZdmOz+ACTtMWbgmN+W0axvnmJ0R51T1UB47gJ5IU99bxi5+CwWHWBqselUAIeEOrbk
         awOI+D6r/hVnOp7lZiL+gGH5j2McE8QYWSv26QD+3ITBEojiWcUd3ob2hUMyXt/6VNsc
         zBgEREyIIJf0PPTLgeojy4u4L6q6QGktvydBChDC6IMzqf5mkZLf7YQueI4tlKu+SDWg
         qRdgjt55ejz2pNG6WK69XUBkq736zM8rwgrCmYZruSf+kPlVKfl64Ztsv3Oe6XI/7QIS
         f09w==
X-Gm-Message-State: AOAM532sEZa54oCciMnfkQM4LbqxjCTZLxvSM72gJU4lD2dnlDnaUFi9
        MHCnYGt0eKlJgDZgCwV102Fi2ngECbY7bcAK
X-Google-Smtp-Source: ABdhPJzN94xilCbuCbP67p0u87AJimzmfRuxVSS/fWsBNXvM+T2pZkYG9frCnEWUOKUUMfMnnn6XUA==
X-Received: by 2002:a17:903:246:b0:143:c007:7d41 with SMTP id j6-20020a170903024600b00143c0077d41mr8542045plh.59.1636914001767;
        Sun, 14 Nov 2021 10:20:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b28sm9405545pgn.67.2021.11.14.10.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 10:20:01 -0800 (PST)
Message-ID: <61915351.1c69fb81.6d84d.b158@mx.google.com>
Date:   Sun, 14 Nov 2021 10:20:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-48-g92f20f391c5f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 115 runs,
 1 regressions (v4.9.290-48-g92f20f391c5f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 115 runs, 1 regressions (v4.9.290-48-g92f20f3=
91c5f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-48-g92f20f391c5f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-48-g92f20f391c5f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      92f20f391c5f952301ffc9a20ec9a5174632bb6e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619117a39013e5c0dd3358df

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-4=
8-g92f20f391c5f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-4=
8-g92f20f391c5f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619117a39013e5c=
0dd3358e2
        new failure (last pass: v4.9.290-46-g1993e44ad53b)
        2 lines

    2021-11-14T14:05:06.607627  [   20.564941] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-14T14:05:06.658262  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-11-14T14:05:06.667263  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-14T14:05:06.687581  [   20.645599] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
