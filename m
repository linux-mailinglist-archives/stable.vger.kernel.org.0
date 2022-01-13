Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D6848DF8C
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 22:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbiAMVZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 16:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbiAMVZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 16:25:16 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A226C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 13:25:16 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso20073395pjm.4
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 13:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TRKEBZ143ENMZ958w1KCL0Uf23UKI+aelAQO8f/BV08=;
        b=nO7XyuR+8GzMaYwY6E/v98SFkz/koceQy+rzXUlSOtthZDD47JqyY3us4TFbXb1GD8
         1+RXSw0R4/o1NxCLZAKbUzM6bVgcxVVhDJ9eE4bobNBi46jmR4XuY677O26OHOgJiN9l
         YaYP6L1QDOZ2tznl5xclZ9ChjQsPNv0POSsSXJC3CXEL252eoigRVPEzNX5C6bb6msHe
         Pj5Cx/xaTOUVykqIwDCXMgJNUFmb3jOrq1umldENH3IXdQqr9gXH9BfWbBIkxc9tHofl
         NeU6OlZZ0AaubUGmb5YeCvAtsAOHTpkHmpTciGUQR81e6J6jDGe0rxa8laDkkkjA/HHC
         Xz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TRKEBZ143ENMZ958w1KCL0Uf23UKI+aelAQO8f/BV08=;
        b=vytEjihJQhE40lT+G3dk8uAGjXVD22azcbjmxAUVSCfiaIAfG0H74F1UNhdPWV/vV3
         /HW90cMTHiQg8P7/R93pwIubZdgLCICVtaaWdzHYhRSTwRwhkJtv7DiVhINnZc1N1Zw/
         aeaQZB+FB/hjHc2bfh1SDZoKn8Yyipt2Z3+xWMvKXTo2kjXvAM/OnJpzn3idBpOTjf12
         Q4JcsY466WWDBqi5sd5eb2Wmyr0jHVEQlJzOFaP2dNSkz7DBP0eHkgNJjbRP3Ad6OP/T
         WuVB1UF9pwlq1swmc4UVkwaPeUG7Mgsw6tgDoRArhBtx8Tqau6OXS0HuItifnGuJEFFZ
         i/OQ==
X-Gm-Message-State: AOAM530d4o+zLWAcySgYWBWZKMOd2xH/uGSbEv4mgAxlX4sViPk4wiZa
        jF+20RdMUEROgDlclpeoVJ5N+bjah93Rb+UThBE=
X-Google-Smtp-Source: ABdhPJzBuB3gpvpCx4BetpxNyKKrlxSyQFICYK2a2v9EzZ03Zu0B+YU9/Ax8Y8w6TNfkn/v9ajXyKA==
X-Received: by 2002:a17:90a:4483:: with SMTP id t3mr7047624pjg.229.1642109115689;
        Thu, 13 Jan 2022 13:25:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w9sm2997488pge.18.2022.01.13.13.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 13:25:15 -0800 (PST)
Message-ID: <61e098bb.1c69fb81.22ccb.8605@mx.google.com>
Date:   Thu, 13 Jan 2022 13:25:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-4-gbd21debdba9a
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 110 runs,
 1 regressions (v4.4.299-4-gbd21debdba9a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 110 runs, 1 regressions (v4.4.299-4-gbd21debd=
ba9a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-4-gbd21debdba9a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-4-gbd21debdba9a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bd21debdba9abc48db21f3cbeaed4f28e72b5d7d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e066b9e5255e95acef674f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-4=
-gbd21debdba9a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-4=
-gbd21debdba9a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e066b9e5255e9=
5acef6752
        failing since 23 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-13T17:51:29.909024  [   19.013061] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-13T17:51:29.955057  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2022-01-13T17:51:29.963895  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
