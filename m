Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B329B45E191
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244325AbhKYUbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244379AbhKYU3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 15:29:54 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC8FC06179B
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 12:21:51 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id l190so6156594pge.7
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 12:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cQyHdVc/tFymyS6yywBe+tJ+Pa9Uuz9qbSndBa/5+KI=;
        b=U8bjvXVZt9kzF5cAyU/gSRVmHezYrHtkWyfLyDPyZMnVzSK3TAijgtQo6TMUsDhTcE
         C80qaDnJKtGZBlbbV/alM4Utr/IsvLBhCjNV5LIgsuDSsnrhGQETxOgI/PcFMDmv96aR
         eM2xrnNMi7cWrrfdC/o3Niw/Z6z0zcKkGY+G8JGCKiSs5z0Suvj2GJCcmhdq9qfK92KN
         yG5VPdW9YNOvRG3X5A8ktands85tUXgXJ9zOFvIX9rPMV4VS82LdvMZvSSUwupEOTD8b
         BxvT3Z3HdgEAy0EDy0KFZXBPOZnH0QqdnyhdxHl3J9wx8WjtoiOPLhJaPHwJaLejQ0p9
         9W9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cQyHdVc/tFymyS6yywBe+tJ+Pa9Uuz9qbSndBa/5+KI=;
        b=K10tsaoL+ZeX8Q1LTadyEy/BJoaDicF/CVBiyt8vydFGsX3M2W8xOE0HeAVXVBxx1n
         WLg+VOQSid+YcW9MJeQFQ4e93juki0BjnnL3NARUewQNFvfQWrTX6k2tqXtElfbmUYpm
         DdN3rrqcemMVnnD9bUbDEleMB5ZuU4gnwDoBy7GTmVrXPETX26pyYCWLeQXUlrKa6g09
         SXxKWcOZcJKPguMoFVXg+ZNLbCM71BWrW1xSAeBI/qzqHnHkvSKlgdNzJgrIPmgRQwNc
         r4kqTV+ZYNotU0bJpMO8BDtxLieWnh2jLpmRQ1u/R9OOwGTQ6zBu+W2KAETzNwRYVjpG
         LYqA==
X-Gm-Message-State: AOAM533Dte3X/vzlK2neUXLrRFTi9oqtl7Kv+2UV8X9tMsKWMsRrV20U
        9PMqmAOKg4q3NxEkHCYCibcFvhIsmuOPYvVy1Rk=
X-Google-Smtp-Source: ABdhPJwXOBahgzFeDxPlTqT6jIP+2Y7eygnd1BjN3zwyUto1n3H+eEyF4HY54aR6PXPCFvMxIBz1ZQ==
X-Received: by 2002:a62:1a03:0:b0:494:64b5:3e01 with SMTP id a3-20020a621a03000000b0049464b53e01mr16797854pfa.35.1637871710798;
        Thu, 25 Nov 2021 12:21:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm8286934pjz.43.2021.11.25.12.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 12:21:50 -0800 (PST)
Message-ID: <619ff05e.1c69fb81.2d8dd.4759@mx.google.com>
Date:   Thu, 25 Nov 2021 12:21:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-250-g2147e9d66a0a
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 131 runs,
 1 regressions (v4.14.255-250-g2147e9d66a0a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 131 runs, 1 regressions (v4.14.255-250-g2147=
e9d66a0a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-250-g2147e9d66a0a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-250-g2147e9d66a0a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2147e9d66a0a6132d8b26c4fed28602e05c6993e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619fb8c9d61810a68ef2efa9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-250-g2147e9d66a0a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-250-g2147e9d66a0a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619fb8cad61810a=
68ef2efac
        failing since 0 day (last pass: v4.14.255-248-g646bcac5a19c, first =
fail: v4.14.255-250-g0b1b1688e7ac)
        2 lines

    2021-11-25T16:24:24.150774  [   19.994415] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T16:24:24.193713  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-11-25T16:24:24.202726  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
