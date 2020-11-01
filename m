Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490972A2143
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 21:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgKAUNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 15:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgKAUNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 15:13:50 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158E2C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 12:13:50 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id r3so5787560plo.1
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 12:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uTTWDhdNZ+5CHNfAIJXpU8pNZgOUcCYBW0+faxnVKFw=;
        b=t3h4hfPeei8jcDlGRD13T5DiDzYfG4Q4VfFj14oLFGVrqSXM/vccgx+IHkpDoFD0KK
         LNoNz57+VuN32P4vy65IYr4c0Eowgk4sIDBh7hyP0uPBl7Q3L2hI91dSE1QsX9KnUZIh
         Q1L9AX3H9YAGomZggPShljDmfhB69Od8oTuEczkm6ftre8hajPzUXdG0Gd7NBqe6KUyt
         KSRAav5VSVBbrm7G2kS8TwbnF7DzJA6LGs/WfPB5Lj03shJMV4v4Sanyeg4u+nkK19hV
         rjvlxQ/P4vQMGNt8QrwxAkti2H4FZEpJaLF4ttckAOryJtu9x7cMK3hoBnsl1qgE0zzw
         54uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uTTWDhdNZ+5CHNfAIJXpU8pNZgOUcCYBW0+faxnVKFw=;
        b=LaipHcidVsM1olJE0+7SPvDf43PcFEmGwUaqI7cI7skWWhAhP2sap6Wb77uK/wuuJ2
         zZh4tQ4Ngh9Pt84wRbZigI0BuCQxXRSTPre/rwSJWU13VpeD7VpMm7H+dUI6dpOx73IY
         OtkyTeHTYnBdSiOxXVw/lQTSLe+HTMXdFcMCp0U1zbWVXuqFyc3YkuyEn7dINrT61m6w
         YXyvHmigPyXmYSISyFN2yIl7uF+gqwZUJcf1sJat2TD+Yr+YR6gmRd7Di+b4OhbcfYqo
         xPs+JXv8qBftJzJz24NgWiuqhd3Vy2RnODc5xgpSLJkSPsRVK75bpprD8Qe28xN5i7Ak
         pP4A==
X-Gm-Message-State: AOAM530zdts/SI5CCQ6hVjyDfPH+0Tf88R8+sLvXdNgNY2IBCyQADjMF
        OkUvXPiamGHD/3lcW6Wfg3bsOboYqFB68Q==
X-Google-Smtp-Source: ABdhPJxClo4TRAetAl74Z7rrjigDoZj785NRUkpfOzb2YRWb4KDZyXJkKKEsccUb3b4QvBfMs48yfw==
X-Received: by 2002:a17:902:10a:b029:d2:6379:ab8a with SMTP id 10-20020a170902010ab02900d26379ab8amr18640461plb.66.1604261629073;
        Sun, 01 Nov 2020 12:13:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i123sm11736887pfc.13.2020.11.01.12.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 12:13:48 -0800 (PST)
Message-ID: <5f9f16fc.1c69fb81.cda87.04d2@mx.google.com>
Date:   Sun, 01 Nov 2020 12:13:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 153 runs, 1 regressions (v4.9.241)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 153 runs, 1 regressions (v4.9.241)

Regressions Summary
-------------------

platform       | arch | lab          | compiler | defconfig      | regressi=
ons
---------------+------+--------------+----------+----------------+---------=
---
qemu_i386-uefi | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.241/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.241
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d69a20c91691be92364526ffb084d750e3e7f7fd =



Test Regressions
---------------- =



platform       | arch | lab          | compiler | defconfig      | regressi=
ons
---------------+------+--------------+----------+----------------+---------=
---
qemu_i386-uefi | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9b30acd28e8bd8a9381013

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b30acd28e8bd8a9381=
014
        new failure (last pass: v4.9.241-12-gec2eae343a3d) =

 =20
