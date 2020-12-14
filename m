Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57A92D924A
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 05:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438605AbgLNEhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Dec 2020 23:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbgLNEhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Dec 2020 23:37:25 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A2FC0613CF
        for <stable@vger.kernel.org>; Sun, 13 Dec 2020 20:36:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id z12so5552768pjn.1
        for <stable@vger.kernel.org>; Sun, 13 Dec 2020 20:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=klaxOewnex//7leOSeuwuFIl18l9Uvm7kDGJe9MbhHE=;
        b=YUFUD8vQQnE1gmE0bm+QdXuFZJE6x7w9ST3aQz12DfwG/h30hj/rTojsJp7miEZEXy
         z/hotKfZo9MOM2rJDjLn+J2fc6ziO9Fhsq1T6p2N+rduZLoA1mTchfi6Y935t1HAkClo
         VG27y+FZ7B2amiG18s9az0dI/eXgcsAmhyzs7rhZx1u1I4X1nI3hiXM7xerbBOjet5wt
         3HTtPOFDVOx0fM29ouWbwhCrTYPbSa0iuiZwLZB7vCJLsjZcwHvhxRBtlFMOLTrzep3J
         VewNi4KBcAbQAIjCtMxXqPG3S+BGW3QOU2Svq3QB/gcaOy1pxWhQWo3opIGLIZmkZPRR
         VxWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=klaxOewnex//7leOSeuwuFIl18l9Uvm7kDGJe9MbhHE=;
        b=ln+SSVaOLeJU1z/2VMC/gjPbMBLk1sMZUdzGmxytT5WfZXzygChBDiaYoqHEbFWKiQ
         0KMp7xGOlCXNqOGnzmsXNFaZbcmpmx4Ht1TMXzJWD0m5CCMja2NhCHylJoDqVdVprWBD
         MdbuikSqApmGDTCDb+MRAAvehvuGoVLTt3DxtbDx/E/brHliEZdHhTEkzk5v0xBIzXMH
         EKPSAXPPWQAZdeeQy+/27ClF29dhs4xv8YhL9PiSj0zvosB2vQIndwfsKNy/eQti7zKN
         BjFdJygJiD1igUDjM6cCInyhxUlHD5ikVPXekE1qYMuXw+uDW7MhY+iXGwXs9R93noEx
         5Row==
X-Gm-Message-State: AOAM530BrIfdheM3dR6yZ1fhW3zvJTI/+x8ktSkKYrfZeM6qj3BZATWr
        x4ajeItq4Wp3N7snYl0/s6I+t18fbWymRQ==
X-Google-Smtp-Source: ABdhPJyYmz/fttNz/3XXKzvIz/RCFXJx27y3k7SXHG2wXdXX+G1YoyeKTAz+TMA6uKoRS1g++1J90g==
X-Received: by 2002:a17:90a:dac2:: with SMTP id g2mr20091751pjx.17.1607920604116;
        Sun, 13 Dec 2020 20:36:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x4sm17709408pgg.94.2020.12.13.20.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 20:36:43 -0800 (PST)
Message-ID: <5fd6ebdb.1c69fb81.5f5fd.4cac@mx.google.com>
Date:   Sun, 13 Dec 2020 20:36:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-16-g4065dd9e0ea73
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 130 runs,
 3 regressions (v4.19.163-16-g4065dd9e0ea73)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 130 runs, 3 regressions (v4.19.163-16-g4065d=
d9e0ea73)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.163-16-g4065dd9e0ea73/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.163-16-g4065dd9e0ea73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4065dd9e0ea73582bc91823177311ca92feb6752 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6b73164819a3203c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-16-g4065dd9e0ea73/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-16-g4065dd9e0ea73/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6b73164819a3203c94=
cc6
        failing since 30 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6b75b64819a3203c94ceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-16-g4065dd9e0ea73/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-16-g4065dd9e0ea73/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6b75b64819a3203c94=
cec
        failing since 30 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6b6fc61d841dcecc94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-16-g4065dd9e0ea73/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-16-g4065dd9e0ea73/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6b6fc61d841dcecc94=
cbf
        failing since 30 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
