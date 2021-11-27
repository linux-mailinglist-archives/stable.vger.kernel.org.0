Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFDB45F7C2
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 02:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243854AbhK0BGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 20:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhK0BEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 20:04:00 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6EDC0613E0
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 17:00:20 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id f65so9617437pgc.0
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 17:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TtMCgFMUVDqRrPYYA71aGSxJ49RAwZ5OUSEsAs2NCqY=;
        b=Vume+kTRrzfFiVYfNRVq30rk02l7srh6CS819sqNv4eybOQau3t1MrAHChqPpcokLE
         Vi/nyDFnsWAkKqfVuzwNr/IVnwBtBB5WDf9D++Hglp01oFrimft6eMVqg0RPAebhIE9m
         A6GiquCE29XWPvfBxVlCmM7M4ZI7RnZeh3W1VvLvOYFKDDr8McgGezV0PyyCHwUfbFqj
         qrz+dID+gFAbYe3IT3iMqSG7BDx3RgcDtIPl9aHl5ACdn/R02QiEfRNumdhHlrqxHgZf
         qhzhKaJavZDenP+P6cGqFJT0TLku50e+3ue5yN4UwnOR1m71vL6Avyj7AJrdnJex4q65
         /Y4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TtMCgFMUVDqRrPYYA71aGSxJ49RAwZ5OUSEsAs2NCqY=;
        b=MO3Dd/7/SR2CYXxACfKV+ARXIz7hrPeVqeWxEPxrTw5LquwDtEqzPCmVNwe18FJuKP
         BaME1ypgS5s7MGtGH+gyF4RtQiHXj9i9UBPMDug9B27WVrmfKrLFL4rN2PjpUVcSEc1m
         j8EmwCiJyKKRgC9F4/4BMWZxATpIjrZh1+JCT+F6ZY6vrPAYPlsEZ0Ay0nxbhlVWKQ6n
         zVE9baMKGWMMim2t+J5mhwUtTC8heLbmeJesd1EkMlilzD0627h3H5/ei12Utll/AxlL
         mVJ6SiLSjrhruDCMLZfYbbXRXJ3xoDhIUxZ9p5/C3ptpEArfd+DsJzQAfBNjRGjL7fb2
         MDXw==
X-Gm-Message-State: AOAM533mm08JVPbyr3i7bmnGUwBLZAry42MguvWZwjRXsjhGEXdbK92l
        7AYUwryhNK62FsSPVZlUDwYZzjq5AN93l4Ut
X-Google-Smtp-Source: ABdhPJymHh+47RgjJUEEcWBFn9yCaW5xc8WDEioTKDyOWKIAjh7X8fwSEMvGr8QNfIfrQ5e9uOSGFw==
X-Received: by 2002:a05:6a00:1350:b0:49f:e389:8839 with SMTP id k16-20020a056a00135000b0049fe3898839mr23917664pfu.51.1637974819742;
        Fri, 26 Nov 2021 17:00:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p128sm8043938pfg.125.2021.11.26.17.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 17:00:19 -0800 (PST)
Message-ID: <61a18323.1c69fb81.370e0.7727@mx.google.com>
Date:   Fri, 26 Nov 2021 17:00:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291
Subject: stable-rc/linux-4.9.y baseline: 120 runs, 2 regressions (v4.9.291)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 120 runs, 2 regressions (v4.9.291)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.291/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.291
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fd8594b3cefd966789dfebf8eb4311574fadbb9 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61a1484f2061164d7018f6f2

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a1484f2061164=
d7018f6f8
        failing since 13 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-11-26T20:48:56.603461  [   20.622955] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-26T20:48:56.653992  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/127
    2021-11-26T20:48:56.663078  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-26T20:48:56.682302  [   20.703308] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/61a1498df34b51c0d518f6ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a1498df34b51c0d518f=
6ed
        new failure (last pass: v4.9.290-205-g54bc9d253e82) =

 =20
