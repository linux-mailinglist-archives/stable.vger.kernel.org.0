Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA18837EDB7
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387985AbhELUl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386795AbhELUWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 16:22:12 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1CCC061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 13:14:20 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id m124so19045064pgm.13
        for <stable@vger.kernel.org>; Wed, 12 May 2021 13:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Zxxg+vUObOkF7b1SVTl6Pg5mESMQE1tjI5hJ714xexo=;
        b=mC6bs60ICe46s52Tf2yAc4fuzEZp6nK3rKNIZDWrky2AwQFuRq9QofDAjt22McJ+fH
         PaSnh2F8kruuUbcFMZi9BPsxN7sOb1XtgXQOHn5pOeCBc3O2cBU4Uuz4EFsDFmKS5aSp
         JazhUkoGC1SqNYp658ldBXrKqwXMM5cIF07oFNJwi5lKpzQ6JXIAkjK+GbLmlLRUKPdP
         +Yv/WDw0Jogl2pSut6mTjxeI11CDwQoIUJwkMW4gT86vbxzrt+LI5rIAPvnanYu2rWn/
         q5RNMXG8M9v5u0eyPryiCuGyAqgfu4BJeQwvSkJhgFrNaVRrt8K+139DNyajnSR7D4oU
         Tp/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Zxxg+vUObOkF7b1SVTl6Pg5mESMQE1tjI5hJ714xexo=;
        b=qSEdAz8hdFDzaPsctbBICJsEjOcJez8bC/5aPTVMWwlRn2onsPAwmr86Dim22iYRJD
         FpIUkWVQpolzVXz+REhTMbq7qCJVL8eAry9nSZXNBiT6w8Kg0h1jLgujXcZ3MoigD+sY
         V1OIHrgFevM1yyU2ShVrzZ1STEPDda/4iDP1Tzjg/HWwLWVkTkXMHE5ORqVo/1iY8J7v
         7d9zp6jEtWwU3egzz0pAPzIUt542RPeMRRem9ONhtW1TeA1hf9o/jeYiTkI8Wsf4WGXo
         4kDXrOTF2yvJWDbrumwKwyp6HvVDaFTBYZjXV0ao/S3tL6nHbTi48m22L/EbBs5XDJOX
         WsCw==
X-Gm-Message-State: AOAM531i0R/3iaORHrhV3Fy9Z8ttfvep5hm+bNtiIDPolNhaNs+1syFl
        IGDUhCt5ymD9nlj9Qklf4pIQYvdPuLaH+d/A
X-Google-Smtp-Source: ABdhPJx+s65ttIXEh7f0EODO7brlqK2U7vop3UGuaFuJLIM808C0Xmq8yztNgkyh3kNk512R0Yo0/g==
X-Received: by 2002:a62:5ec7:0:b029:227:3253:3f62 with SMTP id s190-20020a625ec70000b029022732533f62mr37053545pfb.54.1620850459498;
        Wed, 12 May 2021 13:14:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c201sm547781pfc.38.2021.05.12.13.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:14:19 -0700 (PDT)
Message-ID: <609c371b.1c69fb81.b77cc.25e1@mx.google.com>
Date:   Wed, 12 May 2021 13:14:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.35-830-g80be48bc51024
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 165 runs,
 1 regressions (v5.10.35-830-g80be48bc51024)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 165 runs, 1 regressions (v5.10.35-830-g80be4=
8bc51024)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.35-830-g80be48bc51024/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.35-830-g80be48bc51024
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      80be48bc51024e01cb31e0b2dbd0f5f0e4974b54 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c033600aa396f4019929c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
830-g80be48bc51024/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
830-g80be48bc51024/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c033600aa396f40199=
29d
        new failure (last pass: v5.10.35-410-g9dbd9e48e4099) =

 =20
