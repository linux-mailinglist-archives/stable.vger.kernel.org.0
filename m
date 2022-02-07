Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444BD4ACD56
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 02:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbiBHBFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 20:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbiBGXVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 18:21:48 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5147BC061355
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 15:21:48 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id r64-20020a17090a43c600b001b8854e682eso845628pjg.0
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 15:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S/G4SbxLm+ibI6yMJE+bp270+CDWyGrZfd/g/HO6lc4=;
        b=LZzMNJXe1amdnYU2RSexS9otSWc2iYN7RSEUWGe8BiuBDNqD+Itc2ZsVUuZs85a7SF
         sDjyoHNwErdoL9Qop+YQgE0gk5C+NhU4MC6/oRZZp+leva1MssifwU8eaCBdiqNKz3B2
         02qiw2EHXPQpns53UnTYdDqbSZ7z7Z3IDr6bssosXVfCLKRAnkcZBQ/oY0C/MTUPunZ9
         Pl8CWw5G5WvfKdBiOH9veMzTaqLLubhIly3jTUexBDZx0ueMSr5XURYhpS+PjXoj7BgN
         7k/qhbq1zRhnezm7c+ltguGm7h8QBz73u/NlqYupJNSGw7jbUQK6fOt5yKugqLMIrHWf
         iTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S/G4SbxLm+ibI6yMJE+bp270+CDWyGrZfd/g/HO6lc4=;
        b=JPNyqvqNr4/zNSjdCa40WLlJuUvykVn8SITz1e3PKIZdMW74qliJgoC3Jn0j6R7Hku
         nGoWOV8zGGBmmRcX7VJ8zDoVUSga+kF/yyGRKdiFh8l2HEeAVj9XfQc8P0aqLFBJsT6b
         bEVvL2beClk/xp+vF3oiuIrbAH+6hyF3s0LMTv4PxXO0q/bp6mInW+ko/zIg167dXtBw
         A/WuGKdscxaJvm8SH/htPqdlf6bsBvFcex71qxlevJ10tfULQIL9stsuSgZt7Mldvnqi
         xv/rD/Q/m3kM5N7bkgCG1kS/Jp1OF+u2XhedLSNTAbaIN4reu6FAtJexeifdnDsKTdx9
         p0Gw==
X-Gm-Message-State: AOAM530o2d815EoefVPGJGAoFpHz5O0EYjGjcBaLzRO+Q9pRoxFXxnuZ
        BXjBR+5/PBBokM6bfSrCNm25Pzv3VMvxOKkc
X-Google-Smtp-Source: ABdhPJygC8So6QJ8+bZX6OMz/5JhJj5IZZrLphxoFWq5pZew3r8EBXiA3FIHnZpQvWB1UqIHRwyDCg==
X-Received: by 2002:a17:90b:4b90:: with SMTP id lr16mr1370484pjb.52.1644276107718;
        Mon, 07 Feb 2022 15:21:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 142sm4301169pfy.41.2022.02.07.15.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 15:21:47 -0800 (PST)
Message-ID: <6201a98b.1c69fb81.7a152.ade5@mx.google.com>
Date:   Mon, 07 Feb 2022 15:21:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-69-g50cbdd0bfd05
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 93 runs,
 1 regressions (v4.14.264-69-g50cbdd0bfd05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 93 runs, 1 regressions (v4.14.264-69-g50cbdd=
0bfd05)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-69-g50cbdd0bfd05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-69-g50cbdd0bfd05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      50cbdd0bfd05e44ad1c6735e30113c8376e40f6a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/620171abb2a832c2305d6f1f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-69-g50cbdd0bfd05/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-69-g50cbdd0bfd05/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/620171acb2a832c=
2305d6f25
        failing since 2 days (last pass: v4.14.264-40-g54996bdd9ffc, first =
fail: v4.14.264-45-g6b11d619aed4)
        2 lines

    2022-02-07T19:23:07.444491  [   19.909759] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-07T19:23:07.490413  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2022-02-07T19:23:07.496872  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
