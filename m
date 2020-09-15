Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7DA26B05C
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 00:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgIOWIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 18:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbgIOWIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 18:08:43 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920FEC06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 15:08:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id fa1so512411pjb.0
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 15:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3DAHCu6av9V/TNJ/ncoJwzp6UvjvkktPqJ034aSvcAk=;
        b=oaZ5XzaIh3Siidz43EUVT33mGP5PvKVAnvgGIUIc9L25Nbo+9idR4dwpB199YsSxW4
         +tPODZ6CPDLE4GX0A1NU6Yg+Aae2T7jM2BU9L2q9kZ+TMbnzO7VdTFpgUvSrtA/UZcbZ
         ICY1kP+H5foe7irK4zj5w74hThUBp7C7RTTkiu3lZeUhxje/q1EfnoXr6unLPONSajOZ
         B5h466GM6DBceYeAhANM0dFv9oGSCGDWKGUIODuh/kIF1zTkr6m3LAPSjU7OJA0s5e3J
         aru36Leq/kb+F1nZZLxHT3uI0sh0qlHVBdJvMNmcxGIi36u+3ekd6wWq9vW8Zs6TVMLu
         AzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3DAHCu6av9V/TNJ/ncoJwzp6UvjvkktPqJ034aSvcAk=;
        b=sEoYkjUzcvcsPaw11cScKncsVPLWVf+OY4kSEZ4+/Vx6FIXSwW0/LPx2YolfKeimsd
         RoEht08VH8NXi6/Jk8lxe66mbc1SHjB1g2mMrNtWhqzPi0XBcqHxjsXXOJndaNSUIsCY
         Tlnq7mwVx0bBWiK2ymblRj/cT3GVSCSOasW3NoVGhxRDZVI1p6EpzN21LeQCQ+ZXAxre
         Coc7szlIyQd2QGVE9/6uI0NBzRxdi5V8IHs7SLwbkwAILuexWpt6oda9bkYIwJ+CXJAd
         LU04QsJFCpW+JfYwdbXoOAdXrTeQo0on5ieyt6ZKIs1Pm+7NZyHPTeugbFClEnGCx/hz
         tYZg==
X-Gm-Message-State: AOAM533Y15zzMZJic6jOHLNOjig/45bqQmWVfKv5IMI2KijXG2hVtzXP
        E35S72yc8rIauCokRFyCfHcUnenLAuSQeg==
X-Google-Smtp-Source: ABdhPJxPhlSGNQOAiMWFB2UmRkR4CdXh+j2xzu59+xM/azrKzBJTCN0FeMLOv+LNH4EzZtTbL32GTA==
X-Received: by 2002:a17:90a:6701:: with SMTP id n1mr1285790pjj.87.1600207721757;
        Tue, 15 Sep 2020 15:08:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m20sm14955814pfa.115.2020.09.15.15.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 15:08:40 -0700 (PDT)
Message-ID: <5f613b68.1c69fb81.379b2.6ddb@mx.google.com>
Date:   Tue, 15 Sep 2020 15:08:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.145-79-ge92f22c53d42
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 152 runs,
 2 regressions (v4.19.145-79-ge92f22c53d42)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 152 runs, 2 regressions (v4.19.145-79-ge92=
f22c53d42)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =

hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.145-79-ge92f22c53d42/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.145-79-ge92f22c53d42
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e92f22c53d42d29bd65909f4e01be1c0e0853765 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f61090ca22605b406bed979

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
45-79-ge92f22c53d42/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
45-79-ge92f22c53d42/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f61090ca22605b406bed=
97a
      failing since 91 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88)  =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f610856c9b98ab162bed94a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
45-79-ge92f22c53d42/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
45-79-ge92f22c53d42/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f610856c9b98ab162bed=
94b
      failing since 57 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
