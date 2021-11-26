Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A02C45F736
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 00:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhKZXe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 18:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbhKZXc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 18:32:26 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F186C06173E
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 15:29:12 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u11so7587358plf.3
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 15:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a7AFDjpoIbRdcJlHlJ0dJK3LYPuq+ISPJILdNWTr0Dk=;
        b=xNsbN+e0utljweLL0qihhEiRSU6fnCIdISEkJy77K1ODMx2aQmoGkOVIbRqWzlvxCs
         ldagHf8p7DHCaQSXJ206uBoGDRzBHHJvcUfV5yKTahLbnDjs/5lSUXNtRwG5f8p69mWj
         fl71tsGnQvDrq8EqZRpfB9sNtqScjDnHLQSKGaZ/MaQkqfka8+byVS/0KOK9ordjqL/4
         ElEWm+YJVnClhD3q3mCvOFMI8s9yf3r8ZKk/Q6nh7zb4NzxsepydcV2IOwCcLPUhUI+o
         IZMMLmixeeswGaP4KXQ4rsPbI0PwkjNycfb0LswjMjrvGZER+00mt8b1VA0ZC9UgOl6A
         S21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a7AFDjpoIbRdcJlHlJ0dJK3LYPuq+ISPJILdNWTr0Dk=;
        b=DdNxkCpMk5ptfPhNs07NASkHFlIRIfW5fbChP6HS6wHtDJ/VkoAV34Xs5oVkKHniZK
         /wYBN6CW/VZNZ4XTLMnqCGogbzzhjor4oif908G+hYeA1rI8IQiMrk2q1RrQ8NK2r8yg
         JZFY0Qp6Wu+sF6kgHu06nmoS1UJulsln5GI0ft6dQCHZb2Z2MUB1tjyD610QfNO7Xgjs
         T5eA46P3ARSfGqYzYuZLp9c3CW4LaGyjz6jIVPXtHB5Kv5cOmrWJz+J7lDC6kw65nXyE
         HubEqVwPoR+6dpw1E+xMnBZtlDQ39WUkIpXPJw6ikMutIwfoKd6XJaFguFa3x/DWaYQK
         O+0Q==
X-Gm-Message-State: AOAM532BqLbfUcBDss2GYm8w0XR+CVloSgnfcIhLcfjVdKT/+ShFIMgI
        veJZrNPb3dIhyDQoJ//QQrYDE8tx/Q5rAXSS
X-Google-Smtp-Source: ABdhPJzoZn06UXQuztF8+as5395VALWzBfk9SJaT7QmcKjGiaVm7ivzkXNQMJdPcmE0sEUDXJMyPvg==
X-Received: by 2002:a17:90b:4f4c:: with SMTP id pj12mr19359456pjb.218.1637969351989;
        Fri, 26 Nov 2021 15:29:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c21sm8486818pfl.138.2021.11.26.15.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 15:29:11 -0800 (PST)
Message-ID: <61a16dc7.1c69fb81.b6c6b.7c8e@mx.google.com>
Date:   Fri, 26 Nov 2021 15:29:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.292-159-g9b8f282b0560
Subject: stable-rc/queue/4.4 baseline: 61 runs,
 1 regressions (v4.4.292-159-g9b8f282b0560)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 61 runs, 1 regressions (v4.4.292-159-g9b8f282=
b0560)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-159-g9b8f282b0560/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-159-g9b8f282b0560
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9b8f282b0560aa917b0783f7bff473d7ee8de3cf =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a134814f7c3076e718f6d7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-g9b8f282b0560/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-g9b8f282b0560/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a134814f7c307=
6e718f6dd
        failing since 1 day (last pass: v4.4.292-160-geb7fba21283a, first f=
ail: v4.4.292-160-g4d766382518e6)
        2 lines

    2021-11-26T19:24:28.326893  [   18.861236] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-26T19:24:28.377012  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-11-26T19:24:28.386433  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
