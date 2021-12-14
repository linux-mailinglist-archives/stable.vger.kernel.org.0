Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7862A47451A
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhLNObl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhLNObl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 09:31:41 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A7CC06173E
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 06:31:40 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h24so14453307pjq.2
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 06:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+Md0zlt7Bk0sBewb20r1ZbygPOvQi89X5HNMQVfVZak=;
        b=8UdeeImd48dZvvSSQabn0aCA7P9FLlPng/YYWM0NmA0IDSsRqQNGbSbZ8X+Vzs2rw7
         iSuMrGtwdRbobRdnA5zBu0MsZI9NtpS29AReZOMy40V0GIllytcyVSpUF6dez36gyWr4
         CSYnFnzXyRBAVsUyTBOagqG2JLvrDdAcn93ApMdUiyqR/SdBaxj7/Pl9vaJrBiQusvdW
         RIA9LBgvAPQ4EPM5aLFXoov492DDXAfx6oopCNlS7apmju+E2nW14q8ndRKavPUHM9lC
         fZkkHxGGDyR9rzFG16v9utHcaBfNfeBKOcYrzWItnzsU///rMPxCaVeJEL9EwJ59thcH
         cCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+Md0zlt7Bk0sBewb20r1ZbygPOvQi89X5HNMQVfVZak=;
        b=i+6l+hZQBqtCv3tbSgCrCa2AvMMuLsiZwriwdrh32ciKIWzeLUMEaPznRm05c3tmA5
         pYXbbyhweWJEpcCFfhMjRXh+Lha9O3nnhQg/4BQO1/8xsm6OlxwG9cHEv/Z8yKrQNQLn
         loEBupvMP6Ip4Vb7Q8ldTZJ1jvnRLGfDvHqHhKem5sWt+msw+vWd16TL6/DJA8Vt6ebn
         5hkrz6+MCO58ni7h/3Tpn/+NR8he6JdL0uvxItG7Uei+s0XoRH5Po3THMbBH+qD3hpX7
         zGqoWXsTUOx2ou8L4LtGU85aPBdcmCaj+rO0yrHZ2m307fyZpZm7T8EaA/g6EPoEuwfW
         YRWw==
X-Gm-Message-State: AOAM531srb3OqaqnZqZrj4QV5z3WrHMlqZocwYN4r82KzQqy1lkWZKYb
        3fb9A8PcLCcBYNvTsOKoX83jrca1RWy7p3WJ
X-Google-Smtp-Source: ABdhPJz01uj7rTmJAI6dHiJUYOQ52DDUT7CS1OSayYr2J0HfHXNsEidRkaDgPV+wc5r1NbAzbvHrBw==
X-Received: by 2002:a17:902:eec5:b0:143:982a:85c with SMTP id h5-20020a170902eec500b00143982a085cmr6217095plb.66.1639492300105;
        Tue, 14 Dec 2021 06:31:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p8sm42983pfo.141.2021.12.14.06.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:31:39 -0800 (PST)
Message-ID: <61b8aacb.1c69fb81.31e37.01ee@mx.google.com>
Date:   Tue, 14 Dec 2021 06:31:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 166 runs, 2 regressions (v4.19.221)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 166 runs, 2 regressions (v4.19.221)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.221/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.221
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5fd3cce374df811af0c71585bc3d1096b04da9c9 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b86c3fd6d0b27628397128

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.221/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.221/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b86c3fd6d0b27628397=
129
        new failure (last pass: v4.19.220) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b86c3bd6d0b2762839711e

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.221/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.221/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b86c3bd6d0b27=
628397121
        failing since 5 days (last pass: v4.19.219, first fail: v4.19.220)
        2 lines

    2021-12-14T10:04:28.152785  <8>[   21.092010] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-14T10:04:28.203788  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2021-12-14T10:04:28.213434  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-14T10:04:28.230374  <8>[   21.170074] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
