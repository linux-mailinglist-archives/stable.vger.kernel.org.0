Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BE54445BE
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 17:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhKCQTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 12:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbhKCQTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 12:19:40 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516ADC061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 09:17:04 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id x16-20020a17090a789000b001a69735b339so1776777pjk.5
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 09:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nHxitfXGz3pMm8j941pKZlzuyga8ZroFC2hdAV+joko=;
        b=xhAdAbFZCU8ZhSsXP1fnQhPEwxE26mIlsCqgY99Thxpf4geUmxWySnvMX3WkUgGqYT
         dZz6Epp+9IE+1E0C1cPBdvc3ErVp7ov9Muii9fU3x7lzMKpMshcqsIhBAJlLTJobScGj
         tSJzNUe3LYbU/Wy0shJWJ39L3Lc9T5joonaOTTy2sbFGaODsCTJn1Gola7kadp9AHKmS
         8M9kUErVPD91VE19HCzZ9lkZjbgSbhTjO4I6qFLAqX1eLfzsrzruNJPdV5Q87O4Og2hP
         ciPZ8lpXztpnv6lckQuBqHehsVs982urrHeZ7GpN0nnIYyzAbfJPUUl3fTg36EwjDXHR
         pNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nHxitfXGz3pMm8j941pKZlzuyga8ZroFC2hdAV+joko=;
        b=n8M+89kAZ2rNQxKZ80P93XTXId10t1gkSY3N9y+DT0fU7mxkQJWa/08w9Vqs9Ry+fh
         qEuPeiKhaRqu64w8FFcGAEEwAvDFjOGcD1A6AmwqXP3vLXTDEpDJbvyRyTy9q0FVGNUX
         vlqm6XoInbUw7CGb3IzNO0XtffjCITNHtdCetDtqeLT2Bv9ecOTBykNH9IsRLPtbOszX
         WXxXDBmXvSg8O15kFDeLIaJgi23u35GVA9/thqWHVIu/VjUdKvQA9AkNW2aRyQPpjysS
         OsBn8DSzt5dEn5X+PSyS1kty1ccpHH+IAHQVg+23wazRyfA+VJ20qpQvY4nToFi6LJ5q
         S/tw==
X-Gm-Message-State: AOAM530t9+54OftM7E5kK0Lyfo3O1OS6KP+G2AE72g2p4hezsWR2RkT6
        ZbZdW2fm3tzPnDcxFHm4wFyo008BY0u0pXKG
X-Google-Smtp-Source: ABdhPJzmvXoJ4MZ2Zu17qDfPx4c4jdMJSXzkt2z0G1aW/I6MF6cshUwBh0L4IowA6vlDRLe+NPNt2A==
X-Received: by 2002:a17:90a:928a:: with SMTP id n10mr15488190pjo.128.1635956223669;
        Wed, 03 Nov 2021 09:17:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f19sm2855673pfa.22.2021.11.03.09.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 09:17:03 -0700 (PDT)
Message-ID: <6182b5ff.1c69fb81.e44e.8f4b@mx.google.com>
Date:   Wed, 03 Nov 2021 09:17:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-2-g86b9ed2d25ed
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 125 runs,
 1 regressions (v4.14.254-2-g86b9ed2d25ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 125 runs, 1 regressions (v4.14.254-2-g86b9ed=
2d25ed)

Regressions Summary
-------------------

platform       | arch | lab           | compiler | defconfig      | regress=
ions
---------------+------+---------------+----------+----------------+--------=
----
qemu_i386-uefi | i386 | lab-collabora | gcc-10   | i386_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-2-g86b9ed2d25ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-2-g86b9ed2d25ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      86b9ed2d25ed079d0d818f066b7ac155a92b7544 =



Test Regressions
---------------- =



platform       | arch | lab           | compiler | defconfig      | regress=
ions
---------------+------+---------------+----------+----------------+--------=
----
qemu_i386-uefi | i386 | lab-collabora | gcc-10   | i386_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/618287a779613b8809335907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-2-g86b9ed2d25ed/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-2-g86b9ed2d25ed/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618287a779613b8809335=
908
        new failure (last pass: v4.14.254-1-gf8e8f2eb28ee) =

 =20
