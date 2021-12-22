Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4F547D4E6
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 17:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbhLVQNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 11:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbhLVQNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 11:13:22 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D621C061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 08:13:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v13-20020a17090a088d00b001b0e3a74cf7so4399016pjc.1
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 08:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tZaaXC1DX53iS3jy9ShQCrAFwpMc/qruXqqsQImbJuQ=;
        b=jDbiQDvfOKG1OXVXeJZlJKo8L7ftB47Zx3HO1Wo2E4jgK8sdHNO9CrLvEhdtxwGVbk
         DXEUX6S69+kVgpniy3xpvlCu7WBcrrcBIiyrRbM4aE1drN3HkRIQIZIDR9vPnGd4b8Sb
         Rw24RepczeERnSf6mqaxvt05tUI/ujrZkMBCWWMASF+oxNjAau+g34Sfx5NcIWep+9X2
         ArJgdjMATqqo85Zfx93niFWftP6w4xlkuMt1CSaCkFGV9+4ElsRXXLDaw61AOXNX3Dbe
         1aPYlgzExDJiC78WVl4LtlRqgQdvICP+NHto2O88kwWa63vm1bGeOD0uzb29nMTH6jrP
         Sc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tZaaXC1DX53iS3jy9ShQCrAFwpMc/qruXqqsQImbJuQ=;
        b=q9ixZ78sAIdROzO+e1fd4NdEubLKrhPgMMix0uRF1lH4yXPSI1wUAR/xYDisoaUBRB
         11SF7D/tA4pun/CPzDfKCwKM/Lv7IhDQ2lGimY/BPt2LXMD9rXMQnfMhZ1XxinLTkUqv
         d2HxITCWgFTqe9izHkPOC9MdWnVy1r2Gm9OiL3NPRVSbRDdRi82UpxIKiq/R7l6YaEOS
         z0jikKZXV5yAg+3fHC5kDX6B9jOrJMgunB0kY61Rk4nYyD5HU0QEQxrVk3pNFIIQsnZ0
         txckw428cNyGyAQolTjxSmc1ogGC0xZssV+tqFCWhcLvC1D/5/tqbLkmuuSQx0WcwHVw
         UN+Q==
X-Gm-Message-State: AOAM532/FBPCtBfJMq1+st7KHN0dvfipE1XGhLQE+F5zR3gnirBtPBCN
        JkHDl+Vgx6nn+SLgLYbrwCY2twMPowIr7WvarzA=
X-Google-Smtp-Source: ABdhPJwLxvHgoQiwC1J8du/z7LBL9FZEJIN5vO2hKEpq6ZFQwo4K4apUzeHDtJWd7+0diYDJhRcJkw==
X-Received: by 2002:a17:902:8c92:b0:144:b6fb:f82f with SMTP id t18-20020a1709028c9200b00144b6fbf82fmr3666115plo.14.1640189601711;
        Wed, 22 Dec 2021 08:13:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w76sm2942604pff.21.2021.12.22.08.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 08:13:21 -0800 (PST)
Message-ID: <61c34ea1.1c69fb81.ee68a.7c6c@mx.google.com>
Date:   Wed, 22 Dec 2021 08:13:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.259
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 145 runs, 1 regressions (v4.14.259)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 145 runs, 1 regressions (v4.14.259)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.259/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.259
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8ee0807eedf3bc60c8a47a7dd95387102bcfd063 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c3160af981577cc9397174

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.259/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.259/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c3160af981577=
cc9397177
        failing since 8 days (last pass: v4.14.257, first fail: v4.14.258)
        2 lines

    2021-12-22T12:11:36.760085  [   20.088012] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-22T12:11:36.804639  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2021-12-22T12:11:36.814014  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
