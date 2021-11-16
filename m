Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAF9453CB5
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 00:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhKPXgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 18:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhKPXgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 18:36:03 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6963BC061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 15:33:05 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso879760pjb.0
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 15:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6HwJueYfHR34VyYJ8naUYAYFMG5qhLbV9XPoMJAMRXQ=;
        b=khEjv3iQ1S2xaLQHJ6xVd7n8foviG/1n8sjje5M2fisXNB66CVaZl05Qgk5xQ/j1Um
         utPQHFCTCfZZ+UyspO52Ufm65Y/5vf+QM7faGKXjYBNEmAQlLCkcBQ0v/3WcPJ7P8BbA
         DhEL9vAL7tyoIx6G+Mbz7YTlJhqj/4pz7ZvwUYdsleHyTUbCfAVLLb4pBauQ1fd2yeeC
         qKs+AGTO2dqChL42vTaLtjFh5th6j5xMGmdTfKTRBczhVGAaOIXd6/MdkGqaDXxdfWG2
         SRoAWG3dSiL5+EdooIeG+2n5dBO5zCPEEHyxf49k4KXVICegacQwF+7hwR9rKXDGNHh9
         6t4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6HwJueYfHR34VyYJ8naUYAYFMG5qhLbV9XPoMJAMRXQ=;
        b=MEIg+fkoVVBfyGo56iU9w/G8sV83d/AYaMvJuNVeaZ/inGkGRyWPz732RPpjDbQPuL
         Qrp65Vr8MkWDIUaMpvgRSePt+ZEXHma8tUbnvxBxD9mgHSs+XUEOZdlH3uKJw6O775Cm
         cV+K6Jp+gArOqNHGUkMiyw5DaE0dyMJrcnQXCkJw0TSqTy2LyPPG8h58haIKQsT33BY4
         BqrEgQ311Gz6M1FMhFzD/56QrOiZnxmo/XjLsC1+J5kJKOu5GtVYM2BKm4GV7KM886wM
         w3CcoozopjKK3MWDMJ3pWaksptkSV4YK/6SoenARVzugsyrpflXfNURwUUTPvpaTBbtG
         2lRw==
X-Gm-Message-State: AOAM533bIDXzsAbN7a5kMce9mLe9fEIn9Vb2kQzy2qiQBl6vjjFVHFaJ
        70QkD9ku9eNUxV15bBggoZJw0AqTIHpAxdZh
X-Google-Smtp-Source: ABdhPJwKI58asDVI+I0E3XJkVHzSPn/KCug0IVp2B0LJp2IBH1bdqbYloIjFSDq8Bq30NfayeccK5Q==
X-Received: by 2002:a17:903:41c1:b0:141:f28f:729e with SMTP id u1-20020a17090341c100b00141f28f729emr49214759ple.34.1637105584698;
        Tue, 16 Nov 2021 15:33:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f4sm4015608pfj.61.2021.11.16.15.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 15:33:04 -0800 (PST)
Message-ID: <61943fb0.1c69fb81.dca3a.b676@mx.google.com>
Date:   Tue, 16 Nov 2021 15:33:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-251-g84beceb5c615
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 77 runs,
 1 regressions (v4.19.217-251-g84beceb5c615)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 77 runs, 1 regressions (v4.19.217-251-g84b=
eceb5c615)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.217-251-g84beceb5c615/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.217-251-g84beceb5c615
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84beceb5c615d22dc529f4bb46329752b5c14b2a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61940683bba133a2b63358f2

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-251-g84beceb5c615/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-251-g84beceb5c615/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61940683bba133a=
2b63358f5
        new failure (last pass: v4.19.217-253-g58c021f04873)
        2 lines

    2021-11-16T19:28:48.370190  <8>[   21.557006] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-16T19:28:48.413672  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2021-11-16T19:28:48.423510  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
