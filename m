Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75ABE483AED
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 04:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiADDUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 22:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiADDU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 22:20:29 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B2AC061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 19:20:29 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id b22so30959773pfb.5
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 19:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aywLZVQQYuiHNcHLyzgwr68gxZZQIJUKt7jnpYLQldA=;
        b=kWRQw/u/3ByrrHgP6dhGeee14Zvu3N0ebWYr3npDp6ApH6k6fVVZ68vX0mdbDe85pG
         g2OsT7qtv0ptaCejt6S6BCGXuxiJ9VGn+f6QHqdPX6vaxkVyJY3R4y8chkA/o+P9WWD0
         flIcdVVJ/NSym349ryDP+7S/brmthGMPO4KQsGuI0AFWkWvOyDE4IbeqU7xVgCQBdqwT
         qf5Z8kXsBFcJTylYBARMRI+v4ZIj1QuyU9MuOWFRYoNM5Hw/aEi8pJ/IwSjCEV2Zabbf
         ZuK5BCcVI4vWfRJY7n50LtgonCoMrANTk7kgAYCyML2QRHiW/WVAGTVlkN6265zFRzdL
         qo8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aywLZVQQYuiHNcHLyzgwr68gxZZQIJUKt7jnpYLQldA=;
        b=EPPQV4knbum03bG7PeoDKhb9dlVKdOEKcH+gb+APiK9ktmbewdcyVeKibPwJgieIcj
         RnmCpuW228QXVvAc2OnMuHNtNtQljcjoCVfAJBFxvzP4P/nmm16yyH1tMUyZ6A1sagej
         +lMBycrOCDUsZy2SBCFf6T228NGD4fpEyILwXPBKE8Dq9iz0ypQ3h+iYlAMt9rS+xnzm
         F5m2zg/3eoHI8gsQc70Vpb1wMNmNh6tv8dfoUKhTkUySX2vvtkyvy0zFj3P+OK6u4/ez
         kggF6wngWiTgyLISbbEtzUte/mZh0eEuIXwejgt7+n+xikchOWrMLKNmxU7PyWyaBRp4
         KCdw==
X-Gm-Message-State: AOAM531WQHGBaF0zsf30K7pmPH+yP6EbxfWM8EzcJubCb6wnyb9UQCbD
        ERpwCZUm9Pda9hzb2X0bHVgJ2PMDsxpjwuev
X-Google-Smtp-Source: ABdhPJxEZly95pEXQQTJP3VAR5AJ/nKzOWSSNbRbCefzL47k4Xb5rUo506l3IAPNtSfoMAeQJNnMtw==
X-Received: by 2002:a63:338c:: with SMTP id z134mr27490365pgz.459.1641266429217;
        Mon, 03 Jan 2022 19:20:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13sm36469217pjz.7.2022.01.03.19.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 19:20:28 -0800 (PST)
Message-ID: <61d3bcfc.1c69fb81.c203a.524f@mx.google.com>
Date:   Mon, 03 Jan 2022 19:20:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.260-20-g1e980b44673d
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 123 runs,
 1 regressions (v4.14.260-20-g1e980b44673d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 123 runs, 1 regressions (v4.14.260-20-g1e9=
80b44673d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.260-20-g1e980b44673d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.260-20-g1e980b44673d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e980b44673d11c0bb0bed2afb54341e7541c083 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d38a83124c27486cef6745

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
60-20-g1e980b44673d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
60-20-g1e980b44673d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d38a83124c274=
86cef6748
        failing since 12 days (last pass: v4.14.258-46-g5b3e273408e5, first=
 fail: v4.14.259)
        2 lines

    2022-01-03T23:44:50.157752  [   19.781005] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T23:44:50.201931  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-01-03T23:44:50.210304  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-03T23:44:50.224199  [   19.849548] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
