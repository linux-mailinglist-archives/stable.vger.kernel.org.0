Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABA645B0F3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 01:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhKXA7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 19:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhKXA7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 19:59:36 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A22CC061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 16:56:27 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id m15so564017pgu.11
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 16:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vRAE7zkDxKcYB+BiEbxpty3smQ+PqQS7ACJmob0H5jo=;
        b=VI9G0A+dW/2fwkSfI6AL0Zxyt02PbtveqRUp9aPBOX60+KpWidXChluTMXgH8nboCG
         8hpngGWnN9TGUn+FyyPkom/zcTFi9DYv153HTWXVo/IAAHq4/dRVq5biz7nVx78ivh+A
         Te12Xas3H+H6Y7zXida1UKgZRgLq8MuA4rNJeBwvakkhtXehiHNSSFKTt6dVJyVRRoss
         CS561sWKe6o7rvSk3fPNk993rt6AO55M1mKnuAxUsVOU4zDDXxKG4s3lzHUGbxxM7gZG
         EeGopIUMEue6NjMS/QflEofKWRos60h7YaoQ3F17kflPtHjNoKq1B5UnJdXv+wqWp1vl
         ZqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vRAE7zkDxKcYB+BiEbxpty3smQ+PqQS7ACJmob0H5jo=;
        b=c2KzkBk5GMhIinG/ZlixsDIcUJN9M/eXZBGIe5gBpr1qiJc8puppz0j3DCNDzuJA4k
         lihVMETe+vNnphyGbvloHSSEHm+TVy9LqM0J7mLAjhkW/750iSSe9SToUrhytOkMx80F
         zojC7aDBhpHtCXME2rHuz4UCnTGrXb/9ntLkqyvBU3sS0YjFJ9MQXTGzgGlcj2z6zLC5
         9eo4qSIL+nOUJ27XXNJo6jt/NccKnKEqeKK1mdqt7Hbd8p1HZlf+z76RgtjmJ3eg3I1C
         SVMeECTmX+GEBoopYzY9ivmKz1BbCEJC9YsD0bVJFZihmc2JnIG6sbFi1wGixyuBt/0r
         CMXw==
X-Gm-Message-State: AOAM532P52+kkmX4F2rdJ9cQHpS1XpGsCRari8F9jkQoQOPdtHC9msVS
        JiBXirMiOW70qToTpLbWSyLQA+hDTK+RJ6S4
X-Google-Smtp-Source: ABdhPJzUJ10b4CYr4slCqpux9GkmKqHly+hzDhl9wam88yQd8DYJzd7TRMZ1xT/Yl49CeiB+sTb6TQ==
X-Received: by 2002:a65:4249:: with SMTP id d9mr7129619pgq.351.1637715387039;
        Tue, 23 Nov 2021 16:56:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l12sm14320563pfu.100.2021.11.23.16.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:56:26 -0800 (PST)
Message-ID: <619d8dba.1c69fb81.8f15c.8536@mx.google.com>
Date:   Tue, 23 Nov 2021 16:56:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-247-g90f870a1bea63
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 133 runs,
 1 regressions (v4.14.255-247-g90f870a1bea63)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 133 runs, 1 regressions (v4.14.255-247-g90f8=
70a1bea63)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-247-g90f870a1bea63/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-247-g90f870a1bea63
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90f870a1bea639d4021ef5f121577198daad68a3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619d5a37c4820536c9f2efa9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-247-g90f870a1bea63/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-247-g90f870a1bea63/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d5a37c482053=
6c9f2efac
        failing since 4 days (last pass: v4.14.255-198-g2f5db329fc88, first=
 fail: v4.14.255-198-g6c15f0937144)
        2 lines

    2021-11-23T21:16:17.431755  [   20.253387] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-23T21:16:17.477772  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-11-23T21:16:17.487006  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
