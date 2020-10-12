Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D3928C144
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 21:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbgJLTNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 15:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729890AbgJLTNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 15:13:08 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B50C0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 12:13:06 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h6so15283737pgk.4
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 12:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RJEbKIXAbPjeLQoJCUyG9iya+LBOXpyP3IfJAHSnJJ8=;
        b=nXvhHje2IoNDwpSM6xLFzlXm5LeHJjCRJ23IGt9ZNikWN4+o4wZsSFR3UMavzkE2be
         lWwljA0KrlaDytKD2FCAGwNTisz+9vUUm+C0qW8XQmISFO3TzQ1cf8+3aQ83yj5THJ7s
         hv9fAOFllccfSugW0pAYpvJ8SuntjQy65Fd4enYjhKwSxEDpDqinrDik/+O0cXN1VCm3
         yV+ggLYc0EJBI1cqQTqRANhq5IQs7nStlTXKvWaU79TNAgSg4vFQvmqzdcZThLEq3ita
         dLCj8MM11YI2ugM+Y9edTM7bIL0J7sxs4WZLbTWSXIjFpY7mh67IPay6fHS7tP/VdD/s
         c29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RJEbKIXAbPjeLQoJCUyG9iya+LBOXpyP3IfJAHSnJJ8=;
        b=GqoVZeOSNF8jIAUkPxwXMplB6DxhZs0P4iKiKPYuC6jCo6fh9LhXrq31lMblzxDRd+
         tGbjv74QwvHjfWXg1CCYmhTq9zVwMG78X0pn24INuH4dcWd+ld+lKqFSJu/ObVaabcq7
         KOYPeHxTOz3AgXWg2Az+mTjcpNrUTHLp0npH0ZMGyCu7sbXIWtPfwsLXqmd4fBF+a07v
         TszMfvBtb9hVdqz0lE3pOlQDhMzKY1L0v7u8sVhOwN+pE+0haEq39jPvJA1B2Se/DZJF
         G7X1k/v01Mp3A6xLDGxnVhvQNWlPinh+SiVmaEg2VPuaOOjCFIqmTe5gv3MFTkQ6CxBE
         Ifag==
X-Gm-Message-State: AOAM530Vw5RRZMQgFGoQBUbr3X+V716z/5TAXPmJH2IrbRdwRW0QFrhj
        4YI3d1UsrYbInS4jrR56QOcrDpQLlrxF5Q==
X-Google-Smtp-Source: ABdhPJwen8M6UxgAFvGTks8BTyLs+GQIBMVGixnyHpHeOznP8WU+Q0llg+tSHKtUFzJc2LXB/pqo/w==
X-Received: by 2002:a65:4987:: with SMTP id r7mr14201041pgs.228.1602529985923;
        Mon, 12 Oct 2020 12:13:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm25063365pjs.30.2020.10.12.12.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 12:13:05 -0700 (PDT)
Message-ID: <5f84aac1.1c69fb81.8f2d7.0224@mx.google.com>
Date:   Mon, 12 Oct 2020 12:13:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.150-48-ga118af89addf
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 163 runs,
 3 regressions (v4.19.150-48-ga118af89addf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 163 runs, 3 regressions (v4.19.150-48-ga11=
8af89addf)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 0/1    =

hsdk                  | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig   =
   | 0/1    =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.150-48-ga118af89addf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.150-48-ga118af89addf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a118af89addf40ce0cfb21260215d13939b3e416 =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f846d0a32e7b0bc784ff40a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-48-ga118af89addf/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-48-ga118af89addf/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f846d0a32e7b0bc784ff=
40b
      failing since 118 days (last pass: v4.19.126-55-gf6c346f2d42d, first =
fail: v4.19.126-113-gd694d4388e88)  =



platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
hsdk                  | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig   =
   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f84715f2ef9eedf664ff467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-48-ga118af89addf/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-48-ga118af89addf/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f84715f2ef9eedf664ff=
468
      failing since 83 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =



platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8468ec95632d36eb4ff3e8

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-48-ga118af89addf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-48-ga118af89addf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8468ec95632d3=
6eb4ff3ee
      failing since 10 days (last pass: v4.19.148-245-g78ef55ba27c3, first =
fail: v4.19.149)
      2 lines

    2020-10-12 14:32:07.134000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
