Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C064413C1
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 07:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhKAGcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 02:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhKAGcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 02:32:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D30BC061714
        for <stable@vger.kernel.org>; Sun, 31 Oct 2021 23:29:47 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso717342pjb.0
        for <stable@vger.kernel.org>; Sun, 31 Oct 2021 23:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wWoucIod8+nxf8ZWyMKwYgQltnn8EWKBQR0p5RBa2AU=;
        b=JglOK/Hw+Y7aiRLj0V2mZY/3Y6kk8+MfnTHNgDo7EL8JWsGhWm9MTWEBQjZdkAYRx5
         JGDup02GFOuNB141zh3PeTyKnSOkUJ8ZRLi/j05jTQLnREEt1mFd1PytRfCpL855lv0V
         z4KuzTprMzBuI9JVQ1c+pqlQieQVzqufkPm4Jw6fpeNt6mdHxQpcXnGOpAk2CaA3pOHP
         0fMA/A64sKcXsXMEiuxQF0onOm4XveGL3R7X+NW483qzKd9bIy2CuXTEXQw1EHfavf6s
         rK+GqnIJ3DRlBiKtPPWukCvFqUkFbrskPr9r7RZ/DXRn3WcglKa1ALxK0v0KHlfgfxJt
         YzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wWoucIod8+nxf8ZWyMKwYgQltnn8EWKBQR0p5RBa2AU=;
        b=zK9x/JooC+G+8o3BN5y289mMj2+pC4ylb0RoxT501EpGvJhCJJGtt98nJO2RZ3SkJO
         G7draqv4+WzErFBGICB/sPhfySKl37ryvh8bxjrxxquvT43ClLr0F2/bIqOeFmE03fg8
         miJ6GRngwr51bUK49lpGLH/RFkNu31lRjlfjWYhbrURNCSp97/DjGsE1FJ2f1gzH+GE2
         2J6CiXoy1wh7K/sAavj1ij2dS8Cy27CCGBF1bR8VdyhHGuCs1GajE7By6bMIsDYQ9ctp
         hz3xKtyOdL+wi7CAidHqNPXcEZae7u96Kf9aE58cpk3sK792oD/C4lBQApX5Stz5YhU+
         rZyw==
X-Gm-Message-State: AOAM531i0Xq5cM+N7NVeDg3KBS2RjMJGgUcA39sxr72UMaXxdadmFSOo
        w0a5N59Rk0XVIeJTV3WIwOwb5v95Z/zT6eJQ
X-Google-Smtp-Source: ABdhPJzjjGlp5CnRCTv3zmKYTQf4RRl8838JUv53cgWRMNz6TvBWTS1DSz2/XFVGawHKGOCOZa4f4Q==
X-Received: by 2002:a17:90a:191a:: with SMTP id 26mr36122955pjg.118.1635748186745;
        Sun, 31 Oct 2021 23:29:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n11sm11846952pgm.74.2021.10.31.23.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:29:46 -0700 (PDT)
Message-ID: <617f895a.1c69fb81.975c1.1a79@mx.google.com>
Date:   Sun, 31 Oct 2021 23:29:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.214-35-gfaa5b09f8790
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 79 runs,
 1 regressions (v4.19.214-35-gfaa5b09f8790)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 79 runs, 1 regressions (v4.19.214-35-gfaa5b0=
9f8790)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.214-35-gfaa5b09f8790/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.214-35-gfaa5b09f8790
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      faa5b09f87909e6c1c361bbb605c57d63ba50148 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617f57e0ec5e66b8aa33593d

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.214=
-35-gfaa5b09f8790/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.214=
-35-gfaa5b09f8790/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617f57e0ec5e66b=
8aa335940
        failing since 1 day (last pass: v4.19.214-30-gc41b589f35b5, first f=
ail: v4.19.214-35-g60f0264e8c0f)
        2 lines

    2021-11-01T02:58:17.224614  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-11-01T02:58:17.234798  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-01T02:58:17.257988  <8>[   21.084320] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
