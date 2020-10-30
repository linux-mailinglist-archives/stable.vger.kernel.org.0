Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519622A0B9C
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 17:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgJ3Qqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 12:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgJ3Qqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 12:46:53 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D51C0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:46:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b19so3235744pld.0
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kd+zpkAjrtp2bR+CtlgtK3SVJ+AX73lInmN3uAaQS2Y=;
        b=zUZUTv/c/ViHA3+/98rg0r9bHJt7EA3dK7Aoc0lbWcY/wDoz0h78g5qUUk9VsdEMfQ
         Uxxoee2mdsuhF1lTqe8Bi0K125xIAZOHZHPWN6FnOBEMcLS/uu0fT6aiYJOhY8tOkmBE
         HzG8jsMhNN6oReoRa1lwbn1Bi+AJvZ4b+pHJaRLHp4okyld5Y0Q0Oqp/Z13kDweivgcd
         oBFQKGn2TD0bqgUvjH+iMcVRmSfxs0gDKKBZobYjUFQTkLXbeFLHjqh8Sy5i07yMAUhs
         FC4yMzqT+tsn+93pV2h/Si4BZeGykUhDkAi2mrIx84o27tzHiwIXhiJBsTGIwgRHQo0t
         ZqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kd+zpkAjrtp2bR+CtlgtK3SVJ+AX73lInmN3uAaQS2Y=;
        b=QFZo+sh7hqyP9c2VUjGTcy0C+exWrXGmaqCznBkgn2sG5E71Tc6Qnw4N2QqXlfwBO2
         g1Jc6LPU/97pizNAKhO5RW039FIZ9NxtB0HfropPEupylOPjhVe73Sb7nSAtRbovj7s9
         hA48gvlgbEVMTpr7aRku5nlJ2du23IAuAUZfK0lj34YJKKnmrDFHDjV4Jt949SrS/smU
         bsHSG0+lpr+ps23X4uauJTGyhwI5UF76zKj2AOvLJV3QwKUeEu0JhDmBjdfFFMXZe3oO
         iVnoTvZ3EgmDMzwXtV1IE6L4+fsGObWyALGl3zhrP8iT1SBZ6/7pTL7v9t4+Lublwk0T
         171A==
X-Gm-Message-State: AOAM5329byUn5VgTifJ4CDJJbYJE4dV1lSYSppuj/vRpUc6xNJ1KrGzx
        sGmIZpfDe+MQ+Us5cYL4OLy5GA0bBssKIw==
X-Google-Smtp-Source: ABdhPJyAr5WYR1EI3xFJ8Vy3gxKlKiORPorw5sDA/e9VVwYWSznkeYZPXZeEPT14FGB8ZKvPOcaKaw==
X-Received: by 2002:a17:902:7c88:b029:d5:cdbc:ce6d with SMTP id y8-20020a1709027c88b02900d5cdbcce6dmr9717386pll.22.1604076412444;
        Fri, 30 Oct 2020 09:46:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n7sm6093243pgk.70.2020.10.30.09.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 09:46:51 -0700 (PDT)
Message-ID: <5f9c437b.1c69fb81.c76d.d9db@mx.google.com>
Date:   Fri, 30 Oct 2020 09:46:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-3-gad7f808825a3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 156 runs,
 1 regressions (v4.14.203-3-gad7f808825a3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 156 runs, 1 regressions (v4.14.203-3-gad7f80=
8825a3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-3-gad7f808825a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-3-gad7f808825a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad7f808825a31630e8cf2bdb7f2a0c4db0676285 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9c0f8129558a47c5381062

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-3-gad7f808825a3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-3-gad7f808825a3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9c0f8129558a4=
7c5381069
        new failure (last pass: v4.14.203-3-gd24321bfc541)
        2 lines

    2020-10-30 13:05:01.403000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
