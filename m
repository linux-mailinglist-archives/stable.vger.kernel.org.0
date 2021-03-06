Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C24432FDE9
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 23:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhCFWzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 17:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhCFWzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 17:55:33 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223B7C06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 14:55:32 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o38so3876952pgm.9
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 14:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b2V86t2C72O2fkaZUbS7ozcHpS4zb7jDdcou508cxiE=;
        b=DXlj6ILtDUD1a0I3SQ7pfD35RLMuGmnTov0SXmz4M9pozNck6JkOWbsZWT1G360ZvR
         HLu747a/P+t6scSkElgMaC9RL0DpnD62jf3Er1S7Vvm91twh6a9khol50rNqwGTxmuKa
         l9XVKHqF74yZLm4ecy781mc9BYklqa0GioUNdUua4esstwNRV5ICcn6zjl+mLspj4CpJ
         EodtY7v0a/ucyNWFjtroq2zYu3XT+seRo8t+CeeSnadofJcrmhbD/b9Hsr5cnOBqKma3
         hfPLRab9ZkyFmkXsDsw0/kO2PVkxEszLfz1ysdrwpsaEKBSklXITTG6SggkDMHuCbhc1
         9+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b2V86t2C72O2fkaZUbS7ozcHpS4zb7jDdcou508cxiE=;
        b=nFhUPjw8r9meau0Uv8Qp/KHH4qrNSxlV44aDmlXzND9l3UuIYnPKVBZtYUTalHJm6/
         Kjo6uuKHWwbuARxcwSr3jIgOIe5+Hg2Yrxed+ey6pPi7SqCDDkBnO9lPaq9Z+kU/soJx
         cOlJmt7Qe6qPAQxxfpO8uaBMIPIOL7Jhr5dGVLqVcz2lUGzlpEOZRr5QkzDyUs1BEDYd
         qhJ5YKZc/FO+rYvLunJdEduluip1JI3msAVkqi7hVD383ohklJebzXsgPFnz9TnOerMz
         SSgragi86JFGoQCWVJSdkUH/69QUDWVULyJpt6+OVYXh6rFVopCM+9qW9RcRkuP8LZZL
         9v6g==
X-Gm-Message-State: AOAM533SeCFASITDvLChUS3CIakbuuiFjUcuFMKW5wPQHS2oUQXEJLtD
        Qcfopt29iZBZafANWyDvWfP26RuA6NVcbA==
X-Google-Smtp-Source: ABdhPJxucdTH+a7aLcAFWxE6DrWBmAzuOZSiMxAUJMnF0Bl3IWM0cKZ8WWNlXWrTPS2xHuKSDgg50w==
X-Received: by 2002:a05:6a00:2a3:b029:1f2:f7f0:adf0 with SMTP id q3-20020a056a0002a3b02901f2f7f0adf0mr3589286pfs.33.1615071331471;
        Sat, 06 Mar 2021 14:55:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 21sm6056397pfo.167.2021.03.06.14.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 14:55:31 -0800 (PST)
Message-ID: <60440863.1c69fb81.95df6.fe91@mx.google.com>
Date:   Sat, 06 Mar 2021 14:55:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.259-41-gd6ba95ac1fa2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 86 runs,
 5 regressions (v4.9.259-41-gd6ba95ac1fa2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 86 runs, 5 regressions (v4.9.259-41-gd6ba95ac=
1fa2)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.259-41-gd6ba95ac1fa2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.259-41-gd6ba95ac1fa2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6ba95ac1fa28d38628fd22d8c1eb4aa607fbfb9 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043d1491989a84ccdaddcd3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gd6ba95ac1fa2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gd6ba95ac1fa2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6043d1491989a84=
ccdaddcd8
        new failure (last pass: v4.9.259-41-gf3059ff21bb9)
        2 lines

    2021-03-06 19:00:21.946000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043d051875232d8f9addd10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gd6ba95ac1fa2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gd6ba95ac1fa2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043d051875232d8f9add=
d11
        failing since 112 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043d0ac6078e386b5addccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gd6ba95ac1fa2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gd6ba95ac1fa2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043d0ac6078e386b5add=
cce
        failing since 112 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043cfeb053feae019addd3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gd6ba95ac1fa2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gd6ba95ac1fa2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043cfeb053feae019add=
d3d
        failing since 112 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043d00300e8af0fe3addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gd6ba95ac1fa2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
1-gd6ba95ac1fa2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043d00300e8af0fe3add=
cc6
        failing since 112 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
