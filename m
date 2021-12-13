Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580DF472E86
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbhLMOHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbhLMOHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:07:51 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFCCC061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 06:07:50 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b13so11255801plg.2
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 06:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mIJs2DYrIaKALbG3TOl6ztyZ12+aEQLhcYFsKV6DT44=;
        b=xQC0i6kXt/VCHZAqe5knqakhRBiB9ThDy4rpoGqAamlS0KJ4bVekGiHo8fAhSdI3zC
         5P99R4vdvCZnvKJ77CjEPW1kun7dBYBopcRkeIN7dp88VFozJoWCDbYb/Z4n8ji75rVH
         hcrjgTscXi91Rt6sEJHa6YOXEFzN/8YrOLPosMCnlIUJRYdx2rBT2F1xiXbOE9sIRe2P
         ZYKZB6+0l2nowRs/2hUHXOxsoXdYunaawy3+vwVdoyNzR+MznoXG+kWcOvrBE9fd81kR
         kO6O+l5Ag+H8CWtUXM0EOoiPP/FuS7Roj8qfelXMyjqK48JvUWXs9N7O1658H9SnZkoj
         VoWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mIJs2DYrIaKALbG3TOl6ztyZ12+aEQLhcYFsKV6DT44=;
        b=Ct94SSFFgi9KKUgcUKSmgDJd+LJ4X4o6Ls0NDk19Xi5mwAL7APtfJ2d3QBvKi7sSp8
         aRqnQ8wcnB5aDU50z6jVEFwqkcxKiBEyAYNzp20p7piNLdZnDTw9UTlEIqGqGtaygtm4
         lS7E/u6d8uJjYy+ly6+zXa5/4ferSWYcqW3jVvAeN1Z+bsd2ULl7I9ROQQ6La71OQFps
         k6H0/TnELwNAmdFyTbxwpQiZnEph7TYiGmI1WYUxsHpPKqCRXYVGckGDghIXVPbSQjUd
         Ymd1qVR5c0Ou9IoBK6bobOqmnVlhu+w0hikwzM9SFnRHuAVHtDU3MfP5HlDv/BjEhiEv
         3w2w==
X-Gm-Message-State: AOAM530r75HXgz4wqv954Sjnq+rHRI+AAYd6/SMieA0T94X7mw6QKmiY
        L2y/M6vg+q5Jqnf5vjpYo3nmRnPNzwdCSK2V
X-Google-Smtp-Source: ABdhPJyhbGgN445dw7+CyAAKGHi5oKDfNSafo3++0vtTv+Zbz0PGnzDvHE04JzwgnVkT1Sq/iys3TA==
X-Received: by 2002:a17:90a:af94:: with SMTP id w20mr43632013pjq.223.1639404469769;
        Mon, 13 Dec 2021 06:07:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v6sm2476096pgj.82.2021.12.13.06.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 06:07:49 -0800 (PST)
Message-ID: <61b753b5.1c69fb81.2b8c8.66e6@mx.google.com>
Date:   Mon, 13 Dec 2021 06:07:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.257-54-gcca31a2a7082
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 147 runs,
 2 regressions (v4.14.257-54-gcca31a2a7082)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 147 runs, 2 regressions (v4.14.257-54-gcca=
31a2a7082)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.257-54-gcca31a2a7082/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.257-54-gcca31a2a7082
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cca31a2a708243a4305c86069bc291830d54eb3c =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b71b4991ac28e75739712e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-54-gcca31a2a7082/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-54-gcca31a2a7082/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b71b4991ac28e757397=
12f
        new failure (last pass: v4.14.257-34-g5ece874a0959) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b719a1aa056c2d5139717c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-54-gcca31a2a7082/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-54-gcca31a2a7082/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b719a1aa056c2=
d5139717f
        failing since 17 days (last pass: v4.14.255-251-gf86517f95e30b, fir=
st fail: v4.14.255-249-g84f842ef3cc1)
        2 lines

    2021-12-13T09:59:41.229876  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2021-12-13T09:59:41.238454  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-13T09:59:41.255025  [   19.986511] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
