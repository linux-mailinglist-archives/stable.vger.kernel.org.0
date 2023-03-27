Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D45C6CA7E7
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 16:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjC0Ok6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 10:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjC0Ok5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 10:40:57 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B799A1
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 07:40:56 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j13so7876811pjd.1
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 07:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679928056;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lSrMQmc3s707Wh5VWz3bomqHrLdAjCjKuFkGFJcf6xQ=;
        b=dON5e+/epeioNJntRSORKXsV40xLcBphT1hn4sZt7p4Fa/LRT+/Jtq7+FLEKNQJj/p
         /Hy2tuFeHgXGr6VOa/nvmAPmDrwrXnZOWkhqHO7649A0HhSE+oIcaZllJere2CoJdzHZ
         5XLOsOvdWtkSNAW9/n/pwdyLZkyBQKEQUN73ru/pTZ0VyNXY4E32NCC694uNK7IpqxYC
         JhgPZg8SajENFa4Oa0xyBu/cAGjBh786i9/zauOVF0tQ/bHoQkHITfxgwYT/dxGoPdzH
         XyVNlTeBS0NAShZyLvXtUq+/qvIL2zPXZtzTY0bzBFxrd43x82igcSeibBLD/LGsPizI
         2cbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679928056;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lSrMQmc3s707Wh5VWz3bomqHrLdAjCjKuFkGFJcf6xQ=;
        b=oyYr6YsQ7sr+RJmYOG1iaIun/bqKdk6pYXOsbepO3GlyTq00KYqy8Gt2Eqg0W/Goll
         ENTcUKk04VNrZFwQIngeF+TSLLFee4s25vw7rgDcfMWNHb2FNFgoDqImsJSxtggJuc0t
         PII9S7rpbp0PH/99KLSePO8HIlm/q0ZdUIWCpN2A+WcoOstNXRjUyhNj+yjrTWyKE28z
         Tk/leloPcs8ZpQv1CUbxXkFPL96eTZR1hK615F43UoZj0gmQdSOOT8gtkRTuX0OxhmjZ
         Ir0ZogDY7FI1KQUMwyNk/ORtFWcC4wO3BPkCbn1ah/TQZanFmPbLCs8pJ6S088QUfDMk
         rKFg==
X-Gm-Message-State: AAQBX9dFVoKAMH0OBHv1p2jDhnBMi+6JsFPs7gdURWfjJ1l1I/LmueoA
        uVKUV7Mexm0CO3B5uiUrgKgvMmAKbsmtrfAuTiaxCA==
X-Google-Smtp-Source: AKy350ZPRcOzBEm3dmHsiz1Le8qRTCiv26Gm+4c/NHcSQEpFAAl7dwDbaIyWqrOITAsiHgZKNSqdaw==
X-Received: by 2002:a17:902:daca:b0:19f:3d59:e0ac with SMTP id q10-20020a170902daca00b0019f3d59e0acmr14723748plx.44.1679928055739;
        Mon, 27 Mar 2023 07:40:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iz1-20020a170902ef8100b0019edc1b421asm8249995plb.163.2023.03.27.07.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:40:55 -0700 (PDT)
Message-ID: <6421aaf7.170a0220.9b5aa.e162@mx.google.com>
Date:   Mon, 27 Mar 2023 07:40:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-61-g2332301f1fab4
Subject: stable-rc/queue/5.10 baseline: 119 runs,
 2 regressions (v5.10.176-61-g2332301f1fab4)
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

stable-rc/queue/5.10 baseline: 119 runs, 2 regressions (v5.10.176-61-g23323=
01f1fab4)

Regressions Summary
-------------------

platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =

sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-61-g2332301f1fab4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-61-g2332301f1fab4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2332301f1fab4a0a8d9a3d22ed2ce01c37a0d338 =



Test Regressions
---------------- =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/642179e490f69b6e669c9564

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-61-g2332301f1fab4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-61-g2332301f1fab4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642179e490f69b6e669c956d
        failing since 59 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-27T11:11:10.687593  <8>[   11.009253] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3449132_1.5.2.4.1>
    2023-03-27T11:11:10.800103  / # #
    2023-03-27T11:11:10.903261  export SHELL=3D/bin/sh
    2023-03-27T11:11:10.903649  #
    2023-03-27T11:11:11.004844  / # export SHELL=3D/bin/sh. /lava-3449132/e=
nvironment
    2023-03-27T11:11:11.005221  =

    2023-03-27T11:11:11.106420  / # . /lava-3449132/environment/lava-344913=
2/bin/lava-test-runner /lava-3449132/1
    2023-03-27T11:11:11.107027  =

    2023-03-27T11:11:11.107197  / # <3>[   11.370818] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-27T11:11:11.117731  /lava-3449132/bin/lava-test-runner /lava-34=
49132/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/642179b38af0472a0a9c9562

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-61-g2332301f1fab4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-61-g2332301f1fab4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642179b38af0472a0a9c956b
        failing since 53 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-27T11:10:24.054524  / # #
    2023-03-27T11:10:24.156336  export SHELL=3D/bin/sh
    2023-03-27T11:10:24.156719  #
    2023-03-27T11:10:24.258058  / # export SHELL=3D/bin/sh. /lava-3449139/e=
nvironment
    2023-03-27T11:10:24.258473  =

    2023-03-27T11:10:24.359815  / # . /lava-3449139/environment/lava-344913=
9/bin/lava-test-runner /lava-3449139/1
    2023-03-27T11:10:24.360531  =

    2023-03-27T11:10:24.365843  / # /lava-3449139/bin/lava-test-runner /lav=
a-3449139/1
    2023-03-27T11:10:24.463720  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-27T11:10:24.464253  + cd /lava-3449139/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
