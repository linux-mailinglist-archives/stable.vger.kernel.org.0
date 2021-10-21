Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8784358F8
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 05:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJUDc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 23:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJUDc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 23:32:27 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80762C06161C
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 20:30:12 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id q19so4681978pfl.4
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 20:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=20Vi00WW7p4dNCRELb0FhgTJcU0D5YoadG26JZQQAHQ=;
        b=0QxbNxEjXi9J0EVPufjwDXu8b6qdVkYmz19+8BDJWhPxo1UuyHSnDqQTS9yRDr7pdo
         G9rGq4pYQEoB6CncVlKHBguOEwFLloifsSIYj8EBJEA+QjkYrYSK2GchI1vygxDRf2pR
         G+Hu78NPxJjxXgxQNsE4tn793H53OLuJMT63V2oTwpjJyvnHSQ/Uo+sILK88SWAAIBaf
         59VkM4uLU7rj6qzb6v390rD+ShdlPuImKF63bBIVlkTd0wtyYYjy6MkQPPH+0/GLo30b
         O0L6c17pPI6QgRl03XnhrqxtzwrEvVx2+821aPZ2RzFl1Qlhask7mKFYDznlki3KHwtE
         8zUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=20Vi00WW7p4dNCRELb0FhgTJcU0D5YoadG26JZQQAHQ=;
        b=A6VTx0iU3n9/UkvyawABwYFnXMibytVT7yLfPpRW7zCCtnB9H28xUEpPU1Qqztwhdt
         KxtgPs61EsUMAM0H5BJVF1qqwFORZWs/tQ1Kef5xJYe9j4yTcqCRP1KbNa37VK8ehW6L
         IIogitMi1iQjU4qkbMwO/abF51KAxDmU4eeEw0IaYZ5mQZalFz9GhrIqF3aP+OmwFyH7
         6+ATIDm5zl3wpubcg421d9n6wHDb/N7cHNjif1XnMlcglbJ6L8fhM9HLGY6LTOGQ3Wze
         TyDQnGUoetoV2+NPPD+NbOamYfsRdqGALW1eZ4FGkx7u3sZK+xgzyHfCKDblH4y8ctR3
         KzbA==
X-Gm-Message-State: AOAM533vMf3IEVQnJfDwR0Oj++VuOwL92o6ob9v8KdpRCpivOX5lo1Bv
        xIBfk57PAk8kvu6P+PPsW5xeGg2Q2vZysbl2LV8=
X-Google-Smtp-Source: ABdhPJwpdvCProtqPGrMBwGmtQhaiDX4VxsjvTmuunDsrn15xBt7g3azLEY9H4ZjZIrcgNc7iF4jLg==
X-Received: by 2002:a62:3287:0:b0:439:bfec:8374 with SMTP id y129-20020a623287000000b00439bfec8374mr3218753pfy.15.1634787011888;
        Wed, 20 Oct 2021 20:30:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p3sm3983982pfb.205.2021.10.20.20.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:30:11 -0700 (PDT)
Message-ID: <6170dec3.1c69fb81.b8db0.c657@mx.google.com>
Date:   Wed, 20 Oct 2021 20:30:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.287-28-g0c887f40044e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 96 runs,
 2 regressions (v4.9.287-28-g0c887f40044e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 96 runs, 2 regressions (v4.9.287-28-g0c887f40=
044e)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1  =
        =

qemu_x86_64 | x86_64 | lab-collabora | gcc-10   | x86_64_defconfig    | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.287-28-g0c887f40044e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.287-28-g0c887f40044e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c887f40044e08b0ef66bbb958f11f44b9e9ea7c =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/6170a8f2421bee2f7a335949

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-2=
8-g0c887f40044e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-2=
8-g0c887f40044e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6170a8f2421bee2=
f7a33594c
        failing since 1 day (last pass: v4.9.286-51-gd156b23118b6, first fa=
il: v4.9.286-51-geba1061a3f9a)
        2 lines

    2021-10-20T23:39:52.527071  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-10-20T23:39:52.535094  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
qemu_x86_64 | x86_64 | lab-collabora | gcc-10   | x86_64_defconfig    | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/6170b42ecd08fd04363358f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-2=
8-g0c887f40044e/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-2=
8-g0c887f40044e/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6170b42ecd08fd0436335=
8f7
        new failure (last pass: v4.9.286-51-geba1061a3f9a) =

 =20
