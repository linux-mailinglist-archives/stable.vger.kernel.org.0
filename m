Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878652DF052
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 16:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgLSP6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 10:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgLSP57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 10:57:59 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E80C0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 07:57:19 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id n7so3318383pgg.2
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 07:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A/83TG/+GNevM05ffALs+c7XFrr+M0CP0wg5xQT5szk=;
        b=hEdGNcU2Q4qnzUEWPAtcVcJJGgpnNEmjKUd7VqvggxDvk7sm6v+MwN9+aKlTRf2hxG
         TrNfCjp2QchpHJSe+fXr9TDNNihwLi44FRLcSfNmIsWq8BrHO9vR3ZpBy+n1Rr+osxHJ
         Mq5XOYabJrjBmqcIDcngCIsBDuYDj4NbBXTDThTTcpcDg7HK+tunAD5sBPHG0qnmNV1G
         i1tYwYrbc/WWrI2MO+g7xAf/yFzs+6f2/dwJSFX9lNwtlxZTrtTuA4t7gtfAWn6UoLwB
         HZcfMBxft56I5Qi3jgygp6Zu9ffTRDBNlnYpEc5dsYKh2hTsfY6cLcLBb4VQgI49e0YD
         kqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A/83TG/+GNevM05ffALs+c7XFrr+M0CP0wg5xQT5szk=;
        b=uNxo9OGTuzFtm1lON1zxaw2W8tx9dDxwfnLZSG2Hg/1MPfrCR01vczT+yG36pRq4Ek
         bQE6aJJw/oWPL5NiMIePFJH2U3tqs0tTFu5EnJPj7ALdniyIwlcmRjgerBKQKIVd8NfT
         h5mb1Z/w3iFTIsiSReVyTUpnL3zk6GCjXLWknOCW8Uv7hlNDvBfdjBqmKPg9J4HqmEUJ
         a1L9qq0lcITZctbTbt/A8tVqVPu9cLh0RZqnD2cJbmmPqqNadRJyzCAzGto3jfUlb1kA
         FzGxDSifAGQNmWAbnUMzPkNzM7C6Jty/MIH9Soa/nvx68f6eZIlWCDysK1GKXcZAfpnn
         WK1Q==
X-Gm-Message-State: AOAM530RJuSaGq7pF5N/WEUe6Wu2ueZBA+03u76CV/rXNWCBjA9Owxz9
        Z98SlN0RHlu6XhFjKW0UEkOs40qunY/6xQ==
X-Google-Smtp-Source: ABdhPJyVAej0xDSnTVmVcB3VCkmTIJqRkO/DFtfJ8FgflHV9e/IDZccnCMWxMWd58I1TRBJsHEtNmQ==
X-Received: by 2002:a62:2b4e:0:b029:197:96c2:bfef with SMTP id r75-20020a622b4e0000b029019796c2bfefmr8446504pfr.46.1608393438678;
        Sat, 19 Dec 2020 07:57:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j1sm11877640pfd.181.2020.12.19.07.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 07:57:18 -0800 (PST)
Message-ID: <5fde22de.1c69fb81.5ffdb.0568@mx.google.com>
Date:   Sat, 19 Dec 2020 07:57:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-11-g2d7336c9921d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 114 runs,
 5 regressions (v4.9.248-11-g2d7336c9921d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 114 runs, 5 regressions (v4.9.248-11-g2d7336c=
9921d)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.248-11-g2d7336c9921d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-11-g2d7336c9921d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d7336c9921dadfb7f7d4c546b5754fef20f75bf =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddeaa7dc0b1bc048c94cb9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g2d7336c9921d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g2d7336c9921d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fddeaa8dc0b1bc=
048c94cbe
        failing since 4 days (last pass: v4.9.248-6-g1d3e7d6f3f6f7, first f=
ail: v4.9.248-11-ga3f32b90fa44)
        2 lines

    2020-12-19 11:57:24.058000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddea058accc7fc20c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g2d7336c9921d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g2d7336c9921d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddea058accc7fc20c94=
ccc
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddea160bff951cecc94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g2d7336c9921d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g2d7336c9921d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddea160bff951cecc94=
ccd
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fdde9b8518dc45ce5c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g2d7336c9921d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g2d7336c9921d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fdde9b8518dc45ce5c94=
cba
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fdde9d53369ca648dc94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g2d7336c9921d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-1=
1-g2d7336c9921d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fdde9d53369ca648dc94=
cbf
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
