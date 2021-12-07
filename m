Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2C746AF50
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhLGAqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhLGAqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:46:52 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0F6C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 16:43:22 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso658440pji.0
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 16:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3LyX7HDJLom7WJEeUumFf7USJJyL/Yb7SixOJtPTiD4=;
        b=4FiRQ0AK0WAmZPh4HLIDGTEYGyKAVHvrkr6+EqbRAQ5x0kO7FvGmaXkOl4ChBqhK9W
         rLJfTmw5gH7QS5Sd94ZFdFoKQRvsE38LfO5kb3Q8mNMkQtgyuq6tnXxJfST5HbClSZu8
         C6HFr4fbF1XWnA9L8LcDHkUHXSm3XXM/jfAuUmusrJkB3o8PyYpXtXGH+Cr2qkPyjB8E
         HaNcEYPZMnXB1RzvV+GgZbl3aUyFty5m42oEXgpKkgP9598CDvHNvFXSD0XYwj4rgcd6
         rdhW6Rq1EG+QMJGNJ4ktnh8FcdyrGjML/P7QPxLqt2GckvqrtVfPGXWtoEtZiLjxgu9l
         SIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3LyX7HDJLom7WJEeUumFf7USJJyL/Yb7SixOJtPTiD4=;
        b=zEtTdQFvg4+FQEUqjeajm1OKMqcCGj1areG6HS65BZL6fLo9VLcSdxjwEMAD3AspSU
         LlsVjnjsxsIpSH4lhW4b47oUEnJldze9RpflNpyL7VRoYROPSabLoD9XjDpBlFr1Pyvt
         Xplb9ReFHn6fUdQTAA9rhStAIYZi3FmIJlImkGnjMAwpg93+mIeEJsUFDRCH/IVeuM6k
         1sbx58Do17lDhcovshIGjeA9XmX3v8i5lZpWlEkEeK2EmzY7cmPrBgyRg3vLgDMvdq23
         BFRSP+YaSqBToTtZKwfHj1H0xkRLnc0kPmFLc0zhUXFHtg2dLRQJNA9B4WyFyP0i8SBL
         jGpg==
X-Gm-Message-State: AOAM533dqohjZ/ZLHHphzVhLxtiInTdRjxCMjyoj931BsvkP4hzwYwma
        eQd04csx9u+BEFlyP6Eb/nKj5fPP9Mb5LZ8S
X-Google-Smtp-Source: ABdhPJzl9d6ZTbE1lMU3MOU43SornLOvO7ZvL7DCVf7RvGHwuBYFitdeeU2sZffWcz9sStmt4PYVTQ==
X-Received: by 2002:a17:90b:1e51:: with SMTP id pi17mr2450420pjb.245.1638837802203;
        Mon, 06 Dec 2021 16:43:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 16sm10612490pgu.93.2021.12.06.16.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:43:21 -0800 (PST)
Message-ID: <61aeae29.1c69fb81.86f2a.f082@mx.google.com>
Date:   Mon, 06 Dec 2021 16:43:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-52-g4bb83d906425
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 107 runs,
 3 regressions (v4.4.293-52-g4bb83d906425)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 107 runs, 3 regressions (v4.4.293-52-g4bb83d9=
06425)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig            =
        | regressions
-----------------+--------+--------------+----------+----------------------=
--------+------------
beagle-xm        | arm    | lab-baylibre | gcc-10   | omap2plus_defconfig  =
        | 2          =

qemu_x86_64-uefi | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon...6-chr=
omebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-52-g4bb83d906425/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-52-g4bb83d906425
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4bb83d9064254f736c48c6c91fddde85b3fef561 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig            =
        | regressions
-----------------+--------+--------------+----------+----------------------=
--------+------------
beagle-xm        | arm    | lab-baylibre | gcc-10   | omap2plus_defconfig  =
        | 2          =


  Details:     https://kernelci.org/test/plan/id/61ae73a098845f08721a94a2

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-5=
2-g4bb83d906425/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-5=
2-g4bb83d906425/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61ae73a098845f08=
721a94a5
        failing since 0 day (last pass: v4.4.293-48-g52d38a062535, first fa=
il: v4.4.293-48-g1b8de9fa79c0)
        1 lines

    2021-12-06T20:33:16.618567  / # #
    2021-12-06T20:33:16.619288  =

    2021-12-06T20:33:16.722609  / # #
    2021-12-06T20:33:16.723150  =

    2021-12-06T20:33:16.824445  / # #export SHELL=3D/bin/sh
    2021-12-06T20:33:16.824777  =

    2021-12-06T20:33:16.925907  / # export SHELL=3D/bin/sh. /lava-1197248/e=
nvironment
    2021-12-06T20:33:16.926347  =

    2021-12-06T20:33:17.027501  / # . /lava-1197248/environment/lava-119724=
8/bin/lava-test-runner /lava-1197248/0
    2021-12-06T20:33:17.028579   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ae73a098845f0=
8721a94a7
        failing since 0 day (last pass: v4.4.293-48-g52d38a062535, first fa=
il: v4.4.293-48-g1b8de9fa79c0)
        29 lines

    2021-12-06T20:33:17.494478  [   49.431335] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-06T20:33:17.547161  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-06T20:33:17.553351  kern  :emerg : Process udevd (pid: 110, sta=
ck limit =3D 0xcb968218)
    2021-12-06T20:33:17.557593  kern  :emerg : Stack: (0xcb969cf8 to 0xcb96=
a000)
    2021-12-06T20:33:17.565611  kern  :emerg : 9ce0:                       =
                                bf02bdc4 60000013   =

 =



platform         | arch   | lab          | compiler | defconfig            =
        | regressions
-----------------+--------+--------------+----------+----------------------=
--------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon...6-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61ae724ec03407ba9d1a9483

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-5=
2-g4bb83d906425/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-5=
2-g4bb83d906425/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ae724ec03407ba9d1a9=
484
        new failure (last pass: v4.4.293-17-gbaf746486d1e8) =

 =20
