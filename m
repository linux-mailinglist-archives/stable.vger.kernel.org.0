Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2479449C2A
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 20:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbhKHTJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 14:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236573AbhKHTJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 14:09:23 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B4BC061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 11:06:39 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso683981pjb.0
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 11:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m41NMp9v8Rb3gmmMrSosCzKXW5n2ydc2c3UV/Te2AC8=;
        b=hrhqOnQhBquz0WhKeDYA7+s5rspn10Vxv6QNvrBek7+11f8bCzEq35DheAoK7sVkMT
         pc96kpsVeLytOC4qqRAULmQpup/HCFz8Xa9PzF2cpEXQoo4V/LSCWrie/232G9Nt5l3m
         uPTmrivyHiEZe9+O92TCw83KxjPwDdNCjoixm3nHyOgnxXASDFh4fatn645dO8tnHU3g
         o/iFp9OATikbgol7zkmYFjqixvxCzUG7aJTcNM5ARyaa9YR5+D4WHj4A24HfyjAlH9bq
         VHwZWp2HkXD46qi7aLyaRgkhdHa3OhV9KsFD45Se5yfkUL4lPHwr2UqhEsn+kuiCQO7M
         9w3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m41NMp9v8Rb3gmmMrSosCzKXW5n2ydc2c3UV/Te2AC8=;
        b=KzgmgEoVFuTH+2/zXa2fKHCmjKluJ+2jO6YAYy0wegFsxL4zqmn3am8wofoAinUPCf
         zzEs2AAaTLk6Q2Ibw8df+gBsJtnyT6oPRb8CkMDNorMlKBQZvTW+Q2RZN9hjSK9cYBrl
         1jTEoO/PRtJhO5Wwm4AjVTSa7+r6wJ8qoRv+meqfvdvtKzuhj/KYEhS5cHGpoi6LA+M5
         +gi5BWESQuDkc+3xb3kTNJaQR4X/SluS2stfZQiDfXBpLdRR7hZQWuyvRqaEXR8pGPFI
         ZAiD1ovZZ74eifwEycC5YhAkV27pKk3uOA/EfQLSMrhOynmuC7Zx0i6qGhFL/0L8JWML
         qBpg==
X-Gm-Message-State: AOAM533qdvJzqka2nxilOgNYZMjcjtptZDFMPfS/otQGIHbQTXDisVIq
        ckFQbVxDy0y33vYyFwruS0wJ6LlaZw/fN4xn
X-Google-Smtp-Source: ABdhPJy8/yS86/lT49Sl3Xtd5GsTk6dV595p+bF7J+eHaHZ8tAQDd4ozbZGPRQrgC42fvHiREe9qsA==
X-Received: by 2002:a17:90b:1c07:: with SMTP id oc7mr588838pjb.127.1636398398795;
        Mon, 08 Nov 2021 11:06:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2sm15508460pfk.198.2021.11.08.11.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 11:06:38 -0800 (PST)
Message-ID: <6189753e.1c69fb81.cd9db.ef76@mx.google.com>
Date:   Mon, 08 Nov 2021 11:06:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-7-gc8615621e022
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 130 runs,
 4 regressions (v4.4.291-7-gc8615621e022)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 130 runs, 4 regressions (v4.4.291-7-gc8615621=
e022)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
beagle-xm        | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfig =
         | 2          =

panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =

qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-7-gc8615621e022/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-7-gc8615621e022
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8615621e022defe434711e9e518c25fe05cf1c1 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
beagle-xm        | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfig =
         | 2          =


  Details:     https://kernelci.org/test/plan/id/61893c442919773f683358e7

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-7=
-gc8615621e022/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-7=
-gc8615621e022/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61893c442919773f=
683358ea
        new failure (last pass: v4.4.291-3-gec781d93e42c)
        1 lines

    2021-11-08T15:03:17.384547  / #
    2021-11-08T15:03:17.385453   #
    2021-11-08T15:03:17.489098  / # #
    2021-11-08T15:03:17.489941  =

    2021-11-08T15:03:17.591871  / # #export SHELL=3D/bin/sh
    2021-11-08T15:03:17.592427  =

    2021-11-08T15:03:17.693547  / # export SHELL=3D/bin/sh. /lava-1041694/e=
nvironment
    2021-11-08T15:03:17.694099  =

    2021-11-08T15:03:17.795888  / # . /lava-1041694/environment/lava-104169=
4/bin/lava-test-runner /lava-1041694/0
    2021-11-08T15:03:17.797866   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61893c442919773=
f683358ec
        new failure (last pass: v4.4.291-3-gec781d93e42c)
        29 lines

    2021-11-08T15:03:18.317369  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-11-08T15:03:18.325875  kern  :emerg : Process udevd (pid: 113, sta=
ck limit =3D 0xcb98e218)
    2021-11-08T15:03:18.327420  kern  :emerg : Stack: (0xcb98fcf8 to 0xcb99=
0000)
    2021-11-08T15:03:18.337415  kern  :emerg : fce0:                       =
                                bf02bdc4 60000013
    2021-11-08T15:03:18.351819  kern  :emerg : fd00: bf02bdc8 c06a3554 0000=
0001 00[   49.534820] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D29>   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/61893c281c0b4dcb3b33590d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-7=
-gc8615621e022/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-7=
-gc8615621e022/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61893c281c0b4dc=
b3b335910
        failing since 2 days (last pass: v4.4.291-3-ge1223ca4fb61, first fa=
il: v4.4.291-3-g4b7696b55f5d)
        2 lines

    2021-11-08T15:02:42.661690  [   19.068786] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-08T15:02:42.705192  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2021-11-08T15:02:42.714123  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61893b6e550ba6e04d33590a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-7=
-gc8615621e022/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/baseli=
ne-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-7=
-gc8615621e022/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/baseli=
ne-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61893b6e550ba6e04d335=
90b
        new failure (last pass: v4.4.291-3-gec781d93e42c) =

 =20
