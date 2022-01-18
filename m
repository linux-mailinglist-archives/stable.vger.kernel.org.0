Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479EA4930D2
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349171AbiARWeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbiARWeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:34:09 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01D0C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:34:09 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so3874328pjj.4
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yeM5HiIm5Ll2F7YTpg/E8/aWtoycLvriEuZIswKP2Hk=;
        b=2u0bNhIUVoy0mX5t403ohbH0vAIAwBXby5SVtWbnZTGUqj4UGP4JZNhe9kk1FtxOpg
         YV7PZIF365j0nkDUWuRAy+2SW41Rnq9aN722DN98B6DLYtXSxosk1KwQ0nIJyRcRBXCK
         UNt/pTh4fiZHGeE+pXc3jlKWSasB+1hwlwECiNcPbMV7e+eNZ20l+9tbtI+TyJl/V7er
         AonmHqqVxoy7+sy08yFqJHjO/jf8yeWUUOLVxg99KJMVkU33ptUheWIvHYf9EfP05QSM
         wiyPXIOjUEDHhrnXPI4IBlonMg7rQA63KmT7AVyGmjiHTXEW+nWYeq/Tz+BefwRY5SnM
         /sAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yeM5HiIm5Ll2F7YTpg/E8/aWtoycLvriEuZIswKP2Hk=;
        b=Eb7d6GKLPMl1htpBQKZnS4U6uMv0DbnREPfEtw3b7YcmNgsFWg1M7qJfvE6lIsyYg5
         yWnNsGbNaWqw1JPSyHlzBoyVOs4nyMTnO5W6IxCMrUYbC81znmy5xQKoVvc+HUhi6JSv
         TokZyOfjEnCMBsARQ37R9s2h1bNDTNtC0OOcvT350DqC3XvPHeAcqaPRriIfh9p5Jdwf
         E05iKZMEKMPN3I62de3PLfAg6Y403QhUPj1fx3xfLNfodEmtrW0uyOH40J74/Oqws1yP
         x8FvZO6gfC9qE1WttSDiaMMsXZMvK6tedpI7tgP3ZtWY925+7Wg9NuIxoZO/YXOdQkBE
         Mdnw==
X-Gm-Message-State: AOAM530Z95wODHCCw2venQ8yX+dqrp1Y0zbQnzdalJywjc7fpLixlszI
        qgcDxtPFzcS5+UsOmIfFo7L6fE89V63dHeei
X-Google-Smtp-Source: ABdhPJzWdi24cGNlBmCJm59KehE76pVTmBkbyVjqrRJJwWdrCiaqPgd4/5MhHc7+qhCIbehv1aeELQ==
X-Received: by 2002:a17:903:11d1:b0:149:57d1:acc6 with SMTP id q17-20020a17090311d100b0014957d1acc6mr29746353plh.134.1642545249062;
        Tue, 18 Jan 2022 14:34:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m14sm12437166pfh.129.2022.01.18.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 14:34:08 -0800 (PST)
Message-ID: <61e74060.1c69fb81.95d66.19f3@mx.google.com>
Date:   Tue, 18 Jan 2022 14:34:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-10-g5f58931b34ba
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 123 runs,
 2 regressions (v4.4.299-10-g5f58931b34ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 123 runs, 2 regressions (v4.4.299-10-g5f589=
31b34ba)

Regressions Summary
-------------------

platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig      | 1    =
      =

panda       | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.299-10-g5f58931b34ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.299-10-g5f58931b34ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f58931b34ba8f05b822b98b5ea63aaee96430c8 =



Test Regressions
---------------- =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig      | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61e70a9d6536e2db4fabbd1e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-10-g5f58931b34ba/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-10-g5f58931b34ba/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e70a9d6536e2d=
b4fabbd26
        new failure (last pass: v4.4.298-15-g039b69cc9b15)
        1 lines

    2022-01-18T18:44:23.986075  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2022-01-18T18:44:23.994933  [   12.495892] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
panda       | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61e70d3bc645b1113fabbd1d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-10-g5f58931b34ba/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-10-g5f58931b34ba/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e70d3bc645b11=
13fabbd23
        failing since 19 days (last pass: v4.4.296-18-gea28db322a98, first =
fail: v4.4.297)
        2 lines

    2022-01-18T18:55:35.407174  [   19.167724] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-18T18:55:35.457797  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2022-01-18T18:55:35.467096  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-18T18:55:35.487161  [   19.249908] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
