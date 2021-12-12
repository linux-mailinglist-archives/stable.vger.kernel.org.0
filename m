Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B73471C44
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 19:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhLLSji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 13:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbhLLSjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 13:39:37 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C504BC061714
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 10:39:37 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 200so3817778pgg.3
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 10:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iViE/t4tkt6jAcbTKfqV6tNtBAt339A+KG8DJILVY/k=;
        b=ruESJCK8lvUlBUQspWTMBpK0zTTtYROw/VdJ6prosSud3ddCyNngVi4AXtTsejMw7L
         uG34aRTb7M3C9RDkdV2jz9s2njbR8F520/RY2UAUxvylS+WQXVsQo6l7+JLOWvDKYPls
         mn2WhcRkgn9htBbbzdGEcJpiHYQalmT/ebAJE3B/yqRwEA7oa6k32uAe865iXBFu80wM
         l7eGE51hQQuIR6qa2PSxGCyd0RQ7uIqXUVULuEalLPdVRUDJzAa5T4L/L1wTqw0BNhhF
         KWsUtNuCPVoSX4B7XLjEWk8vVz49IYUuAsEDVLdl07392NThojGAgPvN3zm+XfZPCFBC
         2miQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iViE/t4tkt6jAcbTKfqV6tNtBAt339A+KG8DJILVY/k=;
        b=cda2QTxxpKaEXiA+KyLxUvs/pI+U+T36ixahAthdl0RZ+CXpuuy0kp3xGE4kthplm+
         UVfWXxri5SxY4kcMXGnMmNwadY+Ds3ORqgnqDI2VVImuX3E3Cyj24uUSvYvgl+Cbd8w+
         pkAq/942GIzcExXTqvLUQttbJr0Ez8Y3a6JZs5DtKjNmtjvS8IjrBB0KQnC+JKVzIGSu
         InthklS0AoPmWm4tpP6lmqxJzTItnW7+1N4xh7EjS5pi6/kb8mwWvRe+tcoRBOdoJx0d
         rnaU3GITF3CTeO8qaUPCszXO66Jr6niyMPIbt3AgI//J0SSDaalo7Zk4KVTf8/iLAS/4
         AAoA==
X-Gm-Message-State: AOAM533a254yafMlxoGCr1opX0ODns+mWEhS8apavuBeNIFpwAlyPY5I
        r2vqUdYFC6PLKj7u2MmPLbdNvGBoKRba+PEJ
X-Google-Smtp-Source: ABdhPJwmp/C1mflvXMT8DoULlaGEXYOjA3b7K7bS4MuBGsCUl+Ow3PVMlbMLSPdNa9xnb9bhNaUsKQ==
X-Received: by 2002:a05:6a00:1693:b0:44c:64a3:d318 with SMTP id k19-20020a056a00169300b0044c64a3d318mr29656180pfc.81.1639334377130;
        Sun, 12 Dec 2021 10:39:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm4599962pjk.41.2021.12.12.10.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 10:39:36 -0800 (PST)
Message-ID: <61b641e8.1c69fb81.764d8.c79f@mx.google.com>
Date:   Sun, 12 Dec 2021 10:39:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.292-15-g517057221bb4
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 146 runs,
 2 regressions (v4.9.292-15-g517057221bb4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 146 runs, 2 regressions (v4.9.292-15-g5170572=
21bb4)

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
el/v4.9.292-15-g517057221bb4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.292-15-g517057221bb4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      517057221bb4d33217dd573f2a9015deff11c692 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61b607a8822f3e648d39718d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-1=
5-g517057221bb4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-1=
5-g517057221bb4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b607a8822f3e648d397=
18e
        failing since 1 day (last pass: v4.9.291-70-gd8115b0fbf8b, first fa=
il: v4.9.292-9-g6988c513714d) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b602c3e66dcabc9739713d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-1=
5-g517057221bb4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-1=
5-g517057221bb4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b602c3e66dcab=
c97397140
        failing since 1 day (last pass: v4.9.292-8-g267327cffca6, first fai=
l: v4.9.292-9-g6988c513714d)
        2 lines

    2021-12-12T14:09:51.547691  [   20.351196] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-12T14:09:51.591223  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-12-12T14:09:51.600726  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
