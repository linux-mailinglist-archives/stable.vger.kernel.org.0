Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8679E47542D
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 09:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbhLOIVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 03:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbhLOIVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 03:21:33 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AA3C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 00:21:33 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id q17so15770540plr.11
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 00:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D/cqQrIneywEcSVLMeyzoFR3QTYQTTIL8VmkuVDxmk4=;
        b=pcVw9zhmMgCr6/F0r6FUN2D9ygrIOfjgW9eO1KARXufyggJl2T+2FFy95EUn1fE2Ux
         3wMJX9nP/p0V/RPR4kGPUfxSnOF1PoX3nuMBVplOym94Qbh0a8JyUs2EAV59WRiC/Sy3
         PaKmWCph/CU22hi5CPPmTz+EhUQUEk6u/Pzt8B7+c3yCFubxGyvEf7Z8JaahlOFC/7pg
         BJ5BkkNmFWWqM4OAxx9vBLDe8z17yy4lCqqZgq6EwOmeyaoG46HBMM+6zg5lf8O+bqvN
         h+aYw5E/tLoisM4Q9cPSJV1+p7roRMU63JS4Nj8D7g96kS7lLUMUpAhuMT65ZxO/S8ZJ
         5J+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D/cqQrIneywEcSVLMeyzoFR3QTYQTTIL8VmkuVDxmk4=;
        b=kP9gIHxGqdrht94nkcbfEBm/QGUDENKMWJOAidW48/N98YqhI4N3wgnGvFiIQbuYXJ
         AdJ6ehxC5vdkzH5UXIR5K6LuCtd8yMaj3GxubeLMRgZAgKa6rTvfOL8teg0MmT9Unime
         FmmnIPVkGuktjiTsU/XvG8UMyMTEpqNefdvfKy03Kugnw35XfGl2C3dLb2qObsROXVUz
         lsnOTtfiTEKFDUFr70uOEDi9bx0ihhfWwAoZpDfjK6juIi7kj0C/JQQHC7YID5LndG4d
         VEtnlfQPmtVWMK8pAK/vzlQlQvvSJuTZMRLsDFmkzlui37Qyiw4byGDQulfivKQ8P48S
         pvsA==
X-Gm-Message-State: AOAM533Z+R+Kloxtosdg7lYf8oOU9O2VWIXIJ2u+75s5i8aeVFyT18Dq
        dQKnQUIApLJRwyZvSsGTbgzXrINIhoth6gZN
X-Google-Smtp-Source: ABdhPJwpK4VunhmxzVpMxrz+kMwqbw2M0LVDjB8Mux6Ar47VkgyPDAY0J941bEeGm504sMf2VGgIAw==
X-Received: by 2002:a17:90a:46c9:: with SMTP id x9mr10692084pjg.183.1639556492589;
        Wed, 15 Dec 2021 00:21:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7sm1475649pfj.41.2021.12.15.00.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 00:21:32 -0800 (PST)
Message-ID: <61b9a58c.1c69fb81.802f.44d5@mx.google.com>
Date:   Wed, 15 Dec 2021 00:21:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-4-g6f24489e6ad7
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 76 runs,
 2 regressions (v4.4.295-4-g6f24489e6ad7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 76 runs, 2 regressions (v4.4.295-4-g6f24489e6=
ad7)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
beagle-xm                | arm    | lab-baylibre  | gcc-10   | omap2plus_de=
fconfig | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-4-g6f24489e6ad7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-4-g6f24489e6ad7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6f24489e6ad72d293a63504f6af11a438fa6d00a =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
beagle-xm                | arm    | lab-baylibre  | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b96d148786a6a7ad39712d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-4=
-g6f24489e6ad7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-4=
-g6f24489e6ad7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b96d148786a6a7ad397=
12e
        new failure (last pass: v4.4.295-1-g8d64c5a634d5) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61b96b830f643d8f0939712e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-4=
-g6f24489e6ad7/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-4=
-g6f24489e6ad7/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b96b830f643d8f09397=
12f
        new failure (last pass: v4.4.295-1-g8d64c5a634d5) =

 =20
