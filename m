Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA12A1F8E
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 17:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgKAQgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 11:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgKAQgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 11:36:09 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB75C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 08:36:09 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m17so2058013pjz.3
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 08:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yqKSkilVe7eJ+s3caSKK9aWrpoAxtGBBvALEdx6ePv4=;
        b=kIg0Q2VaJNnIP5LXJ4EC0l3mdGI8nYHdf566KwJXn7wtP85yIAJ8YggUlt6l+ppjdq
         zF6uIkmyWbBd7yKf3ZikT2nrmXNoDOvHi2l5IWdv8ncTqIAC+oDzSef0UZZHetsEAQUZ
         lQbxQvq/id/uN6EIh+Nxq2BPtmONb8SinOr2TXyc0+IvHzIGbtPSPfMbVFr+Sl6GTMF1
         rbnwJq7olzT+a01txCwBLYJiDG8FqTU4CzN5EVH1IPvP3wvyk/EHsv0/4ndRRpNCgw/Q
         gghNnf0pz1x9mNPTh+LQB5Iw/CXdM4Geb5erqII+7UGzLekq8ogqWVN2fp9I8/gEhqRr
         bXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yqKSkilVe7eJ+s3caSKK9aWrpoAxtGBBvALEdx6ePv4=;
        b=svAlM4jwIcwhcVfbijoutBwf+vuK1VxgftwTt1p2O+yCRfLN06FHL6z4RcKonGpMG3
         k6eJ0Lh5YYeyMzvuAc6w761DuZ6bbY3ufsYWVW7mrIYn/iWopy9IJzFefYxWjJiuqhjx
         15UnhqmJh0gDalZ0SCsDa7UlrcYpSmVmNauxarm6Lx/FFWEM1kpIVcL4Op3YVNwRelpf
         McidkACLPtvbGVc+xVkCKZN7+DP4/iezrPIXCiXdGjwkb+ookBdU6TR5aB05rdaQ4+25
         wKqNcTEMJnX2Jm2Miq3ilcWC6ez2q6gIrUMkSA4Bub8Mkn8Tsw6Otwt7e6IUANuFFMg2
         5Q/Q==
X-Gm-Message-State: AOAM531tlJi6BfSg34ZUpYpb9exmRbjwL2oPdOvmlp7fKwDEESNSaFrA
        rLYGn949k+967dXNsBIwpmnrzQV3M6Qz1g==
X-Google-Smtp-Source: ABdhPJy11utbGDmCfI9CRPxiuodXC0hnECSG5+N4QLvR3zVzNm17/Tu94tWdpD8A3uMKFOkQAI7zXg==
X-Received: by 2002:a17:902:ab85:b029:d6:b5d2:b6fd with SMTP id f5-20020a170902ab85b02900d6b5d2b6fdmr6910009plr.9.1604248568618;
        Sun, 01 Nov 2020 08:36:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a14sm11382148pfh.101.2020.11.01.08.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 08:36:07 -0800 (PST)
Message-ID: <5f9ee3f7.1c69fb81.b1c03.de88@mx.google.com>
Date:   Sun, 01 Nov 2020 08:36:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-13-ga8be1d27ea3e
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 173 runs,
 2 regressions (v4.14.203-13-ga8be1d27ea3e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 173 runs, 2 regressions (v4.14.203-13-ga8be1=
d27ea3e)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-13-ga8be1d27ea3e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-13-ga8be1d27ea3e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a8be1d27ea3ec2ce37ac06bbab0fc7d43f7057dc =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9eb1ef5022608fae3fe7f8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-13-ga8be1d27ea3e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-13-ga8be1d27ea3e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9eb1ef5022608=
fae3fe7ff
        failing since 1 day (last pass: v4.14.203-3-gd24321bfc541, first fa=
il: v4.14.203-3-gad7f808825a3)
        2 lines =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9eb1892471605a2e3fe7ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-13-ga8be1d27ea3e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-13-ga8be1d27ea3e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9eb1892471605a2e3fe=
7ed
        new failure (last pass: v4.14.203-12-g1c724983025d) =

 =20
