Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71067319F32
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 13:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhBLMxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 07:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbhBLMwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 07:52:33 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F82C061574
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 04:51:53 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id t11so6171065pgu.8
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 04:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zTX9PnmWufJC212lpcL430ibL2V6QNLLR27nieN0Hg4=;
        b=cv0pANa6/aAtuaehe30NJuGCic+jUENp91lkH6V6MyPvD5kJdnekg5tNvXaEI7DyS0
         hVkqACxeQh8hlVw6dq2iF8W2kp/AMysgwrtrPb+K8cx+79Wl5m9BsP0ukoPnjQmhip0D
         Ut+1h/GUp5bL6e4e2IV/zaWIlsY/TW1Cpr1DyQOvYzKxRfB8NZlMt8CXsQONfE3URQxp
         R3Cxw0xgvIZbGv8sAiH3O7q2d7Q4X5U7a5OLdonY/8Fkh/6qkLQfYOcg3KIQXDBdrDqn
         xjlEzP/FCF+G+qC10203q2uw/duo1FJemL9I4UcFvC8kFY8ZgAZ5ynzIq2qIcaISyNk8
         it+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zTX9PnmWufJC212lpcL430ibL2V6QNLLR27nieN0Hg4=;
        b=RqrYFBnI54YxmX+H1BQFomdD8utxHgXchMCoXGyr7+E6/XcR4AturFbc25Mbl1KKKi
         hEU9XyZ247TL4bKAdeLnyGAGRhtnGlqFFZ3f838uovwFl/UfYLEUncyJoj5P1271EVlz
         h8UfcCwUsLlyl84DNasJQW+bNbbcVCzshopcP/OSBeawFqi9FaIt14Fe1OYGmtpRZaaN
         epi4kvkG0XE3Hj77BtihIxW8vQUvkyLWl0FYQnnHaxwdcPF6iuokvGZhIQjlorYLwrlI
         JjFbjHxQ6cNsv/rwNS7bhSZG6WPatug8TEmiocsZsRqXpCVoQsnQQUhUMtSbBdD0h50b
         APhA==
X-Gm-Message-State: AOAM533swzARRFwQRcSEc6tY4m6UGIDekaqmI8bejfrHAtc+DSYdgmU1
        uqkrXYaZz/qQ8alcWpTGXr51RfTwhpnuxg==
X-Google-Smtp-Source: ABdhPJzN3eUwGzxlIGaRY1e/MoHEr0Ky30RVlr/u/jcCkv43VzdA2eXvD5OVnlQ60S3WUSmyMR5kmA==
X-Received: by 2002:a62:7e8c:0:b029:1e1:6431:7ce with SMTP id z134-20020a627e8c0000b02901e1643107cemr2942219pfc.6.1613134312709;
        Fri, 12 Feb 2021 04:51:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s11sm8519670pfu.69.2021.02.12.04.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 04:51:52 -0800 (PST)
Message-ID: <602679e8.1c69fb81.51da6.2d3f@mx.google.com>
Date:   Fri, 12 Feb 2021 04:51:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.175-28-g7a5acd93ed02
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 80 runs,
 1 regressions (v4.19.175-28-g7a5acd93ed02)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 80 runs, 1 regressions (v4.19.175-28-g7a5a=
cd93ed02)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.175-28-g7a5acd93ed02/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.175-28-g7a5acd93ed02
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a5acd93ed02982be8ee91127bad4f85473b3c1a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602642908c24bfec063abec0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
75-28-g7a5acd93ed02/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
75-28-g7a5acd93ed02/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602642908c24bfe=
c063abec7
        failing since 3 days (last pass: v4.19.174, first fail: v4.19.174-3=
9-g69312fa72410)
        2 lines

    2021-02-12 08:55:39.811000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2021-02-12 08:55:39.820000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
