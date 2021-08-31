Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F593FC16F
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 05:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbhHaDJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 23:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239720AbhHaDJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 23:09:03 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A8FC061760
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 20:08:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g184so15363612pgc.6
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 20:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6hz7BejvGFFuBNs/BURyIMWR1TULOqFzAg5r8R9VTLU=;
        b=ubzK8PiIPwB1rxSu6twh12wBBIOChKu3KTNWnutstAJZliumH470xbhvxeQerVhTuA
         BpranPIwO3wUqbik5j8IYqZGDNNNJT0dAT6hDCiChfpHayovggQuVjvNQ8jZcQ+GT9qU
         xd/LPL7RN3OrelI+e5XrgRMqbuWiFLb/E+XU5GUA3XbkDY0KKEzuCIKdO9cHu1DyNvZe
         KiSZRKdL95n+9Yh/P1BNbrNu6S50IlxoqrmBtqZToGNRSWIDhZxhkYiScTFwlin74Xnj
         itRf2hlusNuGnD5n5bvXPSEzVCHcK97J0aN2w4Ct1P3akseiTDzqzn3HifWywxDUT+jJ
         fEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6hz7BejvGFFuBNs/BURyIMWR1TULOqFzAg5r8R9VTLU=;
        b=h3G8u95MoO4B7ma7lURN1O7J+60kpfoiPjV1vhimNHXfR2iZi1T1wf56P+xf/KBheW
         yKV+LoS5jkWEudQZwJnw6S3i/2DXzIYW2KG3jHuJuOW80pJdeymA4FkfHPBP9vvt8r/o
         1ZKru8p34gz3kNCWXMEsCBAxC0AYmQHem+sj6SqmNIwGi0GqBWagK+al0jU7YnCw8jLw
         LtFOZYZOGzeuteSpdqg4AshWMl3TmbrIHAax1B6lbP8uH+oZ464DOwCJfwboWSg4LQCJ
         YY0GcYvzKLMYtLDRshFrcoiqlziAfyxVQCXBC4HApuzHaNbb3nLyPfzvF9FITaZq3nRO
         W8rw==
X-Gm-Message-State: AOAM532N8GhaCzwIFQkP7d2e4ZSwHfZS8JUOCsVCteZlIR84rSPszovh
        0t2YKBK7jlFWIcRaiJAH3DiidHO/V1RbK2n9
X-Google-Smtp-Source: ABdhPJxXyM4PtTXN1c3vnTQf+k3zlbGJJYB2c+ewrGN73bBhB726Oau3durcklQns8g5CE/Mqu74TQ==
X-Received: by 2002:a63:1309:: with SMTP id i9mr17616070pgl.192.1630379287434;
        Mon, 30 Aug 2021 20:08:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g2sm3879167pfo.154.2021.08.30.20.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 20:08:07 -0700 (PDT)
Message-ID: <612d9d17.1c69fb81.35954.aebb@mx.google.com>
Date:   Mon, 30 Aug 2021 20:08:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.205-28-g8f908e8cd740
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 130 runs,
 3 regressions (v4.19.205-28-g8f908e8cd740)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 130 runs, 3 regressions (v4.19.205-28-g8f908=
e8cd740)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.205-28-g8f908e8cd740/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.205-28-g8f908e8cd740
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f908e8cd740fc01e03d01c3d84fed119b969596 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612d6866ac240a8a488e2c99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-28-g8f908e8cd740/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-28-g8f908e8cd740/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d6866ac240a8a488e2=
c9a
        failing since 290 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612d689dc21eec66c48e2cb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-28-g8f908e8cd740/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-28-g8f908e8cd740/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d689dc21eec66c48e2=
cb7
        failing since 290 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612d6875ccb404f5b68e2c98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-28-g8f908e8cd740/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-28-g8f908e8cd740/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d6875ccb404f5b68e2=
c99
        failing since 290 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
