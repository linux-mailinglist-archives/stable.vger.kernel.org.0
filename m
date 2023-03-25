Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA8A6C8C26
	for <lists+stable@lfdr.de>; Sat, 25 Mar 2023 08:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjCYHRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Mar 2023 03:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCYHRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Mar 2023 03:17:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3E2C15C
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 00:17:50 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso7091640pjb.3
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 00:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679728670;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AZoejvizEMq1YeWka/JWvfrI+Q6sl4zWV8GJupE+JxM=;
        b=YS3aEB8p/eRnhmU1Ve2bCQMeFKklXnQyGjHhO9Z7WxjIEOxQnvPpk0zJslTUan+JMQ
         5QLxhu0u9IVYuJL9SNDOhbfLyWGMW/pB+TMMkOBXrqFhZwFe1ZBl4h9/b0kaF5LG+C1c
         HcsRuqsaxYueJuy35xJ6CoDzvpOMEdrrTU1hkc8hM2Guw48ZLmhCkc+vsmeVEEas+dbz
         gh09/EMfpuqdzxyeSdZT9DhygIRCXOeaKKMIGHe8SMcLDP6KExIwj+RI9BokKYX1WOFr
         jJcrRrCwUvUmyt7yeHHX0riUfbd3jH+Iq0x1oY5c5Hs0AqH4Ghct7iLLUoyvstGaEm+b
         2PBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679728670;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AZoejvizEMq1YeWka/JWvfrI+Q6sl4zWV8GJupE+JxM=;
        b=Ak9/AGmaTQiqvPvKZdLwhQrIxveeUKxoxVm0AYT+if/tfHs4xJ398+eKxFHpewfzu9
         NoP17pvJdDSwQkXZ9Gbve349doWb/Xcxrkj2Nxn2kMICXNnFRo8lo/7aheSkf4ODfob2
         KPqv5TQuVMCSbo/nO2fMRNvbPNQZLjsi3OOhVJOD48rKZIMGx4Ge+jw0H/zPcwZlf9Sm
         pcuVMJUibKEChVr5pXDnVtCQ1SWQpF2Vq4fvK5pVAojpO1jErbtIEodK1s8PiAwQ12Sf
         tAJBI4v5UR3qbW0l0562Zq3OTGle5Q/HepSPc8gJDr/z4WKoBYFJDfzBVDvTwY8Bf22/
         S8TQ==
X-Gm-Message-State: AAQBX9dWTX3s9Z9stcOW6WDm/SsmEl7ntNUYuB9essSuCQwyX1q3uYFY
        4zyQ29ZXGJEh8INjtLCScyWk95viJWYyPTHnkBZwig==
X-Google-Smtp-Source: AKy350Y5GYdgL83V46LlhgOReeG7eG01ga/VKHlZzplPraY5D9+6vszXZTHpp6snJa3JTzQ7RSFgSQ==
X-Received: by 2002:a05:6a20:1823:b0:df:ebd:651e with SMTP id bk35-20020a056a20182300b000df0ebd651emr1079988pzb.35.1679728670203;
        Sat, 25 Mar 2023 00:17:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h5-20020a62b405000000b00625d4a56991sm14883937pfn.125.2023.03.25.00.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 00:17:49 -0700 (PDT)
Message-ID: <641ea01d.620a0220.73184.b668@mx.google.com>
Date:   Sat, 25 Mar 2023 00:17:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104-15-g64e316d3abf43
Subject: stable-rc/queue/5.15 baseline: 126 runs,
 2 regressions (v5.15.104-15-g64e316d3abf43)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 126 runs, 2 regressions (v5.15.104-15-g64e31=
6d3abf43)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =

cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.104-15-g64e316d3abf43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.104-15-g64e316d3abf43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64e316d3abf4397d8e6b7426f5a26fb0451c34d3 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/641e6b97deb87ef42c9c9520

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-15-g64e316d3abf43/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-15-g64e316d3abf43/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641e6b97deb87ef42c9c9=
521
        failing since 49 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/641e69ca959267e7db9c9505

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-15-g64e316d3abf43/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-15-g64e316d3abf43/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641e69ca959267e7db9c950e
        failing since 66 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-25T03:25:51.027709  + set +x<8>[   10.009605] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3442976_1.5.2.4.1>
    2023-03-25T03:25:51.028341  =

    2023-03-25T03:25:51.137519  / # #
    2023-03-25T03:25:51.240401  export SHELL=3D/bin/sh
    2023-03-25T03:25:51.240829  #
    2023-03-25T03:25:51.241052  / # export SHELL=3D/bin/sh<3>[   10.193208]=
 Bluetooth: hci0: command 0xfc18 tx timeout
    2023-03-25T03:25:51.342353  . /lava-3442976/environment
    2023-03-25T03:25:51.342700  =

    2023-03-25T03:25:51.443956  / # . /lava-3442976/environment/lava-344297=
6/bin/lava-test-runner /lava-3442976/1
    2023-03-25T03:25:51.445396   =

    ... (13 line(s) more)  =

 =20
