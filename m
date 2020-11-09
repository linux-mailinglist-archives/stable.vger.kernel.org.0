Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245602AC5BB
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 21:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgKIUIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 15:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgKIUIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 15:08:23 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25FAC0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 12:08:22 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id w11so5274762pll.8
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 12:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ag6GV0jmZS7UYIoCOLKhdcaYLRHX4ghaM3julBMwJ+k=;
        b=lkVuPUbzGbqHzBDM5yPbTYiPkQ75jAbTI1I2jJQGroR5Vs/4nnLjIkQ2irb9ky9/l+
         v+zbD1uIHNN3zgQyDQLiqq4A/aGPYfLgZ/JcVMwA+gHjWtAyrzynFndDkPtDo8n5BYh8
         MacnlydVnregTL6ZsIvz11fclyK84fFYYODInJJ63PZOeuV4V1ABQQZjmdFlKFrhqTD8
         WhbhqwSHPrL531jBnVPvtriCfMOQqngjSz08KnaMR8eJzeBqb+7Dlll5YdR5VlrZrnER
         Et/5kNMSK/DatzlYMIy62n6Ll4hIyKWNs3B9oBFw5rs0qcMa9EaCbcVKzeGZdFtd2elh
         q+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ag6GV0jmZS7UYIoCOLKhdcaYLRHX4ghaM3julBMwJ+k=;
        b=jo/8plw/AD+nlpHdtvdIZ2tIZ4oC8jBC63ykC4D9HLixIwDA7pY0cOP8uthdxFmZEp
         djzTuQxh6ejQ0IkQ0zlD3iiLWgHZvAcX3/cTyhtakv7ty5J+pufIe4OGA91YvHV2g07u
         z/5GC+O54k1HEuPB9YWFPW6s5JsZn3QKa6aveJpk0tRkR0dS2HfxlibcjVyyS0O/Qz37
         Gnz1DXxZ/PHObcrfZvmxosDVY+xpTk/pDeclGlm8KTkL+0rxwoADz56S8qCw7lTBUtiB
         2JIPIJ5MsJbpw24Vb5obkbpLuecyZTBb8LguwZpD6Mi4537QusLLZjCXbYy3DxkwOqBc
         RPvA==
X-Gm-Message-State: AOAM533FPXnGIIG3o4Mau1RXI/bPXDTDQs592mUP7OyEjlgF+soVTQro
        xfrqDK9SqTIpy78I157my/rOY0WtX/I6qA==
X-Google-Smtp-Source: ABdhPJzGhiquBt/cGZXUX9Kxvs4zA0JWVUPmr/qWeMfYJKuX+wwti1jFBXpUbrcHZ0MV3+8OSG2ejg==
X-Received: by 2002:a17:902:d698:b029:d6:b974:13c5 with SMTP id v24-20020a170902d698b02900d6b97413c5mr14422510ply.13.1604952501792;
        Mon, 09 Nov 2020 12:08:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m3sm291471pjv.52.2020.11.09.12.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 12:08:20 -0800 (PST)
Message-ID: <5fa9a1b4.1c69fb81.59944.1006@mx.google.com>
Date:   Mon, 09 Nov 2020 12:08:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.241-86-gdeb6172daf90
Subject: stable-rc/queue/4.4 baseline: 125 runs,
 5 regressions (v4.4.241-86-gdeb6172daf90)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 125 runs, 5 regressions (v4.4.241-86-gdeb6172=
daf90)

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

qemu_i386        | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-86-gdeb6172daf90/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-86-gdeb6172daf90
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      deb6172daf90cce44f2f5c8d8940b02e8cd359eb =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
beagle-xm        | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/5fa970715af99bc2f5db885a

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
6-gdeb6172daf90/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
6-gdeb6172daf90/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa970715af99bc2=
f5db885d
        new failure (last pass: v4.4.241-86-g2fa33648e935)
        1 lines

    2020-11-09 16:36:20.028000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-09 16:36:20.029000+00:00  (user:) is already connected
    2020-11-09 16:36:20.029000+00:00  (user:) is already connected
    2020-11-09 16:36:20.029000+00:00  (user:) is already connected
    2020-11-09 16:36:20.029000+00:00  (user:) is already connected
    2020-11-09 16:36:20.029000+00:00  (user:) is already connected
    2020-11-09 16:36:20.029000+00:00  (user:) is already connected
    2020-11-09 16:36:20.030000+00:00  (user:) is already connected
    2020-11-09 16:36:20.030000+00:00  (user:) is already connected
    2020-11-09 16:36:20.030000+00:00  (user:) is already connected =

    ... (457 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa970715af99bc=
2f5db885f
        new failure (last pass: v4.4.241-86-g2fa33648e935)
        28 lines

    2020-11-09 16:38:05.020000+00:00  kern  :emerg : Stack: (0xcb8cbd10 to =
0xcb8cc000)
    2020-11-09 16:38:05.028000+00:00  kern  :emerg : bd00:                 =
                    bf02b8fc bf010b84 cbbcba10 bf02b988
    2020-11-09 16:38:05.036000+00:00  kern  :emerg : bd20: cbbcba10 bf2140a=
8 00000002 ce33a010 cbbcba10 bf24ab54 cbccd390 cbccd390
    2020-11-09 16:38:05.045000+00:00  kern  :emerg : bd40: 00000000 0000000=
0 ce226930 c01fb398 ce226930 ce226930 c0859688 00000001
    2020-11-09 16:38:05.053000+00:00  kern  :emerg : bd60: ce226930 cbccd39=
0 cbccd450 00000000 ce226930 c0859688 00000001 c09632c0
    2020-11-09 16:38:05.061000+00:00  kern  :emerg : bd80: ffffffed bf24eff=
4 fffffdfb 00000028 00000001 c00ce2ec bf24f188 c0406f7c
    2020-11-09 16:38:05.069000+00:00  kern  :emerg : bda0: c09632c0 c120ea3=
0 bf24eff4 00000000 00000028 c0405450 c09632c0 c09632f4
    2020-11-09 16:38:05.077000+00:00  kern  :emerg : bdc0: bf24eff4 0000000=
0 00000000 c04055f8 00000000 bf24eff4 c040556c c040391c
    2020-11-09 16:38:05.086000+00:00  kern  :emerg : bde0: ce0c38a4 ce22091=
0 bf24eff4 cbc8e540 c09ddba8 c0404a68 bf24db6c c0960460
    2020-11-09 16:38:05.094000+00:00  kern  :emerg : be00: cbcf8780 bf24eff=
4 c0960460 cbcf8780 bf252000 c0406030 c0960460 c0960460 =

    ... (16 line(s) more)  =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fa9705d731cbfd342db888c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
6-gdeb6172daf90/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
6-gdeb6172daf90/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa9705d731cbfd=
342db8891
        new failure (last pass: v4.4.241-86-g2fa33648e935)
        2 lines =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_i386        | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fa96eccbd2a92e1e4db885c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
6-gdeb6172daf90/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
6-gdeb6172daf90/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa96eccbd2a92e1e4db8=
85d
        new failure (last pass: v4.4.241-86-g2fa33648e935) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fa96cc2543e393fb0db8857

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
6-gdeb6172daf90/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
6-gdeb6172daf90/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa96cc2543e393fb0db8=
858
        new failure (last pass: v4.4.241-86-g2fa33648e935) =

 =20
