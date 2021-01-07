Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A32EC855
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 03:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbhAGCvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 21:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbhAGCvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 21:51:19 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A2AC0612F1
        for <stable@vger.kernel.org>; Wed,  6 Jan 2021 18:50:39 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x12so2685159plr.10
        for <stable@vger.kernel.org>; Wed, 06 Jan 2021 18:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EOXCBPEdSKRdmyCTgmbsR7GF5dACLdkb8019b0iu5vU=;
        b=L9MeS9fJlW/68E2i9Ilathpn5Ry9f1tsn8x1T8CP07Pkonbs4l8pt+FnbZzY0bEJxp
         ju57N8Bx8pizNkw/sQH5AOzcd7aRO9eY5hxFJvRR49kWK/pCe8FKCyKDfY6qb29QgMjR
         pP6Kj/lnJiJ9DOEvNKRyeECzQoOcrP6HYIGIaeq2AvZaN4crPtFIkpB9ncQfISwkxssZ
         TOA/zaV80ZyUNM8M1kAnWSfq2vNqN51coDYRaBe9jq8O3S70aj2b3r+I5RmkBEkGTxT2
         qCX1tBastRctiquBD2+wnwpJ96ylc5XajXwWeMqwwQh3QtdqgrCEsAVqRHRj0pLKdC8n
         BH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EOXCBPEdSKRdmyCTgmbsR7GF5dACLdkb8019b0iu5vU=;
        b=a0UYb17k/W/AlWTJUlUNor7jiL2rhADzUxTICpIHfUrF88OLVKPJ+puCZlbzyVCs9t
         NyzNe6qG4uEtSsTA4FpoQLjyYSwrSfV2Cr/mNh1uMhgl+Qm5tHsjdaTKy+cA3Trlc74R
         cTaKAybk3I7VoamfBcWHfjoz+0KVJARS7zx3fxtEPz1PiR8ULX/CKJ6HpLf3dPxnUTpS
         iJ+wyKPy3LqDOUXqkXIeGNjqUoOrzQo3/JmZs8tN5MyTrUkDGMtKTaYJorDFBTey6RvW
         C7e08OaU8MK4zjUYj6rO000o0G3cuguDRRiuN2LCv/Y7g4J0KtTKDFvmKZBV/I/BJ6FW
         qpCg==
X-Gm-Message-State: AOAM530AkOOaFr6ggBQtIPNQRiMk207oZlQ9nuquS+Am658PyHu5uStG
        yxFwsmLD3Jzf68QFtl1Ds3D+hpqFs8ln4A==
X-Google-Smtp-Source: ABdhPJzGlaRUOZ2JwxChccazroMn6RkiupphBOcytf8XDmVtIvduw4zzLjFN87/PQnW1m9iZwQBg3w==
X-Received: by 2002:a17:902:b496:b029:da:d356:be8c with SMTP id y22-20020a170902b496b02900dad356be8cmr7083557plr.56.1609987838673;
        Wed, 06 Jan 2021 18:50:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7sm4341106pga.0.2021.01.06.18.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 18:50:37 -0800 (PST)
Message-ID: <5ff676fd.1c69fb81.daebc.b674@mx.google.com>
Date:   Wed, 06 Jan 2021 18:50:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.249-34-g897479d0e6144
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 133 runs,
 5 regressions (v4.9.249-34-g897479d0e6144)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 133 runs, 5 regressions (v4.9.249-34-g897479d=
0e6144)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.249-34-g897479d0e6144/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.249-34-g897479d0e6144
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      897479d0e61440c143534a2dde91d2c919ef7b18 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff63d4a36f11e26d4c94cbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
4-g897479d0e6144/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
4-g897479d0e6144/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff63d4a36f11e26d4c94=
cbc
        failing since 53 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff63d4068d2029d3cc94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
4-g897479d0e6144/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
4-g897479d0e6144/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff63d4068d2029d3cc94=
ccb
        failing since 53 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff63d4e4dce4abda5c94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
4-g897479d0e6144/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
4-g897479d0e6144/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff63d4e4dce4abda5c94=
cc5
        failing since 53 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff63cf6d83cad3cf0c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
4-g897479d0e6144/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
4-g897479d0e6144/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff63cf6d83cad3cf0c94=
cc1
        failing since 53 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff6674a5997b85d7ec94cdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
4-g897479d0e6144/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.249-3=
4-g897479d0e6144/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff6674a5997b85d7ec94=
ce0
        failing since 53 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
