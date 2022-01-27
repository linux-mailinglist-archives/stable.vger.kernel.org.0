Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D437849EE71
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 00:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiA0XH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 18:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiA0XHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 18:07:25 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC18C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:07:25 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id h12so4761636pjq.3
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R8RbqOKvCelf7XV04m3ZWPuVkzzWf+0k7TycO5+ESPA=;
        b=iHh3amCpoI36OoHeSZP/XMopIOq4e8iRPsla+qCsE+yoKz8CwJXXXblPBgezUkYTsX
         gzkbr91IJLNJYVMmEjlAYf9S2r3McsvlsjuOGjREv8xA2gUnXjZMdz/yOZrIgFfYirgA
         8d6G1JbB2e8bZ3ecmeuItK/alnSMVzRbW42eRcwMnlebAsp8CvWpxDaXuKlBKEn/xISx
         eItGQV6WdAFz7IsmPrXnIJ25j/KMo0hcp/5EwkYpRN6aPCm0rrVwGEOa667iD1tsaoAQ
         krkE25XKMY8gbmNkXlu0tPn4HO724X2z007CEguQmZAJ22pTlOkW4dEk302CW/DMXb/X
         IQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R8RbqOKvCelf7XV04m3ZWPuVkzzWf+0k7TycO5+ESPA=;
        b=W4svgMDn8Us+R/cR3C6YpUb7mTqCoTj4ZhEYGa8xqKzXT0x4TlikzWp/bi5pl3Sp06
         RfRFaoLF4wfX8XuD4hP7Dn8iU0pFdipZc+PNnkF6PJM2QSy8yW8F+Faq7em0YLpyovdr
         tcyVHSzaIp8zgW6ybpTMNL5ELdTGwdlsry/pdyD62DJSeGsHlS4tjwGtTsZiW9y4n5TU
         UGyswdar4oGXAKW9Fjpoq93IxcF7bwSGcmPNZ30C6mHWmm0Uve7iyOVOO9+OBFMlDnmx
         UAY1lkLBtw2E+5ehdLJPVR8XRumMjLx9oYNht7dcDnjjRkubqabap0/N6zwVwXZ5txbo
         joCA==
X-Gm-Message-State: AOAM531MYG0Ptz/soFxv8v/QdPVKDS2vG2MVL1/jfYWpg0GLNId26Hvm
        km4qHz/SGizUDMvs6hL1ASnUSmV9amGkF3mWQUM=
X-Google-Smtp-Source: ABdhPJx1tph4M7OFp5QREnRnVlljzJfjEqgVbfhbM4K0J8jGVdP3IrTwV+USvxYeM2RVIWtHzCTTmA==
X-Received: by 2002:a17:902:e889:: with SMTP id w9mr5446179plg.93.1643324844793;
        Thu, 27 Jan 2022 15:07:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b4sm7121353pfl.106.2022.01.27.15.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 15:07:24 -0800 (PST)
Message-ID: <61f325ac.1c69fb81.9a29e.3f2a@mx.google.com>
Date:   Thu, 27 Jan 2022 15:07:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.298-10-gf4e33f5b11f3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 76 runs,
 1 regressions (v4.9.298-10-gf4e33f5b11f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 76 runs, 1 regressions (v4.9.298-10-gf4e33f=
5b11f3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.298-10-gf4e33f5b11f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.298-10-gf4e33f5b11f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4e33f5b11f3a84227cb47f295ec793d83af7eda =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f2ece4dcc877887eabbd14

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.298=
-10-gf4e33f5b11f3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.298=
-10-gf4e33f5b11f3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f2ece4dcc8778=
87eabbd1a
        failing since 24 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-01-27T19:04:49.278875  [   20.477081] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-27T19:04:49.329682  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2022-01-27T19:04:49.339145  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
