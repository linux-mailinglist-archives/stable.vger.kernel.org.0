Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FE42AF5F8
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 17:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgKKQQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 11:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgKKQQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 11:16:05 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDDAC0613D4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 08:16:05 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id x15so560906pfm.9
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 08:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IJ30XYSfO3zba1oJxxLdavbxBLmHQdmbo3XNXtLjd8s=;
        b=aN/E39kCGPqX1nL8nIV5Pm1GNAzjWPXyz0xT01ghE2rM5Ws7DYNtc7xfqIZH8ckJ+/
         2IHB5GvSEY23KZaHpWu5idVdoa+8MT915PAdT6qoS2z9zjjyH/eZ7nZcfbTTtZ1rM+vi
         Rb2gVPcZxvaa8LVCpy5veGEGhulCfgZP3jLkmwi2syRv4spUbt1X+Xbw0lmTak9EUSGS
         juZjRb/tXyh308VT/T/h+TTqlyl5KqFYOup/fmoQvssDHsjJIIipWg9adnP+AGF8JwSL
         +4jKVtFUaLOLQ38Kvpb4iPxIuVWQHn70USaD659DfOakW1tBZg7SvCcEzRUsmJ/4E6CB
         XKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IJ30XYSfO3zba1oJxxLdavbxBLmHQdmbo3XNXtLjd8s=;
        b=rBCKgStIq399xTBbEK1sVyvpIGN/KDtPnJLJlItgw3LRmYgjMH93eNeZUitj9U3hEI
         SS9JsUQLk4JaLbgbr34Hoy0xWgLW0+usk8/g/LDAzNEyE7mUex6ujP5jARd+rkKCWVZx
         sIV9Ro4vYXPq7jy5+2jMkAuqHwqGtSvZWMuFuhptXLkoKChq3AUhj4HENlJbzE2xDJxl
         MELZrDMXpniFVMXESoAHz+8BXrQLrR03Pk+oZZWP4MmlB6g9nEE3scCU//BcylArfLup
         Figj3TMr8P012++onCY5vksgHmDHJZfRs2iuF3uOtssJFAUmDaKgsNPuY+gEeewyjPzu
         XpDQ==
X-Gm-Message-State: AOAM531gxmgUXzXQq4lasCerzKtAq7x4gdxmeg+Wb2ldd3lsCVwuBl3k
        +P0PEQ86jhnwg9RUAIc/TjUj/TwJIy4Kkw==
X-Google-Smtp-Source: ABdhPJx63bh8cj7OAO3YU6wUcDdO+P/FwX4YZx/aVwEd9ttW5zH4Zs5wAkfHhSeRBvuy08qsT4VpOA==
X-Received: by 2002:a62:19c6:0:b029:18b:5c6a:2ae6 with SMTP id 189-20020a6219c60000b029018b5c6a2ae6mr23549216pfz.14.1605111364826;
        Wed, 11 Nov 2020 08:16:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7sm2861716pjj.20.2020.11.11.08.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 08:16:04 -0800 (PST)
Message-ID: <5fac0e44.1c69fb81.e9402.5e9c@mx.google.com>
Date:   Wed, 11 Nov 2020 08:16:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.243-13-g0e9f589aa60c
Subject: stable-rc/queue/4.4 baseline: 118 runs,
 4 regressions (v4.4.243-13-g0e9f589aa60c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 118 runs, 4 regressions (v4.4.243-13-g0e9f589=
aa60c)

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
el/v4.4.243-13-g0e9f589aa60c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.243-13-g0e9f589aa60c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e9f589aa60c964e0c9f6419bb10733ee05ae62a =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/5fabdd73a874711a31db8875

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g0e9f589aa60c/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g0e9f589aa60c/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fabdd73a874711a=
31db8878
        failing since 0 day (last pass: v4.4.242-13-g4252bfe26b94, first fa=
il: v4.4.243-13-g3ae0f9dc7816)
        1 lines

    2020-11-11 12:45:56.435000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-11 12:45:56.435000+00:00  (user:) is already connected
    2020-11-11 12:45:56.435000+00:00  (user:) is already connected
    2020-11-11 12:45:56.435000+00:00  (user:) is already connected
    2020-11-11 12:45:56.435000+00:00  (user:) is already connected
    2020-11-11 12:45:56.435000+00:00  (user:) is already connected
    2020-11-11 12:45:56.435000+00:00  (user:) is already connected
    2020-11-11 12:45:56.435000+00:00  (user:) is already connected
    2020-11-11 12:45:56.436000+00:00  (user:) is already connected
    2020-11-11 12:45:56.436000+00:00  (user:) is already connected =

    ... (459 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fabdd73a874711=
a31db887a
        failing since 0 day (last pass: v4.4.242-13-g4252bfe26b94, first fa=
il: v4.4.243-13-g3ae0f9dc7816)
        28 lines

    2020-11-11 12:47:41.825000+00:00  kern  :emerg : Stack: (0xcb955d10 to =
0xcb956000)
    2020-11-11 12:47:41.833000+00:00  kern  :emerg : 5d00:                 =
                    bf02b8fc bf010b84 cba59010 bf02b988
    2020-11-11 12:47:41.841000+00:00  kern  :emerg : 5d20: cba59010 bf2240a=
8 00000002 cb8c8010 cba59010 bf24ab54 cbcd2390 cbcd2390
    2020-11-11 12:47:41.849000+00:00  kern  :emerg : 5d40: 00000000 0000000=
0 ce226930 c01fb3b0 ce226930 ce226930 c0859688 00000001
    2020-11-11 12:47:41.858000+00:00  kern  :emerg : 5d60: ce226930 cbcd239=
0 cbcd2450 00000000 ce226930 c0859688 00000001 c09632c0
    2020-11-11 12:47:41.866000+00:00  kern  :emerg : 5d80: ffffffed bf24eff=
4 fffffdfb 00000028 00000001 c00ce2ec bf24f188 c0406f9c
    2020-11-11 12:47:41.874000+00:00  kern  :emerg : 5da0: c09632c0 c120ea3=
0 bf24eff4 00000000 00000028 c0405470 c09632c0 c09632f4
    2020-11-11 12:47:41.882000+00:00  kern  :emerg : 5dc0: bf24eff4 0000000=
0 00000000 c0405618 00000000 bf24eff4 c040558c c040393c
    2020-11-11 12:47:41.890000+00:00  kern  :emerg : 5de0: ce0c38a4 ce22091=
0 bf24eff4 cbbe64c0 c09ddba8 c0404a88 bf24db6c c0960460
    2020-11-11 12:47:41.899000+00:00  kern  :emerg : 5e00: cbb9ecc0 bf24eff=
4 c0960460 cbb9ecc0 bf252000 c0406050 c0960460 c0960460 =

    ... (16 line(s) more)  =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fabdd635dc17fdf3adb886a

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g0e9f589aa60c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g0e9f589aa60c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fabdd635dc17fd=
f3adb886f
        failing since 1 day (last pass: v4.4.241-86-g2fa33648e935, first fa=
il: v4.4.241-86-gdeb6172daf90)
        2 lines =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fabd86d60b8752fd9db8872

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g0e9f589aa60c/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
3-g0e9f589aa60c/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fabd86d60b8752fd9db8=
873
        new failure (last pass: v4.4.243-13-g3ae0f9dc7816) =

 =20
