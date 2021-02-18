Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F059C31EFB1
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 20:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhBRTV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 14:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbhBRTFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 14:05:40 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A786EC06178B
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 11:04:36 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id z68so1753890pgz.0
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 11:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cU9ZKWX0WbzmtdWy9RzjsdP30ODwkhADjv3pVNZBAQs=;
        b=qfKS5iGTsGLY9FenCfNVBTqBrQCFEr1/0wJWew2eiIHPMF1ek409iJndJ5wTkx67JA
         q8bq7f7PtYnQOVigIZ4zzeSTmwHkjKrSrouqxsjFJfiC21DMaGOhuqOedIklsHzWWLFF
         TopYDrUP2fM1wenCkuT2bsY0Y1zZNql+n+Pr7pSf2yLUlvh9s1zzoXU6Atuutbj3rbOK
         RZn8ifgtECTVu47exizjwsdAMKQaWfN5EUljV9dieitWkt6vUt7iEak50vXUue3JxelZ
         eNodK3E5QgORX6V2muB84WtnY52ChIMIgQhTOzXljHx2BtZQWOoZW43Re+99UOaTc1Kp
         +LhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cU9ZKWX0WbzmtdWy9RzjsdP30ODwkhADjv3pVNZBAQs=;
        b=QsLBOoVS16XYu1zK1hkGuGZRVPMmtiMfGzOmiGz5WAccG2a+fesAP9m++FZCRpsGSB
         2YGZF9sA1JtPK/OUB54P9FP5+55Jqem5Oi6vQ7I7tcPsBCLPp63mkfAsqC4buNrpvRGv
         6phAlw7VYbv6HZKlyAqSqIwg+aMkXe9mO7IcZZgNbAVTSi52pxRSjXESQ1EDtsuR6lmU
         qGTBxvXCyG9fURuPQByDISb2T/e9t0W/esiOmhORJ0k/kVTf/8Me6Dw/rPUEo0VXJ+ry
         Ros5iX1cl9J6WaiRbSC734sVySqLfujlf8bRDqfwOi24BCswy1HXWdeUbc3oVlFC4lZU
         JHvQ==
X-Gm-Message-State: AOAM533Ogxzg66L+LzV4lcHvPIbdjy2yCjxoMr/WkA4IOhkYieWyE7Ws
        v0D3Hs2Nq4K38ZoXmEwl93GfDA7kMDBnnA==
X-Google-Smtp-Source: ABdhPJwrsvRnb1gjChNPf7JxtBECQDT+9bUkQ/QuWo5G53Ln3KYGjR+tbJBS6scFiiMPchMDEUeasQ==
X-Received: by 2002:a63:2217:: with SMTP id i23mr5183503pgi.437.1613675074839;
        Thu, 18 Feb 2021 11:04:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b14sm6484877pji.14.2021.02.18.11.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 11:04:34 -0800 (PST)
Message-ID: <602eba42.1c69fb81.db8b1.de8b@mx.google.com>
Date:   Thu, 18 Feb 2021 11:04:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.257-38-g174d2d60a65f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 53 runs,
 1 regressions (v4.9.257-38-g174d2d60a65f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 53 runs, 1 regressions (v4.9.257-38-g174d2d60=
a65f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-38-g174d2d60a65f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-38-g174d2d60a65f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      174d2d60a65f488fa4998d240429da2b70893907 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602e87542d60394d3eaddce7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-3=
8-g174d2d60a65f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-3=
8-g174d2d60a65f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602e87542d60394=
d3eaddcec
        new failure (last pass: v4.9.257-38-g5573542614228)
        2 lines

    2021-02-18 15:27:12.656000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
