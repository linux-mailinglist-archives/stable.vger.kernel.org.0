Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDD950DFCF
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 14:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiDYMX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 08:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiDYMXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 08:23:53 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CBD27178
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 05:20:50 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id k14so13304984pga.0
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 05:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nrbi0mZRMa2Yqh9zeQYT9otoqo0ns0vT9PytTRlSnZ8=;
        b=kwEdg9ALiNkRKaEhKFNlUnDNHjm6h+JkK7bIOuivTAh2OGY+qkj9HeV0R4br0MjxkZ
         WRgiccO4jGCvReJ3c/6828vdEGKQmB4ptPlGSKlJXyXDmLOFNvZhHyMOVPNe1lw6tKt9
         2Ea02yNJZMDZbUkCsgXSO/p0Yuc3XGapQXdA1lZY1R0aPrnA3FqK2s/hXiRLduD5YVjc
         e6009tORO6PwN+BFNjZU9/gVFS8gJC7A7dSaNEMewI1Y0u05+KbjInvfedBX1BEG5PWo
         qgKVHb1g6U8iKwqjh6waNAr1Q99drx6XzCLYKoMLmhx/rjNdN17YpaJGvj7l9dEN2kOT
         6giA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nrbi0mZRMa2Yqh9zeQYT9otoqo0ns0vT9PytTRlSnZ8=;
        b=G7de92Qyg88NArxlnlh02dc1OC22Mr4inDCY1qpLKBSSGTXBadv8MKN5yidDTQHAlx
         AJuH7hDxj3WejJxZv7vqcyKF8D9CFhCgPHRbDtA65ubwZRO+Du6mcEv+/bHzbWaE+tVq
         de+UQ5QtdDbjSNNnbogAA1Z0xGalaD2zRyrubmPUi8sHYWy6vVMkPSo4hVoBuLAtNdlU
         k+pRxYFZFYZRXAQAT/piCKkodK35u1k07sb0uSTDWtoJcMrBbCOEnZIy6mS6mDXbPTWq
         KWzSrr+ZQinCAEAaHX8Tk8ErBKgOlIKPRoaXGZYHuzklbPSVjt7DQWORWgAt/PmZNB9p
         5vbw==
X-Gm-Message-State: AOAM5318ujE7ditUVmSreEJX1B9rQEYPr1rtw2qiNA+Ejp0XBZr2F+QT
        oPIy/cUUzeTgXpug9rgsDmBkn4wVr8/7J+gdxoc=
X-Google-Smtp-Source: ABdhPJwh8EEomujyeQyXmaxlqsDoeQxCHAGhDdG3eq2ZwKotGdX9J4eXX59Y/Ikc1/+eSfCBUkwiig==
X-Received: by 2002:a05:6a00:1484:b0:50b:f383:462b with SMTP id v4-20020a056a00148400b0050bf383462bmr18820617pfu.58.1650889249462;
        Mon, 25 Apr 2022 05:20:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16-20020a637e10000000b00382b21c6b0bsm9747827pgc.51.2022.04.25.05.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 05:20:49 -0700 (PDT)
Message-ID: <62669221.1c69fb81.eaff.780b@mx.google.com>
Date:   Mon, 25 Apr 2022 05:20:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.239-7-g24bf6831577a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 42 runs,
 2 regressions (v4.19.239-7-g24bf6831577a)
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

stable-rc/queue/4.19 baseline: 42 runs, 2 regressions (v4.19.239-7-g24bf683=
1577a)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxbb-p200              | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.239-7-g24bf6831577a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.239-7-g24bf6831577a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      24bf6831577adec00dc96baade95d58afe67f8c5 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxbb-p200              | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62631fe53d55090be7ff9486

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-7-g24bf6831577a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-7-g24bf6831577a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62631fe53d55090be7ff9=
487
        failing since 22 days (last pass: v4.19.235-17-gd92d6a84236d, first=
 fail: v4.19.235-22-ge34a3fde5b20) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6262e05508d17f6788ff9484

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-7-g24bf6831577a/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-7-g24bf6831577a/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6262e05508d17f6788ff9=
485
        failing since 3 days (last pass: v4.19.238-22-gb215381f8cf05, first=
 fail: v4.19.238-32-g4d86c9395c31a) =

 =20
