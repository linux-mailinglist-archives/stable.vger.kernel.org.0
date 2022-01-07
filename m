Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BAE487DAF
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 21:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbiAGUYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 15:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiAGUYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 15:24:35 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE17C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 12:24:34 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id z30so2867411pge.4
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 12:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IrhyoPkDL2YMGMd08CYCixRX1lPrTkpP8Tc8Jcgpnqk=;
        b=QcBYJcep7DxemOt0/djYXioPAaViYkpCKV3nYr8MIq2ub6YQuYQwlzlld1J0GU5dbi
         864HCAYGY0Nm51+vQNH9kTFcQ6qgI2jgnRaU12YQavZbPy04cp0CIsfULsLGBa0RHqlB
         D6LPnN/pXo1RsIDa67SNf2oay4FBQ31JiVAB60kEADTVmQPT7Li7d/1LUIxCXHAN1uFF
         1xv6Gbyj8flax2Okso87wOW1DFmPigM9UDhalLZ+ItwZwbQvqUKVJnZmxGqyPxOWgNiA
         kbKBJ3gIvgK3B0qSGeYUzHS07ocrOR2LrVGCwjAJSdXWvKFPmwSijiRre0YzGKa2qIJS
         Ib9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IrhyoPkDL2YMGMd08CYCixRX1lPrTkpP8Tc8Jcgpnqk=;
        b=7YV3mHVEYlw3o7LPmP5yMPRu49rY8LgynjU/eS7Q2hu5F5dgbTi29ZUfUFzpL0Rsfy
         B+k/b6jItQGVcaeg2yM0MhAztVsDEtUyOOThKfwmK8X5alVOXoUjQKrEae6ng9Nqm60v
         ytONqFohpCaBCsBAiZTc3wu15LRofeWgMQfc/K2nHu9jg8smLjBQCQ8Ofty2dUJvv58B
         3u0pEbQvV2f66Z81auW2fh8njvkq/+uCKEBpKz2mX5C75xfIgasPCHQwRgnU4uJdRFgC
         RlmFIEf+VEgcCH6VfSrqX3FpQOTep9TLTsmKrrkJKQF0c0Z3QJ7HF2jH3uUnJ2U9/LBi
         wMiQ==
X-Gm-Message-State: AOAM532RJs1SYiN2sYEgS96oKnGFtCBPTymAfER8FQ8PdZ44oNrZCqKF
        A0HrIFEfQlU61pcFNX97lKp7zpvvVwYTUBoD
X-Google-Smtp-Source: ABdhPJxMM6JQitb+KY+wBVJHgk4V0vm9OYz45m8OZWXyezhdjAq0II57HyBpWoqSW9sD70yC03xwYg==
X-Received: by 2002:aa7:9904:0:b0:4ba:5abb:aaf9 with SMTP id z4-20020aa79904000000b004ba5abbaaf9mr65170969pff.16.1641587074365;
        Fri, 07 Jan 2022 12:24:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oo15sm10335753pjb.57.2022.01.07.12.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 12:24:34 -0800 (PST)
Message-ID: <61d8a182.1c69fb81.a9af0.86da@mx.google.com>
Date:   Fri, 07 Jan 2022 12:24:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.224-10-g40a6120825a7
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 150 runs,
 2 regressions (v4.19.224-10-g40a6120825a7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 150 runs, 2 regressions (v4.19.224-10-g40a61=
20825a7)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.224-10-g40a6120825a7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.224-10-g40a6120825a7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      40a6120825a7c84207cc5a035b8589af61982c60 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61d86d71bbd2ec74a2ef6749

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-10-g40a6120825a7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-10-g40a6120825a7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d86d71bbd2ec74a2ef6=
74a
        new failure (last pass: v4.19.224) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d86f42a8d4442e8def675e

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-10-g40a6120825a7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-10-g40a6120825a7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d86f42a8d4442=
e8def6761
        failing since 3 days (last pass: v4.19.223-16-ge86e6ad8a5c1, first =
fail: v4.19.223-27-g939eabea13d4)
        2 lines

    2022-01-07T16:49:59.168880  <8>[   21.042358] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-07T16:49:59.214488  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2022-01-07T16:49:59.223838  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
