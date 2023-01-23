Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5446783C7
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 18:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbjAWR63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 12:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjAWR62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 12:58:28 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3D2233FC
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 09:58:26 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z20so10233535plc.2
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 09:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=T7x1A4YuRFUbpYFQY7lNx4BU9nV6r6FDawIUULNfEN4=;
        b=3cPLGdmjxhvC4nBwF+90pTaqkK9SXBg62exRL/7yTjAmhNJBkBHYkWXh+K2cDI7frs
         VG/r58D9qMbRYIn2Q52toNb/fsreKR9yhLQlTvduKGA07GR7LLym+BJJ/2iUAUTwnYa2
         4fSezzN5pHaWvngN8tUel/Yrrd+fmvTa6p1VBz/GQZuZur2hdoWBL1aae1npRdridUyl
         3hBzT0xJVdAvrXbM6sOEaVvA48r/HWQ+6w0+0qsuzxV/SiyVuaJ/nCXIaC29RAenCG3Y
         plk1EaympFR/CEhSFl/2hNHON+RVKfPtF0xJ9THNIMz1134+skbbWnhnlqrCx4Csp3Jz
         k9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T7x1A4YuRFUbpYFQY7lNx4BU9nV6r6FDawIUULNfEN4=;
        b=oXHaz5T6PX46bj8a5j9S3GaKfXiO3TBoEo4ZjNziIabUfBkbAgyhf2BgjWRaBZGKSk
         T/2nyo25ol3s/+vc3+S/LTziWh8ZOb/vhFd9Ry2iYt9SRqxbUP9orItIoNHzPOId8/81
         Yf3sL3Xdx6M8MYN0Gha+8GZkoZSCtWFTZ+d6SXNOo+bI62keKy8Y25dKMbhiUZygxUJV
         Pdwer1nRX09hi99ofBW31HZAL9sW0Jk9CwmS+xo7c1+7KWm247S/PZcneA+DdTlDvn5H
         L8cvJ16zeQl5sTgSPdNX7pdmjm72wIwZ5GbM2lvc8DP6q9iJ5vbi+DQHdcuLw5nB9OaQ
         aKCA==
X-Gm-Message-State: AFqh2kp1N4otzcLnqeBliAv8LA3SYewf8chLeEFIZey+PwxnjFVFR9V6
        BXZQ34jjabTPL1KjUBkFdAgn9Nxb5m0UtXaj7bQ=
X-Google-Smtp-Source: AMrXdXtYcuQF902J9UEonovnXFx3Kr8/avyasmdZV6zJjePi5bHxxvZQt0vdFgcrJc8CoQUyuSG9sw==
X-Received: by 2002:a17:902:b691:b0:192:fb94:a40e with SMTP id c17-20020a170902b69100b00192fb94a40emr26505722pls.62.1674496705765;
        Mon, 23 Jan 2023 09:58:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902bd0400b00192740bb02dsm2848pls.45.2023.01.23.09.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 09:58:25 -0800 (PST)
Message-ID: <63cecac1.170a0220.abb71.0027@mx.google.com>
Date:   Mon, 23 Jan 2023 09:58:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.162-950-g0ce90a11c205
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 149 runs,
 1 regressions (v5.10.162-950-g0ce90a11c205)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 149 runs, 1 regressions (v5.10.162-950-g0ce9=
0a11c205)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.162-950-g0ce90a11c205/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.162-950-g0ce90a11c205
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0ce90a11c2053976a5e4b9990dba9aceeb0ad1a5 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63ce99b148660695d7915eba

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-950-g0ce90a11c205/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-950-g0ce90a11c205/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ce99b148660695d7915ebf
        failing since 5 days (last pass: v5.10.159-16-gabc55ff4a6e4, first =
fail: v5.10.162-851-g33a0798ae8e3)

    2023-01-23T14:28:49.727035  <8>[   11.141785] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3190781_1.5.2.4.1>
    2023-01-23T14:28:49.836766  / # #
    2023-01-23T14:28:49.940129  export SHELL=3D/bin/sh
    2023-01-23T14:28:49.941118  #
    2023-01-23T14:28:50.043240  / # export SHELL=3D/bin/sh. /lava-3190781/e=
nvironment
    2023-01-23T14:28:50.044285  =

    2023-01-23T14:28:50.044868  / # . /lava-3190781/environment<3>[   11.45=
0342] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-01-23T14:28:50.146811  /lava-3190781/bin/lava-test-runner /lava-31=
90781/1
    2023-01-23T14:28:50.148276  =

    2023-01-23T14:28:50.153267  / # /lava-3190781/bin/lava-test-runner /lav=
a-3190781/1 =

    ... (12 line(s) more)  =

 =20
