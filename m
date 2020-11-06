Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4AA2A8C75
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 03:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgKFCL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 21:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgKFCL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 21:11:28 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D08C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 18:11:28 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z3so2903653pfz.6
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 18:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TPbYr4J8wXH4fVTydmqiCr7G5ywKNDZl0WMZ081q4pU=;
        b=kmdSGQr4wmxWR/2h2BUq7MukwwoZrckU2STjcj18TTt6XY8IwGggs4oR83kPuaqbSD
         TKRl2lLwWLFBYT3EZ+IkQ0tIBzSZIrjEuT8gAXg9WgnAU9pkguSE9+CqvVN/3IexqERX
         9hG8eAJen/NDsMMvOWF/p9nLZpOkQdyoDA7Jlkj3RQVsVRDkgn99Ih6WpSXcSE7WXmHh
         ZZWowOchAWyaV4CL8v64JXDQcnT+4T65ESdb24Epgresqk39N87xF5LSC9G8y9a1003x
         Q0RmburWULfgDhaTGEJgiBmwn4eVByf+Lv9IiZ77xFVtwdelDdGke+Y9bD5qCMi7aMAv
         /sjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TPbYr4J8wXH4fVTydmqiCr7G5ywKNDZl0WMZ081q4pU=;
        b=gSSRqb+drc5jcyVU3oQ+5vECLjm4Q2wZNNRBqHhAgRFvTAIjGeARZQcbXdTpLHoXRO
         f5NZ6NEOZG2s+4XdnSzdzGamwr8GkmyjFDCkrSlV+1HVHFr8j0ITAxvMEuXf10/g5ggU
         ybwoGusUCkkqPXqeSYtxD+XUy5ZeofteqfgazqHp9Ih3UcVtNh0J0VOos7Qt1wN2+b3S
         e4pTqwYUiwGeodgOCLvgmtABM5vrZdKjJhqkHSKFlfz+X+hkDOBWmhdEG2mVQ42zAQvQ
         M6RqUwUWVbP1C0ey2iBBnkolGNy5qKNDV0isaL9YbTyCS8fSaux7XkFSIwSh+fqtQgal
         ytlA==
X-Gm-Message-State: AOAM533Ho/DnJkzZEA4Z3u+LHfKLWpIQQxpkOQP/PAxgyzWc05nWn/5t
        n0FeFpn0aShDL7uP78J+AEIR6rPnE+X84Q==
X-Google-Smtp-Source: ABdhPJwSP8URf0mdZyCcqAj84aAouESKDm17cBvo/JekYO7xUGBCc++Bt1bwMz00nAHjvt8w15rKVw==
X-Received: by 2002:a17:90a:4482:: with SMTP id t2mr5161915pjg.44.1604628687269;
        Thu, 05 Nov 2020 18:11:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bx6sm3604451pjb.39.2020.11.05.18.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 18:11:26 -0800 (PST)
Message-ID: <5fa4b0ce.1c69fb81.13f47.75f1@mx.google.com>
Date:   Thu, 05 Nov 2020 18:11:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.241-64-g473b6554b40c
Subject: stable-rc/queue/4.4 baseline: 123 runs,
 4 regressions (v4.4.241-64-g473b6554b40c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 123 runs, 4 regressions (v4.4.241-64-g473b655=
4b40c)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =

qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-64-g473b6554b40c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-64-g473b6554b40c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      473b6554b40cd5e39107e82e5a41cdc12f3129be =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa47e4e1d86b8a5bedb885b

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
4-g473b6554b40c/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
4-g473b6554b40c/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa47e4e1d86b8a5=
bedb885e
        new failure (last pass: v4.4.241-63-g1e4676585859)
        1 lines

    2020-11-05 22:34:05.414000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-05 22:34:05.414000+00:00  (user:) is already connected
    2020-11-05 22:34:05.414000+00:00  (user:) is already connected
    2020-11-05 22:34:05.414000+00:00  (user:khilman) is already connected
    2020-11-05 22:34:05.414000+00:00  (user:) is already connected
    2020-11-05 22:34:05.415000+00:00  (user:) is already connected
    2020-11-05 22:34:17.119000+00:00  =00
    2020-11-05 22:34:17.126000+00:00  U-Boot SPL 2018.09-rc2-00001-ge6aa978=
5acb2 (Aug 15 2018 - 09:41:52 -0700)
    2020-11-05 22:34:17.130000+00:00  Trying to boot from MMC1
    2020-11-05 22:34:17.319000+00:00  spl_load_image_fat_os: error reading =
image args, err - -2 =

    ... (451 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa47e4e1d86b8a=
5bedb8860
        new failure (last pass: v4.4.241-63-g1e4676585859)
        28 lines

    2020-11-05 22:35:52.191000+00:00  kern  :emerg : Stack: (0xcba1bd10 to =
0xcba1c000)
    2020-11-05 22:35:52.200000+00:00  kern  :emerg : bd00:                 =
                    bf02b8fc bf010b84 cb958c10 bf02b988
    2020-11-05 22:35:52.207000+00:00  kern  :emerg : bd20: cb958c10 bf2430a=
8 00000002 cb837010 cb958c10 bf28eb54 cbc7b330 cbc7b330
    2020-11-05 22:35:52.215000+00:00  kern  :emerg : bd40: 00000000 0000000=
0 ce226930 c01fb3a0 ce226930 ce226930 c0857e88 00000001
    2020-11-05 22:35:52.224000+00:00  kern  :emerg : bd60: ce226930 cbc7b33=
0 cbc7b3f0 00000000 ce226930 c0857e88 00000001 c09612c0
    2020-11-05 22:35:52.232000+00:00  kern  :emerg : bd80: ffffffed bf292ff=
4 fffffdfb 00000025 00000001 c00ce2f4 bf293188 c0407034
    2020-11-05 22:35:52.240000+00:00  kern  :emerg : bda0: c09612c0 c120da3=
0 bf292ff4 00000000 00000025 c0405508 c09612c0 c09612f4
    2020-11-05 22:35:52.248000+00:00  kern  :emerg : bdc0: bf292ff4 0000000=
0 00000000 c04056b0 00000000 bf292ff4 c0405624 c04039d4
    2020-11-05 22:35:52.257000+00:00  kern  :emerg : bde0: ce0c38a4 ce22091=
0 bf292ff4 cbc2a7c0 c09dd3a8 c0404b20 bf291b6c c095e460
    2020-11-05 22:35:52.265000+00:00  kern  :emerg : be00: cbc30c00 bf292ff=
4 c095e460 cbc30c00 bf296000 c04060e8 c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa47e4147124ce4c4db885c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
4-g473b6554b40c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
4-g473b6554b40c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa47e4147124ce=
4c4db8861
        new failure (last pass: v4.4.241-63-g1e4676585859)
        2 lines =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa47ec1e41b35f370db886f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
4-g473b6554b40c/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
4-g473b6554b40c/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa47ec1e41b35f370db8=
870
        new failure (last pass: v4.4.241-63-g1e4676585859) =

 =20
