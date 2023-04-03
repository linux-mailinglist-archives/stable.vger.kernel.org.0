Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFB86D4747
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbjDCOS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbjDCOSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:18:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B312C9DA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:18:52 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c18so28121700ple.11
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 07:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680531531;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WaHxsA2bpb+AkdyuIfaKOiEEHjom3P/b5oIvS5/EZMA=;
        b=5PfiwFO+VB34+rbDni3wderBwkX6PfTPvO3LVn82vwK8l0c+IFEkJ8iDGCwlfCfvGs
         hJ8uzR4DJuUNllmceaY9SI/hF3op1R4P2rXR1EOqJ1cCck3eSqh1Qo17TYc8ZqiuFhBg
         iqLYwU/Dy5aG9znCgKUqgGRpbG1qOUCkhYv1yvudQOwxaHQV/GprWQ20Q+dPg3lWRQbH
         3nOyiU2K+QCPTfMVBLwIe58V7rgtmu0Gy1dUrzKwBl8Vf49fxWWYtEB2NN3H4EpukQpO
         qzq8qfgaH+bWm/2Pizps55NoylMvX5Fjv7N6AEdIJfotg7/KjbxorXxpX6WDRhhX7i7Y
         ELRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680531531;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WaHxsA2bpb+AkdyuIfaKOiEEHjom3P/b5oIvS5/EZMA=;
        b=nQ9Yf4qh1je3tcZYLCqBmyJS5Wl/TLUjidcVrENZAGe1qQFTmXoo7W6jwrTPv6t0vT
         JCPLESTi7l/PNLcQSuQOo+4GG/S4mjpGryorWERs7VARO0eOFEaDpsP214MmJX4QyBK+
         8/juPfxF0FuTgQlbGf1qLu3+hoS54RhNfYFK9nhODWfbftkjvwuuieVWLme+ajWF9QKc
         bs2zMxgNAzEw9e0TUGu22BoeTKnTSFqTiS7JQCWMRhI442ycyq/wK15s5f2V4nIBcAmp
         RIOO18wGyCjh69swZwsukHK8HJ5GmllIYnXX5bQcLeFEghvHlwb1Kf2kJfYK0AyQNLWY
         IS4w==
X-Gm-Message-State: AAQBX9fSeXV4mrrA4fl7+8RRy5Q0HWgEYTKLVKl5YycKz90rGWhtS4Xq
        6058s6rfztTWrrwxnYv1/01AcBjYEG/XtEv+4gJBcA==
X-Google-Smtp-Source: AKy350ba8Xu7qfeSj6c8enLm7ReFzwDqZ8EisYhcNSmOB3HSU6+HokoN0M1ryIoeg334Qy8JvggyYA==
X-Received: by 2002:a17:902:db06:b0:19e:748c:ee29 with SMTP id m6-20020a170902db0600b0019e748cee29mr44797226plx.55.1680531531306;
        Mon, 03 Apr 2023 07:18:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ay5-20020a1709028b8500b001a0757b1539sm6195177plb.36.2023.04.03.07.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 07:18:51 -0700 (PDT)
Message-ID: <642ae04b.170a0220.e2009.af07@mx.google.com>
Date:   Mon, 03 Apr 2023 07:18:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.279-77-gb60454c8d9bc
Subject: stable-rc/queue/4.19 baseline: 106 runs,
 1 regressions (v4.19.279-77-gb60454c8d9bc)
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

stable-rc/queue/4.19 baseline: 106 runs, 1 regressions (v4.19.279-77-gb6045=
4c8d9bc)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.279-77-gb60454c8d9bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.279-77-gb60454c8d9bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b60454c8d9bc42971662e06ee2dcb10b0f1a7491 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/642aad4df72186b59a62f76d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-77-gb60454c8d9bc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-77-gb60454c8d9bc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642aad4df72186b59a62f772
        failing since 76 days (last pass: v4.19.269-9-gce7b59ec9d48, first =
fail: v4.19.269-521-g305d312d039a)

    2023-04-03T10:40:56.290087  <8>[    7.309531] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3467170_1.5.2.4.1>
    2023-04-03T10:40:56.400061  / # #
    2023-04-03T10:40:56.503845  export SHELL=3D/bin/sh
    2023-04-03T10:40:56.505137  #
    2023-04-03T10:40:56.607485  / # export SHELL=3D/bin/sh. /lava-3467170/e=
nvironment
    2023-04-03T10:40:56.608646  =

    2023-04-03T10:40:56.711129  / # . /lava-3467170/environment/lava-346717=
0/bin/lava-test-runner /lava-3467170/1
    2023-04-03T10:40:56.713131  =

    2023-04-03T10:40:56.718555  / # /lava-3467170/bin/lava-test-runner /lav=
a-3467170/1
    2023-04-03T10:40:56.800105  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
