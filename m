Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4934457DA
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 18:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhKDRE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 13:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbhKDREP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 13:04:15 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC2BC06120B
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 10:01:37 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id p8so4622992pgh.11
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 10:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0wG62w7f9oh6pmCJxVA+Uz0sfQPt/CueVesAkznSMx8=;
        b=u+WU2k9P/MaR2NrObm96iIN9inlHZhHq5+Gv7gCAGlUbbQ/V48WKEk6bNDedTX0a4+
         3PqjUwKsXQy5XKSNA+//KnipOyme3fM9JNtOd5tPi3Rpg9BIsSd+wSZV2JZgkRqPWfeF
         ev6/5hn8lHbfVqTP7lewF0Ei4D78DNGosrUnoDgQz5H0GpW/GysFaR+uNcqokSXkXWF4
         LKjYXTcpOw5FCt2yobPyZIL41XgBXjQHa99hsOpBo4uIWAdChr24Mm2/YasI1nm8Yqc+
         rg6AZJfsV1Z2n68er9Xugyb/2shaLxJEcFABlVCalN7bWnqcbA1CrwClAzFZRXCPcjY+
         3zlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0wG62w7f9oh6pmCJxVA+Uz0sfQPt/CueVesAkznSMx8=;
        b=KK/n9KTPrMot69mk518RyGDw1eUo9+KocQWS5rEBe4svRz+8gALkrJawPq8jI0PyFu
         yiIDlt7w6zgaPN8bMFNeLYgFOKPw4wtC/Gs3ADLTZ8+EyNFp1Ic4nyNzNxjEp20rl73g
         K/GBlLrsZQ9WIuSoKLiixNIxR0yrd4E2i3i/LXbtxIp3MNlrmfZyIjGlqqF8y/j6h2Xe
         OUpF9edI5BQdPuMEHMdoCyv5QMxgbWvH6Lk6GaugTkNfIZKJp3sTfk90d9TczNdHfRWw
         nFtX81SolagPFuwA6LxrF93q4rfGaiItvbHovhm1kWvCCKFvFe3nLn9e70e+gkzYr+WM
         Ba/A==
X-Gm-Message-State: AOAM533Ah4X8YISYGwDGq/SwLV0J43ySOxenG+IFpB8mM7t13wNwjjuC
        Hb90+eyzEjFiMJn+w9ojDFQCkQHHbGk1NuX9
X-Google-Smtp-Source: ABdhPJzhldnUxFklFz50rWQdspm6YrFip08yK3NgnfcY4FpIH8rilA1rR5LbVxAMjiTc+vWt9mAFbA==
X-Received: by 2002:aa7:88d6:0:b0:481:9d9:3baa with SMTP id k22-20020aa788d6000000b0048109d93baamr32097356pff.71.1636045296474;
        Thu, 04 Nov 2021 10:01:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t80sm1044266pgb.26.2021.11.04.10.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 10:01:36 -0700 (PDT)
Message-ID: <618411f0.1c69fb81.c9e2a.2af0@mx.google.com>
Date:   Thu, 04 Nov 2021 10:01:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-4-g3d5f9eb42922
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 89 runs,
 1 regressions (v4.9.289-4-g3d5f9eb42922)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 89 runs, 1 regressions (v4.9.289-4-g3d5f9eb42=
922)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-4-g3d5f9eb42922/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-4-g3d5f9eb42922
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3d5f9eb42922c7f672ffa0a5e5d964ab20c58398 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6183de566d8887a1ce33590c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-4=
-g3d5f9eb42922/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-4=
-g3d5f9eb42922/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6183de566d8887a=
1ce33590f
        failing since 3 days (last pass: v4.9.288-20-g1a0db32ed119, first f=
ail: v4.9.288-20-g7720b834ad25)
        2 lines

    2021-11-04T13:21:07.943790  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/127
    2021-11-04T13:21:07.953805  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
