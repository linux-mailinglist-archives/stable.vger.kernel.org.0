Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5616458668
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 22:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhKUVGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 16:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhKUVGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 16:06:23 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477A7C061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 13:03:17 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id iq11so12139043pjb.3
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 13:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U7Hqqo7MBpf2qleycLRlIUU1VL6PUd0Lu3Ytxu6JjvA=;
        b=7HsMk+VGb2KNu353yuWiW0ZExjFNBrUD77Q5bwMSt8A+EsgRzbKnFggD+26iG4rPY+
         9e/NfYITGYGEeonZMHquw4To6XuL9OmE3jvGGuV73UADzLl+kvAcL9HJUDAecwsdo9Ud
         cwxsVCyKta8ogScGrJOyAtEMMBlef2O6FooE8sB7Aj8TTmmmjNKxXA/jZ43Ctt6AY6Hd
         +b+KojBd8qQkBOknuFwSPGKak7CUAZEcAELYryCwhHC1d1HuAbdApUIlEVBgfhk2c36c
         mFU90ya3SxX/PYDlMuiIC8OglagOnkc7Ulk7y2Ksy6DZu43Ak/9YjLDKjklakEZZnvT1
         FiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U7Hqqo7MBpf2qleycLRlIUU1VL6PUd0Lu3Ytxu6JjvA=;
        b=rNR9vJ1xq0xyAjRR6fPKLAZh1XtirRGvr54lhO3bYzi3CcH0BOsvoZr2x2Jg85mIIU
         yCYcKSU7egk8VEHEDq/yq7CROplwHDUxqpxZu/oFzbBc0ZqYo70m5xPW2Z7l+JMFECzh
         HIZ70PcvzJnpneo/Y2OfYbMCYbyVSZnb6B8YzIXOQDubCYQ+FYA8AgOttS3rTahtFPpt
         vL1yjONAMSZ3V/GljLueUge+dOjV/dTR09RMTvD0X9De0z5a9fQxRZKYUFTeTZyuYHDa
         ZrYmwlEDgREf4QOp2Yxt2vOihhs8Bw0rUJCIR+WqEh4Exqxt4vQaaY9hiXKL/opHuskV
         OEzQ==
X-Gm-Message-State: AOAM5307AcQBrpBeKKD+5UDEZpoJ1mH1Zxkklcj6RxqaN9aoG3G8klSr
        slviNmHc54Avjl2h+3q5+3vPVHGV5X6xMPx4
X-Google-Smtp-Source: ABdhPJwwyZ0ibqO1pbd3pnKf7jcDnRYkMxC/M7bDA6qJ3HG5i7YTx64Ar9xEz3NrDlimqsuXLNIOzQ==
X-Received: by 2002:a17:903:10d:b0:142:6343:a48e with SMTP id y13-20020a170903010d00b001426343a48emr99941193plc.29.1637528596562;
        Sun, 21 Nov 2021 13:03:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o1sm16180319pjs.30.2021.11.21.13.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 13:03:16 -0800 (PST)
Message-ID: <619ab414.1c69fb81.1fecc.0b9a@mx.google.com>
Date:   Sun, 21 Nov 2021 13:03:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.20-15-g377ca61cde601
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 117 runs,
 1 regressions (v5.14.20-15-g377ca61cde601)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 117 runs, 1 regressions (v5.14.20-15-g377ca6=
1cde601)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.20-15-g377ca61cde601/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.20-15-g377ca61cde601
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      377ca61cde601fa14c1ce130b9693bd61b331d2e =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619a802842aefc2bf5e551d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.20-=
15-g377ca61cde601/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.20-=
15-g377ca61cde601/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619a802842aefc2bf5e55=
1d9
        failing since 28 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
