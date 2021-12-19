Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF81479FD4
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 08:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhLSHvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 02:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhLSHvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 02:51:36 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B65C061574
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 23:51:35 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id l10so6414706pgm.7
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 23:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eVjLME9c7iGnfMo+KqIYRiv2ZCYA81dyENmAQVbpsrs=;
        b=L0RqSf6nxH4ngCfZWogQHP2G4g7uC5PYeIwWZKHYzh29R72DKo9cxFAdcE/zKyrc/K
         sZTtTkXbVnOx8lp0TN3JTfzfrv+1DV1Z8Xad8A6eq2vx7b5/VFS/CJBaiZNMN80dflZK
         T4p6rLP4Yt99F7mD+6lLbCHF+Ord0Ck5GR/nQn+3CXNBEu02kZly2/mkKjOzRFS2dh73
         IAhTNYzWTnyblMRS0sficGjZpX2j9Kj2dtVumxXElrthCWX7R72KRTJMJokFbzr82V7/
         v1drjJBxYPBfYCGzxH6RJ9HxVFAJWKFUVbgoHgRfPHcyxjF8zHYF1zeH29Sj4wTGzSXN
         8G/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eVjLME9c7iGnfMo+KqIYRiv2ZCYA81dyENmAQVbpsrs=;
        b=m93SONfORtU2qBlqE4RmrfTDPNdP87lQChXc3nsA0jaxhht+WeGdZh3KVA9iODOqtY
         LiUNy/raOtSI3Zt52oF2GLdiLZMZ6V0pOZVu+FZPL6++uOnDZE/d9Bs7mZHXltPuT3cn
         mukaZxSyTgFrsOFkvgDYvCHJcShxXLcBUvFFXtytA8LMThvfce/tvn9Del0r/AwCPpC+
         chvHx9wit/V5BHFjAmSc+Lq6TMVdjZ7edgCYq+nysZNz+v4KPPkHtTJ88XMhZWJghwAw
         osuvBSRqUN4KP/g51pilbubhMGGPUw0z4LTHNY+4og+lEBEZo3S4Z9KBHWluuDg2UGaL
         ddgw==
X-Gm-Message-State: AOAM533bX9PPLcoufmPiQ0atqXb85EcHVXV49EZh3Avd8idO+X5I75EC
        Q7TRtzbmLJYupZwgOtrDHcuSmxcwboGQL840
X-Google-Smtp-Source: ABdhPJykduTT3XQwFpaOuo2gVjB0Gb1yTfyeGW11Z9W1TaBqFhVbxI3+flgOIbj73G6JJdujGcUf2A==
X-Received: by 2002:a63:1b02:: with SMTP id b2mr9868265pgb.263.1639900293619;
        Sat, 18 Dec 2021 23:51:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cm20sm2531294pjb.28.2021.12.18.23.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 23:51:33 -0800 (PST)
Message-ID: <61bee485.1c69fb81.65102.711c@mx.google.com>
Date:   Sat, 18 Dec 2021 23:51:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-14-g3ad6fc25fc02
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 131 runs,
 2 regressions (v4.9.293-14-g3ad6fc25fc02)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 131 runs, 2 regressions (v4.9.293-14-g3ad6fc2=
5fc02)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-14-g3ad6fc25fc02/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-14-g3ad6fc25fc02
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3ad6fc25fc02c7d4e52e37fcf6e762c6201c5c5a =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61beb1fb84920dbf0239716c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
4-g3ad6fc25fc02/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
4-g3ad6fc25fc02/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61beb1fb84920dbf02397=
16d
        failing since 0 day (last pass: v4.9.293-7-g5494b85558f4, first fai=
l: v4.9.293-11-g717774ccabbc) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61beb3b4e81a2db6c639711e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
4-g3ad6fc25fc02/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
4-g3ad6fc25fc02/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61beb3b4e81a2db=
6c6397121
        failing since 2 days (last pass: v4.9.293-7-gd89b8545a1fa, first fa=
il: v4.9.293-7-g534f383585ec)
        2 lines

    2021-12-19T04:22:57.146463  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2021-12-19T04:22:57.155179  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
