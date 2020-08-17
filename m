Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1F4247485
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391808AbgHQTK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404144AbgHQTKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 15:10:50 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C8AC061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:10:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y6so8019211plt.3
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5ubU+7s/eePvBW5al4RhTO307+BI/rR3QJAWdOI+FPA=;
        b=kFSeVTXg65/ioypmc84hAX+xhbezW9qwyzf9+FpWxxP48Ev7ZBTq1XEVbY3DvfI96V
         JGGIrciTzD7iIfCfQgiCB27nlHR42z/k8HWbwhPUJHFNzNY/ObziV7Sio1DkaLTWfdjw
         E267xFFCUL9w4aNnw2Y04cJ5poZFArhFSId5xrosuYpCqRxwAGLhkNRErvsISnZwbgtJ
         H+zerz/1DBeX5nW2QtafqTEiPw+ZkeWSpO+rb4ryy4WmSUBl2swQPrXweYR/WfyLNpA5
         FTbMNaOSHKE3MbElLvwcKPafT4aM2kENMQXH0FDKiEh6YbRINIojM2oeBLpZpt1tcAq+
         ec2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5ubU+7s/eePvBW5al4RhTO307+BI/rR3QJAWdOI+FPA=;
        b=F8gpov4JBhRv0GiLHp4Ob18XB3hMEwCRdjI/4ULGvN54iffhwpFJ6XGztr4l9IPcmw
         UgWqc64PwbZAclEidyCNDXYYArxZe2bQmwlW5QgjIfnrbT3gxBbrGallumHhkvzTE+hD
         4/tsrmVcoMVSdsttKgpCq70XJyO7GIAIXmRqT/o+DoTaRafW177cKgKPRcl7YconlFSu
         M2WA6BShORxG6SAd+b1iHdqWSQloPrXOUVniTh8+Pajo7QeEQvBl6ZaAzojDWO+RXYyV
         CqCyfGrpF91N1MuWbnlMHojjTWYX341IFk/72+SHeMHwnD1TxKASDtUQkTTnme+xdk1O
         keww==
X-Gm-Message-State: AOAM530Za5ApXyvaaHojaU2plHemdUsfLqW84qY5pLc/4XiQd7QKtrov
        qh50ckkm56ncy+aNdEOkLiqnl/RXCFt1Pw==
X-Google-Smtp-Source: ABdhPJxGFIFPMOqcVau9hajvnGhXqPXO91MRoXyfDyGrfo1+CYTuZdFRpGlRaSNfWt/2PoHU2GdZHQ==
X-Received: by 2002:a17:90a:f68b:: with SMTP id cl11mr13529527pjb.68.1597691448661;
        Mon, 17 Aug 2020 12:10:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fv21sm18309938pjb.16.2020.08.17.12.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 12:10:48 -0700 (PDT)
Message-ID: <5f3ad638.1c69fb81.16e18.950d@mx.google.com>
Date:   Mon, 17 Aug 2020 12:10:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.7.15-381-g4832c39ae70e
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 196 runs,
 2 regressions (v5.7.15-381-g4832c39ae70e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 196 runs, 2 regressions (v5.7.15-381-g4832c=
39ae70e)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.15-381-g4832c39ae70e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.15-381-g4832c39ae70e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4832c39ae70e8e9e40328619d7a8f026cc257667 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3a9eb9545e3f811cd99a3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15-=
381-g4832c39ae70e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15-=
381-g4832c39ae70e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3a9eb9545e3f811cd99=
a3c
      failing since 32 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f3a98dfb58064d939d99a90

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15-=
381-g4832c39ae70e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15-=
381-g4832c39ae70e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3a98dfb58064d9=
39d99a93
      new failure (last pass: v5.7.15)
      3 lines

    2020-08-17 14:48:46.762000  / # =

    2020-08-17 14:48:46.765000  =

    2020-08-17 14:48:46.868000  / # #
    2020-08-17 14:48:46.877000  #
    2020-08-17 14:48:48.139000  / # export SHELL=3D/bin/sh
    2020-08-17 14:48:48.155000  export SHELL=3D/bin/sh
    2020-08-17 14:48:49.781000  / # . /lava-285812/environment
    2020-08-17 14:48:49.791000  . /lava-285812/environment
    2020-08-17 14:48:52.745000  / # /lava-285812/bin/lava-test-runner /lava=
-285812/0
    2020-08-17 14:48:52.757000  [   60.131532] hwmon hwmon1: Undervoltage d=
etected!
    ... (11 line(s) more)
      =20
