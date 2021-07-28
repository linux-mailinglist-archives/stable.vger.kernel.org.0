Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC1E3D9273
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbhG1P5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 11:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhG1P5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 11:57:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A36C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 08:57:48 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e21so3221960pla.5
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 08:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VdBWhsCzN+TpZmPju91f22IpZtmfPA96CHIv8RoD7d0=;
        b=tqwpIpDlt9uC/z7eypoF5xeEyku5BcwEVtCDbvT/CozHKWdv3elVNYSwgc9RWOvNMv
         IwtJ+mZs/tLp7KIPuB+msCxWc4JeikBmCDp3Q88xkBlGvO/7N2+dHLUbkOhiNvtvkhux
         GK/sjG5h6OTNNUeBQBOYtq+OxSRv04JCTeoZCozy/X9OFqRWYacJv1myxTFHZVE21KDM
         q90N3XMzDOWH/aVtT+wiIQUTk/s61VSp8zeUy03KIRhtbufEeyWh4HLWbz5jAwf3PVmq
         iC6/jfaKyxrkFh7Wn8aiTxsHrGBzDA0SdjYhoH4O28j/bxMMFQQ0L07Pwt2bsMJYl5NZ
         CtgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VdBWhsCzN+TpZmPju91f22IpZtmfPA96CHIv8RoD7d0=;
        b=gN5YmcUQYxt4MpHvSxaF2md4/6C5xM7Sbs+5RqiQKXMiI+PwSbyR0j+IYnGL5/MQvj
         IxiKAi4GOJnYVNGXxMng8fm5epHEZbgQNzG6jmZhs5AU33uO13I4NJ1Vvr7zXq1QB78K
         fpS88m/LqO67mzXNkg4Ou8cuiOLBYJy5zSEJ2DZ0ZTCpiV9VRR58TOpK2z0ezL00/r/p
         3S1UMXY1BnYTFAn9mhrhIah+D/rLd7GITnrvQ4206Av+wDerjq/KEOkevIcyzWVqMmAI
         OXB/a1IqBjdJ5HLKVjZpjf0o1MWhOGQF99R5QybYnEwjFDJCKKWELCJQdDduHap1V7jD
         0VPA==
X-Gm-Message-State: AOAM532TaKaAvEiD58BGJyuJlnUrWZ6rYmtCRU0L+E5a84QMNPILJFGM
        VUTk8IZ15LuTTq8oMC8S2W8lEU79+SysK/6b
X-Google-Smtp-Source: ABdhPJwxVbtFVeRaEIZOU5gY0S7v0prSHVob2bS9OacP1F8ApHPy+wT+nxUQp7qsJ2WapR1Gw61QtQ==
X-Received: by 2002:aa7:9117:0:b029:35c:4791:ff52 with SMTP id 23-20020aa791170000b029035c4791ff52mr359572pfh.76.1627487867334;
        Wed, 28 Jul 2021 08:57:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 125sm157810pge.34.2021.07.28.08.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 08:57:46 -0700 (PDT)
Message-ID: <61017e7a.1c69fb81.d9664.08d7@mx.google.com>
Date:   Wed, 28 Jul 2021 08:57:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.135-108-g3bc4fefb0124
Subject: stable-rc/queue/5.4 baseline: 152 runs,
 2 regressions (v5.4.135-108-g3bc4fefb0124)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 152 runs, 2 regressions (v5.4.135-108-g3bc4fe=
fb0124)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =

d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.135-108-g3bc4fefb0124/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.135-108-g3bc4fefb0124
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3bc4fefb0124233d0be8f4ff4b92f814c1506706 =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/610145a04d343f17e05018e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-g3bc4fefb0124/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-g3bc4fefb0124/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610145a04d343f17e0501=
8e7
        failing since 16 days (last pass: v5.4.130-4-g2151dbfa7bb2, first f=
ail: v5.4.131-344-g7da707277666) =

 =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/610147088b3d4acca0501924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-g3bc4fefb0124/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-g3bc4fefb0124/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610147088b3d4acca0501=
925
        failing since 16 days (last pass: v5.4.130-4-g2151dbfa7bb2, first f=
ail: v5.4.131-344-g7da707277666) =

 =20
