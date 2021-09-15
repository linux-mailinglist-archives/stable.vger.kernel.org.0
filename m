Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A715C40C68E
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 15:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhIONnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 09:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbhIONnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 09:43:21 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D01BC061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 06:42:03 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v2so1649548plp.8
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 06:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uOtmR9KLY+5V455I2N98JVJSZNlil12vwa6hBfLK/tw=;
        b=MfpodH3QEyw3rJkAlXdHE1KvLytM6tzhMg6klJuta+8XCZL3n5DIBXBGYczHqZeuh6
         PXvAO0m9YciM4Oi9L+MmU1bT2Ix2APncZdk2HXqP164Adde1D1/Oj9CeGMAwPECPUL6E
         V10zrttSQy3Nvq0a/FpNnmeMhdBF7z7TyGObtYBZGshSDWouD+DQqrHlei1daBn2JKxJ
         yamCZY6w0kzmvpkEnUYj/9PwZioM0N+l3TumiDbFLmAdGGvlqmmOy7tWFGOeiws+tRvi
         QwYxm40Pb7CRqVY9+3aSZQBWYwSZRf8fUKWvhwBg/uMoNN/R4H2QCtOQ8qcC3yunKmMQ
         kjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uOtmR9KLY+5V455I2N98JVJSZNlil12vwa6hBfLK/tw=;
        b=GaxPpmoPyuGqaC9MMq+wirfU9tnjHJQaz1m14vm4psdhW54rlY3Bhy59vFnbp92jMa
         MuJBtf3z9fCEFFcQZGAjUWjmPLaYe5qDOWkLaztFXWbSMNIGxRPfXwp8Nz1DaiLLQPec
         ZRX/or4Ca9DSIXaT7ypmYJFK6YoBX/2DKFDExPBuQWK6BnG+V1qXJtsPiCsCSMVVnPzE
         ecROXRJL6QDHJ0KT4A2zFJ8hjNCf0phlm3+xhQTmV73Ex89wwqaipVogHdOfqO+jj5x5
         88X+ODLR1afcjLfsmnqn9sW65M7n6LjsyVUvl12zTNQN2n9mn4jtgICHizuu2XL0Q6dn
         k4EQ==
X-Gm-Message-State: AOAM530lWQH9Er9LQNOuIp55eG84l3ZPYP96zMM/9PiG2in+BL+5DEhK
        vQjVQTbaWyKGHYTCQs9t8DyKZA8DZrQahGOD
X-Google-Smtp-Source: ABdhPJzZGV7lOWICiEGVVUVdwCyDc6D1Y5DWZI0KAIejKQJlx+jWKVehI8FNl4iX1dIG8Sa5w3ejKg==
X-Received: by 2002:a17:902:aa89:b029:12c:17dc:43b0 with SMTP id d9-20020a170902aa89b029012c17dc43b0mr19854425plr.81.1631713322305;
        Wed, 15 Sep 2021 06:42:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i1sm2403748pja.26.2021.09.15.06.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 06:42:01 -0700 (PDT)
Message-ID: <6141f829.1c69fb81.29d79.689d@mx.google.com>
Date:   Wed, 15 Sep 2021 06:42:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.64-236-g9e7f7023024a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 172 runs,
 3 regressions (v5.10.64-236-g9e7f7023024a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 172 runs, 3 regressions (v5.10.64-236-g9e7f7=
023024a)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.64-236-g9e7f7023024a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.64-236-g9e7f7023024a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e7f7023024acb2ab65a523616a7c14f060eeb6e =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6141c8ee2b3ec52fbc99a308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g9e7f7023024a/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g9e7f7023024a/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141c8ee2b3ec52fbc99a=
309
        failing since 75 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6141c8230fce62121199a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g9e7f7023024a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g9e7f7023024a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141c8230fce62121199a=
2ef
        failing since 0 day (last pass: v5.10.64-214-g93e17c2075d7, first f=
ail: v5.10.64-236-g18f8c8a12e33) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6141c7bc58a71eb8d499a3ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g9e7f7023024a/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.64-=
236-g9e7f7023024a/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141c7bc58a71eb8d499a=
3ee
        failing since 2 days (last pass: v5.10.63-26-gfb6b5e198aab, first f=
ail: v5.10.64-214-g93e17c2075d7) =

 =20
