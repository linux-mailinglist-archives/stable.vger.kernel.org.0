Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065F2471C45
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 19:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhLLSjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 13:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbhLLSjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 13:39:39 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E357C061714
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 10:39:39 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id p13so13103386pfw.2
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 10:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZPAjk8VNNK6zuiwM59nBQ6jr6fMkt3SMEZOKz3bj+EY=;
        b=5p8FIGR/1aaq0kqcMDAWdDRBc3Z+oJbbjRQewCH9+rbpkv3Dg2xXYcOLCtGfQqPf05
         Wd+f6kYaw32h9vgvB658ziTZfKh7VdlnUbf1PE5Qs6eODQDZ/Wvh7pYFbNf3F+eDTg+q
         oNGakUJKWRKrzF/iAi93cNbxijX5bPZyxQWhT9r7QUi6bQTmAso0WdyXLPVdllqTPVb9
         DfKTLWbdIUEdOdDZSs+c/NditazBEmQogP0Wr22vdR2qC9fqTGiiNpuL9XCjAYyxn6r2
         hpQg60hgtr8q6BPVnW0L6swVjKS3BYtQJ27A0bcx3jS4y76k+/hAud9Rb4xA4g0M8Gza
         P7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZPAjk8VNNK6zuiwM59nBQ6jr6fMkt3SMEZOKz3bj+EY=;
        b=UQ5Zc0krqUmptXYDqgH5eeEV2xM3jPRAc+j9v7zgHC0pfOVK1dw7/kzGsA6PCZehSM
         LoszGd8VYCNbzGQExM3Vzpr0Iuvw/nnFlYGApqiuK1Gt8Lr+h5TrfgBMI4Ahg9vz3OdC
         cjXRRe/4Fi7gDuJgbvAiukAqxafnhfOXkuH02OAG7njCf4LJaSy0W9yPvlAc6hGrkr5P
         J70wlK7/FvdiqQxyXOTObfIKlnIiZXAMoHuiXfQdORi/xkRgGSSBLgYMqdV8Tj7ocMQl
         0KdQguQitpoE7xKih9BVCN85Hm3faZS+0LpODwSv1FNP6HqvYQHH90wOakVl2S0+Vpnb
         JREQ==
X-Gm-Message-State: AOAM530lftb+GrjsKcuSh8W0H0PEDnSiOcuSHs+Bgu490DkcZqyddj+e
        0QwDqt90yQZFSLN89c6kAx472RoDi7eC86vi
X-Google-Smtp-Source: ABdhPJyaDV5D5Ig9azwXQUr1P8jQrM/54rdpoXjiektQQdrnfhGkZlcirkPigkHa4pk9cWN1SLK+NQ==
X-Received: by 2002:a63:74b:: with SMTP id 72mr813053pgh.231.1639334378486;
        Sun, 12 Dec 2021 10:39:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18sm10255580pfk.68.2021.12.12.10.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 10:39:38 -0800 (PST)
Message-ID: <61b641ea.1c69fb81.16708.cb8d@mx.google.com>
Date:   Sun, 12 Dec 2021 10:39:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.257-17-gfd94faa4f23b
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 173 runs,
 2 regressions (v4.14.257-17-gfd94faa4f23b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 173 runs, 2 regressions (v4.14.257-17-gfd94f=
aa4f23b)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.257-17-gfd94faa4f23b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.257-17-gfd94faa4f23b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd94faa4f23b4b4ac484caa1e50bdf8201bb7bbf =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b60c88e716cd4558397129

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-17-gfd94faa4f23b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-17-gfd94faa4f23b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b60c88e716cd4558397=
12a
        new failure (last pass: v4.14.257-12-ga650c963d9c8) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b60cc51772ae85e639712b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-17-gfd94faa4f23b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-17-gfd94faa4f23b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b60cc51772ae8=
5e639712e
        failing since 1 day (last pass: v4.14.256-106-g42fb555ea765, first =
fail: v4.14.257-7-gb7688924d160)
        2 lines

    2021-12-12T14:52:35.548127  [   20.016815] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-12T14:52:35.589745  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2021-12-12T14:52:35.598971  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
