Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFF629EDEE
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 15:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgJ2OLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 10:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgJ2OLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 10:11:01 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630D9C0613D2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 07:01:25 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 133so2394895pfx.11
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 07:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V4Hnp/3vZULMckBx7jBgDtR1lFRhpnhA0KjhzSiZ7GQ=;
        b=V99CDTSGdkAjOfBu84Kw5kqxO/F6ON9/lsNfASZVwJQJ0KZ3SUjQB0Sg2dOF8LQ34F
         GcTK7YDBzn7RNvCn/wbLb1W81hKOvVjB9PMjjrqTM33Ev8ikcUMiBf3QfvUhA9F3kUAU
         vn9pMiSk4Rfg/Huo3f2PYvvdI+xn5Nc1uFFTc4KbExOgNJfscN9tNfTxf78/nHqRQHsL
         oSOQEVzE+C8XEGSxitKSedaeggN7eI+gKgWWEIRrgpP+dKPIzQe3B1W6tahFaOw+STan
         BKAs+dg0OZFLYwxpUvFm2nACLtaY+fn/wIxThHY4g33QxdY5oIvjfjVijxqXDB5MZcSF
         gboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V4Hnp/3vZULMckBx7jBgDtR1lFRhpnhA0KjhzSiZ7GQ=;
        b=cshu3iG1UJKmkPUVydvInRckp8SP9b3aNFWTHOY/yn5nfhfFguaeHlXyFfUQMe/9cC
         UWkWe5JaZN3ao0Mt3LdnzHYNJnDgXj3rPtn9venhMd2Gl1EQd710Vcm9SCsA3yGkDaHk
         Daw9NhH37068ZJvqGXp2WlBcteJ5BWSM1tFkqSMFiBWbc7bY9BiK04aHmF5trgNSr+qE
         l3CRDiLa/YFcHKXHBy+q78HwiwcYdw9wr7x8vqvl344kOulA4T7Xonx6Vt6P383q8ZY9
         B2Q519o+phggSJYeussiuVddCm76rasSUA0OFgAKzGgNB8nxlYp0OzuP08/gZoZA0pso
         ytNw==
X-Gm-Message-State: AOAM531/0WU+CoQWFGkxCc93ucrYcNoS0NksiSgTQTSjAbfzs5MemM5z
        x5Uka8DeT3YwSA8f/kaf2UYL1P460h1JNQ==
X-Google-Smtp-Source: ABdhPJwQ32XsBdb8DmAuRr3jGZDMCO5GsYgTUSh2+21u1ti9BHROnObBHVqCmQpyg8Ccpr1VFxSxcg==
X-Received: by 2002:a63:1e64:: with SMTP id p36mr4151889pgm.126.1603980084013;
        Thu, 29 Oct 2020 07:01:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n25sm2819610pgd.67.2020.10.29.07.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 07:01:23 -0700 (PDT)
Message-ID: <5f9acb33.1c69fb81.2b997.5d07@mx.google.com>
Date:   Thu, 29 Oct 2020 07:01:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.202-192-ge89d89c342f6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 165 runs,
 1 regressions (v4.14.202-192-ge89d89c342f6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 165 runs, 1 regressions (v4.14.202-192-ge89d=
89c342f6)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.202-192-ge89d89c342f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.202-192-ge89d89c342f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e89d89c342f6ee3f6b0e22c06ff3e3d6bc978007 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9a9b6773d56acd27381032

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-ge89d89c342f6/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-192-ge89d89c342f6/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a9b6773d56acd27381=
033
        new failure (last pass: v4.14.202-192-g666a284dfa13) =

 =20
