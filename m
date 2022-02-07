Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D284AC126
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 15:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344880AbiBGOXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390387AbiBGN5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 08:57:32 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826F2C0401D9
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 05:57:20 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso3349868pjg.0
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 05:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=99JlHj7QslyRMsHs7bVoT+RUNF2+Tf5+xcpigifuobE=;
        b=uhBCWLKpW3bC9PVTB3OZB9f5x1SZThqo9p/jSskvGnC09mO0pL7tw+xTCpcm4bVNCU
         Id4uqBNHMUiRHQd0Nzu4aAgbVMPW+UfjBN4hLX/ke2a8KIfvKN0C0FlNcDqg/i7g8GG2
         ctr02MlrbGNVdzNDXWiYvR/RWkLoY3QWfk62tD4AEnbJ6ajM6AvVLD3I4jPy5KvU7EBx
         c/HXeGxeEphOr4I+tzIxv0hPvcb+D/EeIbfDP5yTqMjj7JX8XSOaU9xMOBpbDAoStjmr
         GDfD1SxW3S55bz1GhhS6lZK+IGE/WnUW9UKMZgDUFZk5jr4uCkKy3JX7fJzM4wS5Ge8V
         V2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=99JlHj7QslyRMsHs7bVoT+RUNF2+Tf5+xcpigifuobE=;
        b=VOBxgCdRuOUcyet0+dI/1/DOOZFgDPYi/gq48P9XbtPU72l8q03WJYW7Nh4RbtgL2f
         qAS3kY723jeRTGEMjixD7Cj2f8ETzFOnTuyuWh2gU6Kqj5Ul1043GwkCNNLCt3yQYd9l
         44f4mAM93eFz5+xTAhLysUt8x7YVs1P4VxVK4hmn8gU9WYhT/t78UME1Wz0QheiFjdsp
         5tTTmY8cTWcsAWat0humsaT5n3p6/7zsKjZsq47zT1MLd13fPKYHVUFZIdTEwizg1NQ9
         7iSWd8ipH3NmLTT0lo7Fk5m4FkwMQxvAzfTyvRv8aFcYm2/w55Lm7K6ngkdjdzKVaBef
         Z6Vg==
X-Gm-Message-State: AOAM532rqOrW7aNOlta5B+W4q8zIYJuVjNkGkayJJl+94dviK22Hs5Gx
        JNTu2uf86cJ0NNJ0qyRDZ2EFpSQ+iC41V/2D
X-Google-Smtp-Source: ABdhPJw42pn0Zw3dhBzsN8SEqWqIc6/QqNgLrFY0BTjjiKnEdQGew1qQb70o++ckGIfd0pX0O0jkXQ==
X-Received: by 2002:a17:902:7c0b:: with SMTP id x11mr6457486pll.138.1644242239565;
        Mon, 07 Feb 2022 05:57:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm13149470pfk.199.2022.02.07.05.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 05:57:19 -0800 (PST)
Message-ID: <6201253f.1c69fb81.46a37.fd82@mx.google.com>
Date:   Mon, 07 Feb 2022 05:57:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-48-g168d45804979
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 105 runs,
 2 regressions (v4.9.299-48-g168d45804979)
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

stable-rc/queue/4.9 baseline: 105 runs, 2 regressions (v4.9.299-48-g168d458=
04979)

Regressions Summary
-------------------

platform | arch   | lab           | compiler | defconfig           | regres=
sions
---------+--------+---------------+----------+---------------------+-------=
-----
d2500cc  | x86_64 | lab-clabbe    | gcc-10   | x86_64_defconfig    | 1     =
     =

panda    | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-48-g168d45804979/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-48-g168d45804979
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      168d458049797e3f15b920ec6afb05a6fecd9203 =



Test Regressions
---------------- =



platform | arch   | lab           | compiler | defconfig           | regres=
sions
---------+--------+---------------+----------+---------------------+-------=
-----
d2500cc  | x86_64 | lab-clabbe    | gcc-10   | x86_64_defconfig    | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6200ec53a22dd7ae4f5d6ef0

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-4=
8-g168d45804979/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-4=
8-g168d45804979/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6200ec53a22dd7a=
e4f5d6ef8
        new failure (last pass: v4.9.299-45-g4d186adcc4bf)
        1 lines

    2022-02-07T09:54:14.840931  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2022-02-07T09:54:14.852528  [   12.104178] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2022-02-07T09:54:14.853015  + set +x   =

 =



platform | arch   | lab           | compiler | defconfig           | regres=
sions
---------+--------+---------------+----------+---------------------+-------=
-----
panda    | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6200eeca8ac93693975d6efe

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-4=
8-g168d45804979/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-4=
8-g168d45804979/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6200eeca8ac9369=
3975d6f04
        new failure (last pass: v4.9.299-45-g4d186adcc4bf)
        2 lines

    2022-02-07T10:04:32.725926  [   20.472747] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-07T10:04:32.778712  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:1/19
    2022-02-07T10:04:32.787401  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-02-07T10:04:32.806932  [   20.555328] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
