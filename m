Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361CB46D919
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 18:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237453AbhLHREY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 12:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbhLHREW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 12:04:22 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CFFC061746
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 09:00:50 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u17so1907346plg.9
        for <stable@vger.kernel.org>; Wed, 08 Dec 2021 09:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LYhYNnAsqoxWKw3LHDbPzLhONvpdBfWE/r93TycdRNY=;
        b=SEV5jRuyIczh18+n89G6gjT6MppQOXcWc9ODqkxsxXfI79yFSac3PO7eEc4hYeja8C
         AlWGZRJKtsTSV0lFqjk/ffy4byTae8jjXboKdg81lt1F0spZTD2qd4Oop8blJrSq5wa7
         2/5GoayaeNz+kP26wLDxiVS7/GP5DlLvPVsjAfuvmpr45L54lHkvhahM3g7Q0rU5m64W
         Qn+XfOaqfMOBCFurnMBQl3HOHkRHNuVe1sP/8Ki1j3FnFn91Zs2Yk+i0a8qTz/q52eBV
         skY/9YBEvM9fPI5b+kIzJAR5ZpV6LKJeCy4+4PolFw4qTWlmEMoeEM9H14s+CU/d61R6
         m5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LYhYNnAsqoxWKw3LHDbPzLhONvpdBfWE/r93TycdRNY=;
        b=i63BK4Xx2NxylD5vdpWeLoRBhDDThNDJAfTtYaEkO6Pt0gBVfIt8ezV9NkY4AunYFq
         9PmFwPKzecg0KvG/jrNEKfMkRmZ5x9t4FdneIoVZ1qwi8hdKTNrG9Hs6GOMB7cc+KmzN
         8aGFqf8BZwHldzek2Iezz5YpS85wryghAb1h+xH1UzOmcStXuA/A9jAZRtLUru1RkaDD
         K6hjdT+2ARopNyZ0ajgIMZAHtT+ez5q9EIu052JqfczundOdxvzxs+veJeyxRJQL8coT
         xpy7EHB3uIAAef7c/fXbaCg3fRHGYK+iou8ftj+eWgwM4gDxNg8QBXl5NKPukasUIHxf
         4G6w==
X-Gm-Message-State: AOAM533OQvs4wbSzHjhwoVtOs61IpXsbcjKbyKhbT1YEeDKNqgjuG3NB
        Xvfuaefwjchi4lY8oIc74aTwZYlkZNqzF7V0SqM=
X-Google-Smtp-Source: ABdhPJwmyztCE4ARoqUBQNjIh+IGhfwON9ImVExTf47bCA3rOJrOoKekShn7Ng+cNVNDkkkCRz5+mA==
X-Received: by 2002:a17:902:8f97:b0:143:88c2:e2d5 with SMTP id z23-20020a1709028f9700b0014388c2e2d5mr61087445plo.70.1638982849626;
        Wed, 08 Dec 2021 09:00:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k2sm4539602pfc.53.2021.12.08.09.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 09:00:49 -0800 (PST)
Message-ID: <61b0e4c1.1c69fb81.695a8.c844@mx.google.com>
Date:   Wed, 08 Dec 2021 09:00:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-62-g816c00541db9
Subject: stable-rc/queue/4.9 baseline: 127 runs,
 1 regressions (v4.9.291-62-g816c00541db9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 127 runs, 1 regressions (v4.9.291-62-g816c005=
41db9)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-62-g816c00541db9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-62-g816c00541db9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      816c00541db9814025f5c9e3466c9784fcf91042 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b0ac25645636e56c1a94df

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-6=
2-g816c00541db9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-6=
2-g816c00541db9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b0ac25645636e=
56c1a94e2
        new failure (last pass: v4.9.291-62-ge868da10b6a5)
        2 lines

    2021-12-08T12:58:59.857399  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-12-08T12:58:59.864498  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-08T12:58:59.879735  [   20.433349] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
