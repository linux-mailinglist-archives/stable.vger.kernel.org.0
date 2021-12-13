Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C862F473079
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbhLMP36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbhLMP34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 10:29:56 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964F9C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 07:29:56 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r5so14873738pgi.6
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 07:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IHlXRJ2c5Qq7dS5s+v/jhOhr/Vdg3KxdanAdxYsMVRU=;
        b=7RooBtkVAwzyveJvJ0D1Jo9vjoeWqPCS2P3uTDooO7XmzzFsfIge5GHVl7I16tte4R
         4JaPeq15std28G2oWPwSL2u2lQQh4w1TkhS2kHfPPKhYSUbVWwB3cPyx+rfhzi9tTORo
         z1stegbA3mk4FyC4zNWCKjcaz8GWIgSatTqfKdVJYQiFMS+erkKUOUtZgzJ1lm6EhzM/
         fsVCOwPXX1IoYs8hJZFf/08Nyzn2nTi/hRzT6KzPDrj576qUsYqX1HzMg8/lWWK9VavU
         S4M0pBKEeryHX5JJonzPGV6/f1b9VdEl4IXpDNzrnhee9swbCrRuWPUWqxfT/8Puy3zp
         wPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IHlXRJ2c5Qq7dS5s+v/jhOhr/Vdg3KxdanAdxYsMVRU=;
        b=1ZNG9qCAK3jXzpX/VVb6PCOobMzsxQjh6T5t4VQWJbkpxT4kxbYM00ZvXhe8WPG930
         QbXfg99JveCAbFflv6EclXOuOIGHuNZDt/WGwEd+C/pz//Y264+nXg9Q4/RA+u98qCX4
         0i3VHDQVQi5UJzEMg0WhRp9mXO0G4BtRoKVsAt6nobjlXG2E+4PcfRHbrep+VSpcNJxM
         Pi1eYwAJePukX3juGzA+R9uOMBDqPdwpImbhGY2Mgc5Q0WtBcUD061aVUJOBYIhY/Nf9
         ouTymLBGax4Ey172hmgMOqdcwofEg9AxjjWwzcyz7dDrvU/kuYOewORMwy741O3c/ba6
         xvqg==
X-Gm-Message-State: AOAM532ofO7p0A7WDOynZ4bijiKY8GRldZzeny7kQ77EREMrJDrSj5o7
        LBLQZVqbnlkdDJaF8hAJAl1zFrMLBDFV6iiU
X-Google-Smtp-Source: ABdhPJzBvdgvnS+3hEQsEXY1vFkyzp9K1APEmiHVzcbPR4HoRgirDu0zOOTSNMY8D8/Uiqs7zxM7QQ==
X-Received: by 2002:a63:e555:: with SMTP id z21mr1632864pgj.555.1639409395836;
        Mon, 13 Dec 2021 07:29:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mm22sm7368229pjb.28.2021.12.13.07.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 07:29:55 -0800 (PST)
Message-ID: <61b766f3.1c69fb81.8b6cf.391c@mx.google.com>
Date:   Mon, 13 Dec 2021 07:29:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.257-53-gbe1979ab4cd9
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 148 runs,
 3 regressions (v4.14.257-53-gbe1979ab4cd9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 148 runs, 3 regressions (v4.14.257-53-gbe197=
9ab4cd9)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
i945gsex-qs              | i386   | lab-clabbe    | gcc-10   | i386_defconf=
ig      | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.257-53-gbe1979ab4cd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.257-53-gbe1979ab4cd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be1979ab4cd95c4cb1f03d1d8fc91ca0b1cb8df6 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
i945gsex-qs              | i386   | lab-clabbe    | gcc-10   | i386_defconf=
ig      | 1          =


  Details:     https://kernelci.org/test/plan/id/61b72cd883379487733971a5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-gbe1979ab4cd9/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-gbe1979ab4cd9/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b72cd88337948=
7733971aa
        new failure (last pass: v4.14.257-33-gcf9830f3ce18)
        1 lines

    2021-12-13T11:21:38.998644  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-12-13T11:21:39.007744  [   12.606506] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61b72e0d223ff35e69397128

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-gbe1979ab4cd9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-gbe1979ab4cd9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b72e0d223ff35e69397=
129
        new failure (last pass: v4.14.257-33-gcf9830f3ce18) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b72c77fe764316de397125

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-gbe1979ab4cd9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-gbe1979ab4cd9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b72c77fe76431=
6de397128
        new failure (last pass: v4.14.257-33-gcf9830f3ce18)
        2 lines

    2021-12-13T11:20:06.014310  [   20.154296] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-13T11:20:06.057524  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2021-12-13T11:20:06.066668  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
