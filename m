Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF05844EDAD
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 21:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhKLUIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 15:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbhKLUIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 15:08:46 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21E0C061766
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 12:05:55 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y8so3828363plg.1
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 12:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W/A7EtFc1n7MMChZyN6oUA7pKAKQlXUfu3O5sSpALWc=;
        b=AROTaKBIX1VMp0Yg3wfPt8miGzfG5flMqXWOqZEPR2EOJ7zj5BotI9qRggzrxWa6yb
         6QEykv8ngqGddjkDZHhQyQ0gNaSCk8eI18RQ+mHp7PIm1Xz5bRoAA5oMq02tB+BLsW1O
         IjVIMdBth3pOMFNO7Ro9BnEX/ZX5oQpop7IOQpin/qe8TV94Fk2kFyRtiWJfj6KePLXd
         t4q6E6atc7KgwUQVrdP/TVRRAMcqMnWqULbEOREdYoBWPG8W26e4+HcFnhMdaoZddRT/
         D14Dowm4woZ65KAcFhk4J8XXFRHAzw3aZNn60lWFaswI424qSoQWgpB/jGwRXKV54eZ8
         9A8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W/A7EtFc1n7MMChZyN6oUA7pKAKQlXUfu3O5sSpALWc=;
        b=xcnklrf9PBv0b/wIj5RM3R+Frzp8Lx2p60fWN+ET8q0BuVJoO6JcfHzUtMTKtBxpSz
         Pt/h4f2uYjuU76RikXdS1K++yo2b7VA+gQPdMGq4NwBwApUMdg/J7YCDAPfdPJYDbhzA
         r22kAn1eHcViFrRjwYPRR0s13wLOuFW7AFDhA+TwjRmHfc26srXWyEuvZa9jxqiGkI86
         ojMiZ7ZrBaCPg+aNO/FR8JlkMhrpDHS8dhEvmuG5lZ6O5CQHtPD/Zz5MJF4ctfFXLb15
         kFsylI/y8xIasq3bU++tleY+1oXlP+8GD1eaKgxCxFccT8h5D8HwdED/+SOsb9rtYDvz
         N0Cg==
X-Gm-Message-State: AOAM531L+wfrYS16RE0+mVipLd/11jIAj8Q7BBMP8ff7Y0pfu7T7hPH9
        b2r3M+iqagTpyYJwHjUW+qisy53+5cZ3g0Po
X-Google-Smtp-Source: ABdhPJztq/QUbc72eszzgjwXrpMQwyAQi3PzgYp6stBajT2EnKUhLbvfyra8rHmn1H1lZbEPPHuYig==
X-Received: by 2002:a17:90b:1d90:: with SMTP id pf16mr18998472pjb.93.1636747555093;
        Fri, 12 Nov 2021 12:05:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r6sm5743752pjg.21.2021.11.12.12.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 12:05:54 -0800 (PST)
Message-ID: <618ec922.1c69fb81.2225e.0b74@mx.google.com>
Date:   Fri, 12 Nov 2021 12:05:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.17-24-g78363ad03afd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 180 runs,
 1 regressions (v5.14.17-24-g78363ad03afd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 180 runs, 1 regressions (v5.14.17-24-g78363a=
d03afd)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.17-24-g78363ad03afd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.17-24-g78363ad03afd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      78363ad03afd8cb116a9386d536433a0e376c0f2 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618e90927511ca4786335905

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
24-g78363ad03afd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
24-g78363ad03afd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618e90927511ca4786335=
906
        failing since 19 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
