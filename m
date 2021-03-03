Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2584932BC14
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383076AbhCCNk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245418AbhCCDHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 22:07:11 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C365C061793
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 19:06:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id a24so13214319plm.11
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 19:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PZXqKsfEQp0ZCf2D8yz5rrqFMB1nSpW9a8JT0ubMnZk=;
        b=abm20ukwnxecOhp4+SE9HNrxQlOGLcBKSTCl2rkMhoe4x4rs+M0etEBVi9wP+Um62P
         UG4/UKs45Rma3DQrA+C4IIbpwBTqday8nKMdMjnRBD6P/bbjXACwx/v65Jq3hlPyvOBJ
         FiLZuC7qZctzU3DtXqdaAhhvSIDKnL+VS4lno55MkLO86/7PKmYbITnh9kZ6QPF9riKk
         xsAq1BM+9Dnsicl5BREvJAh4g9buIUw2svsh2tOlzFJPhgRzzGU2UGvSXe1xUqJBpEl5
         8XK6srgPFsbQ0sEA+SjxyCur0/BgRNvl/z16AT5yTUJ2CCtCaI7Wucxt8/F3y6NOOEOA
         Vm/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PZXqKsfEQp0ZCf2D8yz5rrqFMB1nSpW9a8JT0ubMnZk=;
        b=TEq42EUK5ERGAAIz4LR919IJqOqYCM4w+RdsxBFH4lN86ytnqJVmi/YmF7DIZBoxOo
         rnR/F4/Gi7RlnwaXf6HE+gNN8yobJm6Ah9yQXHJ6DL16wtjzEO2qTlLwtfVYRlxj7bxT
         KCaxg4XpHUxcY/lN+92JjIVx+hu8otumoeRDWd/SA07GGzPmFPK5zmFVnP4nqQ6E8GPR
         T2FySHRJ4tIuMFhD6OyIRATntkCeCv0H1RPcsAVo8CMJOwRC88ls8927T98GP1bRxX0q
         bL0tNn6eMZWNha+DmF5fIEZ3mwcXevDgQU/J7ptZ8OP/zxNdbUJJtxy9ujdNawgg21aM
         2wcA==
X-Gm-Message-State: AOAM531XCgnv+Sv+2vV6Ki/6hNEgadL98BPoz7VfbenL+b/VJ2W57LO8
        FurLcgdb4+qyio05GjtDwUAoSNvGyxfNTg==
X-Google-Smtp-Source: ABdhPJzL4KOMUtHHqBP+oq/9g/0CsT2hjhXHsYdIz4fKNJpx5QoJDWL+qxJ5QdOlOo0nT09crZFl/A==
X-Received: by 2002:a17:90a:df85:: with SMTP id p5mr7379743pjv.204.1614740789708;
        Tue, 02 Mar 2021 19:06:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y17sm777049pfp.180.2021.03.02.19.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 19:06:29 -0800 (PST)
Message-ID: <603efd35.1c69fb81.49563.2a12@mx.google.com>
Date:   Tue, 02 Mar 2021 19:06:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-176-g451d68c3cf2f3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 66 runs,
 3 regressions (v4.14.222-176-g451d68c3cf2f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 66 runs, 3 regressions (v4.14.222-176-g451=
d68c3cf2f3)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.222-176-g451d68c3cf2f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.222-176-g451d68c3cf2f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      451d68c3cf2f3a60361954e664e9a97a67f069dd =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603ecb27993978136aaddcdb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-176-g451d68c3cf2f3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-176-g451d68c3cf2f3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603ecb279939781=
36aaddce0
        new failure (last pass: v4.14.222-177-ga03a0d1d4a213)
        2 lines

    2021-03-02 23:32:52.056000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603ec93377a3d97d08addcd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-176-g451d68c3cf2f3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-176-g451d68c3cf2f3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ec93377a3d97d08add=
cd6
        failing since 108 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603ec8fa1129dcb052addcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-176-g451d68c3cf2f3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-176-g451d68c3cf2f3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ec8fa1129dcb052add=
cb3
        failing since 108 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
