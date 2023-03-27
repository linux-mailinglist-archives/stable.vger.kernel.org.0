Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B786CA917
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 17:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbjC0Pdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 11:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbjC0Pdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 11:33:35 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FD7C2
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:33:34 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id iw3so8791063plb.6
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679931214;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XCejFmJP2zwSyLF3qdSwr0b0vU/tZKWF9kpudOe/pIQ=;
        b=cl69OOXWhfGLUUO57xmjGAynMNdryVWY1YhlwO1/jnidv5kfmIUFBKrHQxp6rzOE5G
         YsSCyH9rPSC/ASpR7ZyK0k1zaDy2hLbiJiGBkNIMQrq0mMder7yOdyOL91iN8scC5oC/
         tHKcb7S2ZfAKJ9O+UVJfHRfZ7ru/oWIAzDwQFP6aVl0/GHNreAwfAmzOum3j/EY3R6rE
         6SFAhmGzkFlrA8FKe178zbOFlkToTcwtBjNHqwW0jw33L1xNNPvqEeJjI8J+jXR+qU0z
         Oj2PFz0yU0hamXPJ/R3ts1o/XIAyxjM3gdcDoG3JO/9/EK7arrcAZ5HJWDrUS3Bz16YV
         N1OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679931214;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XCejFmJP2zwSyLF3qdSwr0b0vU/tZKWF9kpudOe/pIQ=;
        b=VEwDDYER5WDeqrFJ2hMnQq/Pu7wI2l+/2x1/ynm9WWHnOQyCZnIg7xvl/CEtEdvYvX
         ixNVSUlljzh64UPj712zulsz1TNTCMg2dXsag7IE0EIA88DRFhX0hgKRuaXTxT5b3hHL
         zQu+uuKcWYg77auOBDJkJMwAKHhSDEvRN5rt8/FwtPxpdRxidnVMZA9CAHJzZqE/E/wh
         SdAsgLmlfQQwGui21kob0JEcxYNikz+C+8D8IFlZrqvGoAbUXAq1RxwO6EecbV4vaDjn
         Gkpx6L0ncLyt3djHPlvMfYBLVo6IlYnIF5mmQFBykUCwkeUaPR+8oggppmwElC5I8uei
         ef9g==
X-Gm-Message-State: AAQBX9fTMAD7j6eWl4ZHE92pxKHgZDDAH8nwe5ZrB14qGoze1+qojXPE
        XSE2JAoV7EMW5pci9vFUZzTqIIQxZBtKxhBIZQxO9w==
X-Google-Smtp-Source: AKy350ZMfmBsDE9tMg/Yd07XFw0/ppZaxRVijuvmvmr5FbFuSee5Evn5fTtH6b+0ZiDDEhh0wU9rgA==
X-Received: by 2002:a05:6a20:3b1c:b0:df:2140:3b87 with SMTP id c28-20020a056a203b1c00b000df21403b87mr7484985pzh.32.1679931213896;
        Mon, 27 Mar 2023 08:33:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c15-20020aa78c0f000000b005a7c892b435sm19238225pfd.25.2023.03.27.08.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:33:33 -0700 (PDT)
Message-ID: <6421b74d.a70a0220.69585.27f6@mx.google.com>
Date:   Mon, 27 Mar 2023 08:33:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104-76-g9168fe5021cf1
Subject: stable-rc/queue/5.15 baseline: 95 runs,
 2 regressions (v5.15.104-76-g9168fe5021cf1)
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

stable-rc/queue/5.15 baseline: 95 runs, 2 regressions (v5.15.104-76-g9168fe=
5021cf1)

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
nel/v5.15.104-76-g9168fe5021cf1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.104-76-g9168fe5021cf1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9168fe5021cf1d0ad0e32162e81e7c841a1f330b =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/64217e97988743077a9c9525

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-76-g9168fe5021cf1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-76-g9168fe5021cf1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64217e97988743077a9c9=
526
        failing since 52 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/64218086e60d03c9279c9566

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-76-g9168fe5021cf1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-76-g9168fe5021cf1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64218086e60d03c9279c956f
        failing since 69 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-27T11:39:39.148646  <8>[   10.035451] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3449203_1.5.2.4.1>
    2023-03-27T11:39:39.255461  / # #
    2023-03-27T11:39:39.356959  export SHELL=3D/bin/sh
    2023-03-27T11:39:39.357363  #
    2023-03-27T11:39:39.458681  / # export SHELL=3D/bin/sh. /lava-3449203/e=
nvironment
    2023-03-27T11:39:39.459058  =

    2023-03-27T11:39:39.560131  / # . /lava-3449203/environment/lava-344920=
3/bin/lava-test-runner /lava-3449203/1
    2023-03-27T11:39:39.560742  <3>[   10.353343] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-03-27T11:39:39.560970  =

    2023-03-27T11:39:39.565901  / # /lava-3449203/bin/lava-test-runner /lav=
a-3449203/1 =

    ... (12 line(s) more)  =

 =20
