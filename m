Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28D24A69BF
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 02:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbiBBB63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 20:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbiBBB63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 20:58:29 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF9FC061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 17:58:29 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r137so1325381pgr.7
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 17:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d+AmNOWQqvmC+g9XlT9xISkpAN6NOqUlJWlO32YO76A=;
        b=kv71t1E+3VbXhZsvks+1fR1ZePrSyT6VVQiTILuGeaNvL2+hRvDIBKRoSZ13zzpWJe
         qYkgzA4edtrOgPAKpjan/9KNThaRORheoq1t4Sm/zi6rDlf4H+Y871n1ojFtpqDaRoBU
         E/Fk5sNldLxVXpvh1xPbj91IuGa7v3rMuXGFQufiXvW2kVYXHzn7df2SR9hoysKbmdjj
         mFLq94lknmVStutibQlsCbA/xaWa+aXouT4Q0vsq55/Rzq6q0WqCdTUaltJXcNe1Z5fX
         YU4+pnnO0y4BhIi7gZjINCQgFSoXmQGZg8Y4jdfhggThOQ1qtAHjT2Yklb5O2UPhXiU1
         Af/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d+AmNOWQqvmC+g9XlT9xISkpAN6NOqUlJWlO32YO76A=;
        b=ehec6YwYjaN0BDH1bTNoUGaT14IeGKRWbAIpLw7X5/L47M3AtIe9cqW4LYGpyk2Cyx
         QjTvKlh9a9z/PADSSHv8zIZnAOfhLpgy9x6j7LF3oLURK4Luj0F0BnmWAGaDmGeG5xpD
         IkqyMXIGeRwb3CvAT1KAiV3S9+sgRi796YJ2Hz1Ix6RXJMjDqb6tuVHBaTFKaNEzZsIf
         mR/SDejAB8vOFKONgXqhXvR+mgM9zT2LzbAFIejdQ8XwGuYmOhIigKf7LmorMN2HPT/0
         VJpsWNookrYNO9i1xNd7UXNguVU1ycabteyf4kV0Aps5WY839BJutAW9KEm9fxOAYuJn
         aS2w==
X-Gm-Message-State: AOAM531rVpDJdudOW+0EaaFVExZZCKwJi8CHvWCj4aAwwAtP7r/rWE4D
        8bJmkzYO35tukvxQmR8HjRlsYxMRGKv3hetk
X-Google-Smtp-Source: ABdhPJySEq1fj24dfdejQ2268yEncVPUyadNclZstUZR+BCZJWUPJXdii1Ci6pPeEecB3dxTBCfRHA==
X-Received: by 2002:a62:3686:: with SMTP id d128mr27643958pfa.63.1643767108458;
        Tue, 01 Feb 2022 17:58:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9sm3845555pjg.44.2022.02.01.17.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 17:58:28 -0800 (PST)
Message-ID: <61f9e544.1c69fb81.5625c.b176@mx.google.com>
Date:   Tue, 01 Feb 2022 17:58:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.301-25-g6565be02586d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 120 runs,
 1 regressions (v4.4.301-25-g6565be02586d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 120 runs, 1 regressions (v4.4.301-25-g6565be0=
2586d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.301-25-g6565be02586d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.301-25-g6565be02586d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6565be02586d18eafffc443ddc84eff2ea35a9a3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f9ad816bd4792a465d6f0b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
5-g6565be02586d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
5-g6565be02586d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f9ad816bd4792=
a465d6f11
        failing since 0 day (last pass: v4.4.301-21-gf1b3a01fec55, first fa=
il: v4.4.301-21-g4b4eb3554fea)
        2 lines

    2022-02-01T22:00:12.956712  [   19.136047] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-01T22:00:13.007441  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2022-02-01T22:00:13.016810  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
