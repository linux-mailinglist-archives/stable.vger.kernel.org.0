Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D282D460A8E
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 23:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358413AbhK1WKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 17:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242169AbhK1WIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 17:08:40 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC821C061756
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:05:23 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r5so13847906pgi.6
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5YgccKgneMLzzUPAvxCOXvyo78NSRQ2xCwrIrRuyJIg=;
        b=TBr/r23Wg7vIjLojhXhyNrqffGExyzm7iMW4GlELRCdZTWNL5MKR09O/s7Rw3wQ6Zt
         +6pd3+oEsH/VgUeab5YXNGTJFFluScWu5qucDMk+wrXPXee+vjHrAg+vE6RUDDAG+MF2
         YLHfX4VpeYmDCKmgpbWOL4zR8U2mReupJFiO9Hft6i5DkGHmPVSobOkJHfxrnrZlem+6
         Uk5zg+6mqdzh3ri30GHHqRy4n45KMDy6t8YAlrqm/c/qEHkNUdWk7FzCzlZOgklayshU
         kJNFEa3LdRehkVJPJZxDiAPdzLMxicM0SvP/zsnYGjWMhxIIn4h1+/FeXf02U8ieaC/q
         N2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5YgccKgneMLzzUPAvxCOXvyo78NSRQ2xCwrIrRuyJIg=;
        b=OUXpevN+V1d36Y6tRhXqChkcaMnu1aJ7VZWIetHox2F5+zLIuYsYLpr/90hVjl6Mbz
         g7ohJxwTdVwMjtHTYcQeYQ+WUwtBCr965rPp6k1rZ7AHgroFRfojZzdzOGPKMaXzn1FF
         DrU7RtsCbs2O5BofnFmZ2C1Ox1Z325EGqT+dA26fR7uvJXa1RCASUU+6HqCeN2dtADW0
         GC1OLTQynCY80K9kWZL2acVZnWO6bRSrYmlzYkwhjTdLKcHX0ASkJWlRgl3+drtG//Z2
         oG6gIzB+HI7uq1HVUDMw6Z+OriaOGj40mmZmAK4KcjoS5raUaWsT8pr3v6ORgAMscXQh
         gOug==
X-Gm-Message-State: AOAM532oJOSK+utLuHUFKWy81XA9mCunLQr6Gr1wlL2BkN3Jh4kCkP9U
        QG5OaBbZs+RSt7U+JD2lcsBjxvz82ioaQ+Dh
X-Google-Smtp-Source: ABdhPJy5i+iCF/EjeJknBlyDyS8O7Qb+cqOiRPS2F5ioGJ5g3ecQlXsPFlntYS7NvKhC8B6jBk0sIQ==
X-Received: by 2002:a05:6a00:1883:b0:49f:a8be:af29 with SMTP id x3-20020a056a00188300b0049fa8beaf29mr34585160pfh.22.1638137123170;
        Sun, 28 Nov 2021 14:05:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t8sm13969019pfe.28.2021.11.28.14.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 14:05:22 -0800 (PST)
Message-ID: <61a3fd22.1c69fb81.80d32.7600@mx.google.com>
Date:   Sun, 28 Nov 2021 14:05:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218-37-g64a98a60fb899
Subject: stable-rc/linux-4.19.y baseline: 151 runs,
 2 regressions (v4.19.218-37-g64a98a60fb899)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 151 runs, 2 regressions (v4.19.218-37-g64a=
98a60fb899)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =

qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.218-37-g64a98a60fb899/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.218-37-g64a98a60fb899
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64a98a60fb8990a42d2afcd274b7419ca74e42bf =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/61a3c66a9fd1dd236918f6ec

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
18-37-g64a98a60fb899/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
18-37-g64a98a60fb899/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a3c66a9fd1dd2=
36918f6f2
        failing since 1 day (last pass: v4.19.217-321-g616d1abb62383, first=
 fail: v4.19.218)
        2 lines

    2021-11-28T18:11:38.286260  <8>[   21.061279] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-28T18:11:38.330461  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-11-28T18:11:38.339770  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61a3c3a56d1185bd3f18f6df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
18-37-g64a98a60fb899/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
18-37-g64a98a60fb899/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a3c3a56d1185bd3f18f=
6e0
        new failure (last pass: v4.19.218) =

 =20
