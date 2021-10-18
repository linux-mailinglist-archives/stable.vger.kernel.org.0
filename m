Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF134316F7
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhJRLNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhJRLNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 07:13:13 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD648C06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 04:11:02 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id y4so11012856plb.0
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 04:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R0JbmmPxKD++KeMkfWPEaQQF0x54jxcwOEu5qUI0f4w=;
        b=A8DHDQ7aSqWzt/WR+LLKjhb/WNkOKG8Z5YjVpBZn6p1dYAqLnP9lNaYeytSHr6bd2s
         LWlHBfhtoQA930XF3ohJjyCKP2H10rDNTqA6xKduCgTJLNSS4aixSCXprxi3oYLHeLoD
         jsgGYn8EeZJDXapl/NvyrGYIZ6qLc6HRNOTABCSox8oO7wSprhygPmPKqCb81DyVV/so
         J23G03QeL2JfQVSSn37WEvxlbZ38L82LDqRB/lQjuzDI3UfsetDEf1Zh3bogb8LF2hgP
         mji2MYATN+CXuZ1St2xqYhiiK8b9+gZap7dgojs1lKmqvrs+y2vZa5QT07KF+C/pItRO
         gP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R0JbmmPxKD++KeMkfWPEaQQF0x54jxcwOEu5qUI0f4w=;
        b=zUXj76H8d8bXqvRppq51ndgyaOv8WtHueeasGN3gs+uSWSbPNoneXqLPPjEOfNV4za
         QA2Zqd1+PiL9YLPgFOzt7MBEaQ1iXs00B0/58lfaDHPS/4aSc6vmrrbML4SFaFBlIJDV
         UGO27ybPfUSrrU8POMsWr2T45+BJbtJFvsqeOJyyIsf/BzvXMth0FpaTG+YKc2wkNhf4
         NRS/hxAp2FYa/cWdteLs84nidTBZuBET4Y8MMyqjP3KqHWlx1zdDTnTMqDV0eCoGSI4J
         88iJg2yF42PbaJx+k1t8YBQtNHHoLRPmp9NAPC5RQUll9IjdstauC8nmsqsbyJn55qDi
         K/UQ==
X-Gm-Message-State: AOAM531STJVQVfgGby3JZ6aszMo1Rt/bu7860F8azSA0JHfsaRDHU5if
        aHkRo78RjCls8cVImz27rBN+2d/Kw0u4mA==
X-Google-Smtp-Source: ABdhPJyHNzrexUne8Hao7sT+3u7a0hPvEKq41APGP3cp399RDepa9yJmFdw+94IpDxs/Wmg1YRxyew==
X-Received: by 2002:a17:90b:1c02:: with SMTP id oc2mr32557938pjb.128.1634555461924;
        Mon, 18 Oct 2021 04:11:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w19sm19906236pjy.9.2021.10.18.04.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 04:11:01 -0700 (PDT)
Message-ID: <616d5645.1c69fb81.9c159.93b7@mx.google.com>
Date:   Mon, 18 Oct 2021 04:11:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.211-23-g6a69a7fc4b12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 83 runs,
 3 regressions (v4.19.211-23-g6a69a7fc4b12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 83 runs, 3 regressions (v4.19.211-23-g6a69a7=
fc4b12)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.211-23-g6a69a7fc4b12/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.211-23-g6a69a7fc4b12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6a69a7fc4b120ed4a4660cb2450ced8fac856aa9 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616d17605de24f263c3358e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-23-g6a69a7fc4b12/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-23-g6a69a7fc4b12/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d17605de24f263c335=
8e7
        failing since 338 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616d176478ad717d373358dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-23-g6a69a7fc4b12/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-23-g6a69a7fc4b12/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d176478ad717d37335=
8de
        failing since 338 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616d175d7c7c6eacf333590e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-23-g6a69a7fc4b12/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-23-g6a69a7fc4b12/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d175d7c7c6eacf3335=
90f
        failing since 338 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
