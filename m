Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042C42FF4C3
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 20:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbhAUTkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 14:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbhAUTi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 14:38:57 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFCEC06174A
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 11:38:17 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i63so2126661pfg.7
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 11:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lm3tSE8frt+TvtCDqs7Bxg6e1ZUNAEQiXXlkkUdztC8=;
        b=RFlEp8CmlTvOhg132OZ2Yjpy7l/Et7OUvYvLPWWks1sAO3a2BSyrqnvUtlcgpvNpXk
         Uf2lWI2lRWor3ANG6Uz+3eLLfJP/0BVhqaFDuVP+ScsdIdhJTSWGAv15knYaYi5KyAvY
         wg5VbTFg6VCWQ1MX1lVAOgb6tGxHoKM5fTEyI/1i7jPo/M5PisawM+x01EkIKt/ttgBr
         bhG/CPTkGKdMKaAE8z1AXPXGyPPCRv+KM97GaRjvMLTi+rF50DtPLTIL9ng0xNaOn/ma
         x+72jIdXSFmtDgEczhH4Wj4Kwh5U9f4TMwJwzukDNM9K/VHlfVYdzW7JyOLfTTUwFiQu
         sKiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lm3tSE8frt+TvtCDqs7Bxg6e1ZUNAEQiXXlkkUdztC8=;
        b=KCDQd8L1Bn5OKuxqW9vrPRA4yX0/Fdq4ew0+4sIJlKGhZa5GTKZzF/TJYocNEFufMT
         d8DnU/8r9QdHdRB8pPRqbVjz6tHCf9NC04vfx7vcz7Ld0629cu3aTCf1zb9dEJpH9Kyi
         rkkP5Tlylw0UsSse+q07LRKWcSUOxAbZtj3MzBD7mk+ZqtVomCxdPPR/Cdt1sVWnk6K4
         2/b3Ou6zv+IgOGkNrGCe+JHmHVXKmEPaE/Nfbli8UpC66vmZrHuSw7p3ovePeD76W6w7
         49DVVJoFrj0HStmqjIgy3RC6e/bamez+xbTZNBu2csyqPx38Vavlz6T+6siY+b7fAjPf
         Rlnw==
X-Gm-Message-State: AOAM530RdKhzu8FFfRzqvwV+jan6uVxV4yQMoPjq+8kucMr1FKgWm8Ur
        ezhDTN3Qi4WzypkjTOTstIHu2YQ7cP1B9kmO
X-Google-Smtp-Source: ABdhPJy+UB30AUgNuL1sbUDGqT68V8SkhbdWVP+Z3rZa1tLVW4V4s9GxkYbYHC5CwMiSHbsiMYaqGA==
X-Received: by 2002:a63:f405:: with SMTP id g5mr878782pgi.276.1611257896333;
        Thu, 21 Jan 2021 11:38:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d22sm6810430pjv.11.2021.01.21.11.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 11:38:15 -0800 (PST)
Message-ID: <6009d827.1c69fb81.e0a42.f658@mx.google.com>
Date:   Thu, 21 Jan 2021 11:38:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.252-25-g3cf282e4940a1
Subject: stable-rc/queue/4.9 baseline: 101 runs,
 4 regressions (v4.9.252-25-g3cf282e4940a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 101 runs, 4 regressions (v4.9.252-25-g3cf282e=
4940a1)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.252-25-g3cf282e4940a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.252-25-g3cf282e4940a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3cf282e4940a1933190f935dfc483512714984c9 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6009a660349ff938a8bb5d1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
5-g3cf282e4940a1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
5-g3cf282e4940a1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6009a660349ff938a8bb5=
d1e
        failing since 68 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6009c51a310e20e0f3bb5d0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
5-g3cf282e4940a1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
5-g3cf282e4940a1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6009c51a310e20e0f3bb5=
d0c
        failing since 68 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6009a657b2151253e1bb5d0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
5-g3cf282e4940a1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
5-g3cf282e4940a1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6009a657b2151253e1bb5=
d0d
        failing since 68 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6009a627349ff938a8bb5d0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
5-g3cf282e4940a1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
5-g3cf282e4940a1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6009a627349ff938a8bb5=
d0d
        failing since 68 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
