Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6148645DEBB
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 17:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356458AbhKYQuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 11:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356496AbhKYQsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 11:48:10 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9A3C0619DB
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 08:27:51 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id u80so6336601pfc.9
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 08:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JrqHFkb4l6EuedP/AlQ3Xk4mYzxQ6EdumeWmJ5shYM0=;
        b=3OWAdTJ66kWwLJFks91biDOMBo8RmmKX6cpz5Io3ZOgOcAn33d5XywK9Z8Bb/phupt
         XsFHOXWTGzEpJhiZA3Vw6fJlpojj6w2bOd1/ZlMPvSbdv6kfdpmjnr3FYK4z5ikxiMub
         dAh2qaoikAn9lbBkf3vXKUQuuGOM3f7IcwFcRegfvJLH74ZKZLChSRWi/HprxsIXcEv4
         dvKH0oG6rVu1Wd2amqrej1cwMHVqey6iY0i2UnO3bnS+6nCbfuBuL9Qz6ilPofVfOu0R
         ClUQrW/7069iD/545vifpDDCc6viRje1yS0ZupMyDtU4X+1OSwKypMwBJHzx1z8XvvBW
         2RHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JrqHFkb4l6EuedP/AlQ3Xk4mYzxQ6EdumeWmJ5shYM0=;
        b=rRIA3csOSm55urCExFTQw0sOMxTgn3+TgzPrAEoGrhXh9PJesTKR5y51bNPCwamkaP
         19nmk8ju6cJu+zlcyzC4Cv0i0Y++aHcWx3J5kikLPaob2blF+h98JfkkgDoqxdcCyBCm
         1MkZLCGhEkEJnex8h/0nffpKNp+SCn94i/JUypfLBvZwKIa8rJavbSqrde59075maZmy
         em2zwlH9azRnaFtQGLDI7l3Y7QotwvdFPiNYmTiMdlpnLLyjwzJVoW52R0SnJ2YYCJYG
         b/iWnCcarPiZYza1jrwVhuaqxjHKRCMKKI1CS5ESFAiMDQh6su7KQGCpCEnHQJpnoBMn
         p1pw==
X-Gm-Message-State: AOAM530NC2yabIuuDPQrskI1spn7Ant3rOOtRVJdqiFI2KC5WfMBYpLu
        6nYOfEjf7ppNBw/INZnDjIOe0piz8eI4KoUsUfI=
X-Google-Smtp-Source: ABdhPJwPj86s2xzpuYaGqajF7UtXAtTq6O0IhDmXP51E4ym0yNqv9ITJL9WujxUEUhSC0ubqMhSS0g==
X-Received: by 2002:a63:eb46:: with SMTP id b6mr2925469pgk.550.1637857671063;
        Thu, 25 Nov 2021 08:27:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g20sm4630202pfj.12.2021.11.25.08.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 08:27:50 -0800 (PST)
Message-ID: <619fb986.1c69fb81.439cc.bdf2@mx.google.com>
Date:   Thu, 25 Nov 2021 08:27:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-160-ga4f1dd290df8
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 99 runs,
 4 regressions (v4.4.292-160-ga4f1dd290df8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 99 runs, 4 regressions (v4.4.292-160-ga4f1dd2=
90df8)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =

qemu_x86_64      | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =

qemu_x86_64      | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    =
         | 1          =

qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defconfig    =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-160-ga4f1dd290df8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-160-ga4f1dd290df8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a4f1dd290df803fcb4aef1430dc48ac3486b760b =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/619f7f78d5b8894063f2efc9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-ga4f1dd290df8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-ga4f1dd290df8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619f7f78d5b8894=
063f2efcc
        failing since 0 day (last pass: v4.4.292-160-geb7fba21283a, first f=
ail: v4.4.292-160-g4d766382518e6)
        2 lines

    2021-11-25T12:19:47.860965  [   19.131225] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T12:19:47.904488  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-11-25T12:19:47.913695  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64      | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/619f888f0294572ec5f2ef9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-ga4f1dd290df8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-ga4f1dd290df8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f888f0294572ec5f2e=
fa0
        new failure (last pass: v4.4.292-160-g4d766382518e6) =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64      | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/619f917a2999fdddacf2efd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-ga4f1dd290df8/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-ga4f1dd290df8/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f917a2999fdddacf2e=
fd8
        new failure (last pass: v4.4.292-160-g4d766382518e6) =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defconfig    =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/619f81afa2b4f705cbf2efa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-ga4f1dd290df8/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86_6=
4-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-ga4f1dd290df8/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86_6=
4-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f81afa2b4f705cbf2e=
fa7
        new failure (last pass: v4.4.292-160-g4d766382518e6) =

 =20
