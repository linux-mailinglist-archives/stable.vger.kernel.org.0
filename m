Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7DB49523C
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 17:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346592AbiATQVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 11:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235587AbiATQVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 11:21:03 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE50C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 08:21:03 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r11so5740834pgr.6
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 08:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TYWuAUVheMX//awlv++4BMkgkT5TGcukaDVRQ2qfKVI=;
        b=MTrWIya6SzKVNO0bixTLbpI4PF0iigh92O+pxIpwcnpNjNa7vv+tjGcfFTx9D2U/jQ
         egVyDeZkkejBsOna9SondcVLVcksk8mt7YEIKm0T6yhTMJpjTt/3XDpyUIoF7LyKLeTQ
         pEfhKfnnF2RzdWi9qG9XVf4jD2Rh4DxjGvyDitJjbmyd2Q5r2JNOmcyzbmbbXeA0v1TB
         f2cVEk8F8+DsWyiCWJO0+ILFG2mNtFzkY5dP/6rUYwMhO+YB8IFHBfdGim8VWX1ouBpT
         yohO1xyA2ZaE12ywTyvUmqfelGRTCEZiM4oPkp2Ar8w00fvESp/m9rdtYrP1i3w9unWn
         9jXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TYWuAUVheMX//awlv++4BMkgkT5TGcukaDVRQ2qfKVI=;
        b=q8ZmdTixm+Lng6zbxNkU5WbVdu1nMRiI4+eVUgzu7HB3FH8cJEWWQQAMfF7u/hBe6y
         utRZmRUyDEe46gvHkTRqVBLh8F47aNBQ4UqVxAIMXyNt0DcnqVHsqWoGoZQFVDXYa6HN
         YsEyQrehDZqnPnkz8X+7Af4740iOPwVqtTsuIgOwQx7MxyjvzO2agYbKEuWPmFnOOj4H
         j3D528LZ8YYC55DGVBeu5WD8fxnQJDMlj31/Yw4CveOeGelKJVo1JX3ShpHd3A/M09oF
         cnbceJgMfACYn4jQP3etPrKwNF4LjaeZUt6vqgOu6AXjbeI5jK5vqqcYG0D634We2DSO
         corA==
X-Gm-Message-State: AOAM531hr2E35CLULxGyNXLOkzfvFPZPXSDy+/5sMNFRt0G7/MgDQPkA
        3DB/jEL+UNCxBPiiFgaxWxtz1ozuw7v4hmB3
X-Google-Smtp-Source: ABdhPJwSqAdy0YCVLNagc+whLuUTr2mqoIG6QE05F/UcC6zXqg7Pi64xsrKzAK7kSIt+CXHCwvASqQ==
X-Received: by 2002:a05:6a00:1818:b0:4c1:6983:f1c9 with SMTP id y24-20020a056a00181800b004c16983f1c9mr36564608pfa.59.1642695662582;
        Thu, 20 Jan 2022 08:21:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o23sm2946097pjg.14.2022.01.20.08.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 08:21:02 -0800 (PST)
Message-ID: <61e98bee.1c69fb81.cb3c2.7ed4@mx.google.com>
Date:   Thu, 20 Jan 2022 08:21:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 238 runs, 2 regressions (v4.9.297)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 238 runs, 2 regressions (v4.9.297)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =

panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.297/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.297
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d58193689d0deecd834a254892b4df49a723d54 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ddf260b155c4e407ef673d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ddf261b155c4e=
407ef6740
        failing since 8 days (last pass: v4.9.295, first fail: v4.9.295-14-=
g584e15b1cb05)
        2 lines

    2022-01-16T11:57:57.530660  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2022-01-16T11:57:57.539345  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e95b1a374f20ffb8abbd11

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e95b1a374f20f=
fb8abbd19
        failing since 8 days (last pass: v4.9.295, first fail: v4.9.295-14-=
g584e15b1cb05)
        2 lines

    2022-01-20T12:52:25.168091  [   20.095031] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-20T12:52:25.211600  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, mmcqd/0/83
    2022-01-20T12:52:25.220166  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-20T12:52:25.235629  [   20.163787] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
