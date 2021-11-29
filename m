Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57B84612BC
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 11:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353457AbhK2KqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 05:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350867AbhK2KoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 05:44:01 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E6CC08EAD1
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 02:07:02 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id o14so11759508plg.5
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 02:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ihsFdEEA7sVGXyYQdPPcSCbkZ1Q2dNlGVEp6N0EZFjY=;
        b=eD5PswDpA04bfggqZHWyMZErK9eqLVcA8n9Olq5lT0DHEHtW4r2wLAG6J4y0BmsjkA
         YnL+tDfqGmUnlcfjjFVyzVc7lQLELQE6nAJ2V0a+fAsI2qQ2nk7ToY7Ggmfm/FeyoVmM
         N6FzH3t7e71QY0Oji2iolUcb1OaYR3Yak4ZsB2zobV6nkYsKGHeUbzG8GTnDxRaGNNZl
         VxAYLY+wnh1gnltUOp67RucMNHWDztBSHhPMDGSGI+P2gsZk8uXBUvEOL8bZKvnVZdte
         9vP685AggWGQUY4G+ltvrL4nF6M9/0qgvOw2UokcaibUVzcFxLJ8TEuivPllXpqPErGY
         9+dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ihsFdEEA7sVGXyYQdPPcSCbkZ1Q2dNlGVEp6N0EZFjY=;
        b=BGm4RvSPtIfu0GCXdHymDKZENNE6ORFLG28X003ciaiBU0EUe1YY5zvMw03ushgbVO
         b+HONbK4o2LeHHkPsD0U7h1WDEUFm4zdr49zTOrbKifj/UpGF+OFfR7yl8SFhUasIPJQ
         iVSBzunvoVaW58rt/F3nqRrIlWzfXpBj2i3QkUC7OGVI2Vh/fepF5RtkJ6S6vaBLhDbo
         yWIQfvpIy61XSFdKchgLFo8ZK+pZ+SrY6tRxU4LbCoSlDr6vRGqlEIv/EEDUHTk+uc3l
         PDIO4jYs+Z7ytUNvbFeQ1s1eFC+6evEGicPLUUtR7fBBeeEcwDp/htmIv2dtS25si6YV
         sVbQ==
X-Gm-Message-State: AOAM530fjpJ69GyZeDpK1GFdt+9zB0vMqw44tH/UMK9zhG4jXDo2Lu8L
        jcVeGKA+3hgNJfbV8Ya4LHVdKHh+0hJu+H4D
X-Google-Smtp-Source: ABdhPJwXw1K2a0kffrORlsj3Tf2cHyQjNiWwjXqTXE+5JdZi5A7en0OWWRm4m0eW6BPDy3LH5cVRUQ==
X-Received: by 2002:a17:903:2093:b0:142:7dff:f7de with SMTP id d19-20020a170903209300b001427dfff7demr59506542plc.75.1638180421942;
        Mon, 29 Nov 2021 02:07:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pf15sm19534692pjb.40.2021.11.29.02.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 02:07:01 -0800 (PST)
Message-ID: <61a4a645.1c69fb81.e9763.09f5@mx.google.com>
Date:   Mon, 29 Nov 2021 02:07:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218-54-g4559f99e7676f
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 4 regressions (v4.19.218-54-g4559f99e7676f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 4 regressions (v4.19.218-54-g4559f=
99e7676f)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
      | regressions
----------------------+-------+---------------+----------+-----------------=
------+------------
da850-lcdk            | arm   | lab-baylibre  | gcc-10   | davinci_all_defc=
onfig | 2          =

meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-10   | defconfig       =
      | 1          =

panda                 | arm   | lab-collabora | gcc-10   | omap2plus_defcon=
fig   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.218-54-g4559f99e7676f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.218-54-g4559f99e7676f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4559f99e7676f0253480ff10c19c25ab6cb38b17 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
      | regressions
----------------------+-------+---------------+----------+-----------------=
------+------------
da850-lcdk            | arm   | lab-baylibre  | gcc-10   | davinci_all_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/61a46d1ebf9310445718f6fa

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-54-g4559f99e7676f/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-d=
a850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-54-g4559f99e7676f/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-d=
a850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61a46d1ebf93104=
45718f701
        new failure (last pass: v4.19.218-54-g88fd43d770ff1)
        3 lines

    2021-11-29T06:02:58.375778  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2021-11-29T06:02:58.376014  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2021-11-29T06:02:58.376186  kern  :alert : page dumped because: nonzero=
 mapcount
    2021-11-29T06:02:58.434623  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a46d1ebf93104=
45718f702
        new failure (last pass: v4.19.218-54-g88fd43d770ff1)
        2 lines

    2021-11-29T06:02:58.569827  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2021-11-29T06:02:58.570120  kern  :emerg : flags: 0x0()
    2021-11-29T06:02:58.652240  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-11-29T06:02:58.652483  + set +x
    2021-11-29T06:02:58.652664  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1162674_1.5.=
2.4.1>   =

 =



platform              | arch  | lab           | compiler | defconfig       =
      | regressions
----------------------+-------+---------------+----------+-----------------=
------+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-10   | defconfig       =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/61a471379b9656b75d18f6cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-54-g4559f99e7676f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-54-g4559f99e7676f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a471379b9656b75d18f=
6d0
        new failure (last pass: v4.19.218-54-g88fd43d770ff1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
      | regressions
----------------------+-------+---------------+----------+-----------------=
------+------------
panda                 | arm   | lab-collabora | gcc-10   | omap2plus_defcon=
fig   | 1          =


  Details:     https://kernelci.org/test/plan/id/61a46e6f1785f0863218f6cb

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-54-g4559f99e7676f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-54-g4559f99e7676f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a46e6f1785f08=
63218f6d1
        failing since 3 days (last pass: v4.19.217-320-gdc7db2be81d5, first=
 fail: v4.19.217-320-ge8717633e0ba)
        2 lines

    2021-11-29T06:08:39.951100  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2021-11-29T06:08:39.960127  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
