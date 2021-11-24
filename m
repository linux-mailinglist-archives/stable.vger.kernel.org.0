Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858AF45C7A5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345011AbhKXOnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347625AbhKXOmz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 09:42:55 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19CEC04FDE7
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 05:55:09 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id p17so2219666pgj.2
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 05:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nn5aSHPVY/ui0MvElDAmWnmam1AlynMXPORt2z1IWEg=;
        b=t3xyj6bc/gpt11Dyx7nbjvJyAtSt6ZrQYyB0Su3S6dgEtRpuBlx30Khq3l1tq1ihaM
         Ycw2CEBvsNCyOJEPR8OvY8xwsXhN4AVUPPJ2Fp+V8C8LbrNwsFkE89JQZNiiNTr192T2
         IitFkg171ZrBe+13Fo/Fl6NQ6zm9UIKT2gFIXt/8Ez67Z2mejGCLHldT+8qW6mM/4YdU
         hSJy8VWr3DCLriIE5+iwZBNwwDb1UcHqquZw0KgzFcoinFDQu9L+dpeFLwpAK7Q20m25
         h3qZZcn5GbJ0XUTsQJ4Pq3HB1x/LfpxQDjEt3PROtfaVEy2jpz+ghKSqfKMilC5hvkzS
         CHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nn5aSHPVY/ui0MvElDAmWnmam1AlynMXPORt2z1IWEg=;
        b=jU3ENLiKm1r8n9hys3zq+oB/QmyMLSzX7Rx4XvvQuPKsPA8gIGze03d6k0kT8I2Jfi
         OuT4Cti0EzeL8D5pBnM/M7H8KH9G0AWrcIdmRk5/cVY6AXtPMfuCgkkqxAHJai9G2csP
         f9FIwA1Nz0K/Rrljen6JDUAUhSmp6IVn1GaFsQXnaCIKjzKrawT6Rs8UP+EIfgbvaMNK
         MpWrAVT1m4B5pWJcTBNPJD0dWvK677ptqWNB37qi9nHHqo4gUWugei8nz38yJ0hzKB64
         0CdDf+d0cXtQDMMWGGhF0aFHKUj7MeR2yiYMhG2+ItBts/RjbMFOmf0Yb8nBFl8no5XU
         WW4A==
X-Gm-Message-State: AOAM533JUOGHNuMb64alXonASHCynAaCCbl52kQK3tDrHBFzPC4sCelm
        DjTsFo0smkjswFtIlilbvVkbz4+O9iBtck6C
X-Google-Smtp-Source: ABdhPJx62a9EU0Y1LuJKnvM7+pTnl+gIUByaASm4GusWx4i8Z5YzJ/42JGzoVuCiMLC3avLJGr+pcA==
X-Received: by 2002:a63:d047:: with SMTP id s7mr10238119pgi.470.1637762108633;
        Wed, 24 Nov 2021 05:55:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lx15sm5306323pjb.44.2021.11.24.05.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 05:55:08 -0800 (PST)
Message-ID: <619e443c.1c69fb81.808f2.bc39@mx.google.com>
Date:   Wed, 24 Nov 2021 05:55:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-251-g2f2090beb462
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 123 runs,
 1 regressions (v4.14.255-251-g2f2090beb462)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 123 runs, 1 regressions (v4.14.255-251-g2f=
2090beb462)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.255-251-g2f2090beb462/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.255-251-g2f2090beb462
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f2090beb4622e9209fee6b1d8928dbbe5ea4c21 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619e0ff20484713c73f2efc3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-251-g2f2090beb462/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-251-g2f2090beb462/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e0ff20484713=
c73f2efc6
        failing since 10 days (last pass: v4.14.255, first fail: v4.14.255-=
54-gb6f4d599e1d3)
        2 lines

    2021-11-24T10:11:44.466149  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-11-24T10:11:44.475703  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
