Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E6D2A17A9
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 14:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgJaNay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 09:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbgJaNaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 09:30:52 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DEAC0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 06:30:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 72so746558pfv.7
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 06:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fr/8ySmSE3aBrFCCR0u4ddUsr95Dxexl/Jx+TFlA490=;
        b=Nctq9c7kywd3h0yAdvcOsTPqNMoVDYXPoRel7rEvAGrQJHDiNOSMH37qMcGwZPuqGS
         X0NwE5amNDhllpf38sg43BewnJSn4xbRWEDGwSdWVprc4BBBU6U1I1YqGxdcZtOnHH8T
         gcAQ7aFV2jJ5Wi0O0/KfIjYNBHXw70yJdd52WJzSEicU5MBgQc373Hc+8u0jXGv/Iwzf
         7Z3ucF7mn4QpL8zQO4r3wcjR9aIn5VfN3m9KQvjlNPOMAvqG0E2ASwUzAjgzSFrxCrcM
         AbzCG7ceZy9A+1/OkcBf8Q88jOJtbmBIEYnFFxadmk+MZiUD1YiRbvTdETK7UvabEpcc
         cXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fr/8ySmSE3aBrFCCR0u4ddUsr95Dxexl/Jx+TFlA490=;
        b=P3o9sgAQDM0iOzNYiX/uUorKCVVB0A2ZEWCpgDNAQ1ngVufYp78wY5FhOvzdyQPfg5
         mnB7UAg/5NCeu9OcsBs0h27Wi9CsHiN05dTeoTFV8iVc9Zl1ta8VHqvv/YlzXrdUX8FO
         i+w7Oe6am2Pc9ZgbP5/9kONS7Hs5CvFXG8OReXXyKgFJrf+mlsyVQl3DSYUpDOElfgs3
         HGTcj7SSDmjlDD9P4vq6Kwyxn+aTc1ryytqPqRAXrXv5WZ77vBrtCsIJ2EcI+BvCDEB+
         xDGB3w7jOxEs3yM2ZNpf/nZWL8C7cVcEQ9g06oU5Wut+RKMPEhBqS53XZJ+R/kMiL+iu
         cgoA==
X-Gm-Message-State: AOAM532GG1CevexMDys4O/wgdiN87/5CkyAeedCp+bb5dYv/52gQ9Hh9
        6eprAVJsDq5K+iyDPql60GcMGuKkNIJSpA==
X-Google-Smtp-Source: ABdhPJyJp0ssTQluzpyhADDm3mgxVQIsMLj7IU/ryMJt0dVlQ0XsL++DIdwAWcGUsmBEpZBjbelh3A==
X-Received: by 2002:a63:24c2:: with SMTP id k185mr6399363pgk.421.1604151051856;
        Sat, 31 Oct 2020 06:30:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t28sm8627452pfe.2.2020.10.31.06.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 06:30:51 -0700 (PDT)
Message-ID: <5f9d670b.1c69fb81.24a48.5041@mx.google.com>
Date:   Sat, 31 Oct 2020 06:30:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154-6-g2369e6ceae2d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 181 runs,
 1 regressions (v4.19.154-6-g2369e6ceae2d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 181 runs, 1 regressions (v4.19.154-6-g2369e6=
ceae2d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.154-6-g2369e6ceae2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.154-6-g2369e6ceae2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2369e6ceae2db84822b057f93d37593830a9e4c0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9d35faac9906cf463fe808

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-6-g2369e6ceae2d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-6-g2369e6ceae2d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d35faac9906c=
f463fe80f
        failing since 0 day (last pass: v4.19.153-118-ga7e6db9970f8, first =
fail: v4.19.154-6-ga0d1e09b43bc)
        2 lines =

 =20
