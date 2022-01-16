Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7D948FF44
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 22:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbiAPVrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 16:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbiAPVrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 16:47:21 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C74C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 13:47:21 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso18733780pjd.1
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 13:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vmWjOoqmrcqF6nalKNZd0JWCvx8qOM9MGpUTYDrP/fM=;
        b=D1erfjJsMqecLEIhUOyTtV6rqQTUyd4H4NYCfr61SQxG9lyp++kZcDt+77XXCRnyQf
         UAFhVltZN8KMHx2LmcIV7r//nJ9Hu89fc/AweY8E565ZLjGSc0pFlV9f9bSxPjCy00Qn
         xQGYhGUjj6iPlw9aZgAX+Nk5uQYO1GAhijVDcTP7MOhsxhCVmbGyqieNtyrXyX7C2zo9
         ZhsL5pXiGpsn51NIFmtONp2bMmzLmbCPHI03QlNBZFqYRZezwWsUjxGRBdXTmaSK2AJC
         xtBAry3QkS35MtvQYiYlXb4KbifAJOwIcaVytwffroCwk3yx0gNfGkrNkZPIUpf8bFQz
         CqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vmWjOoqmrcqF6nalKNZd0JWCvx8qOM9MGpUTYDrP/fM=;
        b=X7GRqwtSN81oFG7PymfXkLmcC1++9pvc7uvnCoogbNz2zkLXEy3kU0I0ZrRgAGcxv+
         xE9pdskYDTrK9YNa/CAatLdkTmuElollKpkhqVmCmMXrfbIy9VkvnwPDOeUX0Wn/bktm
         XvSQz4V85qyevDu0Z66HZREICseaIfUpyoblGX99NSxoI9HScKDFqslitYQC1/AblHyn
         VD811g3w8zvlZxq4sedO0h2JibO1Y8olnWWK+S5MD4P0BiPu8Qx7+s45bh5bPdvDb9zX
         gqp7xOchqsDv8xFzUQ7TltVhbc0bLYeIp0CXEBYu4xoKSLq68r6G1R/la/+0naCe/288
         66Eg==
X-Gm-Message-State: AOAM533gZ3DISfN3p01eiV8wlAdaRuwU6vx3Ydbe9is0wYWxvDa+LU8m
        Jgoq92VsN/qPPo5bBi1JVEuLnthBVgeOfHOE
X-Google-Smtp-Source: ABdhPJwp6Q/zTmSSF3LO2KYeXVxOvtxIEl7DAGz1Ll3QKs/vr3F0QHC2HVYw6EURhGbK10Nk8r6D4Q==
X-Received: by 2002:a17:902:c406:b0:14a:52e4:3e5e with SMTP id k6-20020a170902c40600b0014a52e43e5emr19748166plk.4.1642369640485;
        Sun, 16 Jan 2022 13:47:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13sm9686358pga.38.2022.01.16.13.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 13:47:20 -0800 (PST)
Message-ID: <61e49268.1c69fb81.187c8.ab30@mx.google.com>
Date:   Sun, 16 Jan 2022 13:47:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297-10-gd6bc6be08f75
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 131 runs,
 1 regressions (v4.9.297-10-gd6bc6be08f75)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 131 runs, 1 regressions (v4.9.297-10-gd6bc6be=
08f75)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-10-gd6bc6be08f75/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-10-gd6bc6be08f75
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6bc6be08f757494e68363b55b2482d5d539f887 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e45f4d1d6a507130ef673d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
0-gd6bc6be08f75/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
0-gd6bc6be08f75/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e45f4d1d6a507=
130ef6740
        failing since 5 days (last pass: v4.9.296-21-ga5ed12cbefc0, first f=
ail: v4.9.296-21-gd19aa36b7387)
        2 lines

    2022-01-16T18:08:59.237980  [   20.250885] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-16T18:08:59.287192  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2022-01-16T18:08:59.297047  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
