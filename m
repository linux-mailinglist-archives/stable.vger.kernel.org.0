Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FBC44F5AA
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 23:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhKMWzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 17:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbhKMWzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 17:55:10 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23128C061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 14:52:17 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id v19so581624plo.7
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 14:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sX7IO/A7fVmGoCh4iLkukBjo0E52sxIeZkbyepP63jo=;
        b=rqWElWt6QR7U8J5lWUvJZ1Lipdm/M1Pw9vCP8NKUaEH4gTV4nvEPn11IP1Q2Z/4SxF
         ziH/egaKkKPxO0qVC7kslUOe936r0Rg88+qp2WdoMQqLWi8/P6oX0zheA+hW2PQ9EhBp
         T2/xcqJzwVxcCS4uSuLZE0vEBRBb8YqCy7P31tT5Th+fshgeREd3gIdVY3bfUier5kQf
         dGT8GGVBoexPInZek2ClHFu6XnywZr8Zz3fGaTVyx3xzkqaWbDr4JPUGTPlhXmIZpbwT
         Rokrjs1UMh/ddAcjtNqCG1FHURtejZHwVmmEF53tNLwQuHfbIRAcM8kwjLgHXNjn7BnV
         pCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sX7IO/A7fVmGoCh4iLkukBjo0E52sxIeZkbyepP63jo=;
        b=V47WrxVSfB4Yfkq+smevZ6TmtrJFiRyC4Suock4UvcKGpCvPUzxn4mLkXcxVMz2YJD
         QCHZAuuCTpgfZP3yn7nXEKRFKmItM+NYOML2cj6G83iHCQuoQE1tdeOk2WTUNPKzeYm4
         q6lX0dtnEpuKhMwHEzsI4xuFoSLDn+faXOP8TYQ3i5KAGE77XkO11y1jBoMQt1g8Wm7l
         LNRkrczLtaFFxbNCVNf1arH6dfCLM3FlTJAELhGJ6KYMwe4uwGfJefJ5TQjyvSjtbzHv
         EuPdaF+4ZwWzxMzM4L5xyp4sPzJiz2VfyF21fvZa4DdftvH7cV2F+cIRj5RvX4BZl8KE
         M9ww==
X-Gm-Message-State: AOAM531wIPg8tBtH2G0B0PbXN0bHgHFoYPDgw6jpp4ltheQouDOT8r6X
        0xpOAtNQgmbb0iyeJYCETFETPFjVKK0ZI+67
X-Google-Smtp-Source: ABdhPJyd7owxqxezWyQTzKhksJcJ3IGxD20b+qcBulhAB0GLaVIeGXiaTCboSDB6Zgqj5c6E3udacQ==
X-Received: by 2002:a17:90b:1b4a:: with SMTP id nv10mr31445293pjb.87.1636843936472;
        Sat, 13 Nov 2021 14:52:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t4sm10637648pfj.166.2021.11.13.14.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 14:52:16 -0800 (PST)
Message-ID: <619041a0.1c69fb81.95f7c.dbcf@mx.google.com>
Date:   Sat, 13 Nov 2021 14:52:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-35-gf481b21305a4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 131 runs,
 1 regressions (v4.4.292-35-gf481b21305a4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 131 runs, 1 regressions (v4.4.292-35-gf481b21=
305a4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-35-gf481b21305a4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-35-gf481b21305a4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f481b21305a43d5bef683e60cfa38262a8cee1d6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619008e4df5009575b3358fe

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-3=
5-gf481b21305a4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-3=
5-gf481b21305a4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619008e4df50095=
75b335901
        new failure (last pass: v4.4.292-35-g08732977a551)
        2 lines

    2021-11-13T18:49:52.608540  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-11-13T18:49:52.617758  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-13T18:49:52.633308  [   19.207702] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
