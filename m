Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CF832B0BA
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345345AbhCCAyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238157AbhCCA0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 19:26:41 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55342C06178A
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 16:23:53 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id q204so13918752pfq.10
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 16:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Mczpd5MJDlU8bBuDA1igkQlcLtNLzgsxtDDK/lNFEME=;
        b=ftW7V2o1Vmn3Fnc5jgIxcaPx1SWp4kRka6ZSWt0w6DB7+YNpSaClokVZwUKdrsLNZQ
         /35m07OLw7XB9jLBi/scUwtbLIxBQuCaDX58xZQVcP36yFNUIlzMOsZmQehwPATvl6nr
         j3dNBDUnITyGxgBa1j0szHi2r6h6WLH7yx+bxp402EQNcn9YjAw+JY2SDtCxGsPKv+nm
         2yB8vgQrthmWucStlJrC91jumhKD1lHNpr8uXfX/6lxRJJlQrB1h9gkTLq31LYlqUhav
         ICsHql3hTAGEDyvaIEINRBzC+Zqtdq+gi0t1qfDezl9K5ntViTP7q6DkBKgvD9aC5kfJ
         1Klw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Mczpd5MJDlU8bBuDA1igkQlcLtNLzgsxtDDK/lNFEME=;
        b=ivOs2yq95eiaRtlZBPmb2WUkH7ZmUHKe31vR40dCaHMpHxwI96r0/RAGsneMCTT+Rh
         DDz6EsEjVKK5WmrjLVqwBweRYTfz2AMaAAM154WLMLUPbkDEhkSutypVt6rBgxixA6zJ
         jPBdN2pYIQVGcQp2YxdicKfGmd1wKxfHLXWXSMcxThWqe2GgJ4+LBA9E/f92TAnRq3b9
         fhNPliK8hql2+txTGnGgHeB1Adf5bjV6C7qtlD1JqGXasmBx3eUWFEm66Q7TlvXMxXhc
         osijtsivjk9bKQCGCNaOrTprUbPfB62ZZvuVja+07ff8rvUIOB2WJoOUrkOBw3jOGpeg
         KN9g==
X-Gm-Message-State: AOAM531kxyVozz/GnLln+RW9yTSVvqp5N44ahZMETJbZt3MyS0kyMmL0
        md3HbLvjNytLQ0PiwgPsKrl1VCKoIGIReg==
X-Google-Smtp-Source: ABdhPJzeIMWMhwAhltAwAlnnRNgzcXwSY3Pj0kfoFzxaqf5iXqsB5EuzxAyBEw6eV6/1ylT/nHpI2w==
X-Received: by 2002:a65:4942:: with SMTP id q2mr20063663pgs.34.1614731032755;
        Tue, 02 Mar 2021 16:23:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p20sm16339759pgb.62.2021.03.02.16.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 16:23:52 -0800 (PST)
Message-ID: <603ed718.1c69fb81.e7abe.5b0c@mx.google.com>
Date:   Tue, 02 Mar 2021 16:23:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-134-g6fa032fed227
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 76 runs,
 3 regressions (v4.9.258-134-g6fa032fed227)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 76 runs, 3 regressions (v4.9.258-134-g6fa032f=
ed227)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.258-134-g6fa032fed227/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.258-134-g6fa032fed227
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fa032fed227ba4fe058e8ee1fb421342939bfd8 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603ea42dc1bdadfe37addce9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-g6fa032fed227/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-g6fa032fed227/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ea42dc1bdadfe37add=
cea
        failing since 108 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603ea41fc1bdadfe37addcd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-g6fa032fed227/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-g6fa032fed227/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ea41fc1bdadfe37add=
cd5
        failing since 108 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603ea65426c0befd13addccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-g6fa032fed227/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-g6fa032fed227/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ea65426c0befd13add=
ccd
        failing since 108 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
