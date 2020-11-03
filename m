Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9AF2A4C2C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 18:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgKCRCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 12:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbgKCRCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 12:02:48 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771B5C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 09:02:48 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u2so2903700pls.10
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 09:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iDNBoK1wA7x8Bn49HCAhRMf81/FwYBjl1NB0nE+zVSw=;
        b=XkASpMcgL0h/L2gx7z595vIzVltDPudvUxhHMHtSb0yAg7eldaHctdXuh1cudbLvvo
         Y7zEzbuMZMwEF4Fz5v35Eeezl0k1xK04b4eJLglOiyTBylW1YgEn3EUq0LJRSlC/Cvg4
         tXK896rWG4sus0H21ckFtTuxUy0aS5Yg51Rn9WFTiJcgnQtfv8PXOfZ4enWZ5Y08lcW6
         M+Ww5krrYz9o01UvAL5YxzGufEXFUFkDDNowio7/eOtwQjQmRGeQvWXgh7cU7eqQ5kOk
         IKSYFXfuEmbx48xicksD/QnjIgB35Vmr+bLDMG/H5Bu68kWONL5KIq4nqu8UjbXSqcSf
         WCOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iDNBoK1wA7x8Bn49HCAhRMf81/FwYBjl1NB0nE+zVSw=;
        b=P6Cjopg+gUw9cbJ5uHH5jg+nK04qf7bI16q0lUy0M+IuWqS6zMhQAY7G2KNT8eQakz
         ADd2n23flIcY4k+zY8ndHHYCLj4yrsSya75MY0qga/xmybQjU4yQCgt2GhHBf7Z/S/tX
         787ScIKzMS3TmjVwW6c7epbEeM9rpl79ly8YeNF6+XUVPlRbYxYcvyOVjnsI6cDNVkMW
         dZkYbRjJBnmBuwguTcsPKLOWvSZrU+5mQe5AuiKRPNXgby0ma2grUQjdfNZMQHxaG5Dv
         IpnKUcev90p/3eSWAzx1fcFtg9yYoyByVs3oV34ie5xBHjup/357ArM2ZsvvZfLUMWMJ
         1F8g==
X-Gm-Message-State: AOAM531h5hop4Q+G46EPbTMrhBdWlEFeKzc5j5NqKUip1vdDcB0rJWH6
        7P5++bdm3kypDuP+3mU5UT0oNabRfcYU8A==
X-Google-Smtp-Source: ABdhPJwKc/1c03zWxJXszTRBsWRTyRsObUuo5hEn81VCvnq4TMsk71jmB8h1p7zEWn4pJ7refzOCsQ==
X-Received: by 2002:a17:902:7685:b029:d6:65a6:c70b with SMTP id m5-20020a1709027685b02900d665a6c70bmr25016506pll.30.1604422966903;
        Tue, 03 Nov 2020 09:02:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13sm2483084pfd.97.2020.11.03.09.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:02:45 -0800 (PST)
Message-ID: <5fa18d35.1c69fb81.6a257.4787@mx.google.com>
Date:   Tue, 03 Nov 2020 09:02:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-41-g583b80963b82
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 132 runs,
 5 regressions (v4.4.241-41-g583b80963b82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 132 runs, 5 regressions (v4.4.241-41-g583b809=
63b82)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
beagle-xm        | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 2          =

panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =

qemu_i386-uefi   | i386   | lab-collabora | gcc-8    | i386_defconfig      =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-41-g583b80963b82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-41-g583b80963b82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      583b80963b822c557b0ef90686b21bfad1de1afa =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
beagle-xm        | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/5fa15523e78717f60e3fe7db

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
1-g583b80963b82/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
1-g583b80963b82/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa15523e78717f6=
0e3fe7e0
        new failure (last pass: v4.4.241-35-g00e1b9176297)
        1 lines

    2020-11-03 13:01:40.956000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-03 13:01:40.956000+00:00  (user:khilman) is already connected
    2020-11-03 13:01:52.107000+00:00  =00
    2020-11-03 13:01:52.113000+00:00  U-Boot SPL 2018.09-rc2-00001-ge6aa978=
5acb2 (Aug 15 2018 - 09:41:52 -0700)
    2020-11-03 13:01:52.117000+00:00  Trying to boot from MMC1
    2020-11-03 13:01:52.307000+00:00  spl_load_image_fat_os: error reading =
image args, err - -2
    2020-11-03 13:01:52.858000+00:00  =

    2020-11-03 13:01:52.864000+00:00  U-Boot SPL 2018.09-rc2-00001-ge6aa978=
5acb2 (Aug 15 2018 - 09:41:52 -0700)
    2020-11-03 13:01:52.868000+00:00  Trying to boot from MMC1
    2020-11-03 13:01:53.058000+00:00  spl_load_image_fat_os: error reading =
image args, err - -2 =

    ... (451 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa15523e78717f=
60e3fe7e2
        new failure (last pass: v4.4.241-35-g00e1b9176297)
        28 lines

    2020-11-03 13:03:27.287000+00:00  kern  :emerg : Stack: (0xcba11d10 to =
0xcba12000)
    2020-11-03 13:03:27.295000+00:00  kern  :emerg : 1d00:                 =
                    bf02b8fc bf010b84 cb98f410 bf02b988
    2020-11-03 13:03:27.304000+00:00  kern  :emerg : 1d20: cb98f410 bf2010a=
8 00000002 cb98b010 cb98f410 bf24fb54 cbbca390 cbbca390
    2020-11-03 13:03:27.312000+00:00  kern  :emerg : 1d40: 00000000 0000000=
0 ce226930 c01fb3d8 ce226930 ce226930 c0857e88 00000001
    2020-11-03 13:03:27.320000+00:00  kern  :emerg : 1d60: ce226930 cbbca39=
0 cbbca450 00000000 ce226930 c0857e88 00000001 c09612c0
    2020-11-03 13:03:27.328000+00:00  kern  :emerg : 1d80: ffffffed bf253ff=
4 fffffdfb 00000028 00000001 c00ce2f4 bf254188 c04070e8
    2020-11-03 13:03:27.336000+00:00  kern  :emerg : 1da0: c09612c0 c120da3=
0 bf253ff4 00000000 00000028 c04055bc c09612c0 c09612f4
    2020-11-03 13:03:27.344000+00:00  kern  :emerg : 1dc0: bf253ff4 0000000=
0 00000000 c0405764 00000000 bf253ff4 c04056d8 c0403a88
    2020-11-03 13:03:27.353000+00:00  kern  :emerg : 1de0: ce0c38a4 ce22091=
0 bf253ff4 cbcda4c0 c09dd3a8 c0404bd4 bf252b6c c095e460
    2020-11-03 13:03:27.361000+00:00  kern  :emerg : 1e00: cbca6b00 bf253ff=
4 c095e460 cbca6b00 bf257000 c040619c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1550c01a57c010c3fe7d6

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
1-g583b80963b82/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
1-g583b80963b82/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa1550c01a57c0=
10c3fe7dd
        failing since 2 days (last pass: v4.4.241-8-gd71fd6297abd, first fa=
il: v4.4.241-10-g5dfc3f093ca4)
        2 lines =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_i386-uefi   | i386   | lab-collabora | gcc-8    | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1548e51b6bc655b3fe844

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
1-g583b80963b82/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
1-g583b80963b82/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1548e51b6bc655b3fe=
845
        new failure (last pass: v4.4.241-35-g00e1b9176297) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fa154591e37ec2a643fe7ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
1-g583b80963b82/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
1-g583b80963b82/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa154591e37ec2a643fe=
800
        new failure (last pass: v4.4.241-35-g00e1b9176297) =

 =20
