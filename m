Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5A9391A5A
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 16:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbhEZOgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 10:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbhEZOgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 10:36:44 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E7AC061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 07:35:12 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso455865pjq.3
        for <stable@vger.kernel.org>; Wed, 26 May 2021 07:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kk5tW/kz26iKBoEvAcCm59WlcwiIB7k1Y6qJw65bXWo=;
        b=I384SD2qGfvO8mPHS6XLIjcGXgr+7D/y7AOnr+q2j2BjvwIP5gPGuk0otLQtqSfrQT
         tlslFSdq1KjIGx8yV3sIgVZ8bBnywyIiirOMO81aNP33Ir7mxzH8GZkU4Aiy3IretEqM
         LPvElZ8Gvy9/ByCZjDXcOy6cSRtbYQPypp2zOk6Ec/4OSqxlCN9lr03qOX1wIH19jXMg
         04PLEx0odWZ6kKCRguuPgjrtQIAkp8BQhlDiRQKhOOk6p/swXkSdbcQOOTsNionBlT1I
         tuDL0pnDdHIGTPTTmm0479OlzGugC3ZCRc6RCGvzBGOx4PVwqOTPcWjQXqPT/3fQ9b/4
         f3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kk5tW/kz26iKBoEvAcCm59WlcwiIB7k1Y6qJw65bXWo=;
        b=ONoBLOjSj3i4keeZ9Vh6AvYz3iFxPAgiyXlkUwSYO8Kb0D1y9fZgAQUk164uD/U/r5
         OU9w67tyqghCaulC8PQXMG3X69tPKVaE9oq/8mxsqWtoQOpYK4lWK0vygQmNKRx/Chyd
         33SZ8prJDkjOSeIRM6v69/OXphtjYVD+SMr/upiGpdngJZDES7U/PcsSzK0LCfxadwiw
         /ayKZoqZ3dfChro3KzQHTicOyLqjo2HkTCLfR7uRIMlDMsloald6j3fERm3ETjdNBiRV
         9IqCj0ViW3GS6HQNCVyuYt13F/skWnMT8/9eumVqa8xirC2MQNg+XB24Ubh1px8DnIUX
         dMYA==
X-Gm-Message-State: AOAM532TJXyj0GfeRlSJ5pPV2ZyEOyK/G+kcl6T5iWUQ1vNmpWKEtySw
        D2c+7gCZvKF97fTR7WK4HFB7VjZ3llAZhZCr
X-Google-Smtp-Source: ABdhPJw50WZYC2/mKWcYZ3eZANxlknA6Y1PRdbjL5AtfRXQg2iLinvpuVLJTCN67ZYyYn3k0VRSN3A==
X-Received: by 2002:a17:90a:8991:: with SMTP id v17mr4133219pjn.132.1622039711844;
        Wed, 26 May 2021 07:35:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mj7sm4394555pjb.47.2021.05.26.07.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 07:35:11 -0700 (PDT)
Message-ID: <60ae5c9f.1c69fb81.0de2.e79f@mx.google.com>
Date:   Wed, 26 May 2021 07:35:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.269-37-ga1966856a76d
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 82 runs,
 3 regressions (v4.9.269-37-ga1966856a76d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 82 runs, 3 regressions (v4.9.269-37-ga1966856=
a76d)

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
el/v4.9.269-37-ga1966856a76d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.269-37-ga1966856a76d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1966856a76d7f402493b81eec051368ecd1335c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae3196fb0640bf3fb3aff1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
7-ga1966856a76d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
7-ga1966856a76d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae3196fb0640bf3fb3a=
ff2
        failing since 193 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae3028a34a2f7ac0b3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
7-ga1966856a76d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
7-ga1966856a76d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae3028a34a2f7ac0b3a=
fc2
        failing since 193 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae31fdad5030ca82b3afa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
7-ga1966856a76d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
7-ga1966856a76d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae31fdad5030ca82b3a=
fa2
        failing since 193 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
