Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FA43A31DF
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 19:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhFJRSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 13:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhFJRSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 13:18:39 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BA5C061760
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 10:16:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so4142437pjz.3
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 10:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KWo0V9/AmeNu4STH67T3yiLxMib9NDRnAWQvq1WOXgE=;
        b=I3wf1P2ud4bIFE1diM8nb8KNGPtSMXUhNpTXqUxdsKOLWFeAbuOQ6sHmVA1n+0Afsm
         18iXoLyS5x0LCaZL70rZO4eqXI7ONFnMMVctluM4I7kL56AxHSU4+iYfP1gWfe1J1uOY
         wAHN3vKMsPDeTIJEgtijouHgWD8XQyd6Ohe3ljE3m7cC+2JQ2srcax49a514YfH9+nc6
         eD5e+aB6BNZlLIGM9aJiQn+qP+hUvQ6wIMgm/psJnBqNf2aBpfiFM3ndgh28B726Yi01
         B9upb2BfY919GLoEwCfTsAZ5wAC+VyFagW6jDouLk1weYgFZCdWJWDtteiH3p5IAHINQ
         qZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KWo0V9/AmeNu4STH67T3yiLxMib9NDRnAWQvq1WOXgE=;
        b=tvGMk5f+BT4gu1qbDyN1IiUMU+k+tNkj/ucq7w7RhX70hrWt4/piAB6QvjaH0qKpIx
         bOdVXxl0mwzSHGcw5mvuvdDhZ86WX/DX0bTaVxO6TIWfDN5RTAnEeBxCK2LGAZQ11+l+
         n3RxgFuIztYkuIhlkDesHI60BA/oaUfHzZE6MEhFNN7fD4LGaBGRezFRSQFoBMeEJ9Mk
         IjHZe9jf3XRc0H1da8ewOGA4ljdI3sjUM5CqLjuk/n2GPdRIUWszW53d8FIp6tFlxqf3
         npbce6qvTxJUJghbFEHhM92/+bGBBkJj3262IClOLQNqLL0TH+/dZW480SHfdDw6rM+r
         bwXg==
X-Gm-Message-State: AOAM532Q7nJ8lMmGhXj/XhXZ9X8RD0I7n3vxdsNehkwAYD60SfoVsS0S
        0fyk8BF5gzMYcvZrOj7Fp/GWbNdqf/XJ5DBQ
X-Google-Smtp-Source: ABdhPJz2mB+kage2IQuFPPTKoT8g8bAj0ejv6Q/Bn0WO23y5PLYsNX/hK9LRSFPo8UcgZ+707wdkKQ==
X-Received: by 2002:a17:902:eb05:b029:fe:e0fa:e1f1 with SMTP id l5-20020a170902eb05b02900fee0fae1f1mr5767276plb.10.1623345402256;
        Thu, 10 Jun 2021 10:16:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm2767584pjr.48.2021.06.10.10.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:16:41 -0700 (PDT)
Message-ID: <60c248f9.1c69fb81.abd69.8a6b@mx.google.com>
Date:   Thu, 10 Jun 2021 10:16:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.193-57-g49c9e6157fa5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 150 runs,
 4 regressions (v4.19.193-57-g49c9e6157fa5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 150 runs, 4 regressions (v4.19.193-57-g49c9e=
6157fa5)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.193-57-g49c9e6157fa5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.193-57-g49c9e6157fa5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      49c9e6157fa5736b7de119e7d69e288c3d934eb5 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2128bf57087e2420c0e0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g49c9e6157fa5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g49c9e6157fa5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2128bf57087e2420c0=
e0f
        failing since 208 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c212b503aa2848cf0c0e34

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g49c9e6157fa5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g49c9e6157fa5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c212b503aa2848cf0c0=
e35
        failing since 208 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2127b61c1f4ac100c0e26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g49c9e6157fa5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g49c9e6157fa5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2127b61c1f4ac100c0=
e27
        failing since 208 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2126fe1f35fc6170c0e06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g49c9e6157fa5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-57-g49c9e6157fa5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2126fe1f35fc6170c0=
e07
        failing since 208 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
