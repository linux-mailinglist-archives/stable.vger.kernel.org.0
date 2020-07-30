Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99C82337CE
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 19:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgG3Rja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 13:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Rj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 13:39:29 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D3EC061574
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 10:39:29 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w19so1820596plq.3
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 10:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jJox6PBEwIqZzuVwbWvzXi9fjtvHjRadP/lG4Fhn4dE=;
        b=YBV944vdlwfrsLD4ZSoiHekoIo4+6BuHJ2zTET4gcdE32LdiduYiV0Vi/cwHSD8fT/
         CVyPOjPjCRzyJTGOp6e1GSoMJGnL69tVT0w48aoPy+qnD73J6NWa6TfbIVv8CVq9FO3H
         yXkKR6kZiZja8g1uapWD0vj3Cadt+hH86Dmyyp1KlsAvL2ofsBsgdLKFnh0SbQeVP0Hk
         DvlMI5U+LBx/UqpR2XNMMQCIup/eZD/LK9xxaUPibFFzBMzsrScZqerNC/D57JinP++p
         kT3tG/+tRKci6vR8CvTI7h61GvmVpPpVznGcdm1qXuVZDG5ndvUh7xaAq2jvYfBHIVN8
         ZQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jJox6PBEwIqZzuVwbWvzXi9fjtvHjRadP/lG4Fhn4dE=;
        b=sCCAB62LwdKrsYfbPksRu+qb7gpSOOD9lLHwztx9pMBY819exTni8hj+lCpyjp2yLH
         +eopcXMdMsuvR0hnoz/bVpIYjjtgvND3E9bXAWHcI8BWCKEDx2hTXs/9DoSqDPJW8Yjn
         SwSO/TS+ck8wugXOyGAef5RpriTbTB51EHljL/EDFNMYZkqSZzVk15qv4B/17+sbBCx7
         FMz6BRveZkQn4sFuo4PV7bAQs+r/38LDxzQ199fIWO/UQ0zA5fdpMWkPu8N7hWF5amoB
         XFRNDy8TiE4fP2ArmqvjIeS2h3Ta//XgFzSQBUGKX5W62O2LZTO5DHI0Q1E+hfh5gL6S
         czYQ==
X-Gm-Message-State: AOAM531gRx1zlwkbpkgXQezxzgAo372L1+jUnJdyn9J36FG9zcyEXoSH
        Rgvdqi5Y/pT8JADxlR3IHTxH+Wma1rw=
X-Google-Smtp-Source: ABdhPJz/H4cp9a75OcSFQMUwZcwHjRsIh2/3DL2rdyb4TdD971QqQ/pTVHOtK5GMkxmMvaj591QtVA==
X-Received: by 2002:a17:902:7e86:: with SMTP id z6mr256041pla.161.1596130768839;
        Thu, 30 Jul 2020 10:39:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 9sm6942965pfy.177.2020.07.30.10.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 10:39:27 -0700 (PDT)
Message-ID: <5f2305cf.1c69fb81.e3600.23cd@mx.google.com>
Date:   Thu, 30 Jul 2020 10:39:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.231-55-g0ee6ef294be6
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 119 runs,
 2 regressions (v4.4.231-55-g0ee6ef294be6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 119 runs, 2 regressions (v4.4.231-55-g0ee6e=
f294be6)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/=
1    =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.231-55-g0ee6ef294be6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.231-55-g0ee6ef294be6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0ee6ef294be6266800b03470220722c82b6ceb47 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f22d3bdc2e39892aa52c1b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.231=
-55-g0ee6ef294be6/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.231=
-55-g0ee6ef294be6/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f22d3bdc2e39892aa52c=
1b7
      new failure (last pass: v4.4.231-38-g39099bd269e7) =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f22cf8982bb09eeb852c1c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.231=
-55-g0ee6ef294be6/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.231=
-55-g0ee6ef294be6/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f22cf8982bb09eeb852c=
1c1
      new failure (last pass: v4.4.231-38-g39099bd269e7) =20
