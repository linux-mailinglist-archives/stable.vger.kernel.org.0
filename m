Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9017F43AAD1
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 05:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhJZDrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 23:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbhJZDrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 23:47:51 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A757DC061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 20:45:28 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id y1-20020a17090a134100b001a27a7e9c8dso716007pjf.3
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 20:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ctixC2TxOKX0JMlvCqtYRLH/X6QIe1dXZ9/qGAvuTKo=;
        b=BrT5n2p9Z+qQBRc1Gc6hsrQ7g9GpURUxN+/Uv194Pso8+CcY8Zc2qRHxVQposLJLm6
         Af2upuJi9zqC4PI3y7n1B67ZQnQfmNTfpMVHqSwf6g9QZRI0Afg3PgxWysDWNlwDqLJB
         6FLnc6U7MGLkq13OZVk34kUR5wDQekW93qhmhXwRP7wbNhY1bOwYXgKW6fddnZlXBxQF
         /4fCytslKThE09vPqvp3n/mpikL1D9OxzpMUN9zrsypugKXsinCBuE4mZOEpcaQkBaYT
         KQVn1OGINZYtNr2cPxQCRENLQb9eJ4L/Tio7ogbeLwHYmpkPiRI9mDYjZi7oHdrtfSWv
         AcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ctixC2TxOKX0JMlvCqtYRLH/X6QIe1dXZ9/qGAvuTKo=;
        b=oZ3C/Jg8bab8xMZeJYEvGTtO1if8NghkEICg/0NRHAtEkN+W8EgHTYtu5lIItKBDB+
         dlM24dtvSezNmoBy3a3Vj3ih8k9I2kXmJ7M7jckHW5YszaQGwdBD1h/HTt5/UyX1SadV
         A4/Co6/cgraLVbJzrNxyPopEp9FvSN8Svv4RrHdBQIogWMQifqYOKsIKPuQvFHhV/flb
         Fm3g43YkzabedxNP/4zmwIsNA3Kgi/7aYwYjUQIGTpbWi7GtSYavn52/KFb/0GDKYHPo
         1N577fE48IBcG6trp5of80w//RTN3gpRwLtaJ/Aw/3M5EK1LJbDPuMLKUJtDoWjH+FT3
         HwpQ==
X-Gm-Message-State: AOAM533u90jcyyPUDkJfZAbt7eZfcUopnONxDngk9V0y/FRPMHua2iRM
        dq0JaFL36dBKdZBAEldyZ7MfIKs7Rrd3htoT
X-Google-Smtp-Source: ABdhPJwB9foyLFoXQVB/I9F5io94LInMmvAA8ntcoc2U25ZUKQ5DJujO8vyCfFO0hnv8QZiWqDYqbQ==
X-Received: by 2002:a17:90a:b396:: with SMTP id e22mr22775698pjr.169.1635219927821;
        Mon, 25 Oct 2021 20:45:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l11sm22567698pjg.22.2021.10.25.20.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 20:45:27 -0700 (PDT)
Message-ID: <617779d7.1c69fb81.f54ff.da77@mx.google.com>
Date:   Mon, 25 Oct 2021 20:45:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.252-30-g4bee378fa973
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 97 runs,
 1 regressions (v4.14.252-30-g4bee378fa973)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 97 runs, 1 regressions (v4.14.252-30-g4bee37=
8fa973)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.252-30-g4bee378fa973/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.252-30-g4bee378fa973
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4bee378fa973518e7a271ef9c323067ff3de2707 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617742186255179f21335906

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-30-g4bee378fa973/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-30-g4bee378fa973/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617742186255179=
f21335909
        new failure (last pass: v4.14.252-29-gda4196858f20)
        2 lines

    2021-10-25T23:47:15.803695  [   20.326202] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-25T23:47:15.847575  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-10-25T23:47:15.856948  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
