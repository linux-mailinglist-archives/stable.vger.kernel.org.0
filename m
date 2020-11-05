Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B972A8AD1
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 00:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbgKEXfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 18:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730895AbgKEXfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 18:35:38 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1681FC0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 15:35:37 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id q10so1994824pfn.0
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 15:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2K5WS3X+Ns5L6Avg2XF5Eq3lGJD2yKKQnWDzXi6YWg4=;
        b=pDueugU8yEcxG1icKT/Az3A4AFZ1qo4DNigEx2yossCrsbpJILYPMWpXMF7CRWt49c
         GSv2iVz2fLnyhHWUWMaGSzBCY79vCi2UFdfC9VfCs3pVnSmt+Qrt/zxrZQOIkDA8A7Hy
         B5FAYrFuyiSZgeD8GDp9vt1my/gwgPbHJkK5S2v3lhr44AghAs+vto3ruwCtKr4a/AQe
         GSsVFRi2kky+auXPg+03H6iYRevLgNOpQ1Z2WMODXIO0FNwO8fMPYwYblutcQ98yYQkP
         ry9lHTdub0ti3b5AuUDJ/4g+AxZWGTfdJtycTr6K8S3uv88j+csqWp/vxQXfpH7n1v14
         BiMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2K5WS3X+Ns5L6Avg2XF5Eq3lGJD2yKKQnWDzXi6YWg4=;
        b=dfIq1p1HizjTiLkafGWxIvYuhZDp7t8qyWgdRa54Ebtux/QFuYiraBqnRCZ10Njq65
         VW+D66aQOCiltKvkdAcTwx585wTdrlI+Q/S552/oKCbfxdAdemrIXWW9TmOK8a0EESCc
         0PJY3PxCpDoSUZ7pV5Y4WEwbYBNy2zZ2Hzqg2ViY/fxzgdivh49/35NFqThvxKUxS0gW
         /SRAJMiaO859aeQx7D88JTPijjPJAdR78lNW06bcnjE8/1XkYwiPOvZY4YPnxv4J6nZS
         ISA6H4Kwkyxkje7pjtSjMPQ02rBdWLCQNCSllX6wbJkVak7xQRBNeh4uTT2KDReH4J18
         /WUA==
X-Gm-Message-State: AOAM5328Ao29w9g32sXBS0BsHs2XsJso7GJH139l+21ppNB7+78E9Sv4
        FXuT32/IcB9RmAQh1uNphDcrCcTc67eaLg==
X-Google-Smtp-Source: ABdhPJw7R/V9zYVp6fyFG/ai7nVEpDqxqEkzbdQPOjluoVyD2wkF5njxqadfT9KPPDPubSedBTPbcw==
X-Received: by 2002:a62:cec6:0:b029:18a:d620:6b86 with SMTP id y189-20020a62cec60000b029018ad6206b86mr4597768pfg.2.1604619336133;
        Thu, 05 Nov 2020 15:35:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11sm3990896pfk.52.2020.11.05.15.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 15:35:35 -0800 (PST)
Message-ID: <5fa48c47.1c69fb81.aaf5e.82bd@mx.google.com>
Date:   Thu, 05 Nov 2020 15:35:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.241
Subject: stable-rc/linux-4.4.y baseline: 133 runs, 4 regressions (v4.4.241)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 133 runs, 4 regressions (v4.4.241)

Regressions Summary
-------------------

platform       | arch   | lab          | compiler | defconfig           | r=
egressions
---------------+--------+--------------+----------+---------------------+--=
----------
beagle-xm      | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig | 2=
          =

qemu_i386-uefi | i386   | lab-baylibre | gcc-8    | i386_defconfig      | 1=
          =

qemu_x86_64    | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.241/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.241
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8dfc31cb1f532f20ae71ca049a84c40226f30753 =



Test Regressions
---------------- =



platform       | arch   | lab          | compiler | defconfig           | r=
egressions
---------------+--------+--------------+----------+---------------------+--=
----------
beagle-xm      | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/5f9b4382de644be978381032

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9b4382de644be9=
78381037
        new failure (last pass: v4.4.240-19-ge3d3be91473e)
        1 lines

    2020-11-05 19:25:52.392000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-05 19:25:52.393000+00:00  (user:khilman) is already connected
    2020-11-05 19:25:52.393000+00:00  (user:) is already connected
    2020-11-05 19:25:52.393000+00:00  (user:) is already connected
    2020-11-05 19:25:52.393000+00:00  (user:) is already connected
    2020-11-05 19:26:04.797000+00:00  =00
    2020-11-05 19:26:04.804000+00:00  U-Boot SPL 2018.09-rc2-00001-ge6aa978=
5acb2 (Aug 15 2018 - 09:41:52 -0700)
    2020-11-05 19:26:04.808000+00:00  Trying to boot from MMC1
    2020-11-05 19:26:04.997000+00:00  spl_load_image_fat_os: error reading =
image args, err - -2
    2020-11-05 19:26:05.238000+00:00   =

    ... (452 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9b4382de644be=
978381039
        new failure (last pass: v4.4.240-19-ge3d3be91473e)
        28 lines

    2020-11-05 19:27:38.812000+00:00  kern  :emerg : Stack: (0xcb8e5d10 to =
0xcb8e6000)
    2020-11-05 19:27:38.820000+00:00  kern  :emerg : 5d00:                 =
                    bf02b8fc bf010b84 cb95ca10 bf02b988
    2020-11-05 19:27:38.828000+00:00  kern  :emerg : 5d20: cb95ca10 bf25d0a=
8 00000002 cb8a7010 cb95ca10 bf292b54 cbcac330 cbcac330
    2020-11-05 19:27:38.836000+00:00  kern  :emerg : 5d40: 00000000 0000000=
0 ce228930 c01fb3d8 ce228930 ce228930 c0857e88 00000001
    2020-11-05 19:27:38.845000+00:00  kern  :emerg : 5d60: ce228930 cbcac33=
0 cbcac3f0 00000000 ce228930 c0857e88 00000001 c09612c0
    2020-11-05 19:27:38.853000+00:00  kern  :emerg : 5d80: ffffffed bf296ff=
4 fffffdfb 00000026 00000001 c00ce2f4 bf297188 c04070c8
    2020-11-05 19:27:38.861000+00:00  kern  :emerg : 5da0: c09612c0 c120da3=
0 bf296ff4 00000000 00000026 c040559c c09612c0 c09612f4
    2020-11-05 19:27:38.869000+00:00  kern  :emerg : 5dc0: bf296ff4 0000000=
0 00000000 c0405744 00000000 bf296ff4 c04056b8 c0403a68
    2020-11-05 19:27:38.878000+00:00  kern  :emerg : 5de0: ce0b08a4 ce22191=
0 bf296ff4 cbc2f2c0 c09dd3a8 c0404bb4 bf295b6c c095e460
    2020-11-05 19:27:38.886000+00:00  kern  :emerg : 5e00: cbcde380 bf296ff=
4 c095e460 cbcde380 bf29a000 c040617c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform       | arch   | lab          | compiler | defconfig           | r=
egressions
---------------+--------+--------------+----------+---------------------+--=
----------
qemu_i386-uefi | i386   | lab-baylibre | gcc-8    | i386_defconfig      | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5f9b431f413e950cea381019

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b431f413e950cea381=
01a
        new failure (last pass: v4.4.240-113-gb3d9b0c29dc8) =

 =



platform       | arch   | lab          | compiler | defconfig           | r=
egressions
---------------+--------+--------------+----------+---------------------+--=
----------
qemu_x86_64    | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5f9b43d2292a2d8a90381015

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b43d2292a2d8a90381=
016
        new failure (last pass: v4.4.241-9-gc264933bf666) =

 =20
