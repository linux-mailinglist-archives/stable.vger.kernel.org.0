Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EFF45AD33
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 21:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbhKWU0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 15:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbhKWU0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 15:26:18 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08CBC061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 12:23:09 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u11so39594plf.3
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 12:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BmFLsC5hJUz3778Bd5NM4qcxYIxgRC1Fx0pZ+vDvs1s=;
        b=X3wqWxZiICcxmqqLC6O2BjwDpjemL9v8Nz5u38ba8o3wenwR48Ul6zqwlMUv1e13zQ
         enSMTSKZic4DSA/nh/atlJw5AIdFPQ+/Ckp1eX/jEz6kINxAc81XecMP6zeHkdIPBu8/
         XIL5piPZVX90hCagnvM0T92rhFVSFt6V9KwCNEghNejDHvwFJrh6lpit1ZMQ8zz1NLQ8
         M777DN/HCypb8VwE8ZZA9g1t9XgByzp6NHPe9qJEQFRU3+Sm/WxSxng1CKqDVBeM3DzF
         5Z1wcBaDlsbVi7szOdqDQ80qCbW9/hSTJSp5Yc9ijBks63S5l8yBnb1MHLk99NNKr0Wz
         3TMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BmFLsC5hJUz3778Bd5NM4qcxYIxgRC1Fx0pZ+vDvs1s=;
        b=ot58SRrrYieUmZzkPLZA+oV5n9Z2ZQIAlcl+7//9yJWb0Eqh5X5mtNPUprzwuRHxbY
         Uw8cDHhP8BMJp4JLuo6El+q/YSh5ymSYH2+lKx2EYmQHEaWdbO/6Y4o9PKdF1B+6qkhC
         xVtUmUlQpftqLlzHYJOJ5HXGL9u+2ATScj1p5yPOMCX95WGiFbQLh6p0Ym36SQUCrGnf
         PK/TTkLizHNUOp6fMzTgfmdB6d8LpXqIjfRELDL1JodOKnyxCJIRzwWyOnsIValVBw8r
         B54ReTgg3ObN1Q3TA9ggeeyn0nLD80vVXcrmjjgpN9UdQunquS6wneex8wbHlpESg54v
         gKxA==
X-Gm-Message-State: AOAM5319fPOAjThtwYWehWSy/AARlw2NP8slPHM2RfSefI+ylBkC095Q
        YL08udIVoDpwnPPbkkUSV/7q3NEZH5Ir6wuu
X-Google-Smtp-Source: ABdhPJxNp/A//1Nu4pe2LFR4Dec+U6ENgE9F7pjQWRU8dx7mtDHcRoD4xtQCRFwd6AxnhGJi4rWkUg==
X-Received: by 2002:a17:90b:17cd:: with SMTP id me13mr6691034pjb.79.1637698989105;
        Tue, 23 Nov 2021 12:23:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i5sm9851350pgo.36.2021.11.23.12.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 12:23:08 -0800 (PST)
Message-ID: <619d4dac.1c69fb81.57a0b.bd8a@mx.google.com>
Date:   Tue, 23 Nov 2021 12:23:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-159-ga5eb1696f0eda
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 106 runs,
 2 regressions (v4.4.292-159-ga5eb1696f0eda)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 106 runs, 2 regressions (v4.4.292-159-ga5eb16=
96f0eda)

Regressions Summary
-------------------

platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1 =
         =

qemu_i386-uefi | i386 | lab-collabora | gcc-10   | i386_defconfig      | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-159-ga5eb1696f0eda/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-159-ga5eb1696f0eda
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5eb1696f0edacc6493e37e782a5343a02b22ebd =



Test Regressions
---------------- =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/619d17bce9211fd297f2f020

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-ga5eb1696f0eda/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-ga5eb1696f0eda/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d17bce9211fd=
297f2f023
        failing since 1 day (last pass: v4.4.292-116-gc13aef2ca259, first f=
ail: v4.4.292-140-g1794f2b1b0d51)
        2 lines

    2021-11-23T16:32:38.168161  [   19.025665] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-23T16:32:38.210954  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-11-23T16:32:38.220180  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
qemu_i386-uefi | i386 | lab-collabora | gcc-10   | i386_defconfig      | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/619d2479d9c3569099f2efbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-ga5eb1696f0eda/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-ga5eb1696f0eda/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619d2479d9c3569099f2e=
fbc
        new failure (last pass: v4.4.292-143-g38a064392378) =

 =20
