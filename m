Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AC8462758
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbhK2XDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbhK2XBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:01:16 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC9FC09CE54
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:22:37 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso15236020pjb.2
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ffmN/rH8RbB8Yku+AMpMXdvR6j1dm2G1EoBYhbmle2Q=;
        b=KweFF2SSoAuBY7UYgJ8RmlydAvdr+0SwEMHDLvkRSo+23d8P2NfAUj6aCuLUUc5nx7
         EAxBr7Sl/RB+AfFXEJsmqSGm7cujJ2hjykdbMNu76p2AD96/7glRRvyYAfFu699j1mSn
         34r2kjo0n1eRXuxf+Hx8k5iF1uklwCOpFPMvptaG1TrUa8m9081FvF9Le9LpN8s0Igkm
         oWifZcCmME/HBeNB9poY14GNWtUrGhQKGxYnxzZgOEMy0G+XDVeRNLeKzarWpnXsONRe
         kbKPXrRMuR8gKdXK3wZkReCKeUo1KkDgBqqaMGUesBUcisXGCuxHoFmMK2N6B4NZPr6j
         R7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ffmN/rH8RbB8Yku+AMpMXdvR6j1dm2G1EoBYhbmle2Q=;
        b=y7mt4bibU66+deSqvwRxQa95ij5V6EfKjQm55/vyeGXS/4WnRRVKvbFh4bhfqHNzlF
         sCpW1fVZGLMJOaEv5mxt0pcR8m1PG4+8lVydynSItdzpjqe9QIA8Si9V7CJ8n4IqjlA6
         uZOPob9Ot+Gdsnycv6I9s4KImEHM/D1Mlaoz/QcwwbjBoLQc6ocdW8Qp4x2EFgyQNMTm
         eYMyfcJCMhYeNn5zhWpQknC8BWEudQggovB5/LP9rlGeByRJeqqRARhxkBl0DUFNpUUa
         8/45u+ZwiXU/pyDI+/Rg+zzbU6bpp6LtItiwBFwA7+5r/vNmcXnhDMmhK6ZUClUcACSG
         7NjQ==
X-Gm-Message-State: AOAM533nDrjqhz1+HDbPEv6iy7qD0dwCAnvdzF5JMZRb33r5eNcKzJ76
        9tdsmncRi4UV0yzoIUnWa8mruXoBKtohy92m
X-Google-Smtp-Source: ABdhPJxDDtnzDtPKGiAPYYCYWVrOvcBaEtLyz0/Vvop2TK82EOpGr4hFOt3RIFdIqNxbGvrfaAb3Tw==
X-Received: by 2002:a17:90a:d192:: with SMTP id fu18mr340176pjb.177.1638217356832;
        Mon, 29 Nov 2021 12:22:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p188sm17501064pfg.102.2021.11.29.12.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 12:22:36 -0800 (PST)
Message-ID: <61a5368c.1c69fb81.82e13.03b4@mx.google.com>
Date:   Mon, 29 Nov 2021 12:22:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-22-gd0a6005afb1e1
Subject: stable-rc/linux-4.4.y baseline: 103 runs,
 1 regressions (v4.4.293-22-gd0a6005afb1e1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 103 runs, 1 regressions (v4.4.293-22-gd0a60=
05afb1e1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.293-22-gd0a6005afb1e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.293-22-gd0a6005afb1e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d0a6005afb1e1cb961e5bd396a120aa337ae8895 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a4fe1484def7a4f818f6d8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-22-gd0a6005afb1e1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-22-gd0a6005afb1e1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a4fe1484def7a=
4f818f6de
        failing since 3 days (last pass: v4.4.292-161-g62979a1e3cbd, first =
fail: v4.4.292-160-g026850c9b4d0)
        2 lines

    2021-11-29T16:21:19.224906  [   18.930694] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T16:21:19.274837  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, mmcqd/0/78
    2021-11-29T16:21:19.284662  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
