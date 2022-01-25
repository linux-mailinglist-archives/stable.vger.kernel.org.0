Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F36049BEB8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 23:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiAYWjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 17:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiAYWjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 17:39:17 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7C4C06173B
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 14:39:16 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i17so3528681pfq.13
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 14:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IvD2hG3oH/JSHYDsC8zviWFYhaXgrEUMQsSDncS7sVk=;
        b=a5+oGh4MuYLFgXYTuWR1yJxEvYh9OWNW35ejZZpDjl4rVZnwtk6TnBXLqJ+VVhsDm0
         D6Or7StGwjI1Yzkc1NPw239otPBUjRbZv+7xS7i1iLQYszLKnqgsOGLX/PSGl9yQqgCL
         IK9GAixrhY6UsFW2RW6Ir9sBLIUzhhgMtP53TL1asLLay3dFcTJoncsG154WZmH2gr0A
         O0nEpwwbneB22A90wRzIdnXdjnLtH8LuJq5RiKnZXZIXCSATGVoQ9oGPC0nhns2327he
         +J2M0/6ix+rP85sr+N0yl6cu/h7nXG64K7BXx0KzL1D3/7Lxu5y+SIESmhq/3Cp3mXIS
         Lq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IvD2hG3oH/JSHYDsC8zviWFYhaXgrEUMQsSDncS7sVk=;
        b=cEtxyUuydechFa63SmpWnNCMJqeFW1j22hw6pZODNKwKPYh+F8UJW8XbK/p0MpBG5g
         xgBVDc0PiYqabWBC1VYRuG/GYEkBKsBpk3LxAp3sM108iLQOKPl1vRJkOT4OR5F3gokw
         nU4ET1LMejE4c8+czw9qsJUrIwby2UdZ/ih0et/K1NSk37wd6R+ZspKLuOKFH9Ztb0Ok
         8JZKUvjClF7IajkisB12LdeFUEQYpgWYuluJno9/3aHZitJA7s2eCcnz9ZKGtBp+Jifq
         x4EDpkTa2VFITZSoHitQScbqAKdzPUgQelGDNvYYhq+JLWmEb3wKLtaQXsm3n6+H39I/
         a6Uw==
X-Gm-Message-State: AOAM530AmZeW1xhgySZhFPA2UGKyA6aZFxD3j5W2aLnwhgA5g87Zd5wO
        skFy72rnJ1iMoiDhqY/wvAEBH3jjkp5a3TO0
X-Google-Smtp-Source: ABdhPJztMl8AfYmxMcxJnjagHTWDAL1c0pEhxJmzTkVzVLJ9mA+YZadmUqOee79KoBnpPnZcxpar+A==
X-Received: by 2002:a62:1cd6:0:b0:4c7:f6ae:2257 with SMTP id c205-20020a621cd6000000b004c7f6ae2257mr14658366pfc.59.1643150355909;
        Tue, 25 Jan 2022 14:39:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q19sm44209pfn.159.2022.01.25.14.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 14:39:15 -0800 (PST)
Message-ID: <61f07c13.1c69fb81.d0609.02c9@mx.google.com>
Date:   Tue, 25 Jan 2022 14:39:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-155-g882382565432
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 2 regressions (v4.9.297-155-g882382565432)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 102 runs, 2 regressions (v4.9.297-155-g882382=
565432)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-155-g882382565432/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-155-g882382565432
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88238256543276a57af8fe88a724f3ed4c57b13a =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61f04258c2c1722350abbd4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
55-g882382565432/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
55-g882382565432/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f04258c2c1722350abb=
d4f
        failing since 0 day (last pass: v4.9.297-157-g670a9111c52f, first f=
ail: v4.9.297-157-g84580a31d426) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61f04006d1ef65c82eabbd1a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
55-g882382565432/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
55-g882382565432/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f04006d1ef65c=
82eabbd20
        failing since 0 day (last pass: v4.9.297-124-g1de5c6722df5, first f=
ail: v4.9.297-150-g86d4516a7d68)
        2 lines

    2022-01-25T18:22:44.326552  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2022-01-25T18:22:44.335733  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
