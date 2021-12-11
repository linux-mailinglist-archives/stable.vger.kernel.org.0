Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B33470F2E
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243876AbhLKAJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243923AbhLKAJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:09:45 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAB1C061714
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 16:06:09 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id o14so7307689plg.5
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 16:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ogf6c0k7JujWdiZ8OssFxkfPkFnhtgDMUzhRQcqDegM=;
        b=In1qMuNu05MC2TPW8RDtdAHJLpHk3Rn5MaRnu3Vy+O9eBpnYwV7h8dVBO1tRGhnUNJ
         jGfdIfm+9+9IVIIMhEpIUWoMgcwT/ettcxdqC31nrhE0FrRFsEZ2BF5pcj0lNFczAlfc
         CzP6APxk6RcGbgf7ApEPv8fbW7OJM1Z+9OoaK78iT3fm7kYZ6w1/Tcaz+zt9ecH4EHox
         wQ3A47XxsWg7qfpwjKd1agm5sqa/upekW4UWhtKpombd2RRjwWVei6mJeihH/U9oYlGy
         9sdIi0Iv7fBUDcSq1rts/WmUvdkhGfEIXmkbk1vGiXlGJxv2Ua/TOcklGZFBqqcFHQZa
         tq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ogf6c0k7JujWdiZ8OssFxkfPkFnhtgDMUzhRQcqDegM=;
        b=QLQOAv7n9A1mq+GqCOyOSuSnDL/xXNmC8mKfonvncG9Xa4JJRNKvk1NX0orp7ufm+U
         ybehUCZbYtyx6Y4LyWFGXFJ5tYzcmyTduw4LXSRm/Dq5/sjiGayyqE0I6FhsFWqZbLcQ
         Gh+fNXmbON4cEFY1BVPp8aZwgDU2Gtvap8NIsa2RDw+ToUhk/UM+fN4b6/ILZ07gFr1m
         BjChgZ2mLtQFR5/P5xmGoqN0piF1iB1aGcGK4P/3ivkrsQHn4puSQSYF97w1wzeuXmlX
         qeEdccKcCdrOLLI2YIlz4586gHLD919CAu7vX6j22n8gTt/QdcI8MDfmPUeek0RbJHF+
         eQaQ==
X-Gm-Message-State: AOAM5339u2q6VLiATd+EJaR4kPx832GY8KcdQZTcEJxoA0bhFYQNZVKh
        4OR+KBq6DSotyu2jiVawxvLj/OFYdLMdE5qy
X-Google-Smtp-Source: ABdhPJwKqJ3CdL23z6zdMhOEc1YAIm19zOmjQERUsV4twFKy7T4JFrKFxgnMzKYZMk8p5mBXHIIonQ==
X-Received: by 2002:a17:902:b08a:b0:142:51be:57e2 with SMTP id p10-20020a170902b08a00b0014251be57e2mr78793032plr.53.1639181168779;
        Fri, 10 Dec 2021 16:06:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l1sm119189pjh.28.2021.12.10.16.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 16:06:08 -0800 (PST)
Message-ID: <61b3eb70.1c69fb81.a13f1.0931@mx.google.com>
Date:   Fri, 10 Dec 2021 16:06:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.257-12-ga650c963d9c8
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 149 runs,
 2 regressions (v4.14.257-12-ga650c963d9c8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 149 runs, 2 regressions (v4.14.257-12-ga650c=
963d9c8)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.257-12-ga650c963d9c8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.257-12-ga650c963d9c8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a650c963d9c8247d3b4a9c32b5d25abfcd96b2e0 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3b218b5d65f6bdb397143

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-12-ga650c963d9c8/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-12-ga650c963d9c8/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b3b218b5d65f6bdb397=
144
        failing since 0 day (last pass: v4.14.256-106-gdcd74d7b3f01, first =
fail: v4.14.256-113-gb546adcd17c8) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3b15c68deb5ff79397132

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-12-ga650c963d9c8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-12-ga650c963d9c8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b3b15c68deb5f=
f79397135
        failing since 0 day (last pass: v4.14.256-106-g42fb555ea765, first =
fail: v4.14.257-7-gb7688924d160)
        2 lines

    2021-12-10T19:58:02.253991  [   20.084289] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-10T19:58:02.298253  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-12-10T19:58:02.307789  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
