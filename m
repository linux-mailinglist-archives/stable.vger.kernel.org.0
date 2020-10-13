Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567D128C8FD
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 09:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbgJMHMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 03:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730003AbgJMHMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 03:12:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE435C0613D0
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 00:12:40 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a17so1588751pju.1
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 00:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FjGLEh5YfhiKNLlmq9WyALT5L0cgxwKjDPtL415DMX8=;
        b=QxumJtmI0pSHaGgzdM+bFDKd49u7P+slikhEqIBZC8LgDdWVKoP3TJfAUdG5MxCh6C
         Wa7lhhUVy8nqa6NhQL8itoM6+xYn4ugIX+53kUHv0KimZ/PJEfsbS4ym0OuyljcHZRy9
         JUB7mfPn0Srtb/RoBR81tRqKqDCgRZJdsPKPe6XXOzRpKWvHJL1JmvuNp9hWOBm8DMWV
         Yq4pSRjKlVHjW25Mf1zcHjNucKiDzkmBq4+J+ksabDmc5UTB4fNi3cPqhIqAVLWGZSAD
         UaDhwNsAO2W8raraeL2Uu0UTIV4OYMRJTEQs32eUx8YlInOMDdvdOAVyjYIlZs9wa/nr
         o/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FjGLEh5YfhiKNLlmq9WyALT5L0cgxwKjDPtL415DMX8=;
        b=CjGe4D6Ynl4+1Jaokye6REqsjaVBOjr/4ETowwJCGZXggfCzASarul1kpDr9Na7wn4
         FSScbacW969BBu+2mHVT6XJs/tWtZlwJFtL7lP/S2kgMqOA8X0FtzjR3sT0zhWfTfDdc
         Zp55iCRffjwCW10pxshYoT6VWoKqmZ0cLos1BMQ270o7C99hmx98CEmn0gLGRPHAkABu
         CHnAw3ALfyZQ+rqfYGPaO2auYxuAgoJM02m1OWBFn7uOVpjmZT7CPBCVMmsNhIHVy5AJ
         cXVAzMcxWVZeF6iViwQSt/i3BvrNwHnwfGYTnIzsYVSiCQ5dwmS313kXdIJ3Grahj3Rc
         /Wyw==
X-Gm-Message-State: AOAM531xiFlsNedI4nULVZuxJnlHzKTJxRCixCef4AvCDq5O2XrJgxZg
        b0aenrajGlToR8O4UyzJRVbP6fxT1zZ/+Q==
X-Google-Smtp-Source: ABdhPJxjZfyikckQuWSZAiWIwIMd/nWZwOOMPpXZ8cu+NZZhVmKWst/MVxq3OoJt+3y0jYim4xCBFg==
X-Received: by 2002:a17:902:8c8b:b029:d2:6356:8b43 with SMTP id t11-20020a1709028c8bb02900d263568b43mr27160586plo.34.1602573159885;
        Tue, 13 Oct 2020 00:12:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c12sm13001595pjq.50.2020.10.13.00.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 00:12:38 -0700 (PDT)
Message-ID: <5f855366.1c69fb81.a74f6.b15f@mx.google.com>
Date:   Tue, 13 Oct 2020 00:12:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-39-g1779016429f0
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 115 runs,
 1 regressions (v4.4.238-39-g1779016429f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 115 runs, 1 regressions (v4.4.238-39-g1779016=
429f0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.238-39-g1779016429f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.238-39-g1779016429f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1779016429f09282dae0f8283562019d1c56fb2c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f851960d2e3de37694ff3e2

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-3=
9-g1779016429f0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-3=
9-g1779016429f0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f851960d2e3de3=
7694ff3e9
      new failure (last pass: v4.4.238-38-g473dc135aa7d)
      2 lines  =20
