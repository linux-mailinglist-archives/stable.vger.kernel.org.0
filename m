Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC08B35A83E
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 23:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhDIVSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 17:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhDIVSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 17:18:20 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F04C061762
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 14:18:06 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d124so5023660pfa.13
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 14:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qnqF4eq7BeeuAE4H8t/Gl43MESxllC1YhfT+bMUgAx0=;
        b=i4tXix4O8IjNuO8KrQ0h8fidWIFVSz0toY2U2fOQiH2jFf6HvDP3L0oei2V+fnTUJQ
         wCG9/PyrkjHOU8gNvxEc+A1noTfKRV3Zt64XB06Mvvt3UlpOHqWY581P3hojw91ULx4D
         fO2auBOkq4Nt6SPeFh8ewTquycc9mV4CkLZZhjpZMxwKiSQevmu2YRT2eNoI5houxFV4
         JU4yYT1k1J883wckGcVPuDTH66032qkIwqU3bsc9c0lRemzwMWZJo8+5n8UFiLNx77v7
         FMmpXALOE1YsFceX0ZmlwAS89UuET6gOd11CALwyIFsm7y6bPEjBRABg5s5OGx80Ibg3
         7nPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qnqF4eq7BeeuAE4H8t/Gl43MESxllC1YhfT+bMUgAx0=;
        b=nliGGstIBAY/QdoQFBioYfQnLR859m1BR2W/HhRPis2YUQo5are4U5fCuFFznUTquQ
         eKLOudSGJPUVcb1xIyE/vCvx8x6U1SSzVnToch8JaQLcQN8YgqAUvPTqLQAvi3lLfZF2
         DFLQitUgvVRPkDpTyenJsj2dx79AVmeKbDBLMMX/hHhYYjzqF1/D9F1FNIPCvNgu+L7e
         VGbgFu+zNRMCrc8JCG3HwoebsH1ybrBr7K3loIHfzSeBHJFZo0Y/LGC+PFUHPvPz+T6p
         SgLvrXKRQlonch+mVxAJDNtXI5cVuUx9jAcEltLQTX738jQPg5EMKLijB6uMghBMXldK
         j9mw==
X-Gm-Message-State: AOAM5335wYA5/5g4nMIsV3JgNY+Oq6npDHZvk3HvjLz8OjXsUcHzcbEo
        H9EFh7GZKEg3Q1ZgvUnI0wtYpHXKFfJysCqV
X-Google-Smtp-Source: ABdhPJzh1dEUL6T+qjCifUvwJmIqxUJGdl7SM7S5VG15BYCuYf0QrTUKUM7i0oQKRsvQHOAy8igKIw==
X-Received: by 2002:a05:6a00:1651:b029:241:afa4:92b1 with SMTP id m17-20020a056a001651b0290241afa492b1mr14137536pfc.12.1618003086151;
        Fri, 09 Apr 2021 14:18:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h18sm3591884pgj.51.2021.04.09.14.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 14:18:05 -0700 (PDT)
Message-ID: <6070c48d.1c69fb81.a85b0.9a64@mx.google.com>
Date:   Fri, 09 Apr 2021 14:18:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.28-41-g4005a6006d0ae
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 126 runs,
 1 regressions (v5.10.28-41-g4005a6006d0ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 126 runs, 1 regressions (v5.10.28-41-g4005a6=
006d0ae)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.28-41-g4005a6006d0ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.28-41-g4005a6006d0ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4005a6006d0ae3fe69e4eef5f1851cb1941361c5 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60708c0f7853aa5a45dac6db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.28-=
41-g4005a6006d0ae/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.28-=
41-g4005a6006d0ae/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60708c0f7853aa5a45dac=
6dc
        new failure (last pass: v5.10.28-41-g3a4f6976974a) =

 =20
