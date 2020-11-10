Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC822AD800
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 14:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgKJNtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 08:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729898AbgKJNtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 08:49:13 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A426FC0613CF
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 05:49:13 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id y22so1484851plr.6
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 05:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5ReivqUdMRmz3q6HVB4FMWBcjzXxphNq16L81zKs/SE=;
        b=LlKP1+12JNfQoVXYpXowPHpB2IrR/HhxK5zDMfqT2APJ96VKTMez2xERMqV2uw1Tle
         O5+O3LL/3CoOIs8NCEVWDbazUiDNSVrsQTSTgZp0dMqa/kdMIn8aBegfaODdeLcD6ET/
         q+xRiNBO0Aw/jhyFoVitVLtlZAOk5Ey5k/EgbkSGUw4Ne38wdHPJK+9yXBoBuD7bILzo
         0daT/ZjNTfsOcAq1E39j8t+ApqDe7Z2WDomnzYG4ah7kW6eXk5cvI2SGGpNbcv/nQZL2
         BGYqlXBwHG4pARu5tRZzHB8h7sepTp7eIUupdgeQkMTVJH86YgXPqF5Y6Kvlcrl2+VGA
         e2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5ReivqUdMRmz3q6HVB4FMWBcjzXxphNq16L81zKs/SE=;
        b=tmYQjneGn9ticnFsY796f80EkSi5AHOcwlQQ0V7G6MC4oUJw8MKCs4FYDEWRA7SUgJ
         AkkSxY5kmHHlIBzgsRLA8qngiYWLTdfaq+rkH7ItTIVTl9zyBGU2PR5MZ09KWMrZ2tjz
         Gjz7YTeKgkUrtCTmxXfhDIQJOYUgNWVfOUqLHkWiXfLloQLTpHVGWhAIz9Rm7FYucoFk
         oyMXqA/gc2jNF5KpCMMJ6HbR0b3dkWe9nxnA7QbMkgFmbvHTytCt0ppG1kbmS5aCDV1O
         M+a9oj0Z/oqiHewWRPaTCSCFBmHa+XNojARD5g6DhmV4IW7Mdck0QGmzxOaIAwAAktqb
         f4MA==
X-Gm-Message-State: AOAM530/ulVeORXuMe3gfhr/xON9FskaxSXEI0jv1dSEhArbDC97J8mb
        IIOC9UU+p9DzPqN3bKB4dYyTDFCraGWtYA==
X-Google-Smtp-Source: ABdhPJzoOE+Sj48v6R8HA8Yru3TojnXvo35e/jg20E9d/PS7OSYk0HZKxWc4U2tk2VFy5yIejCfMTg==
X-Received: by 2002:a17:902:aa4c:b029:d5:e527:654c with SMTP id c12-20020a170902aa4cb02900d5e527654cmr899719plr.24.1605016152720;
        Tue, 10 Nov 2020 05:49:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5sm14707396pfx.63.2020.11.10.05.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 05:49:11 -0800 (PST)
Message-ID: <5faa9a57.1c69fb81.9d5f3.0acd@mx.google.com>
Date:   Tue, 10 Nov 2020 05:49:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.242
Subject: stable/linux-4.4.y baseline: 122 runs, 4 regressions (v4.4.242)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 122 runs, 4 regressions (v4.4.242)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1 =
         =

qemu_i386-uefi   | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1 =
         =

qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.242/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.242
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ad5e80d0d772cea9c08eceaceda3b30131cdaaac =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5faa62a29785e9770ddb8879

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.242/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.242/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faa62a29785e9770ddb8=
87a
        new failure (last pass: v4.4.241) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_i386-uefi   | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5faa628c0c5823cb28db885f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.242/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.242/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faa628c0c5823cb28db8=
860
        new failure (last pass: v4.4.241) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5faa6270b8c3eba4b3db8862

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.242/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.242/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faa6270b8c3eba4b3db8=
863
        new failure (last pass: v4.4.241) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5faa6259d757146610db8857

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.242/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.242/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faa6259d757146610db8=
858
        new failure (last pass: v4.4.241) =

 =20
