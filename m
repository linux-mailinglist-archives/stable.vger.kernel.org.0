Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B34433DF0
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 19:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhJSSBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbhJSSBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 14:01:31 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E4EC06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 10:59:18 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q5so20086812pgr.7
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 10:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MUkoT0FW4TCIrUjQd+bBTX4vb40G5KVREY+A7T8qw/s=;
        b=dT9cN5Tdt0eaKjdGgixqyoWsHzKOwGg3h43ALgCuSqFx8pkvgbJeMLBb17A06nl+3U
         670Pm0MjnZ2VrbMfVMOLXhG6Wps0g/j5ovdsF/ris2I4yRWd2MCwGUMZAGAKmDyA+ixz
         h7Ab3xKGpojx/uc2kKVFBab67MFmW+MBkA1+HEYBL//Ar71Nv6w/D5d+gTO5dasWi9T/
         OKWBal6eOjYg3YqcpLMqSqwQdQJCznKsroRKV/h5KsH6vzZfnQQJJRlP2V6XoDHCG0i9
         kIQTyCEN6sLBIfKHhwSc9OLrOgt+dCDLvzqos3wk3A5IFvtccUbXPVL2JNAy6HIyuQxR
         rbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MUkoT0FW4TCIrUjQd+bBTX4vb40G5KVREY+A7T8qw/s=;
        b=Zw9IENuH98gcL+JxvdKjs5ILDxnPx7XYzUgcsjhQbpENoRkLRtsyMx3wZMzf5Tx0y0
         DJnPh4xCZg35JgnEvcNsziIGJEl9Y0Oezdez2V3Fvri4bUjgkcpSVWjwc9t3AL4pilzG
         rf9n1fZefw4WLAr3rnwuutdQgJj+T3WXdnuOBvLX37G2iXDji3bo9Bbs31iLP0FhPL5c
         3DaOZX49dWifcsXj8Qe66G5Wssx6tfbdzbT3Cj9MjazacxRhTtry1Ajng18g/31NYn/E
         bmv5OhvRKAShG0BwR/WCS7wP/WLM8YVNSE/+tj3NodjS5+Zt63NTWNSX+mD9HHcAgZM5
         GIqA==
X-Gm-Message-State: AOAM53380gS0XOvJQ2LKMKLN22w/1sBtmXZTjWQHSaj04eCg/gp2nZW+
        kF5xdiGFOuvBG5J4h1FXZMvhTDtpqgCqqoh+
X-Google-Smtp-Source: ABdhPJyQERzbytIjRXTpqFO2Se60iNoRh6dT0hEI0WVJDnifQAd9WR4eJF1XGCrc9h2QVYGJn2qDjA==
X-Received: by 2002:a05:6a00:234f:b0:3eb:3ffd:6da2 with SMTP id j15-20020a056a00234f00b003eb3ffd6da2mr1297803pfj.15.1634666357652;
        Tue, 19 Oct 2021 10:59:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lb5sm3521910pjb.11.2021.10.19.10.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 10:59:17 -0700 (PDT)
Message-ID: <616f0775.1c69fb81.a4ced.a156@mx.google.com>
Date:   Tue, 19 Oct 2021 10:59:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.286-51-geba1061a3f9a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 136 runs,
 2 regressions (v4.9.286-51-geba1061a3f9a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 136 runs, 2 regressions (v4.9.286-51-geba1061=
a3f9a)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.286-51-geba1061a3f9a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.286-51-geba1061a3f9a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eba1061a3f9a80437a730537c21a11f420b8e906 =



Test Regressions
---------------- =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig      | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/616ecc2aca92f9e1e93358f8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-5=
1-geba1061a3f9a/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-5=
1-geba1061a3f9a/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616ecc2aca92f9e=
1e93358fd
        new failure (last pass: v4.9.286-51-gd156b23118b6)
        1 lines

    2021-10-19T13:46:01.590357  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-10-19T13:46:01.599314  [   12.230725] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
panda       | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/616ecdeaeaf674ae193358ee

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-5=
1-geba1061a3f9a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-5=
1-geba1061a3f9a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616ecdeaeaf674a=
e193358f1
        new failure (last pass: v4.9.286-51-gd156b23118b6)
        2 lines

    2021-10-19T13:53:26.824566  [   20.255004] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-19T13:53:26.866937  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-10-19T13:53:26.876753  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
