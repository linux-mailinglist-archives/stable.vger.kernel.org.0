Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5329449D7E
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 22:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbhKHVFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 16:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhKHVFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 16:05:03 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45800C061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 13:02:19 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id g18so12449633pfk.5
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 13:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oJ89cmSdMZszkAlxff8Xg70mGIfSv3GT0/A9G2HRZro=;
        b=tNrwjqzVeCgewvqCsLKRt6hAPqKlNULzHaOn/UIbq1VYKha4ZVFjVUFTOgsHahS3Gz
         EruMKn7Fb2D4pv3uH0WjUvVFNLrbsqAC52Y3dYsViYpfkDnxZuhCHdQ1y6HQMrAPpuO2
         fBbS+6Y8/UzLuqPyCQtOX5gs3Hb9GdZM1T0NU1torGy4TrMZMT05UAbPyonK5CePfpsC
         EwZAQWz++kXSmlKqowKCaTtVTqO8L4dW8HyeAxVffZgRM5F3BrBa8KSdSzp4JRhZKiEP
         hdf0lQmIQ5ZJQV4YJ+kL6LaethBn9/9VPJlnbtOblLJoZVbbE+a1UDscn0ofv/1BAzxL
         PNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oJ89cmSdMZszkAlxff8Xg70mGIfSv3GT0/A9G2HRZro=;
        b=oM77e+QIxVFxMXJoyCqDFW+HBdyzmhqU+rFQalVOMJBmM14HgGJcZI9WMTaky9tify
         9Y2XzlyoUta4bhIY/q8m0Y6Obb0mVlfNG+zAvTalmvTeSkQXeMUdM+ktJAkiaklfq+Mc
         7Ofzu4aGCgSKgydv6hkKYqNSkBB7xiEvGT6Qcjje0uLG4pAPC9AGplK/Xd1VlLuwST73
         v9XM9esokdvIR5eJeR1MUuWLBoNXV+4ggE2qAw5enMdwGNQJ+MSfqkijHUbb9cAe+iFQ
         CD10JZX9R9gfdU2ASWNxRNRmB+/ryuiZmV9IwEX3iZAZgi2+CVAKNpjyfSngOG5rguYp
         K16g==
X-Gm-Message-State: AOAM5316Z+asKef/3Sz+KTCwUoCj3d7RaYkhjrFNehu3VX3mAu5V09qI
        MYaNeovdt5J2hCrmkuEmq9khiP5UJUPvP+3f
X-Google-Smtp-Source: ABdhPJwsl++dGTGnFoyxkXM83eZb1MzmufCDoIAtdpruUv9z73+jRtEPQCWk0HaVRfnjs5zKrm2gcQ==
X-Received: by 2002:a63:9245:: with SMTP id s5mr1864449pgn.4.1636405338596;
        Mon, 08 Nov 2021 13:02:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm16866238pfu.189.2021.11.08.13.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 13:02:18 -0800 (PST)
Message-ID: <6189905a.1c69fb81.a6d68.3b46@mx.google.com>
Date:   Mon, 08 Nov 2021 13:02:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-12-g923d11bd34b9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 158 runs,
 2 regressions (v4.14.254-12-g923d11bd34b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 158 runs, 2 regressions (v4.14.254-12-g923d1=
1bd34b9)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =

qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-12-g923d11bd34b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-12-g923d11bd34b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      923d11bd34b9ba1e84659c5cef3a9523076fccab =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/6189584df987817e343358e3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-12-g923d11bd34b9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-12-g923d11bd34b9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6189584df987817=
e343358e6
        failing since 0 day (last pass: v4.14.254-7-g292cb9a1cdd5, first fa=
il: v4.14.254-9-g32e6402e132a)
        2 lines

    2021-11-08T17:02:50.634053  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2021-11-08T17:02:50.643055  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-08T17:02:50.658614  [   20.003295] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/618956ed4c8cba1c2e3358ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-12-g923d11bd34b9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/bas=
eline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-12-g923d11bd34b9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/bas=
eline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618956ed4c8cba1c2e335=
8ef
        new failure (last pass: v4.14.254-9-g32e6402e132a) =

 =20
