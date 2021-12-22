Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655A947D5DC
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 18:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344358AbhLVRcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 12:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhLVRcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 12:32:08 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1354CC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 09:32:08 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id jw3so2855661pjb.4
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 09:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZQxH2t270dAHd7y1atdmXioqt0lT9OTDMfp4XIB/ml8=;
        b=x12z/PwKL0OBbWHclluQfMwBs9hrhzv8/gRB6a9iUnuFjmSeApwsNuDk7NnF9pnuJF
         6idth0+vpn5ozvIVxNjJJFgrvJJJEW8YRkxSBhe57+L1vQBTBr+C31X0YG4Ht3V4kJ4P
         r0lNKsyFzBx0fUcbxoNFIMAvfAtnABC0RN3CYBTvC4lxW8AtAlUpCyeSknp/rv4vRnPb
         XBMIxx911mkYoADYgHKWzCqjwNt4Nk6l2j3zefMgsouOFiOTyIz7j/Y/y2t9xmiA2Eh3
         1/0YEEZJGBJ/WIRCfxI4guo//qvilXpts/4qmLyHUcXIntnoGZukwgjuZAKl97rCsGxm
         CvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZQxH2t270dAHd7y1atdmXioqt0lT9OTDMfp4XIB/ml8=;
        b=ujl7DWjP1KeNGq3p4JctWO1wFMy1px6jOIwzJc0PGBCC9kvtDNA0rswydxUW8CBbxt
         kUU6s9GL9zhZeQ9m5s0rixKM+8poIKWFpvtZAUumYsI3tKpRup1tWqcHxsVutciJAaLr
         fq3yZuqwLGqgIkVt/0Kvv+7IJssaRknvCsR8tZQqvaSa/heZtO8x6Q7Y0Hl7H9ID2a8Q
         wzEWE+MjwwTxqvbgCn1tFdN/qGPQMTpRQiPxJq0Nml0N5JQqausDUb1iP1EJ08bZ1yOb
         20HOV3sPq5SJntrDFwfGF49q1Sr1qzkvY7JLnWlRy2pYBsV5lnPAJx1ffJDqcLGngcE1
         zuSg==
X-Gm-Message-State: AOAM531Zz/vBTq5dVtqko4wguUGN9YonatVva6eKGYXQcQK+8MCJRO/O
        5b899VMxeu546n1oYzzxP+vzJz1/r5cwXbq6kLI=
X-Google-Smtp-Source: ABdhPJx6rlK/fYI6mp/rBhGzdM7Rvhm293H60oNs7dRfXi6LVZwNW9vE9qAozFP7Bze7uBZ04w30Vw==
X-Received: by 2002:a17:90a:16c8:: with SMTP id y8mr2401641pje.207.1640194327531;
        Wed, 22 Dec 2021 09:32:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s207sm2721284pgs.74.2021.12.22.09.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 09:32:07 -0800 (PST)
Message-ID: <61c36117.1c69fb81.a8221.74d2@mx.google.com>
Date:   Wed, 22 Dec 2021 09:32:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.294
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y baseline: 121 runs, 1 regressions (v4.9.294)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 121 runs, 1 regressions (v4.9.294)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.294/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.294
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f84cbc484575d3e2977e06a4b9d69ab644426786 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c3269b9cd1368d3839717a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.294/x8=
6_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E382=
6.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.294/x8=
6_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E382=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c3269b9cd1368d38397=
17b
        failing since 8 days (last pass: v4.9.292, first fail: v4.9.293) =

 =20
