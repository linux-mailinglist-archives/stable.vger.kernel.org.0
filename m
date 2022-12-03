Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66194641777
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 16:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiLCPQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 10:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLCPQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 10:16:09 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CE91F637
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 07:16:04 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 21so7501101pfw.4
        for <stable@vger.kernel.org>; Sat, 03 Dec 2022 07:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7bJDtGCyrz5PKp8uTSgGhu8Tt31/+yKd82+8oHUq7tY=;
        b=1BEnRUDHyX2A9x+T1SXrYVZo3VHKNM+/lQQdK1QyYL5g0aLiJzHTfIRUPBmRc/hdOU
         GArCDAAtPY6Yfw/gTfJ/trbEbW8FPFRjqT98RZrHY287icyAZ64qdc9rjo56BzPmTNff
         j0LwqlVGptV4oO1uXAjGoHwR4I0eV6/sp2at6OK77DB27VOk6xdRSSO651klAvqBLR6h
         zElVbpKEO6wQrig3zvN6qdDSmJ0D/EiCG7OSF7jlUW3FacIAj+5we9gkHz8LYDWzoD4C
         wgBbIy+IbjmqSCbODW1bCqXjw6XiF4V9bC8u5GLbncq4Av9pbiYXmmWIWZwL06dmftnQ
         idxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7bJDtGCyrz5PKp8uTSgGhu8Tt31/+yKd82+8oHUq7tY=;
        b=15A5IvK+ft5R6Y38bi/D1ArzcxyCdCNU5zjkRQDipuaWqYYrthWSxfy89u/mV2YrLc
         pCbOvDfkBCtDIhdrWPaOA+FzaQxm/tI5sDOIOdj34uNffdDdizp88wAbruS3kHwURhPk
         1mI1z+GaYk9p5y3IFrD7ZnPf6DU22ApLE1FymHna/Wcp6NwfFF5ACxe+zVUW8O00qn90
         WbMUSa+mXbbhK0G5oq9Pmq7j5HdAWC7c3jWkOQTj/80R4y0hSscX0bM+BgI7K4yaqSzg
         rlf4vOjiHSuR61hGxG7wf/BKl8rjGYZCQ56E0RmMhjwEDla3kgr+8hkDovKSFbCX/vue
         S5Vw==
X-Gm-Message-State: ANoB5pmITGekrn5y0C6Z6T2Pk9GGYB/z8Bk+M7zFl5ij9NFZ0Ma1SiVW
        DRsHDwBWV3fFMKplZAUDIrXi4QSidioeVYE5Efc=
X-Google-Smtp-Source: AA0mqf5wmLwHpxXs9jWyZSHc9Y+FWcZsNxOt7zisq6IGUQEHqqElV0O+tk5Xuc94+sz0qPSuR/TAoA==
X-Received: by 2002:a63:4f25:0:b0:478:3376:5561 with SMTP id d37-20020a634f25000000b0047833765561mr23617674pgb.618.1670080563815;
        Sat, 03 Dec 2022 07:16:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n6-20020a654cc6000000b004468cb97c01sm5704637pgt.56.2022.12.03.07.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 07:16:03 -0800 (PST)
Message-ID: <638b6833.650a0220.0603.a38e@mx.google.com>
Date:   Sat, 03 Dec 2022 07:16:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.157
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 141 runs, 2 regressions (v5.10.157)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 141 runs, 2 regressions (v5.10.157)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

r8a7743-iwg20d-q7  | arm    | lab-cip       | gcc-10   | shmobile_defconfig=
           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.157/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.157
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4245f05389c29c0d556fea359b2fcfd8dce7bdb =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/638b3826083762e9d72abd3e

  Results:     17 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
57/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
57/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/638b3826083762e=
9d72abd51
        new failure (last pass: v5.10.155-309-g64cb1fe918e7)
        1 lines

    2022-12-03T11:50:56.813034  kern  :emerg : __common_interrupt: 1.55 No =
irq handler for vector
    2022-12-03T11:50:56.822848  <8>[    9.727641] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
r8a7743-iwg20d-q7  | arm    | lab-cip       | gcc-10   | shmobile_defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/638b34b9a2d440289d2abd27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
57/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
57/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638b34b9a2d440289d2ab=
d28
        failing since 18 days (last pass: v5.10.154, first fail: v5.10.154-=
96-gd59f46a55fcd) =

 =20
