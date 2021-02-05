Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A573118DB
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 03:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhBFCsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 21:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbhBFCnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 21:43:37 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDBFC06174A
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 13:57:54 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id j2so5514439pgl.0
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 13:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OKWLWJeJ+ro4mz9KOxAKdC7mlQWcenbLYsRfnwnzR+o=;
        b=ZWhCvG2crgW64cyuD9yAqMV9NDb1AN+DD3vY3YtLutDiu7uYRROFLqZkBI57NSaiGh
         cCRxIpgCBw8uiLv+onkC2PYnIsSwR5hiLLyZgiGr2kkBc3LhKHaObbIVTUPNVgs7qrR0
         kzVHZXyfzgJTgjzMlEngKXvWlnamQk3WYXWKOi/dwCJ41i9a9ITx/HWEKqltZFyg89UP
         rpONoVVOxB4SGug4E5sCWDwU9KU/Ks0A2EOWczxb1NfMARX2WM/ZN1ZBfXp2qHFfF1/k
         nq8f4EQDnqq/pJxHQuaI6liiktyRaPbCGtEao702OITxnwSDoh9wG//pQLROtTbz+Xlo
         Yafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OKWLWJeJ+ro4mz9KOxAKdC7mlQWcenbLYsRfnwnzR+o=;
        b=axvdSVC98BpUJbmkSPTMyST6AD8kiTDNdHWWeEXLZuCKGFnyhRmvtoNDlNKdLE2gMy
         PaHJfLaUPEDQ6m3GGsdX3Xff7VyWI/n6MLxpCj+nG/kSnorFvl8Bmpflkhp9/aPalH0e
         z4fJ7tefIIbBJ/r7ne4GxtD4O1fFQDORNiLoSMILTI5hl/MvkQNsTZ5gdwwJP3R//Poi
         aFXRAogq699KaxTJKPL/MBQ+HBwaMLrN8ktcROsSpsCuzwyBrE32kBr+B+L2nAy5oqiN
         X248zYLc39sD/7aNhjhmWZkZtyPh+VatodoZN7p8HWe0hYBKBWP9V14Rm8SZ46xnscua
         H2qA==
X-Gm-Message-State: AOAM532J4JAtsWWeYDbqBWitvBeWYUGiv6j1LFzorMMlWOZfSd6yean5
        J0AmiaQu+POl9VAyvcwIx5GYxVNgcVboZw==
X-Google-Smtp-Source: ABdhPJy9BJ5iF4my9PtrIvs8BoMjcoGiK5O2WMPgcIphlhdxNOMDtVZMiKcNoLSo4szMitrK3IeV7g==
X-Received: by 2002:a05:6a00:2385:b029:1b6:1603:4ea3 with SMTP id f5-20020a056a002385b02901b616034ea3mr6397488pfc.40.1612562273616;
        Fri, 05 Feb 2021 13:57:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r9sm10878805pfq.8.2021.02.05.13.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 13:57:52 -0800 (PST)
Message-ID: <601dbf60.1c69fb81.a14ce.7105@mx.google.com>
Date:   Fri, 05 Feb 2021 13:57:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.95-32-gcadda5bd1041
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 153 runs,
 5 regressions (v5.4.95-32-gcadda5bd1041)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 153 runs, 5 regressions (v5.4.95-32-gcadda5bd=
1041)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

qemu_i386-uefi       | i386  | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.95-32-gcadda5bd1041/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.95-32-gcadda5bd1041
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cadda5bd10413732c97274a44a639a3345696f0a =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/601d8a5d21a4e277363abe95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-gcadda5bd1041/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-gcadda5bd1041/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d8a5d21a4e277363ab=
e96
        failing since 77 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d89febe4df7c8103abe74

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-gcadda5bd1041/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-gcadda5bd1041/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d89febe4df7c8103ab=
e75
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d8dbdc99049dd2a3abe9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-gcadda5bd1041/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-gcadda5bd1041/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d8dbdc99049dd2a3ab=
e9c
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d89b7cbd32f155c3abe83

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-gcadda5bd1041/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-gcadda5bd1041/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d89b7cbd32f155c3ab=
e84
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_i386-uefi       | i386  | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/601d8d89a2f0a384373abe7b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-gcadda5bd1041/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-gcadda5bd1041/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d8d89a2f0a384373ab=
e7c
        new failure (last pass: v5.4.95-32-g4af9560d1c93f) =

 =20
