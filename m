Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C4023AD9B
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 21:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgHCTpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 15:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728069AbgHCTpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 15:45:16 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94661C06174A
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 12:45:16 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id z5so20654454pgb.6
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 12:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DcjqZqC6jNqTGvQqDPFTWrVOCFQI5GTLAsYOqljRf9g=;
        b=Vjpurm59gIbjLTsgjd2D6tOzZY6STsDgO26kbckP//Kz33YnV6xKErO4DT++IrUvSh
         zqdRLienzbMQZNunqIycMwSQWicCVtnok++U92LYQJ7IUBTUJlOWGGDq6F/u6W40oZ+H
         5oL0rj4QgPk0AD24UDt043ozT8L3A/ppj1/XztH78HRfkyTYkY5HF590M8mYlbUFDks7
         d7jRFLtMfCZ5AbNmKlJ9eF73qGNLBcKaiSUVyZGjN5hFmCI3ZS6sph+EqyR7xNFnZKrv
         zpUgT9Hal0ccLz/4TVsf4HofgT9H4OnSEY6XAoJ993urS2hFHiwkQIK9pK86sAthWViD
         1fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DcjqZqC6jNqTGvQqDPFTWrVOCFQI5GTLAsYOqljRf9g=;
        b=oLNmVSlgfw8VbvYEPmpD4m0pG8zyJ8jyujksl5HcTCxGzGOgOEmso2ofQcyoTvTdJ6
         gloz3MnztUonXyegmof29nI1f0tg5YEJjCITgORLyvdvTY5JD0zy6AnC+DIXtvKE1YA5
         Au2QOKBLD1pi1j/w+yTJ1UTq9+xARqn6jpoJFpLiIl8BwmICOMb2Y1Hmmr3dcdMl0cbk
         L6xmVbON9PkPHSsAoQOLR2J0/6KWM+dgs5/n5ISXewZz+vYa4Mjd+kbpl47Dgs2bq5eC
         IYqH1QveMFo8WjIolW5NVFQPJBUSN9bvUklXkEO6NIICyHeGVxFqFdCbqZrsnhbXFIG3
         bwwg==
X-Gm-Message-State: AOAM533MnJzIyFTr/zoKwC27vHXfXCFz8umrYUDw6Py0g0Vna6NYivnI
        whGHi7OSxdjBwZ42qlH32x6b0df7szk=
X-Google-Smtp-Source: ABdhPJzXn5pRnYI6xocB8xoC7n9AbV5hG636xBO/r7BDptPZ7Z6GYeOsunzA6I7EwOZgHiN7waTg5w==
X-Received: by 2002:a65:558d:: with SMTP id j13mr16730482pgs.48.1596483915385;
        Mon, 03 Aug 2020 12:45:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x20sm16350156pgc.49.2020.08.03.12.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 12:45:14 -0700 (PDT)
Message-ID: <5f28694a.1c69fb81.fe6c5.6509@mx.google.com>
Date:   Mon, 03 Aug 2020 12:45:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.232-33-g191818eb5a46
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 91 runs,
 23 regressions (v4.4.232-33-g191818eb5a46)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 91 runs, 23 regressions (v4.4.232-33-g19181=
8eb5a46)

Regressions Summary
-------------------

platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
minnowboard-turbot-E3826 | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config    | 0/1    =

omap3-beagle-xm          | arm    | lab-baylibre    | gcc-8    | omap2plus_=
defconfig | 2/5    =

qemu_i386                | i386   | lab-baylibre    | gcc-8    | i386_defco=
nfig      | 0/1    =

qemu_i386                | i386   | lab-broonie     | gcc-8    | i386_defco=
nfig      | 0/1    =

qemu_i386                | i386   | lab-cip         | gcc-8    | i386_defco=
nfig      | 0/1    =

qemu_i386                | i386   | lab-collabora   | gcc-8    | i386_defco=
nfig      | 0/1    =

qemu_i386                | i386   | lab-linaro-lkft | gcc-8    | i386_defco=
nfig      | 0/1    =

qemu_i386-uefi           | i386   | lab-baylibre    | gcc-8    | i386_defco=
nfig      | 0/1    =

qemu_i386-uefi           | i386   | lab-broonie     | gcc-8    | i386_defco=
nfig      | 0/1    =

qemu_i386-uefi           | i386   | lab-cip         | gcc-8    | i386_defco=
nfig      | 0/1    =

qemu_i386-uefi           | i386   | lab-collabora   | gcc-8    | i386_defco=
nfig      | 0/1    =

qemu_i386-uefi           | i386   | lab-linaro-lkft | gcc-8    | i386_defco=
nfig      | 0/1    =

qemu_x86_64              | x86_64 | lab-baylibre    | gcc-8    | x86_64_def=
config    | 0/1    =

qemu_x86_64              | x86_64 | lab-broonie     | gcc-8    | x86_64_def=
config    | 0/1    =

qemu_x86_64              | x86_64 | lab-cip         | gcc-8    | x86_64_def=
config    | 0/1    =

qemu_x86_64              | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config    | 0/1    =

qemu_x86_64              | x86_64 | lab-linaro-lkft | gcc-8    | x86_64_def=
config    | 0/1    =

qemu_x86_64-uefi         | x86_64 | lab-baylibre    | gcc-8    | x86_64_def=
config    | 0/1    =

qemu_x86_64-uefi         | x86_64 | lab-broonie     | gcc-8    | x86_64_def=
config    | 0/1    =

qemu_x86_64-uefi         | x86_64 | lab-cip         | gcc-8    | x86_64_def=
config    | 0/1    =

qemu_x86_64-uefi         | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config    | 0/1    =

qemu_x86_64-uefi         | x86_64 | lab-linaro-lkft | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.232-33-g191818eb5a46/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.232-33-g191818eb5a46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      191818eb5a46dcb3882f9357d2dabcba82503db6 =



Test Regressions
---------------- =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
minnowboard-turbot-E3826 | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282e26599c0dc0b352c1cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282e26599c0dc0b352c=
1cd
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
omap3-beagle-xm          | arm    | lab-baylibre    | gcc-8    | omap2plus_=
defconfig | 2/5    =


  Details:     https://kernelci.org/test/plan/id/5f282ec3a4b3bf54a452c1c2

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f282ec3a4b3bf54=
a452c1c5
      new failure (last pass: v4.4.232)
      1 lines* baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f28=
2ec3a4b3bf54a452c1c7
      new failure (last pass: v4.4.232)
      28 lines =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_i386                | i386   | lab-baylibre    | gcc-8    | i386_defco=
nfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282fc84d12175a5b52c1aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282fc84d12175a5b52c=
1ab
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_i386                | i386   | lab-broonie     | gcc-8    | i386_defco=
nfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282fe84d12175a5b52c2a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282fe84d12175a5b52c=
2a9
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_i386                | i386   | lab-cip         | gcc-8    | i386_defco=
nfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282fea9ee228a5bd52c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282fea9ee228a5bd52c=
1a7
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_i386                | i386   | lab-collabora   | gcc-8    | i386_defco=
nfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282fcb4d12175a5b52c1af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282fcb4d12175a5b52c=
1b0
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_i386                | i386   | lab-linaro-lkft | gcc-8    | i386_defco=
nfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2834aaa4dc0921aa52c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_i=
386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_i=
386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2834aaa4dc0921aa52c=
1a7
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_i386-uefi           | i386   | lab-baylibre    | gcc-8    | i386_defco=
nfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282fc934750587a152c1dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282fc934750587a152c=
1dd
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_i386-uefi           | i386   | lab-broonie     | gcc-8    | i386_defco=
nfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282feb4d12175a5b52c2ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282feb4d12175a5b52c=
2ae
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_i386-uefi           | i386   | lab-cip         | gcc-8    | i386_defco=
nfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282ff19ee228a5bd52c1af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-uefi=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-uefi=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282ff19ee228a5bd52c=
1b0
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_i386-uefi           | i386   | lab-collabora   | gcc-8    | i386_defco=
nfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282fcc34750587a152c1e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282fcc34750587a152c=
1e2
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_i386-uefi           | i386   | lab-linaro-lkft | gcc-8    | i386_defco=
nfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f283494d8d61b1f2a52c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_i=
386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/i386/i386_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_i=
386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f283494d8d61b1f2a52c=
1a7
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_x86_64              | x86_64 | lab-baylibre    | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282e1c599c0dc0b352c1bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282e1c599c0dc0b352c=
1bc
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_x86_64              | x86_64 | lab-broonie     | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282e3204303f219452c1ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282e3204303f219452c=
1cb
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_x86_64              | x86_64 | lab-cip         | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282e2e04303f219452c1be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282e2e04303f219452c=
1bf
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_x86_64              | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282e2e04303f219452c1c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282e2e04303f219452c=
1c2
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_x86_64              | x86_64 | lab-linaro-lkft | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f28342673969402b652c1a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f28342673969402b652c=
1a8
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_x86_64-uefi         | x86_64 | lab-baylibre    | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282e1d599c0dc0b352c1c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282e1d599c0dc0b352c=
1c1
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_x86_64-uefi         | x86_64 | lab-broonie     | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282e3d04303f219452c1df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282e3d04303f219452c=
1e0
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_x86_64-uefi         | x86_64 | lab-cip         | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282e4aecd47757e852c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282e4becd47757e852c=
1a7
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_x86_64-uefi         | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f282e3004303f219452c1c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f282e3004303f219452c=
1c5
      new failure (last pass: v4.4.232) =



platform                 | arch   | lab             | compiler | defconfig =
          | results
-------------------------+--------+-----------------+----------+-----------=
----------+--------
qemu_x86_64-uefi         | x86_64 | lab-linaro-lkft | gcc-8    | x86_64_def=
config    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2834273da9ffda6a52c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-33-g191818eb5a46/x86_64/x86_64_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2834273da9ffda6a52c=
1a7
      new failure (last pass: v4.4.232) =20
