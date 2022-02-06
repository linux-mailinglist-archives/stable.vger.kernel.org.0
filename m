Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D174AB123
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 19:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiBFSBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 13:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiBFSBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 13:01:37 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00CCC06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 10:01:36 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso4218117pjt.4
        for <stable@vger.kernel.org>; Sun, 06 Feb 2022 10:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TJ7X4vZoZ2Thj5vuOrBY9STlW4bs+4lJPJ+4Yc79aao=;
        b=qYThgfeGahUk3hmyaXDiPE9eZEx5yMiqC2nDHvxok8bwIg4i8y9vkGT1D+OtLscEv9
         s8Y6t/76FUfW9PhK6JZOAlzwg73mnaer9liHmeM6cFnX8Xs42E1LcR4ggiVLr9lV8X1u
         gL7OeBrthGN1p19SrN3pNWtNYhvc4SteJA+fXX60s4LJzBFYN2WZWS88UUs/kPGHQUu4
         JOdb76ozHTcEz4c8GRWhIM/FEZpjBjXIywLucqw8S5ziyY7yh8K2y85g7WSRU8RxAqGv
         NV7aME7Eark1VyDuZ8npZ0dkBdLDYcEgc4/ysBKqp/mFascaYeUc1+3hTLpG/RPj2Y4T
         HxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TJ7X4vZoZ2Thj5vuOrBY9STlW4bs+4lJPJ+4Yc79aao=;
        b=dY7F4aGh4kMbc/AnqeNi/13701PO1D/Mv6slEZRTGElDd9T4JC7c9GEyrHWMG2yIWX
         l2hj3tfLwMnN0FJ0zh7qf4oLNPDTb8VS6xo8kqjT5zxM+3A6lzCqwsVn3rfcFfSFXWM4
         SPzEvejPbuX7jNWs0ODucyZ8UuxSPQhUEV4bC6eY7rpUHnYM3zFFjPvIR/BoEkVzNlk/
         KUkD257nxjukSl35DM1IJ8+PZnbXnGD/8mFxb7zsOu7FQ5NsrKz4R37zpjbsNQcIM6ev
         le0Ruiv46s5IaiAIWZguZ3ZSbQHr+EUz110rJ3PXaTURoRAntmWu/F4wWhLXPLV9niYH
         zRYw==
X-Gm-Message-State: AOAM5302vxNc+6xDYlgsBFR1Xm/EHBmjUAB8vjSM1rNT2DbSl0EUUEDN
        Kl16loqZr/ROcUEsvdykq9r3qwlN2AgFnp21
X-Google-Smtp-Source: ABdhPJwDFgTtQz/g1RKKeQPWs5Xs4PdgJdc7b2QDdFnmqDEHOTyJIkU3vhLAnzBQc0QQ53Mji6lyYw==
X-Received: by 2002:a17:90a:4291:: with SMTP id p17mr9779292pjg.126.1644170495521;
        Sun, 06 Feb 2022 10:01:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10sm6389298pgm.30.2022.02.06.10.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 10:01:35 -0800 (PST)
Message-ID: <62000cff.1c69fb81.3d14a.0757@mx.google.com>
Date:   Sun, 06 Feb 2022 10:01:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.227-83-gfd119a34964b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 135 runs,
 1 regressions (v4.19.227-83-gfd119a34964b)
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

stable-rc/queue/4.19 baseline: 135 runs, 1 regressions (v4.19.227-83-gfd119=
a34964b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.227-83-gfd119a34964b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.227-83-gfd119a34964b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd119a34964b8f8967f0090e1a656b06e8c6a288 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ffd95ed52784b5715d6f10

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-83-gfd119a34964b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-83-gfd119a34964b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ffd95ed52784b=
5715d6f16
        failing since 4 days (last pass: v4.19.227-45-g1749fce68f74, first =
fail: v4.19.227-45-g388e07a2599d)
        2 lines

    2022-02-06T14:20:57.732730  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2022-02-06T14:20:57.741398  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-06T14:20:57.755968  <8>[   21.302947] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
