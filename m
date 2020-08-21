Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3E724E219
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 22:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgHUU3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 16:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHUU3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 16:29:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79DDC061573
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 13:29:44 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d22so1624746pfn.5
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 13:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WW775V0DeYPaCtI3/L9tbqBHfRAPWRfGiAGKFfYNz5U=;
        b=SgBO/pABcMNr5PBP194xF/jdRSUD7VO+JrSa0OUPYHs5eFG1m5uzTo/zZ5Sz6zgW1L
         NXMSbuMZWpvJr3fQvecqEVgIn9eHlWk6dJsgEfcvXye1JjvuU9TFT9atUj+LPzirAuTs
         zN44bV5PcR3UDUhl3wMAiDr90yj1ISiF/5e/sX5OhK70smTgX2JH2QA8+zFUmic3cslz
         jDU5+qxSTJIX55uNho1mAV9jP0vmNmDu674e4KMTydnNfJ0fKQU5+fdWcpJMxL1PA/HG
         PKGxCPQh0DylSYPwzw2q+QUUlvQ4lE1HriWb3sNpIpsELLoSNUzntajnLlhG7uDaIYkR
         lRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WW775V0DeYPaCtI3/L9tbqBHfRAPWRfGiAGKFfYNz5U=;
        b=Ry3C9BoLd2yS6GLYpmBc3pqTgi52cCiWLbjZnSGrmXfNJyeeFJJg31MDTUOwA6BiJs
         ua64/HTKj9GavE6zpHSF+6VfXgr3fhALQ3hulGgLs9Y9fuSkAE+l2d/u4a7Oipw62UfP
         m0F/X2bUz2Nq4nPxWVG6rkWq/L9xEwRT/9noZ5FE6nUS3f+FOGoOC7ygGB4uiHqpPm13
         5rt7dQMyUYz4MRiceo5L07dbB6GmvcpO4DWxF6jzfBED98m7AKHywpNpBeYJxlfehv/e
         6IFAIkBh+O3ueQpsAoh4kxeI3wWjEUV1yaOQ0tshUnFITTB8bVJRkYm/td9om14XnR6y
         WFPQ==
X-Gm-Message-State: AOAM532OcUerxxsT2CDojeZozHvbeJI4wOloIkHVOFv5x8BtEUWgNpVt
        qbNL8wTArYOTRIDOPJzQnrwaVnzNiKisyg==
X-Google-Smtp-Source: ABdhPJwH3Vyxlmn2rbLiHWstCKJOg8FH8/YQo+qFLfvSIgt0iPGpuJLwdU1fWkzs8HMbjMmK7xv7KA==
X-Received: by 2002:a65:6554:: with SMTP id a20mr3173707pgw.301.1598041782387;
        Fri, 21 Aug 2020 13:29:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d81sm3421342pfd.174.2020.08.21.13.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 13:29:41 -0700 (PDT)
Message-ID: <5f402eb5.1c69fb81.5e66a.a922@mx.google.com>
Date:   Fri, 21 Aug 2020 13:29:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.141
Subject: stable-rc/linux-4.19.y baseline: 169 runs, 2 regressions (v4.19.141)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 169 runs, 2 regressions (v4.19.141)

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
nel/v4.19.141/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.141
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d18b78abc0c6e7d3119367c931c583e02d466495 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4001a344261025c19fb42d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4001a344261025c19fb=
42e
      failing since 66 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88)  =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3ff9fea1b873344b9fb442

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3ff9fea1b873344b9fb=
443
      failing since 32 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
