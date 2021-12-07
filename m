Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DD146AFA0
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 02:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344899AbhLGBW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 20:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344156AbhLGBWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 20:22:20 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5A5C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 17:18:51 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id h24so9087253pjq.2
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 17:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Dy79etYV06Uvnq/6cF1cJmfGyDPc6QLSiA8Fb2bsBSU=;
        b=su9MHwBS+uFbtXiYxVQhwY3YJ2wauwbZ5Lhn/sQ54hcbvR1J7SkzXHcRqzFCTo1IdY
         qwVhwX5SZE+Bbz7Ybe8yogtQgQhByY1Z5UpPlBYkotZT6muYKm6+2L8NZafQdySmzMkV
         ujFvTPuDJO49BJtsFdvyWBXCchiDt++C0+mgYmr1VsPA636DVRSJosTUfxr0bXV+bT+r
         x8tf0irNX6RDCiVWD/z3DxJPqJGMlKqcSLJf591ZgMo3Z1x0hfxK/2ndNw/7D4mf/c1I
         cT7MxFeVFu0nh005XqmNOS8Kf+SF7lFbPXk1WbgbH1E/oZA+j8fA1Lr9U/h2mTO6Fs27
         xFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Dy79etYV06Uvnq/6cF1cJmfGyDPc6QLSiA8Fb2bsBSU=;
        b=LzzBumJSR024Mt1XefdLEmUbzXNRj887HxC8Isurdym4RLUREY/QdG76q34oaw7eHZ
         lUTq473RgyreKowb1QYl4+iKy6RNOaGp+VOWseLoN/rgeEfWs9lVaV91ij7MalYB8oR1
         FS8IcrDZAJyX4GGDUuv+orqP0YmnZSIfCNEhZ5mqpFQunMCscXQM6lDhYBS3cp9jOjyY
         OJUZ3Fc0CW7dR3EGQ9AMnYxKaPhQL1l1BWD8HhJs6PJMn7Xa+loQLjyrYZGytRZrYzC3
         QLUDMkphWZiLQJSCYTqNogkHPbfHfYpjjQOmw3STsXtsxMFpjgoLZoI0Fp/UXzU8w3da
         Zl3Q==
X-Gm-Message-State: AOAM533skbafq1LVrj1OT2jCzwA6twsAentJUJLhjZaTznLze28ER+BC
        rphiRBoQJaXiLRh+NnJx1Zt2WZQwAqztZjG4
X-Google-Smtp-Source: ABdhPJxmq7anILl6xhLrAptqevDDNVJvOYPx+46l8Iv9ho/qeB+MQbjEWNiShs7eLd5XhulTHpAsqQ==
X-Received: by 2002:a17:90b:4d8c:: with SMTP id oj12mr2770973pjb.100.1638839931001;
        Mon, 06 Dec 2021 17:18:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm13555001pfl.88.2021.12.06.17.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:18:50 -0800 (PST)
Message-ID: <61aeb67a.1c69fb81.65fff.7552@mx.google.com>
Date:   Mon, 06 Dec 2021 17:18:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-106-g0e1b735b5316
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 149 runs,
 2 regressions (v4.14.256-106-g0e1b735b5316)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 149 runs, 2 regressions (v4.14.256-106-g0e1b=
735b5316)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-106-g0e1b735b5316/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-106-g0e1b735b5316
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e1b735b5316567be036843a464bbbcca4c32666 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61ae7b712fb99ef40e1a948a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-106-g0e1b735b5316/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-106-g0e1b735b5316/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ae7b712fb99ef=
40e1a948d
        failing since 1 day (last pass: v4.14.256-86-gce5b7722e4968, first =
fail: v4.14.256-96-g0a8417bc52507)
        2 lines

    2021-12-06T21:06:42.835033  [   20.067504] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-06T21:06:42.875615  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-12-06T21:06:42.884990  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/61ae7df69e5e77d2f41a94ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-106-g0e1b735b5316/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-106-g0e1b735b5316/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ae7df69e5e77d2f41a9=
4ac
        new failure (last pass: v4.14.256-28-gb75fc63979563) =

 =20
