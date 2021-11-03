Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8875443B44
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 03:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhKCCWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 22:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhKCCWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 22:22:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAB4C061714
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 19:19:33 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gn3so248665pjb.0
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 19:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VLsCm/1/GZGnXzC8fCJ6QuI5EYBMU4CVnFJNUJAK9tg=;
        b=8CILiJm4jOaw95KfTs2EdBzghhgisHAlOL2rYSE+kb4PkEWqDT6CNkjl3ORGsKTeXT
         TyohOES73c6nZBCzN4WRiJWyu8/FOy62bn/Cd22sfQ7YQWDZi22lKNunn7xhUxObmmHT
         MrnTOWdpyFUEmX/KOWmJj0/gCh9Jtktr2EUvP75m44V1C326g0YGNKCQA2e0p1ECROGA
         SVbddVB0lXsD2fYVvtAM8neaBbpCZo5Xg/77xJnVmi2d2iKvkA/qHke7tDLIjwfPKW4D
         +9zpBAjsh8iRh6mfUuZUkOmGpIjzdezrejVlZQgki6C2iGNRp6a6muP4r6CekQmmfME4
         ag3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VLsCm/1/GZGnXzC8fCJ6QuI5EYBMU4CVnFJNUJAK9tg=;
        b=hPyHQC7Vt03hfd6Acq6q4V7/6cSa5h2gBqWU9jcMN8HDZy7ar7ZNRj6ik84iC0QrKb
         7TzmpfCNHuTx1FOmnp5N0XtzPGmvIjndaIMjJqtuEw4HJcerbKDPq3WN8c9TaUStAccl
         cUFK/H9Nc4g2VlhC0YZhGWcwLUg7MLSgeHgIoPYNWJNlhIIFKVSwP8CP23z89NhQCkaR
         Pu6/OlLl2KMpl90osABsghfhDxP2puhySc/n/xUzlhnUt4yYeTwff/IlMO5OFbif+EHi
         zSioMKJZLDXjsgLht873NJiOLQkkEh0RJbMOyfQkN1DEUwSmitxkFj7q0X5ddo+NhEAC
         FADw==
X-Gm-Message-State: AOAM530Ef3eQR13sHg2NsDCe51+ARHXoM06JYWY7x84qNEBIIa5CXJi7
        kR509Qgfl3wfIgh9YtvjjqK2Jtu/ssHeW06o
X-Google-Smtp-Source: ABdhPJwhYQVZraIpThX/nrf940eaaZv/GmUIbiHhRo4KYZTa4rDQSX6ZrNSrCT1uE+qSXaKu12afcw==
X-Received: by 2002:a17:902:e302:b0:141:af98:b5ea with SMTP id q2-20020a170902e30200b00141af98b5eamr28525208plc.53.1635905972492;
        Tue, 02 Nov 2021 19:19:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nn2sm3824500pjb.34.2021.11.02.19.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 19:19:32 -0700 (PDT)
Message-ID: <6181f1b4.1c69fb81.b9386.c038@mx.google.com>
Date:   Tue, 02 Nov 2021 19:19:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 77 runs, 1 regressions (v4.14.254)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 77 runs, 1 regressions (v4.14.254)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.254/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.254
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0447aa205abe1c0c016b4f7fa9d7c08d920b5c8e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6181c0acd8ddb89fc33358eb

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
54/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
54/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6181c0acd8ddb89=
fc33358ee
        new failure (last pass: v4.14.253-26-g64fad352ab39)
        2 lines

    2021-11-02T22:50:02.673431  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-02T22:50:02.682251  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-02T22:50:02.704905  [   20.348449] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
