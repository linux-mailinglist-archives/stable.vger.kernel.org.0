Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CDC478FF9
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbhLQPct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 10:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238452AbhLQPcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 10:32:14 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819D3C06175C
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 07:31:40 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id k4so2428433pgb.8
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 07:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gzxp81TQrUH/LxwhqMM5dYcdL0vmZJXiJYQNwVMBaWs=;
        b=O9Y0eEMBSVTaRmJPlbLuOQKzUvPgpWxYF6Da70igDQqgIjqujAnrzhdVF+xFD2iZcu
         Qwnm+dNEuSNsMkWwiLHJxRlhcHf/YFVarIBRQF4pFh6tHZlIkdUd/gR9c7Lx3xlg+ipW
         Qsvaf9Rj7hZ2kl20sH/Hnfu4Ar1VcCzuFIzOtOfZy4l5n5JtnMSuFA4DaLSsyutK0U9s
         kIWqTKglRKrZ8SD+ulPkkrGlDj4XF+Lo1uKER0UA/73TNuUlqr6wAekFrelb33PtZ4mx
         bWamCgVuPvGyryuAFyVJvjYLmiH3fyC9IZB28MAGqNOA12N6ksbIUQVXXheuiHte0U6C
         5RAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gzxp81TQrUH/LxwhqMM5dYcdL0vmZJXiJYQNwVMBaWs=;
        b=fIdTNM52D2oHjK3n8ga4A+5HgszJI8WqHe1LptKJFSYy59AwL766Spkwm61EEVi9ec
         NBuEToDZkdGRtWppbvkPx9iU6NsgglsqjIu5YgZhBehVPvJoGUY3iJN+K3LjhmGYAbxJ
         SLtHHN2hDJu55N6OltRHooOnryF/5BYptJPV1Wv7Q9J0MMy4FZ0qtlBSl1XFOhnXnHeV
         GtuFI9y0PJXa4L5xuED2Dyd79ju6S+NrH1MoTo5ll7kDebF6tzX6woOdq5q5A74zZ2Rf
         WQHO3Phi7yJKdd5By3vbH2syBa1pEM4ZI66rguEtXb3L49+4+2gA6UPxPuB7/Twwoqvb
         xJTQ==
X-Gm-Message-State: AOAM532L9Uk3a2KeHXPFAKKrKx5RznG+Z09BQ4ro1zJHYqhElv1VmiNv
        watlmYFJ2b3z5ZwfPrWksaycnRSCWHOP60vM
X-Google-Smtp-Source: ABdhPJzebjVELsFDA40SW+PYMC0Mct99QbSx1E9FwKOtdimTaX7rMLpACeTFmlcoMevA+lGTUCUuhA==
X-Received: by 2002:a62:14c7:0:b0:4a2:a6f2:2227 with SMTP id 190-20020a6214c7000000b004a2a6f22227mr3632778pfu.22.1639755099872;
        Fri, 17 Dec 2021 07:31:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ng9sm14060512pjb.4.2021.12.17.07.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 07:31:39 -0800 (PST)
Message-ID: <61bcad5b.1c69fb81.dcdf4.667e@mx.google.com>
Date:   Fri, 17 Dec 2021 07:31:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-9-g3a1ed112a57c
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 125 runs,
 1 regressions (v4.14.258-9-g3a1ed112a57c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 125 runs, 1 regressions (v4.14.258-9-g3a1ed1=
12a57c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.258-9-g3a1ed112a57c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.258-9-g3a1ed112a57c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a1ed112a57cb0dfc89f41c483e2ac7cadce64a9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bc76563d74c7747b397145

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-9-g3a1ed112a57c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-9-g3a1ed112a57c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bc76563d74c77=
47b397148
        failing since 4 days (last pass: v4.14.257-33-gcf9830f3ce18, first =
fail: v4.14.257-53-gbe1979ab4cd9)
        2 lines

    2021-12-17T11:36:36.312734  [   20.309173] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-17T11:36:36.355420  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-17T11:36:36.364483  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
