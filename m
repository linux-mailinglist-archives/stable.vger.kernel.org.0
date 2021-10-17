Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C0D430C0D
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 22:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344571AbhJQUpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 16:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242454AbhJQUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 16:45:03 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3CAC06161C
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 13:42:53 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id om14so10822741pjb.5
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 13:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ng5tjsL7QOAAWxApMjuVoKEnfNdg8oCJ6v8QUtzkfaw=;
        b=5D4LUT4cFWLjkkqPhaPhIY289T2rDA8tA5/okfmjRS6Kvy5rNEtoAgbjZKsXEsNspn
         oC7y+cy4mf+RkWaUREIwYEsBR5HoYqY1b+sRiAK5mtCkztWaxIGlOE4v8UIKgcyzpduk
         +rl4i3ksTjEm8QqEmKO9iMfMPsUWpZSmQ0i7g5AAKojnJy7jbrXqj9fyGc8TK4RMvlMN
         pgh29FVPRzp2nhLxHw/HAKAetj3AJ57ct55pJI5LDK1YD8uSV4j/2Z0FEwCAKU8IzjgT
         sCdNIRO9mB1JQaW4r3eq+JH7OjqbU51qM+feyGjCUu9SUvF2VV457S0ReKiIpB7vwHQK
         6KMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ng5tjsL7QOAAWxApMjuVoKEnfNdg8oCJ6v8QUtzkfaw=;
        b=H/YN3lTkKCDj2l1Kvnm/PK/6JHbXfG6rOwjlrMHqDuyswBDDGmDmpk/ntRkbPXPGgF
         vDQRN3N0acuIWI0I+Q/k64uvFAYiNdmLQ0dcf1yIgTZEwineS5ctuskq83Rusb9bpd0z
         Oxzdnvq8iTbfcpiBFQcCfhVd7StK6V+TAAQY2nZ9wYnogCKTCPrg5J0+j6bZgXsNrOov
         QHyh6tYwtaFfLpp0VZQMjpj7iNcQol3yOZVz8i6isY07opAgNVtM4rKys0j21z8rI/Yh
         NStfDf692rcC72RhugegH/pnMEdWzXwAjEmLdALZFBjzAjEylijFwMwZ3q3GZWECC4PW
         3NVg==
X-Gm-Message-State: AOAM532GoBaTNmuq7GV3zZ/6L4rjy351b7plL90dQVO0IhkxZSPVySyR
        tFdoJepR7QbAKThIUe15SV0sq3pmD3UEIMlL
X-Google-Smtp-Source: ABdhPJwnAzIsa24xytE1Syju9Y9fXamG1U/e1828MeSK8cHtQ9TsF7Mwoiu0ZxhvmpNwMr3LJ4PjJA==
X-Received: by 2002:a17:902:cec9:b0:13f:17c2:8f14 with SMTP id d9-20020a170902cec900b0013f17c28f14mr23431352plg.66.1634503372516;
        Sun, 17 Oct 2021 13:42:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm10634342pgv.26.2021.10.17.13.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 13:42:52 -0700 (PDT)
Message-ID: <616c8acc.1c69fb81.488c1.ec6f@mx.google.com>
Date:   Sun, 17 Oct 2021 13:42:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.286-28-gac8720e3af97
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 57 runs,
 4 regressions (v4.9.286-28-gac8720e3af97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 57 runs, 4 regressions (v4.9.286-28-gac8720e3=
af97)

Regressions Summary
-------------------

platform             | arch   | lab          | compiler | defconfig        =
            | regressions
---------------------+--------+--------------+----------+------------------=
------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre | gcc-8    | versatile_defconf=
ig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie  | gcc-8    | versatile_defconf=
ig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip      | gcc-8    | versatile_defconf=
ig          | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie  | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.286-28-gac8720e3af97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.286-28-gac8720e3af97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ac8720e3af97917b0233518952fa19eb60fbc58e =



Test Regressions
---------------- =



platform             | arch   | lab          | compiler | defconfig        =
            | regressions
---------------------+--------+--------------+----------+------------------=
------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre | gcc-8    | versatile_defconf=
ig          | 1          =


  Details:     https://kernelci.org/test/plan/id/616c4dda49b5d264363358e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gac8720e3af97/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gac8720e3af97/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c4dda49b5d26436335=
8e5
        failing since 337 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab          | compiler | defconfig        =
            | regressions
---------------------+--------+--------------+----------+------------------=
------------+------------
qemu_arm-versatilepb | arm    | lab-broonie  | gcc-8    | versatile_defconf=
ig          | 1          =


  Details:     https://kernelci.org/test/plan/id/616c4e83e37bbfe7343358e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gac8720e3af97/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gac8720e3af97/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c4e83e37bbfe734335=
8e7
        failing since 337 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab          | compiler | defconfig        =
            | regressions
---------------------+--------+--------------+----------+------------------=
------------+------------
qemu_arm-versatilepb | arm    | lab-cip      | gcc-8    | versatile_defconf=
ig          | 1          =


  Details:     https://kernelci.org/test/plan/id/616c4df249b5d264363358f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gac8720e3af97/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gac8720e3af97/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c4df249b5d26436335=
8fa
        failing since 337 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab          | compiler | defconfig        =
            | regressions
---------------------+--------+--------------+----------+------------------=
------------+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie  | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/616c4fd7b34210eb4b3358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gac8720e3af97/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gac8720e3af97/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c4fd7b34210eb4b335=
8ed
        new failure (last pass: v4.9.286-25-ga2dd224a9213) =

 =20
