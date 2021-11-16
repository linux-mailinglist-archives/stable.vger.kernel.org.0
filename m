Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A24A453C32
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 23:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhKPWV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 17:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhKPWV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 17:21:28 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6724CC061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 14:18:31 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u11so416472plf.3
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 14:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FES5/Oa3elLrQBSXND9+ZyIwrJhwbAB4/TeARbseCiY=;
        b=uxqP31m1PPbtCIetvz4jdpHQfN236Ix7mF2T3n9RODBoOvnZTIuTgZBL+ejmyeZGW4
         hWE6Nch+AImD4bW89ZCWWKZYabeOEzP3ahUy978NB0zETjOUnaeMRN59SdLzNl/rIIwv
         cGoaol+WA6A8eYlSrjn1rZhpalD1XdFvWtLgM7+A1BAY5pjCn5IHKGPnLPIdbRKFtWFw
         U09/jBFU+rX9kni9VX63pxztgzJ0sBYCbjSYXF7QSOlVSdwBmvklnVuymeGbSJah4ZET
         heQHCKGXQq5TKpRwCQ5LqY3feGvpjA07c90Ml9KBVXbWL/UmTuor+KmV5FR4gSztTLoh
         FyDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FES5/Oa3elLrQBSXND9+ZyIwrJhwbAB4/TeARbseCiY=;
        b=6miK/eCsABRAubdVt/c8/x1XIMuraMOugELDZQKIpvGcoNmAocQgEVepuRWh5HCaTt
         BTnEtVaOhr4lLg7Nv0v9nDVxEU1PSpJPcF7ASrXviZ20hehn9d8mYfGqWgEnrybLJg3J
         A1kYOef7XWX6yE2X+W/3+qMEPdalUucokk7bEIcAM1Z89uzts/wLxWerGqS8e+mfkldc
         22ZnwP8/2SduanKx+r2vpUqRUEskWQZSpQe53aedvl0cTkI6BUT43XeRCOsOEpqr85mx
         2IWrsqFPftfZEkizxF1gG9CXxmV62GSUZZ93nOtJeYGUQ+bCrBzrS2Bu3xjK0OJ6opA1
         lk9g==
X-Gm-Message-State: AOAM530ukUCK8gF3YvacgrtS49B7K2UpcWTniSTUXr4VweFw9gxFmOdc
        6ru16U7AZ94LmELATbKSRbdcZNKVCGLDs4KZ
X-Google-Smtp-Source: ABdhPJxa+sVn/i6mmqE4Yf2ct7FUsri99edMK+jrhKD1gw/KFL2EvQRkzAHcBCAGl4OUY6jNr0lDow==
X-Received: by 2002:a17:902:db12:b0:142:3ac:7ec3 with SMTP id m18-20020a170902db1200b0014203ac7ec3mr48853542plx.2.1637101110767;
        Tue, 16 Nov 2021 14:18:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l12sm20354167pfu.100.2021.11.16.14.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 14:18:30 -0800 (PST)
Message-ID: <61942e36.1c69fb81.dc6ba.a26f@mx.google.com>
Date:   Tue, 16 Nov 2021 14:18:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-250-gc4a264dd81ce
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 113 runs,
 1 regressions (v4.19.217-250-gc4a264dd81ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 113 runs, 1 regressions (v4.19.217-250-gc4a2=
64dd81ce)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-250-gc4a264dd81ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-250-gc4a264dd81ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4a264dd81ce73e72bec7af5498d600ef9800e36 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6193f5393e07b065d23358e4

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-250-gc4a264dd81ce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-250-gc4a264dd81ce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6193f5393e07b06=
5d23358e7
        failing since 2 days (last pass: v4.19.217-72-gf6a03fda7e567, first=
 fail: v4.19.217-85-g1a2f6a289a70)
        2 lines

    2021-11-16T18:15:05.721592  <8>[   21.344421] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-16T18:15:05.766281  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-11-16T18:15:05.775993  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
