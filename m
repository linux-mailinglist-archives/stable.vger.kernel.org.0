Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE36928C720
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 04:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgJMC2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 22:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgJMC2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 22:28:19 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E17C0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 19:28:19 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x13so167430pgp.7
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 19:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cYx3kbIuWg3LQ+vflhsNivjAIxBTXXDVsMxsrkzRus4=;
        b=LpwKdVFG4Qcv6lZXJXIaheRVbp3iyhjS0Ro4U7A0zgGBDPpFLLVjmRbfM5unfzTnom
         ij+46fiFMrWkXVTwfKnEz6d46V63ksdlzphoKm1l0NKF5/9jHsfjeqKU8A78xf8b9uzo
         nctMnmlsdfa8rHSGCeITXBre2h8YiPDgNfgMMhgnzd9bGUKO/Kbvm1n2ULvc+U6yvie7
         uwARauJD0sO003S7nIbbIGE5XlHvhG4qYzcEnZPCGUaryfHgySUE6feDNN3m/mcvIrCo
         sKO4GajCgWCaLUBCPElYYlrCebB5WQnf1G3+m9wJQk26qi5N2KwVIZO9KPUvc2fRbRX/
         V87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cYx3kbIuWg3LQ+vflhsNivjAIxBTXXDVsMxsrkzRus4=;
        b=nxxwpStr7lsveplMcWpSk608UtJrB662bDaDOBBNnlAqc5fYcGG9n3j+Gqu7XxzIOY
         nqW8xFILf9HNcsj52okOgkh4xQGonJwnzAaJP7QaCsLIi9ywjWeduI+0gKiIhP3Wx2Oc
         3DcNYB5Km7cp6ApuWnJfgyPPcyxRDuDwaO8cGFPgyuolvBo835hm8RkU6wmOR5ws18uv
         ZpSmM1qZbeyimZ6KMEePNz2qfRqir6RGuYCBhsZ0Rbl4rEu0qgQy8orFp/8BAkH2JfRm
         2+mIqi8SOJURDf3rfrx2XEEzMQdBQJZIS7ornBDmkCyM21z+73rlWGizHCJvk7MrQUji
         pT3A==
X-Gm-Message-State: AOAM530QbH8UlDIuYkBFdZyheJikog3MCws4i9OyvCiStAnVtZQcC3/0
        Uo+FNT3Zxt4oNGWbWEPvu1D0moxR5zqscg==
X-Google-Smtp-Source: ABdhPJydUH4RKWKnMZRNwL11YKLNMNZlLbC61G6y5Q5txmMoPVi+NsQQY2gA3gbiLRnCtAyKNpA9kw==
X-Received: by 2002:a63:454f:: with SMTP id u15mr15345876pgk.198.1602556098867;
        Mon, 12 Oct 2020 19:28:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a22sm10296524pfk.29.2020.10.12.19.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 19:28:18 -0700 (PDT)
Message-ID: <5f8510c2.1c69fb81.4b5d1.5cf8@mx.google.com>
Date:   Mon, 12 Oct 2020 19:28:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.150-50-g7457eed4b647
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 100 runs,
 3 regressions (v4.19.150-50-g7457eed4b647)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 100 runs, 3 regressions (v4.19.150-50-g745=
7eed4b647)

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
ig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.150-50-g7457eed4b647/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.150-50-g7457eed4b647
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7457eed4b647560ae1b1800c295efc5f1db22e4b =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f84ccd92b62f754734ff3f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-50-g7457eed4b647/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-50-g7457eed4b647/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f84ccd92b62f754734ff=
3f3
      failing since 118 days (last pass: v4.19.126-55-gf6c346f2d42d, first =
fail: v4.19.126-113-gd694d4388e88)  =



platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
hsdk                  | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig   =
   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f84d3e9142c3262424ff3e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-50-g7457eed4b647/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-50-g7457eed4b647/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f84d3e9142c3262424ff=
3e6
      failing since 84 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =



platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f84cdbea58a41a79f4ff409

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-50-g7457eed4b647/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-50-g7457eed4b647/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f84cdbea58a41a=
79f4ff410
      failing since 10 days (last pass: v4.19.148-245-g78ef55ba27c3, first =
fail: v4.19.149)
      2 lines  =20
