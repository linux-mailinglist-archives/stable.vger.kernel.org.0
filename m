Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E90146010C
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 20:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240489AbhK0TFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 14:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355934AbhK0TDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 14:03:32 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CBAC06175F
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 11:00:16 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id iq11so9376820pjb.3
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 11:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gLXZkWnhZjwJWhkXhIPItil9s6Ass/nhDsr2wDDZR8s=;
        b=M82GiG3VbzuVs+TMnubLsczPScosh743JxEtRxO6qQwI+MrJTGRn0TBelsn4NT2TA1
         MNMsmvoK5LgOqAmUAlI4+qt2jwAWUnSGQeVcH3fq/VxYwiBs6SS8g47IAzEgLYnRIKcB
         AY97iCnhcJsziro+WI/xYl1YOw9vfkPVcbQygGTJ3vIbz9DCMEhee44WGcf234URNNh8
         VT4NGh4v/hlNpLGyAKMAUa1dnKph0y2TZYRGlyl4qQcaRywucnh3gDwfWC5nEmI1kFSc
         i+5BOnZNRePO/LrOzj8ll+zgQrXXFk3AktRIjuTrGko6Z76IkM44S/7n0q0lrlvL/iBS
         cfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gLXZkWnhZjwJWhkXhIPItil9s6Ass/nhDsr2wDDZR8s=;
        b=WP2/vMhYfhEquDZiY2eZ6pMyrS7Zqn87g5cRCQ2xufLa4rHcbm8oW0Co/B3+eByVZP
         Bz/dTwGft8yM+EEnoXnerTWxEgxvA9Ti5XPVc9ZcFWIszfvXyjDWY2W7nmpNLI2esrwa
         z7UNwQNnZ27lRvM9KZ0YlIcLhxvO5NPPIAQ9zoo2M0JJFtZCnLVl/kfg4WPUyMQGQ0e+
         XogdIwGZ/In52x1uKwzAadBc5MlqumOqbRL59NT0X0OfBN9mmUwshQBxOEzNdiLoolja
         TBq0J9n1WqjS4Uz/8ryDVejk9Pu3HwLfgZrVNRn3XzfpSkZ8Nvdk5LvhoXIjxCtHWPSR
         GjjA==
X-Gm-Message-State: AOAM533u7/wPej5tKk+4xCQ506NRAVcJht1v3mZyWEJAas1lXcqhuEWY
        qALYZmvHDPX88m4DFWPjTctmn+rsKDgU+Sz0
X-Google-Smtp-Source: ABdhPJx6vkTLTV4w0yxA1vnzz/4JCuCDojESOjdPTqDzrwOR+TT9iKwRkX0vYIRcWeaV+OC8qEI4HQ==
X-Received: by 2002:a17:90b:1b4a:: with SMTP id nv10mr25188620pjb.87.1638039616269;
        Sat, 27 Nov 2021 11:00:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm12087424pfi.154.2021.11.27.11.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 11:00:16 -0800 (PST)
Message-ID: <61a28040.1c69fb81.37587.0534@mx.google.com>
Date:   Sat, 27 Nov 2021 11:00:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-8-g0a2d353d748d5
Subject: stable-rc/queue/4.4 baseline: 106 runs,
 2 regressions (v4.4.293-8-g0a2d353d748d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 106 runs, 2 regressions (v4.4.293-8-g0a2d353d=
748d5)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-8-g0a2d353d748d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-8-g0a2d353d748d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a2d353d748d55d9668bb4a6b1f78ad11a8559cf =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61a247618ddef05cec18f6d5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-8=
-g0a2d353d748d5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-8=
-g0a2d353d748d5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a247618ddef05=
cec18f6db
        failing since 2 days (last pass: v4.4.292-160-geb7fba21283a, first =
fail: v4.4.292-160-g4d766382518e6)
        2 lines

    2021-11-27T14:57:16.307047  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-27T14:57:16.316147  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61a2452e2d6509a34018f6d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-8=
-g0a2d353d748d5/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-8=
-g0a2d353d748d5/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a2452e2d6509a34018f=
6d7
        new failure (last pass: v4.4.292-159-g9b8f282b0560) =

 =20
