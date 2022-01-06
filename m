Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2827E486DDC
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 00:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245577AbiAFXi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 18:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245546AbiAFXi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 18:38:59 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C583C061245
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 15:38:59 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c2so3767169pfc.1
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 15:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uEkmzqMak1tJS5rhvO78VLYejMxMwo8Rwpf0D0mRKp8=;
        b=5HFcKSp8xI3kZJJXeFeY/Hk9KfmOvPb4otXJPjQh1RuMAcQ4c4ynnHaj6mGAAkDkCm
         0C2BCrJPi7MIdWQ7foOauh1br65v5sHFhdxNLBsh66I27RomUcstpJpFIZvTBK7KVSyw
         F4JZJ1uE9e40PHUbHfqdL6FsMN5WI/7gtnyWyrTNKVW/sRnHTz+D1jkTW8Pg5Y31qG79
         D1My9isRS4G8JW78Ii17E5FM5ARxCkIjmDFm9yjwYUKxh155Wl3J310PpHyjKX2OvBFC
         gj2P39QiPra+b5RxAvyvLCPYpkVy30sfKmsKIh3ahUwVNqGuaXREvkefvL8V/RbQQ/XN
         WzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uEkmzqMak1tJS5rhvO78VLYejMxMwo8Rwpf0D0mRKp8=;
        b=16x/Vb9zirUmtJ2aEpj1dtspO1uaJVBcwN87lyavQ20QUCwkxZIHsyVQZFrM+P1fzD
         86U+aweKctji+GSaEr86VEpXEOUdFKOLNoGisLTCG/waYVTrfkYVqg2uBBvSXWLTVHMx
         pQ3l9rWYzu8jy2zEMNCgFNvkiX8rrnE0LCnUK5eoJ/Dsd4COZ7kp6tpFxIELRe5rF/mB
         2pAEkRtTL8Q6ryojmdH+v2UETb8gPD3CYzWIkUR4L1I4insk+wq/5/t3IoatOdewc7bA
         faHSMUuVeuixcPCPqHYdPOqa7XPhB7TbaDE2PMZ+ll04UMGylCWjguB3/Gfkk44FjgVj
         XUfQ==
X-Gm-Message-State: AOAM531HDh4K6XSuLca/4r9fFq9L3OrI4vgXewO3i9xJhc24uA7gNtaY
        ZmOqvPSggqlIUjinSuTWgVziSsrXyj2+mr/+
X-Google-Smtp-Source: ABdhPJwb79k4Mmg8swDCORdC429Ri6/Dx9hwznkyKSEI5oPbFvOoFkJamDBIIFywxdU68txqVyHp1g==
X-Received: by 2002:a63:6d0b:: with SMTP id i11mr35872582pgc.190.1641512338418;
        Thu, 06 Jan 2022 15:38:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f124sm2935269pgc.32.2022.01.06.15.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 15:38:58 -0800 (PST)
Message-ID: <61d77d92.1c69fb81.37611.7fa6@mx.google.com>
Date:   Thu, 06 Jan 2022 15:38:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.296-1-gdae9eb7a8688
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 131 runs,
 1 regressions (v4.9.296-1-gdae9eb7a8688)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 131 runs, 1 regressions (v4.9.296-1-gdae9eb7a=
8688)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.296-1-gdae9eb7a8688/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.296-1-gdae9eb7a8688
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dae9eb7a86881485dbde579fe2d9b207780505cf =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d7489a7b5610f106ef67c4

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-1=
-gdae9eb7a8688/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-1=
-gdae9eb7a8688/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d7489a7b5610f=
106ef67c7
        failing since 9 days (last pass: v4.9.294-8-gdf4b9763cd1e, first fa=
il: v4.9.294-18-gaa81ab4e03f9)
        2 lines

    2022-01-06T19:52:39.389045  [   20.098785] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-06T19:52:39.440666  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2022-01-06T19:52:39.449463  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
