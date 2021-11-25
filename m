Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B8145E32D
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 00:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245193AbhKYXJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 18:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346870AbhKYXHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 18:07:53 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC2EC06175B
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 14:59:44 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so6696794pjb.5
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 14:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JadG12qawYiAjxkJzDhS+7ckbyp4hwZRhZrXYliczzY=;
        b=Sg+lxHnxTkngelD3nBtN00Z/2QAybDHvG8wfsjXXPbqzTQlEnZnAL8+m8UF+yz/mrU
         dWFNvZ96XanzoxzXNuacfpBgikw6ayEtAkm2/9DZOKClydALze24KVpOsyFuuPeWHha6
         hh6ON2kBvM3eEXQrTdG+QGvHc2U+kqd1t52u/kkcibpAEpZT9PL1xiOaqTjIxJdpDbaN
         HKpIrK3ckDZv0nIOJ5PV5CGSKkSxYNZNu7SrVL0pWarA9Ft8Ulry3y0F4XZ6zpL1jbfr
         AAg7AO7zrs7LJc3l9RK0HsNQOD2cB38KSIa92UY+ZkJ6oobKt+dRNtqEtL/KQnZwF+K1
         AxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JadG12qawYiAjxkJzDhS+7ckbyp4hwZRhZrXYliczzY=;
        b=FfgJxVtFzn6snpHUH76okdMr6cjAdoLbyzjW7iodj8zatI+aTtbEQWZkGPBI/dyEYM
         mRg1HUdq1lgqiLQn/lDyA2GCWtUBHsXQkdQLsWM1yyzLOpCl63M+GGEyczullehVDoqr
         CikqtX77b4Jfu6pKTkJmGDkQLs/8EdvHBz+1v/kZwQqootNBbAjP/XVwb2rFChTfDi5B
         zQcovngBA8RGtvX1bxy9haddf7FK9QMePZqSpS1j3X0LqFxetSTndHWfzKDs418/Gxf4
         H+thlFx1vg0UXSJuMLTFTaPIxqZWTY9VihNSKQtrzLkMkSJY3JHJOJSrCuuO5ErPpItC
         JfWw==
X-Gm-Message-State: AOAM531Euc5L36TOtzXe4bEGLFRdpVx6V4lJup+NkhpdyVQuCe4NL1tJ
        2pD+V8LFX7DcX6BKFzjrDkH8D0QDzEUaW+Y9C00=
X-Google-Smtp-Source: ABdhPJwnY6d43jiZHHc+23LLP88/JFEz4F+bl04WHoSrKjxWeLnw1MpHOKXdq7F1gbOzxKpf3bl2ig==
X-Received: by 2002:a17:902:d491:b0:142:892d:a89 with SMTP id c17-20020a170902d49100b00142892d0a89mr33170685plg.20.1637881184293;
        Thu, 25 Nov 2021 14:59:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p188sm4278507pfg.102.2021.11.25.14.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 14:59:44 -0800 (PST)
Message-ID: <61a01560.1c69fb81.82e13.c210@mx.google.com>
Date:   Thu, 25 Nov 2021 14:59:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-159-g1759246049eca
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 105 runs,
 1 regressions (v4.4.292-159-g1759246049eca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 105 runs, 1 regressions (v4.4.292-159-g175924=
6049eca)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-159-g1759246049eca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-159-g1759246049eca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1759246049eca8f7a43d9bae49ccc73b08851f39 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619fda2dac25e17495f2efb6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-g1759246049eca/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-g1759246049eca/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619fda2dac25e17=
495f2efb9
        failing since 0 day (last pass: v4.4.292-160-geb7fba21283a, first f=
ail: v4.4.292-160-g4d766382518e6)
        2 lines

    2021-11-25T18:46:50.713165  [   19.276702] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T18:46:50.762537  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-11-25T18:46:50.771488  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-25T18:46:50.787429  [   19.351898] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
