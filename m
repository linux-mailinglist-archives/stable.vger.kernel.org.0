Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C355E4516EB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 22:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345810AbhKOVwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 16:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351337AbhKOVri (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 16:47:38 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EC8C0432D3
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 13:24:02 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id b68so16123228pfg.11
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 13:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tcS5luizrzD/4F4BUGufFxJKJR6hYL4mqlHIV/Uj8qw=;
        b=PsK0nEAEIMSokI8Jw7V3eyCWywvNkQ06zFZzPrIiIAx9RdtlJn+jmip0cqjs203FTq
         1MSu4NcI4GX+drwgEidLRuN9gHVXsOHKqf3311ThWvFN4acbwpsSReltAymdYnDU+uk1
         RLeMJqh95tjtH277QhELTXm3E0qpAoYy0YjgD/6h/TylWQAopsi8CijeB6pieil8mAtA
         xn+7p/Ai8pOoMyoC41RlTjoU6vm39bHnmvsS5Pb3y6W81PaxhKH+WzjGyExlyxkErYeC
         FKipiq/IQ80wtcminub2pcireFelMRPGZx2ZN1S5FO8BAYjBGTADH2LbDnjLb0KFyLxV
         yq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tcS5luizrzD/4F4BUGufFxJKJR6hYL4mqlHIV/Uj8qw=;
        b=IvtvvPvJKV1CDnPpTYRvw3JvZWEMqYd8mG8rqoZOf2NNbKYhOfte0UBTYzMYwSotR8
         dTii3tYTpD2oBU8HF5RCq46w1Rv/jzqN/GnHN8VHPxS/59d4q/N7QOoTybLuo+NqS8eW
         Zc3vg6fU2HnZtGUXnlO850rNBeLQLOgZ9dP6sv9NPc5MCegjvjDFeiBNJ6Tsyi3Hf+cg
         RZx7yKt+XkHJH0tIanptGBldVf6mhafjlxfOxJbqGQGBnFfaRt9LAHoQtsK+ksh/7FMO
         fOQ3IRfh25n5zXQO3qp0Odoid8c2sDHKKOMYX2iWFzfH4CtaeQSLxC0qEdUXGLV0v50m
         rDVw==
X-Gm-Message-State: AOAM530+wlhgTNlr0yhmN4Ro8YbpH07KfhEsrIV3iIlqIWHuaILoWpog
        SuftMPP+PhwyeV9vafbnnK8peWm/YB9WQFKc
X-Google-Smtp-Source: ABdhPJyOTJVDzPIEkAHGwVYRl9tAxhYx9UzSolfbpeKiodCVkJs+GRJ6TxwJ/yTAW34nG3BXDB2Piw==
X-Received: by 2002:a65:6a12:: with SMTP id m18mr1407401pgu.124.1637011441831;
        Mon, 15 Nov 2021 13:24:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z3sm15958934pfh.79.2021.11.15.13.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 13:24:01 -0800 (PST)
Message-ID: <6192cff1.1c69fb81.d96cb.e30f@mx.google.com>
Date:   Mon, 15 Nov 2021 13:24:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-159-gcb74f3cdcc0d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 120 runs,
 2 regressions (v4.9.290-159-gcb74f3cdcc0d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 120 runs, 2 regressions (v4.9.290-159-gcb74f3=
cdcc0d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-159-gcb74f3cdcc0d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-159-gcb74f3cdcc0d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb74f3cdcc0d1f4348cff79ad701468d7bb2cd4d =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6192951c9dc96802203358e2

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gcb74f3cdcc0d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gcb74f3cdcc0d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6192951c9dc9680=
2203358e5
        failing since 0 day (last pass: v4.9.290-56-g5c0fdc0dbedd, first fa=
il: v4.9.290-153-g690c63d8995e7)
        2 lines

    2021-11-15T17:12:43.142020  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-11-15T17:12:43.151059  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/6192957783abce831d33596d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gcb74f3cdcc0d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gcb74f3cdcc0d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192957783abce831d335=
96e
        new failure (last pass: v4.9.290-46-g1993e44ad53b) =

 =20
