Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8B0312EA3
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhBHKNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbhBHKI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:08:58 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D17C061756
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 02:08:18 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id j11so7538394plt.11
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 02:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LGdVkTzdjzzXV2TjY3P59vX7ARoVEr67BP+SRSU4vHY=;
        b=UUTQz2B3UI1DBzTk96mBUAge6N1m51aA9ZL4RDoZ7kJU9mFSKNrv8EJDzn/ZJsOMp+
         7fz/ITaS8HzHHhrPG+yla3aSxiCZ7W1kYHSeyyr9KgBEFAhWnujwh4AyqmKgx/Waqt/A
         FC0DCwmg3N3AGGkURHO4RxCIxAFPGGYoiJkTvt68OkvoJ6lZYZsXyf3glrSqA6fz8AGt
         8VdiNLzQwFvGtBW7Jcqj4VWGcVcHA5arMaLV3HRiq0afDGoXIDj6Fw2OiYutlDnT42Jo
         R7SzpqpqfJ+oF+Ssl5Z0iuR09KhQS7mnczElxMzo/JKL41n1rGvZDHrVtm7CZunjdQ9O
         YMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LGdVkTzdjzzXV2TjY3P59vX7ARoVEr67BP+SRSU4vHY=;
        b=e34CDxwdCIz4rWqeWvmZcQEhjGaQK+KbiQJfg1zSiEC8izvoe9HbbnJlVCaaJtGTpq
         y9o/HpMBirTVkExaEI+9UEuLUYlBcN4W+qpqwDANrNOD7HhyZ5reS3ZIlsepbV0zhzOF
         ovMAG26HPtr9aAio63/y7gkTOStPbFCHAdBR6RemBid8Ls8YidrLdGVuV2nrtpGCG//p
         Uabzixb9d6NLARTIBzLwzfTYS3Tpn8zhkvXQSpNaoo24eSg0tW9sCAx7UMdx4Ox0AWdQ
         VutCAREYX/8mma+uTGCTfrqTdHCvJjPa/PpBbgXTuTQ0HB5eQ8lY+NJkOYX5svnXnQpm
         Xjnw==
X-Gm-Message-State: AOAM533qKtaAlzGDz2dOjndi//Pkjqd12S+kBn+dcNtWfM+pT5Jz1Evw
        z494AfNH23ghpPfHOApEl8D2VE2WBwdNtA==
X-Google-Smtp-Source: ABdhPJz8T18BuZnXTRDJROTLKoVEPP/Pp8O/9u5z5OPxVogjb9UfjcKGo/CQQzhr336X4z30Fz61bQ==
X-Received: by 2002:a17:90b:a58:: with SMTP id gw24mr9677594pjb.143.1612778897409;
        Mon, 08 Feb 2021 02:08:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n12sm17757872pff.29.2021.02.08.02.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 02:08:16 -0800 (PST)
Message-ID: <60210d90.1c69fb81.ea3ff.7cb2@mx.google.com>
Date:   Mon, 08 Feb 2021 02:08:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.96-22-g157237aef1207
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 185 runs,
 5 regressions (v5.4.96-22-g157237aef1207)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 185 runs, 5 regressions (v5.4.96-22-g157237ae=
f1207)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.96-22-g157237aef1207/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.96-22-g157237aef1207
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      157237aef1207c8262d15bb9a41b2693eae7a2bf =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020d2e19e0f7d674a3abe88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-22=
-g157237aef1207/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-22=
-g157237aef1207/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020d2e19e0f7d674a3ab=
e89
        failing since 86 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020d2f09e0f7d674a3abe94

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-22=
-g157237aef1207/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-22=
-g157237aef1207/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020d2f09e0f7d674a3ab=
e95
        failing since 86 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020d2f29e0f7d674a3abe97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-22=
-g157237aef1207/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-22=
-g157237aef1207/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020d2f29e0f7d674a3ab=
e98
        failing since 86 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020d31d5e1528ae113abe6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-22=
-g157237aef1207/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-22=
-g157237aef1207/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020d31d5e1528ae113ab=
e6d
        failing since 86 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020d2a02459059d0a3abe7e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-22=
-g157237aef1207/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-22=
-g157237aef1207/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020d2a02459059d0a3ab=
e7f
        failing since 86 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
