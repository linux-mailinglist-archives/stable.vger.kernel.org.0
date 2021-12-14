Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB62474521
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhLNOcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbhLNOcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 09:32:35 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912F3C061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 06:32:35 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id q17so13655475plr.11
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 06:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GyLrTh0rB9klxTBq3pNtk88n/4F6Dihd+Sh5QVIi9Ro=;
        b=6zA9FCgA4jxlqrxpUfK1IBKgFYmjhEgO43M7RYGtcVXpg9GZelcmvdvv4f3Lr0C7QC
         fqoSv0TTRACx0Vg9cVAfkD8+0jY/BVmFyM/Fylas2ikw1cCk7AWSeOYp6VBNrHYzLXHa
         rK+YJiZGneYEpCODwpjxk/JeDjjwbYbJ/NH4TZphFVhk4W6vAGIOzaBsTwMYHydZViNS
         fQorYIoYfoWUEIuXhaHWm8eJxnGv9tLt1OWwjc1BjcxAy44NgaNDJEKGJhsezM0P9g6Q
         Eyjnz9yBG0XvPuYWJg7yf7pN8cdXXq1zgqwhqZ2ZekRSI/tHpFeCy+ACmvZr6cZCofTU
         Wziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GyLrTh0rB9klxTBq3pNtk88n/4F6Dihd+Sh5QVIi9Ro=;
        b=Be1ciHvFe27iiSMVFeGqWDCNhlGUtKdDgnEmt8PLCTmwOXDVlLydhWqL/Wg6DzlAJX
         apOhz7/oXgA40My5Tz9aiuN/tB3N99U4gcYjbSQlBcla4vkrzXU8zLAaCcvsBLxfWm/L
         rP26w4UwVqrQqCoZLgjjhekrj83iCffNjc0V9NeCvhQAb6//l8f5BUym932vyd68Vg8P
         WHK/6GV6LQPv/oEGaq+ny4cSCja0Hy3cro/ag4M9TYVSS++NEesw7nacWTaQ43daGn6j
         GBeuiHcZKUKZN9FbyK2o3oiI2BDMaXEqk4hBOaht+NcDfC+r6T/+U+bz6EXlgJd5I2zU
         k8eA==
X-Gm-Message-State: AOAM533FDLAgSnbJ2bZHg22tE6mfpcu7rVPJbkepMAlLcd/iX8XxuNu8
        YjCE3xIe9fvxsbuOimJPCONO4xefZ7D6JVp1
X-Google-Smtp-Source: ABdhPJzmhbe3ek4VEHyCxWTznBm6rh4odF/NFEjwacY1DQgysxLpKJzDEeel2vWS2Nk4hdkMgNyCNA==
X-Received: by 2002:a17:903:408c:b0:142:45a9:672c with SMTP id z12-20020a170903408c00b0014245a9672cmr6527544plc.7.1639492354921;
        Tue, 14 Dec 2021 06:32:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d12sm57069pfu.91.2021.12.14.06.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:32:34 -0800 (PST)
Message-ID: <61b8ab02.1c69fb81.e8d73.026a@mx.google.com>
Date:   Tue, 14 Dec 2021 06:32:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.292-42-gb3e34e530f60
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 91 runs,
 1 regressions (v4.9.292-42-gb3e34e530f60)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 91 runs, 1 regressions (v4.9.292-42-gb3e34e53=
0f60)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.292-42-gb3e34e530f60/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.292-42-gb3e34e530f60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b3e34e530f60d4a5e6cbe79a3b5dea426667ddbf =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b875d9c526c0d49839711f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-4=
2-gb3e34e530f60/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-4=
2-gb3e34e530f60/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b875dac526c0d=
498397122
        new failure (last pass: v4.9.292-42-g7b8a51e9ff81)
        2 lines

    2021-12-14T10:45:26.777758  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/128
    2021-12-14T10:45:26.787183  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
