Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C3D29ED9A
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 14:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgJ2NvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 09:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgJ2Nu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 09:50:59 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875E8C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 06:40:52 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f38so2379075pgm.2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 06:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7mAsV5xqoCDLelwe+ykhJFWxUZ5BlQC4EQr+ISXEcx4=;
        b=OB+FSTSbKjcCbMv1F00rN0c41ULd0LCyXNa+ZqpUvBdd+6gPmaEqcX8NBTGNg1OctK
         iqIQdLMb07ZPvHdYfus3sx9MQSIar1jgIZ61WOIH9eoszpxvVncYUC7zllOhWyWmXtxz
         MpVN9m8c/FAyvN0AmyyxRPhwYqXixcwf+L8PocdWW3FG5p2IHYl1J371luS4nIza5f2Z
         3alntlhGeV/XzcC3aEVXfoiFSW4eEZ3JrQ27UZnlZxpS2W2pAvQmv7QbbIzehhT9HEb3
         xCQe57ci1XgVgBXi/v0vqFnTPbcSibvN3QLhZgBqo+1Yro2KX3GeD7PEakw4K7HjPNSD
         LbXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7mAsV5xqoCDLelwe+ykhJFWxUZ5BlQC4EQr+ISXEcx4=;
        b=tj5FHGwzXJuA8iNge1P8S0AfLeBbJsabdEBeh3hVWCh+8wYrTICi0jkNfL5G9UzGIR
         Sz2HURyBR1JUM+PbeMRG1kuskmJ3duY3l9Kgh32olkNejoUzyiXHtKIsAwDx01UacH87
         FlvwbgJUM7Op1YCPnJazpu7+CHzWVnJhcgMtHGXZYGFN8QOtMVJdR8XFAZfUgqJiYKrX
         BztLkpTH3PBQ9EZYkj/8wX7ov14T/nEsjGdmgOE3bItqTsfxhT6uXNt92Y15yGLUJ8/o
         B7G1u0jyOfmndIkwkd9MdDe0w7RwiD/IQ/Ihe6L6J06u2vNbCvjyRB3b+P5FTv0pxq+G
         vZvQ==
X-Gm-Message-State: AOAM532qsHNMpnOP+itKbH+2DvdG1y23mORboqiqkcEH5DHgy6O4J+SQ
        /3muyMNAEjD1K3QvizNEiTZtXqS2zF8+4w==
X-Google-Smtp-Source: ABdhPJwiP92ebiinADSIVPGoZhr2SF/B0duJh+1ZRb0BSPgdnrrEls/0c6kUykH5z7Ra2mCkj7Q8fw==
X-Received: by 2002:a63:5914:: with SMTP id n20mr4142273pgb.69.1603978851685;
        Thu, 29 Oct 2020 06:40:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q13sm2961891pfg.3.2020.10.29.06.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 06:40:50 -0700 (PDT)
Message-ID: <5f9ac662.1c69fb81.a1438.6e78@mx.google.com>
Date:   Thu, 29 Oct 2020 06:40:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-408-g4434824fa314
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 201 runs,
 2 regressions (v5.4.72-408-g4434824fa314)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 201 runs, 2 regressions (v5.4.72-408-g4434824=
fa314)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =

stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-408-g4434824fa314/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-408-g4434824fa314
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4434824fa3145abeb80894a9ee92d977c3ae831e =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a91e1188e42b04738102a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
8-g4434824fa314/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
8-g4434824fa314/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a91e1188e42b047381=
02b
        failing since 0 day (last pass: v5.4.72-409-gbbe9df5e07cf, first fa=
il: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a9390e27e48b931381038

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
8-g4434824fa314/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
8-g4434824fa314/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a9390e27e48b931381=
039
        failing since 3 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
