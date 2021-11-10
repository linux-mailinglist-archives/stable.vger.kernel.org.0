Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DE944C8AB
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 20:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhKJTOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 14:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbhKJTOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 14:14:50 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8C5C061766
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 11:12:02 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id b13so3882783plg.2
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 11:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OXcqtrbNMO5U7M9JiIOidqgXm5vx3DXstP9fneCp3rM=;
        b=m/9WMhhEpAvdVaE9H3yDAI/uLR1IW/DzDXMUL3hu0GWyn1zd7Z6oqilT4m93yAVpa7
         lWFXYiIvbsW/OktN+YoQyuj9zE8zQ+dvVHmIitr+R5XOF8rB+4g0PCK88XD2Hy7TLOlI
         T5Gg4AdhC1o6SxsukbT2G1aJxuT1wZh+ZoblGZe9npG3XQxqY9DoGsCxGTgr/EmzDrh1
         zCMqA+ynuCPFmKHWI6uYRmNU1yNneewJyUfTt4+Rgp9vb7QtXUcBASluxTbe+f/IzPHq
         CiKuL5Ld+25P9ehgDypnRELShj5kCuJA+4wjyKLV8VCfqBkT0dp4Ko7BygINHP3yTN6a
         7OTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OXcqtrbNMO5U7M9JiIOidqgXm5vx3DXstP9fneCp3rM=;
        b=H5dPpPPdHlLtMwKUGTD3rwggv9iwD7TThCGTHUo9cvpXQkOisHHFoFvKTJ5g2WD2+H
         6bkIK6ccrxD5QFs92l0JCo9Y7OS4JyKgSQ3iI2EtpzK1fq/G/IiezvJ4PxWzN5txK3nq
         T8CRTnLd4uoVjW/EbSmEYtXP/xH7mwrOC2qnYdjY9SvqrFkS6gdL8iOtAxKxk3cMF8p3
         6/I7o/cV6uzWbi/6NXPDiu5CBRi8EtjlkPQkxoshj1+NvJW5WQfdjSq9Y7jvaABdbJca
         DI6vorF8fv2XFnlHsX9hGt6L1Uf97LEt1SHxwjH/bDgV6VyXxxfkDQtnVbOaue9Eh0P4
         qyzA==
X-Gm-Message-State: AOAM531k3bkpFuxbsQ9W2ZElY9Fmr6+zhAoXRt8PE4Pj87+nN/z2+lG4
        GfQYNslSFcZpN9c/I3aQ4BZvLt3jRyw+PXnN0e8=
X-Google-Smtp-Source: ABdhPJx/er4iTAcpNR8wtmphW2krZsKKBtb1Z8l2nG4rJAhD0C8b/rqxQHHWtjpe04cV0Q4sS/Z0IA==
X-Received: by 2002:a17:90b:50c:: with SMTP id r12mr19486677pjz.71.1636571521914;
        Wed, 10 Nov 2021 11:12:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x37sm426910pfh.116.2021.11.10.11.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 11:12:01 -0800 (PST)
Message-ID: <618c1981.1c69fb81.4d4eb.1c37@mx.google.com>
Date:   Wed, 10 Nov 2021 11:12:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-9-gf5954069c4ee
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 135 runs,
 1 regressions (v4.4.291-9-gf5954069c4ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 135 runs, 1 regressions (v4.4.291-9-gf5954069=
c4ee)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-9-gf5954069c4ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-9-gf5954069c4ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f5954069c4ee94757bda0b300af90ab596995617 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618be0531cbbd0a80e3358fd

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-9=
-gf5954069c4ee/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-9=
-gf5954069c4ee/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618be0531cbbd0a=
80e335900
        new failure (last pass: v4.4.291-8-g748a6d994abf)
        2 lines

    2021-11-10T15:07:42.113605  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-10T15:07:42.122050  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-10T15:07:42.140858  [   19.252044] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
