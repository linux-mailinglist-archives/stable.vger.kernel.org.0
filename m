Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4672AFEC6
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 06:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgKLFix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 00:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbgKLEjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 23:39:51 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DDCC0613D1
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 20:39:51 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id i26so3122461pgl.5
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 20:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2+2vHUqFOIWKJCsa/ip85K7+iAphyOpU1QQYD+AAims=;
        b=TSEtDBF3nySENjrJ/rWEn2p1X6y+Sn8PDf6WjLFvAv2BgTi1kxDEKLiAzFdU+veOQs
         l5rYYD4cv4BZ9VQuzrKkeP6GrLRyL25OmpeBwBeaD6yxc4sM9CMgkRsRakV708OJldoM
         +loof2q0Z3UpxyV9vRMVpLVdNscaCOocBNsrv1deBQk0nygWDSwGTv1ShMTQHAOjoJj+
         XLXXMLATx2L5OEvCZhSWoKZGmyHBFaYBVxDBGM9NzJrILgnaJ1ETTYOQE8WS6uyZrlI9
         BhnPo5ivRvZStWyCfA36C1SbDapzM//1qKY23jLzGefIw5uYwqZv94Re/abngngKh9T7
         DK3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2+2vHUqFOIWKJCsa/ip85K7+iAphyOpU1QQYD+AAims=;
        b=E1ZFr+zxAAqpUJiJvU2/3DsL0Dy8py8nYTcxXGDAOQ/zl88yIiyZ4JUICMnGV7ADwM
         85qdjCfIKe1dn7YqzIPWpCAy+x7yUBBxQKP3T2PuQfwnS/6tgufwvk3YykJFDSPhtS04
         z2yt3PFcL/zN6X7fSqYJ4mMA58yzR9jYwaPytGQuOyFN2b84ifxV1PDygB5iVMfbyAPY
         q4bOg4YzLKdhE9h78fgg+hS1lc6fWOshFhwRrTFQMm+RJaOQhx2/sJRcmflAJTdLLRrc
         Y9LmKca+AT8r8eGQR9K34xHVU15KjaITZBS83tv+D750MBde/kPpeMXXwtIx9D7pSl1n
         6rOA==
X-Gm-Message-State: AOAM531GKUQw1z+yjid0W58RURvtWQeDDcW/5tDxw49nfiYT4ZusJ+RU
        x0VRTa+O+wIfexpnxbxw/3Un/uGHNrv6cA==
X-Google-Smtp-Source: ABdhPJyyhwJfSQ9O4A51kacEi1324/6f8LaUDM7Xflq9RBOSqOykbVtBgPUXzAg04II8N+mdfw2dfw==
X-Received: by 2002:aa7:9e4e:0:b029:18b:7623:7cdb with SMTP id z14-20020aa79e4e0000b029018b76237cdbmr26106933pfq.45.1605155990171;
        Wed, 11 Nov 2020 20:39:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s19sm4209738pfe.26.2020.11.11.20.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:39:49 -0800 (PST)
Message-ID: <5facbc95.1c69fb81.a95ca.9cd9@mx.google.com>
Date:   Wed, 11 Nov 2020 20:39:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.243-14-gcb8e837cb602
Subject: stable-rc/linux-4.4.y baseline: 124 runs,
 4 regressions (v4.4.243-14-gcb8e837cb602)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 124 runs, 4 regressions (v4.4.243-14-gcb8e8=
37cb602)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
beagle-xm        | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 2          =

qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig      |=
 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.243-14-gcb8e837cb602/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.243-14-gcb8e837cb602
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb8e837cb602c819fa4b3423bd5d59886f18202b =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
beagle-xm        | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 2          =


  Details:     https://kernelci.org/test/plan/id/5fac82aa38bedea5d2db886a

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-14-gcb8e837cb602/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-14-gcb8e837cb602/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fac82aa38bedea5=
d2db886d
        new failure (last pass: v4.4.243)
        1 lines

    2020-11-12 00:30:51.851000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-12 00:30:51.852000+00:00  (user:) is already connected
    2020-11-12 00:30:51.852000+00:00  (user:) is already connected
    2020-11-12 00:30:51.852000+00:00  (user:khilman) is already connected
    2020-11-12 00:30:51.852000+00:00  (user:) is already connected
    2020-11-12 00:30:51.852000+00:00  (user:) is already connected
    2020-11-12 00:30:51.852000+00:00  (user:) is already connected
    2020-11-12 00:30:51.853000+00:00  (user:) is already connected
    2020-11-12 00:30:51.853000+00:00  (user:) is already connected
    2020-11-12 00:30:51.853000+00:00  (user:) is already connected =

    ... (462 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fac82aa38bedea=
5d2db886f
        new failure (last pass: v4.4.243)
        28 lines

    2020-11-12 00:32:37.459000+00:00  kern  :emerg : Stack: (0xcb999d10 to =
0xcb99a000)
    2020-11-12 00:32:37.467000+00:00  kern  :emerg : 9d00:                 =
                    bf02b8fc bf010b84 cba50610 bf02b988
    2020-11-12 00:32:37.475000+00:00  kern  :emerg : 9d20: cba50610 bf22d0a=
8 00000002 ce33a010 cba50610 bf246b54 cbcc2030 cbcc2030
    2020-11-12 00:32:37.483000+00:00  kern  :emerg : 9d40: 00000000 0000000=
0 ce226930 c01fb3b0 ce226930 ce226930 c0859694 00000001
    2020-11-12 00:32:37.491000+00:00  kern  :emerg : 9d60: ce226930 cbcc203=
0 cbcb2ab0 00000000 ce226930 c0859694 00000001 c09632c0
    2020-11-12 00:32:37.500000+00:00  kern  :emerg : 9d80: ffffffed bf24aff=
4 fffffdfb 00000026 00000001 c00ce2ec bf24b188 c0406f9c
    2020-11-12 00:32:37.508000+00:00  kern  :emerg : 9da0: c09632c0 c120ea3=
0 bf24aff4 00000000 00000026 c0405470 c09632c0 c09632f4
    2020-11-12 00:32:37.516000+00:00  kern  :emerg : 9dc0: bf24aff4 0000000=
0 00000000 c0405618 00000000 bf24aff4 c040558c c040393c
    2020-11-12 00:32:37.524000+00:00  kern  :emerg : 9de0: ce0c38a4 ce22091=
0 bf24aff4 cbbf2340 c09ddba8 c0404a88 bf249b6c c0960460
    2020-11-12 00:32:37.532000+00:00  kern  :emerg : 9e00: cbbd0580 bf24aff=
4 c0960460 cbbd0580 bf24e000 c0406050 c0960460 c0960460 =

    ... (16 line(s) more)  =

 =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig      |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5fac810c613ce98208db885d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-14-gcb8e837cb602/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-14-gcb8e837cb602/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fac810c613ce98208db8=
85e
        new failure (last pass: v4.4.243) =

 =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5fac80c2b935c8642bdb8870

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-14-gcb8e837cb602/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-14-gcb8e837cb602/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fac80c2b935c8642bdb8=
871
        new failure (last pass: v4.4.243) =

 =20
