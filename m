Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898EE45F6C1
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 23:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhKZWOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 17:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhKZWMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 17:12:22 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D7BC061574
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 14:09:08 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id iq11so7972697pjb.3
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 14:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PCwoSK6AwSPsQqPWAXJoNaPum+Suh99CAhVYuY+1ke0=;
        b=YPT80yN25poBRgyUvmYKut2sXZPpjIQ3kYYNoGF20NO306WFcVaCYu0WDBvwsisTSZ
         fI3mldGScKIfbDhlWEPInzqvdA7k7ZH/IiU02h0+FeiOl/XYqCJqRzWqzQu5REjICD4i
         8kiMf6Q6CFZi1484UZa4EmQThB71vzZT4a4zVn/FZ/n0FqU8yHjum+D59IMsTLMxnhjN
         T0L+sJPFDai4s9fUoll0XqS8JMUEYzA8v0CMYSx3GPEQFgRO5+KX24qjf+1DKFuPZXgu
         4pLhL2uG0E8jDGh9AWXI6/YRoj0UfY96F2awuR7stYu/3qmuKw9W22Ekq569RLfiZQCC
         Se3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PCwoSK6AwSPsQqPWAXJoNaPum+Suh99CAhVYuY+1ke0=;
        b=d5S/KoSSep0NT2ckaogmBVcIsZb6VUmV44nc1V+6j1hEOjr7xHFHU58xbvS17gb/uX
         c0nHHbfBjxooaK9MIqvM/1hikpgZvQC9VpRv0Tt+jNWbVVhO63pkXfDijX3rIhoW+CHZ
         FPh8dHuQbwp0y1eHmm+jio3sAbItuaN0OxAJAfFpjDJ8VWQGkdZqeFa6HFbZ5CNFEjpY
         vddu4ntDJmObzIVpCS0RK9w4UAeG5tmwNFw2Gnt9Kgiik16TeUpteikSNcsWF7eY8CTQ
         Laaxf+Q6bQW+lownmzKeOmYZszUK5OIpTqSrA93xxHzcK01K4c7ybAzlQcSjz+36cXSv
         7+4A==
X-Gm-Message-State: AOAM533wOW6VFgNzYf6/Djy5dgWiHdzQleYR0/saqXRuzG/ONjCIrNaY
        BGOuHkilU9UKJn0c8QmAu+mBHJIpWRDY/GUg
X-Google-Smtp-Source: ABdhPJwJ7JsMu90Q/n1FbDX2pdfrrc/A4muOt8ihA3s1l5EgDQ0Oy5SX9ljwVb/NUKIVk1CEQYFE7A==
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr18577496pjb.8.1637964548367;
        Fri, 26 Nov 2021 14:09:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm8923202pfl.118.2021.11.26.14.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 14:09:08 -0800 (PST)
Message-ID: <61a15b04.1c69fb81.8da84.7eef@mx.google.com>
Date:   Fri, 26 Nov 2021 14:09:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293
Subject: stable-rc/linux-4.4.y baseline: 90 runs, 4 regressions (v4.4.293)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 90 runs, 4 regressions (v4.4.293)

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

qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.293/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.293
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae6f8ce9b7496a4ffd3ba545f824b44cdb217149 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
beagle-xm        | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfig =
         | 2          =


  Details:     https://kernelci.org/test/plan/id/61a121960610fdc63318f712

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61a121960610fdc6=
3318f718
        new failure (last pass: v4.4.292-160-g026850c9b4d0)
        1 lines

    2021-11-26T18:03:48.755748  / # =

    2021-11-26T18:03:48.756645  #
    2021-11-26T18:03:48.860495  / # #
    2021-11-26T18:03:48.861201  =

    2021-11-26T18:03:48.962770  / # #export SHELL=3D/bin/sh
    2021-11-26T18:03:48.963270  =

    2021-11-26T18:03:49.064661  / # export SHELL=3D/bin/sh. /lava-1149904/e=
nvironment
    2021-11-26T18:03:49.065147  =

    2021-11-26T18:03:49.166517  / # . /lava-1149904/environment/lava-114990=
4/bin/lava-test-runner /lava-1149904/0
    2021-11-26T18:03:49.167925   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a121960610fdc=
63318f71a
        new failure (last pass: v4.4.292-160-g026850c9b4d0)
        29 lines

    2021-11-26T18:03:49.530519  [   49.161468] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-26T18:03:49.596196  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-11-26T18:03:49.601731  kern  :emerg : Process udevd (pid: 107, sta=
ck limit =3D 0xcb93a218)
    2021-11-26T18:03:49.606083  kern  :emerg : Stack: (0xcb93bcf8 to 0xcb93=
c000)
    2021-11-26T18:03:49.614318  kern  :emerg : bce0:                       =
                                bf02bdc4 60000013
    2021-11-26T18:03:49.622576  kern  :emerg : bd00: bf02bdc8 c06a3614 0000=
0001 00000000 bf010250 00000002 60000093 00000002   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/61a121810610fdc63318f6eb

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a121810610fdc=
63318f6f1
        failing since 0 day (last pass: v4.4.292-161-g62979a1e3cbd, first f=
ail: v4.4.292-160-g026850c9b4d0)
        2 lines

    2021-11-26T18:03:24.778036  [   19.236175] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-26T18:03:24.828051  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-26T18:03:24.837425  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61a1229c452a411a7318f6e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a1229c452a411a7318f=
6ea
        new failure (last pass: v4.4.292-160-g026850c9b4d0) =

 =20
