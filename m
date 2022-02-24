Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763B14C2088
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 01:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245226AbiBXAU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 19:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiBXAU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 19:20:27 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B08657B3C
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:19:59 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id cp23-20020a17090afb9700b001bbfe0fbe94so537090pjb.3
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DX2YoqSzRNHXCU9xU15fHBWXCLyFycz5b+F292zGRUU=;
        b=GHmIyIVhefMmkEtQWwA9djcmXL2WbEE+4+E6NZwBfhVGGZbT1gRlnPiX1TgtZENxNW
         pTXYhJ3RetcNlqBEcGeTbnMuTBsy4txfdLwgw3tRKAnf5ws5a53u6JYl1TT81+HlR+jg
         9oMRpByLgao3L/iRvllu03UoOZvo1uUDZ8/m2+bNElScw2xrIdFpRulQ0O0YSLPk187T
         KT8Mx7sEFzqyTFhriumJ7KfWyOj+czqtNhbb2OrpoWG8C3ngCN5eghZ5Gy7WWfS56Pyf
         j9en9IjgjoyZWqLnWyylG63kbpZjeNBMUkstMhHOLVceS5NLyO1Sqn/jWfF0AoYUv+0o
         MDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DX2YoqSzRNHXCU9xU15fHBWXCLyFycz5b+F292zGRUU=;
        b=tMSxxWYfajSaLDoFYXQBiPWkZe0WRzOGuUQKpcX2Uh58uwav141kpcuOjz+P2UqsGj
         0s25AqktSi90tqnFmpl1MiLMm4zQqgwf1+YjuMvOEScI3JlD+nSqFgyMKODN375JBE/b
         lVCROgTsF8aWbKFloTCz7Dm+C/T7H2SaaL4taLVSIjy1OtnO+pHT9S/BS3e/QgoQPBqv
         TM0L3QR6md+AWhG6+ANjLs/x3ckgq7JrcOSm5e0SZE7G4mJlOvJR7bu1OSJj+J3dddAy
         07jzZOd/k9CDwvd3foJeI7nr4MFeV7XYIymLClcYo6GRbV0Qgh5W1T2bZeAG5J0Oemfk
         Gt1Q==
X-Gm-Message-State: AOAM532yuazu5LNoDpQa0LgdrqibpXAYUxxjWz3sppcwDtXVKvNSEqR2
        FDcdJ2Yzj+70C9JA90DsIHq40T/Kuqfou4foEQM=
X-Google-Smtp-Source: ABdhPJzVPsjmHUcJot62evSNqwhW6YoNuHqYZocOTXJ5m2tlhF5HkCeA2yaowig2NmOWP7aWqubATw==
X-Received: by 2002:a17:902:744a:b0:14f:a63b:577d with SMTP id e10-20020a170902744a00b0014fa63b577dmr306092plt.86.1645661998496;
        Wed, 23 Feb 2022 16:19:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x26sm184736pfh.54.2022.02.23.16.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 16:19:58 -0800 (PST)
Message-ID: <6216cf2e.1c69fb81.76b06.0be7@mx.google.com>
Date:   Wed, 23 Feb 2022 16:19:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.231
Subject: stable/linux-4.19.y baseline: 91 runs, 1 regressions (v4.19.231)
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

stable/linux-4.19.y baseline: 91 runs, 1 regressions (v4.19.231)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.231/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.231
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1763074989b3fdb49c4b6e38ad7d70c69f93076e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62169339e5737767c1c62992

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.231/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.231/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62169339e573776=
7c1c62995
        failing since 43 days (last pass: v4.19.224, first fail: v4.19.225)
        2 lines

    2022-02-23T20:03:56.446695  <8>[   21.739929] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-23T20:03:56.491490  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2022-02-23T20:03:56.501110  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-02-23T20:03:56.519493  <8>[   21.813201] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
