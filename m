Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AAF4814C4
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 16:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhL2P5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 10:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhL2P5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 10:57:24 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B037C061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 07:57:24 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z3so16148343plg.8
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 07:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cqak43pJ447ualpuCTilXxMl6olkzFuIJYdPkklzIpQ=;
        b=A6mDLUbkfdW0utXJgbIoar4WNsW5HVsSk4uXV33XmrKSnrYMjKcvNjcm7yMS+fZx4N
         gwozxsmP27doEvX5DZyZs5p4VVISduTkbSKet2yAVy/4ToshciL+50UHYWJVs/O3BvP3
         d3VZHZ1QPx+PaDiiEqGH7Bq5yiBBFvW+mK9ZPu6ZKwbH7f1UUvF91dZ8ezQoSDPycgO3
         n87PusJc25YMGWHYQNnhLWvPEoxAA8iavz+esFERlOxR7Ov/pJZ4iAlxArq6eB4BLOQD
         /gGmghsK7ydrnH4F4+HOsMSZmr9Ld/CfiI8lq9Du3K+3N+N1b4ZE2HnHXhqTRYQFTc5T
         W3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cqak43pJ447ualpuCTilXxMl6olkzFuIJYdPkklzIpQ=;
        b=7MzmPX8QXAPmgTc9wuQluS+qbXHbyAnJFthedAniATxlGJTftN/cA/HGJ3ufl1PPQh
         OYowMi8X0DWS+2yAK8/Q6CL80LTubPNEu37to6IYXNRSlkTXCJAKw1mkcXIUPA4HxCQq
         MF1r6VTPyV7eXk8xJchl6SLycBnyhgetxzlxq5UEczqj+Xtk2vRwCR3cHlNNeH6sPFzc
         UrXFyXPytF8/o13Y8vDFZYOxQMtUSUQrsSz025kjJ/BGiWefkR2wRL+TydFjzyizFLR6
         hVNt6mlkyN93M9YRN+TY1WIruDe3GVrXhjRdhqqpJYlZN5iwGZV30R1gKqsv1jFz0Mgn
         T1WA==
X-Gm-Message-State: AOAM532RLtrklEzacI8ZTo8PfrptTPrz6mjp9u+V6w2LYTr18el2M6I1
        lev7PSQmuxaabL7BKnF+RzVw/oR7AtQ9fxdI
X-Google-Smtp-Source: ABdhPJxOL8EFZUI57yNVBAFKDV54vSSXc6J5lynvEZiCLIBGZxM+3cS9xiAbb2un/3Vm8ekrTGqlgA==
X-Received: by 2002:a17:90b:4a47:: with SMTP id lb7mr32521680pjb.126.1640793443368;
        Wed, 29 Dec 2021 07:57:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c21sm25903048pfl.138.2021.12.29.07.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 07:57:23 -0800 (PST)
Message-ID: <61cc8563.1c69fb81.6f0f4.63ec@mx.google.com>
Date:   Wed, 29 Dec 2021 07:57:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.297
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 117 runs, 1 regressions (v4.4.297)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 117 runs, 1 regressions (v4.4.297)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.297/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.297
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      76d42990efb4902de293be254f5e93c693058c8f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cc4b49d637af308aef6764

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.297/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.297/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cc4b49d637af3=
08aef6767
        failing since 32 days (last pass: v4.4.292, first fail: v4.4.293)
        2 lines

    2021-12-29T11:49:10.369669  [   19.433746] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-29T11:49:10.409257  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-12-29T11:49:10.418811  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-29T11:49:10.435361  [   19.503417] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
