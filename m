Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74673FAC3B
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 16:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhH2O2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 10:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbhH2O2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 10:28:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8B6C061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 07:27:20 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 2so10066595pfo.8
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 07:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=byLXo1BR3OqBr1SB50QyTidxgqjD+jgrZ35HA0cYqhM=;
        b=fgqSsuJRJQcYGcR6ookmfdQyS1fOHbUEB0/aOqSsdOGjmnRTel0Rg9sADdLew8HdIx
         Ek+W8j9CkveltB+wKQ2UYhanNe1ViRAwS+j26qxoPID1YNILsLwaBV6dV/3a0PzQ+QxP
         NeitOzGIL1/TROzTAc0bHNJate/2yD1EGsCFGMy+1NKvtv0Qi7bOOE5OWRylBZzkQR+o
         saoHifLMjwUqadkqqkcrlPRYxMWJNIsbicl+31HD54x9ONESG9DI4+2+ma17wX4vtApE
         dcsMWzf0W9CujSvXAhbycWgyteDyOOdjijckvJdV2qPRdTbjoVgOfWNq7QfV/oTBLqWv
         eaHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=byLXo1BR3OqBr1SB50QyTidxgqjD+jgrZ35HA0cYqhM=;
        b=ILIvfC+EgYaViPjK9qXmkEAY442Hv+xN6Fehy3hJwLD7495OQsqfN//rpZDxDxbJo/
         7N09OMGjGMtm4KyxbeTyvFB5KKEemeXxzoK9ugJz3lG8YHy66eQMU8X855EmcV3u1kGo
         2ys/8bs6YaH/kRbeSMHmwTkBfJdMw9BjVLIEMX5h0FRlD1lYn4vZThP88yVJ9dOw7ClA
         V8LDOIvz0sKRf8jva9Db5QGlA4A0zEn291aX7KqJSHKA+tnRmR/OvgvmKZ5OTGWBGILm
         dzqpUNaYx3cpeK9p7h1m/dP80UqDqypevwnwVi+ELT549Ktvfh5pP6LRUtRMPZPi6RAY
         W3Ew==
X-Gm-Message-State: AOAM532saqY2h9BB/H6dQopjLnTWmixwGrm8BlWArQZIK3eVuY4AZYj9
        9ppCwAyrlajXtn3CIlBfzxOUwrkfxpg5fdiz
X-Google-Smtp-Source: ABdhPJzfa12GCr8s/TVzOwxN6gh1hrP9PUSRlmujTLMivMeeutAlWkeAWS8WnqPTQPW1mGeZF7dXNQ==
X-Received: by 2002:a62:1c84:0:b029:39a:87b9:91e with SMTP id c126-20020a621c840000b029039a87b9091emr18455825pfc.7.1630247239414;
        Sun, 29 Aug 2021 07:27:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 22sm13782041pgn.88.2021.08.29.07.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 07:27:19 -0700 (PDT)
Message-ID: <612b9947.1c69fb81.8262f.27fb@mx.google.com>
Date:   Sun, 29 Aug 2021 07:27:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.143-14-ga1866264c6c5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 152 runs,
 4 regressions (v5.4.143-14-ga1866264c6c5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 152 runs, 4 regressions (v5.4.143-14-ga1866=
264c6c5)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.143-14-ga1866264c6c5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.143-14-ga1866264c6c5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1866264c6c57428ce0ff10589d661ffba5db113 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/612b65ea63f1b7e6668e2cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-14-ga1866264c6c5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-14-ga1866264c6c5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b65ea63f1b7e6668e2=
cc3
        failing since 282 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612b659f2817de084d8e2c8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-14-ga1866264c6c5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-14-ga1866264c6c5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b659f2817de084d8e2=
c8e
        failing since 287 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612b68bf45cf4be0218e2ca3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-14-ga1866264c6c5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-14-ga1866264c6c5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b68bf45cf4be0218e2=
ca4
        failing since 287 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612b658affb00edb128e2c90

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-14-ga1866264c6c5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-14-ga1866264c6c5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b658affb00edb128e2=
c91
        failing since 287 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
