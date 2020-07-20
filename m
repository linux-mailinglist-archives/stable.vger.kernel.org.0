Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26D2226FBA
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 22:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgGTU32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 16:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgGTU31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 16:29:27 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46E2C061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 13:29:27 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id s26so9629897pfm.4
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 13:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7EBcJrQq8ZUrf61AvV1UTMmkyqit9hE7nD/rsf11+sU=;
        b=f1hEuN10gamhqXbz9iOZbpWCWkTmYlMWjqoXY3H9kxkVp9JJwYomIQxPsDEkTYUGT3
         z30QWYSe9l6xuqije6reUoDR9VaHATrsPPtHgJZ/dECvI1QSGk/2Yd6ovHb8IX+sd7cJ
         NE617iupJpEkLrpMzfk4zPxVl1mFUPXBMkivlHYojHGPZZo4PlGzWseyc6xlZbwuwUIu
         PZxgcF5z+QUf9wg6WPFzgnZELf3C9zkdZdS9CQhWOUlyh/yd4/W3iq0id1dNp2/ZaN1v
         bfAis5ieMSzNK/mpM+LkWaLq9dxXobNsJr94w98FRcPo+/QmMOvdN5qtPOPQ5DaK7cdP
         /yfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7EBcJrQq8ZUrf61AvV1UTMmkyqit9hE7nD/rsf11+sU=;
        b=U4z/RNpxqa0T1WP3HkvI+byFKSYtTVQPGBNNUxZDjjcbD9lAA36CZcF+l/CjRLIlmZ
         DllIjtbdTow6XUkFrq7Y9XobeNduGILET/RaWQ7LD0yiNoo2HTaJgTxlYNopMBfa32dN
         w9/1nOaxY5k1vNuBY7oLOenya/RviN0LAleNTGIPFfJfo8gi2MZeAQd2DzWXzo7VSyMd
         zBRoddGF7BfIiHgaefYVRqUEht6XjX+DRvT7BCG8G5pWsmUST+G41Nyeyp4fDq+rL4YJ
         khcz88pnjreK3ekqjA5phUIQDMV9uFEhx/9AnGyCogqoWc5ekbtYzMYfeQWInNpuZ3Rr
         cM/A==
X-Gm-Message-State: AOAM532bnQuzSH4odV9+8v5GvSLB4JV+b3YwUwqYRfEONZ6ccV95YZ5+
        nFzOwjJh1zHNDPW8GNEXMXlUP1qocJo=
X-Google-Smtp-Source: ABdhPJwToqI93F0tSwxwyazPEImlBZeR9RceYBjdlsPJUT3BElY/dtjypOOxGHvD2XSJZykeP9Qarw==
X-Received: by 2002:a62:1ad6:: with SMTP id a205mr20596494pfa.109.1595276966879;
        Mon, 20 Jul 2020 13:29:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z10sm18218403pfr.90.2020.07.20.13.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 13:29:25 -0700 (PDT)
Message-ID: <5f15fea5.1c69fb81.cbc1e.d102@mx.google.com>
Date:   Mon, 20 Jul 2020 13:29:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.133-134-g9d319b54cc24
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 67 runs,
 2 regressions (v4.19.133-134-g9d319b54cc24)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 67 runs, 2 regressions (v4.19.133-134-g9d3=
19b54cc24)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =

hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.133-134-g9d319b54cc24/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.133-134-g9d319b54cc24
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d319b54cc24b7800883e120b93d20d117181089 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f15c3cb516df8bc7e85bb36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
33-134-g9d319b54cc24/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
33-134-g9d319b54cc24/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f15c3cb516df8bc7e85b=
b37
      failing since 34 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f15c5a4947b5d58f285bb2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
33-134-g9d319b54cc24/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
33-134-g9d319b54cc24/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f15c5a4947b5d58f285b=
b2e
      new failure (last pass: v4.19.125-93-g80718197a8a3) =20
