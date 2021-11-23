Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEDF45AC07
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 20:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbhKWTMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 14:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235934AbhKWTMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 14:12:16 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46216C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 11:09:08 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so22766pjb.5
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 11:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qiQueEGzF/82lsXdzh+PUs3ml6xI6UQtaMF83oAF78A=;
        b=F7rn1YwA0unT0MGfjLOWMaEzUH9al/YHB/a1uve9p/HBkSf2fAS1FaLQLBNLlXZmM5
         /pJXe8dWuPAIm2o12df+sGWlea2Hg+CR66yi9D04L3Qaxs8RCJ2zJeQyFheuksDgXVg4
         taw2pC7k52qThBhKFd/VWLXkO8r9EyPTLbj099C7tFHMxLwts0fy9Oi5+yZNhwh55Pko
         ERnmYNiOMM059m0G6wGv9zNW3vpJP3G96tdXOt3tbKKCANkEDmHDd3Kgv/vsQnt/3V1C
         tQQtTTxRIy2lULzjEWrnfxRo81xQGy7nrW99/TTRKLNItzNPYMsSY087E2vSjJ6Pr8Gt
         MGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qiQueEGzF/82lsXdzh+PUs3ml6xI6UQtaMF83oAF78A=;
        b=mwRLLjAAwlWBbzTKNfMUYrpdU3nlFo5SDSc9I+O9sHzbVb5pGJX5/nhRiJUreTkbTa
         ouzO6B3n+2yw6nGOuNRgJVYSM2OV9tAUBPfpZmwtpix0iJeANkFO5/9RJ7qBFnTt+sMc
         IkfZ8GJ56AmvRpA/it1hTyBrTNZ2OToSwf9Aojf/Om9uXoxRhDTNqEQxklKyZk0ps04K
         B+Ss0foWE94T1t4BHHEAFWiOIDi1960nbHwBpQC++bVyYYq1Xqq/JKtiA3P8FXsaz06y
         IxnOxNrFcnhkBIrX3RiBoFoPpspEaX2SyjYBLHJHQUOU9xfv3z6wZYq0YOLlREWQ3RZ+
         dKPA==
X-Gm-Message-State: AOAM531/D/jRI7jc63cxh6M7XqLUgTDQJsNWDTwA+iG+hGJHvAtbZI3F
        kSsKddoZ0ni59Q8njkYsrNZSfEQtIMTKBgAM
X-Google-Smtp-Source: ABdhPJxdi+1H/M+CPqlUssdUKmG++A1N2KhB8Ua84r9GLw6G/D0mzOZpsWgjigkhaEvSdGLEJ3jD6A==
X-Received: by 2002:a17:90a:df14:: with SMTP id gp20mr5952402pjb.186.1637694547490;
        Tue, 23 Nov 2021 11:09:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2sm14908173pfg.124.2021.11.23.11.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 11:09:07 -0800 (PST)
Message-ID: <619d3c53.1c69fb81.551d8.840a@mx.google.com>
Date:   Tue, 23 Nov 2021 11:09:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217-320-g4c6d4ba9b9ce
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 114 runs,
 1 regressions (v4.19.217-320-g4c6d4ba9b9ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 114 runs, 1 regressions (v4.19.217-320-g4c=
6d4ba9b9ce)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.217-320-g4c6d4ba9b9ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.217-320-g4c6d4ba9b9ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4c6d4ba9b9ce87710d0e5d1f2e350835c05eb086 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619d05a98152e60819f2f003

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-320-g4c6d4ba9b9ce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-320-g4c6d4ba9b9ce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d05a98152e60=
819f2f006
        failing since 10 days (last pass: v4.19.216-17-gf1ca790424bd, first=
 fail: v4.19.217)
        2 lines

    2021-11-23T15:15:38.927730  <8>[   21.405853] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-23T15:15:38.976946  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-11-23T15:15:38.983951  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
