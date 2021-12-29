Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912E84815FC
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 19:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhL2SJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 13:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhL2SJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 13:09:26 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CD6C061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 10:09:26 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 196so19323369pfw.10
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 10:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wbowo69P0+3MsEffj8WsZ9QT5fs4oRAV+EALUClBh58=;
        b=WTXULJQKMVhbyaL54cIK8eFvYvQqX76jo2U/G28xFg00ftBrZcRhp3j48UhhIo+DqX
         OBPTUsfjGnfKgpAEFUnsVDsAkCjwEOmoKMMg1a1xGNDe7ioV4mLSoal7UQ6/u7I0Ryf2
         U3imsazH5ScEKJai0OxdyMAq0AH5cuc4xR/MMzbWt7cPFOq0/+iPFPAtVPMBvc2nzS/u
         10r9qlZC18WYz0Q6ZuJRwOZfuHZiTpJxRM6aLPfGQt7E2zhWArPmYudn4O0wd7a9JBHv
         KevGywqDXim3t+or8Y75za0QRqf3ykqBdy/+pycHI9qoODWa5CVRsCaqAvkj3zeQkqXz
         TIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wbowo69P0+3MsEffj8WsZ9QT5fs4oRAV+EALUClBh58=;
        b=SUCl4YGvZXuyPNhzFS45IZ9I8KthWvjCkWe40B525118ACUs+k15oEoTrXWK04H+wq
         r6UGdQvpQ+79Lgl0iIQ/IvvoyUu3H/WUWAoiOzo3AP9jpYhFhjjvTw1bwjnSZ75aTAjN
         f3iNg/6vbnPB2+BxRS/WqnB80d3duzwXTwZd9r3YJVLDU7z/Y1UsLivtWpJKdcGfAtrA
         4qwJM8Ax8Rk8e4SNkTyz+gqKTecd84L5bUwzxPJy+lIzYFtBF+QJabfNRPFtJU7sewAd
         oeaIMJTyprYKDPvV5mM04oWzGkZSvGLfa5eLIe60LedGJvr0i4VPNJ/kEJUOwVsIiYWX
         CVgg==
X-Gm-Message-State: AOAM532+isF9IZu5Gjx91d12OXvVky6R0TSGf46Tjcc+Lgpq1sTOu3Q/
        ieDAEpTVkNrje028hBfINM9BmXqiobAs8tkf
X-Google-Smtp-Source: ABdhPJyIgy1EdeQeujZuk25IuM4r5MGLnx1dH4TlG05DMUDxade3NXZqL9WvJD/XY/OIY2AguAMdLQ==
X-Received: by 2002:aa7:9539:0:b0:4bb:7c61:7c28 with SMTP id c25-20020aa79539000000b004bb7c617c28mr27263797pfp.3.1640801365989;
        Wed, 29 Dec 2021 10:09:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oo13sm25122374pjb.25.2021.12.29.10.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 10:09:25 -0800 (PST)
Message-ID: <61cca455.1c69fb81.6c96b.43e5@mx.google.com>
Date:   Wed, 29 Dec 2021 10:09:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.168-46-g998c9bae461c
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 138 runs,
 4 regressions (v5.4.168-46-g998c9bae461c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 138 runs, 4 regressions (v5.4.168-46-g998c9ba=
e461c)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.168-46-g998c9bae461c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.168-46-g998c9bae461c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      998c9bae461cb9c9f7719a8ac24a75ab424e8103 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc699eba1a3ed794ef673e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g998c9bae461c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g998c9bae461c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc699eba1a3ed794ef6=
73f
        failing since 13 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc69d48b175eb7a4ef675d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g998c9bae461c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g998c9bae461c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc69d48b175eb7a4ef6=
75e
        failing since 13 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc69c7e2f70fedbaef6779

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g998c9bae461c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g998c9bae461c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc69c7e2f70fedbaef6=
77a
        failing since 13 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61cc69d58b175eb7a4ef6762

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g998c9bae461c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-4=
6-g998c9bae461c/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61cc69d58b175eb7a4ef6=
763
        failing since 13 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
