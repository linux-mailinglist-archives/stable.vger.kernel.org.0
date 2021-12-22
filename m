Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42ECB47DA76
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 00:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245390AbhLVXWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 18:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245371AbhLVXWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 18:22:37 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1F0C061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 15:22:37 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id iy13so3489307pjb.5
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 15:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=watEAo0TctoIMHj16unMxi7M7gSHnxu/SRSGf6Txo8c=;
        b=gQuwPF/zGGKcR20XIMTsZFhzSy8meyqG+JZkmgZdTT6o19D+rWdA20pJrtB8LpJZXO
         8EsxKbaMRg/qJZ0GTDkTY6UAUCrdqIWas/3deqjmbdqvzwxX836Bw9SGlRAC1gqxjMS8
         z2cdw46EhIvo0275eXR6l/OTrDhoQVA8g4u7gB2aRup7w29XS2ZGkuVMZ59r1XgRJw2V
         fxwswds1QoYAr5N78CC47Ej1UxppsF/jiHFyyogtCJXRAknHCLqflt57HrRFQn7tf5ZW
         Lqfne5GQC9qHrRAMTqjOs6OMEJ5GQJqHit7x14RDU/k5vTdEqKBTVw/C08nalypkAsol
         zS/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=watEAo0TctoIMHj16unMxi7M7gSHnxu/SRSGf6Txo8c=;
        b=ZtO0OSSP84RyqfE31UZ3Jcmuf/BENDSmPqcxzGUkV8esDWtAQcXbC+MAZDPimuElP/
         nEv9tQ7wenL6f9o0Z6NYWAZUjGnKiQnO7vMqvUpQu5y17OeUyHhjEuyVAkgHr5orecTH
         vhVuQSkYQOC98Oj6VQN3xawgTMw2blc3VqVVf3r0UJaC/APp1FPikvNRjMdThmZqRIjV
         xgn6eW6btnOSHZhm3yw6vPMJVXoit2CSoiG+9cxiGj3hR6lT+pkEzAkxE2CysS2db8hG
         NEG+hsDkKqjbiOM2KPaU7B+XlxHGb3X/z+/TXopcVcg733q3YI2nhS2GPCk6F7G5p3m/
         5vXQ==
X-Gm-Message-State: AOAM530gkjzFSc7KDUWKoGMgnfSJj/vKV5gGLeTBpEddu+QmC0iB+Bkh
        k2uwrurovdses8h0EjfAK7gfb3nlADDNs81gaxc=
X-Google-Smtp-Source: ABdhPJy15MDCvnPGWjAmJ5mBwv3EoKEiwCQjouiIZqGaEbqiMzeZMMt2uSZJkEZJzaaa51jpZsKhMg==
X-Received: by 2002:a17:902:7c02:b0:148:a2f7:9d6d with SMTP id x2-20020a1709027c0200b00148a2f79d6dmr4994096pll.140.1640215356385;
        Wed, 22 Dec 2021 15:22:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k18sm3917050pfc.155.2021.12.22.15.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 15:22:35 -0800 (PST)
Message-ID: <61c3b33b.1c69fb81.705e3.b000@mx.google.com>
Date:   Wed, 22 Dec 2021 15:22:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.294-3-gf62d2edb6c14
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 121 runs,
 2 regressions (v4.9.294-3-gf62d2edb6c14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 121 runs, 2 regressions (v4.9.294-3-gf62d2edb=
6c14)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.294-3-gf62d2edb6c14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.294-3-gf62d2edb6c14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f62d2edb6c146322ad62c770d95c7e9de4a34e59 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61c37b5044453171ed39711f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-3=
-gf62d2edb6c14/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-3=
-gf62d2edb6c14/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c37b5044453171ed397=
120
        failing since 1 day (last pass: v4.9.293-15-g3fbbbaf0d213, first fa=
il: v4.9.293-31-g9d50eae56b67) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c37c92b260eb8016397154

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-3=
-gf62d2edb6c14/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-3=
-gf62d2edb6c14/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c37c92b260eb8=
016397157
        failing since 5 days (last pass: v4.9.293-7-gd89b8545a1fa, first fa=
il: v4.9.293-7-g534f383585ec)
        2 lines

    2021-12-22T19:29:04.378051  [   20.282684] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-22T19:29:04.428358  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-12-22T19:29:04.437918  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
