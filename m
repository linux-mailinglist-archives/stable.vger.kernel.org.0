Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325215ABA23
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 23:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiIBVfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 17:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiIBVfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 17:35:43 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9FAE9255
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 14:35:42 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso6659835pjh.5
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 14:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=rwVu/XLLJDV+3I7FLwddwx+OCg+/gxDuYHzRjSG/XRY=;
        b=zZpH9MBBiOWxd7QUFK7WLZJHMvCht8SugDQiW/NaA7wjLfr3mOvwXXl4gDaf+qHKvz
         /60vGXQsKTxQ5Cv/Ii11MioItU7qf1RsUKMaAXyCPsYhxvo8Z5gEF8W404onkDoJ97vM
         G+FWeqzp0M1PHrA3I43u8oBpFxe0zibSpP/GzhldwT0n0eLiSHfQQvrgNxiDE8R+BKNi
         ei5ULuf+0wKRvChzCijL6otAf99XWH4hRMMKV26dpezNvEhrKT1wbOGOVz9gCUcON2/Q
         ALpybNGeeUODM95T4hQqxxAVHm62jGegP7enOw5MwVdyLD9LpDQS5kuAP1FM65SUI5Zk
         n46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=rwVu/XLLJDV+3I7FLwddwx+OCg+/gxDuYHzRjSG/XRY=;
        b=bn8OqH5IhrGlB1zjqXXFcvDDQjHsoQE9agukOeWz7zMe9mQeOcS98rnw0uHwLZUYKt
         C2qk5xUyQmvT5BsmkGG9EUHo0QmlcIyGmAX9ZXj2mdaxJM25Nrrt37I987vQ9XfZeuew
         4iZVPye3tTFm1at7e1zOGiLuTNNem+u4enzVArF027oXDFJgd5XRacaO3L+gJBqHsMzn
         urXSSrBfG1DjuqJADroSYD1R84toWoBjklLgbNBflsR+6K8/LBPYbLvacWtrtLbSzUmh
         S2tNPliXkdjRWWo6H7UsrxmtfyU6vTKG1LKISNzIpgKfCNm2QSsS38YlxUWWtcjIy6kY
         Zipw==
X-Gm-Message-State: ACgBeo3DOKgSycZ5Bpb946hqkUZonf2m+KNZPtk23l8ZaVwDhg57Ttqn
        /HC+YS8wjMm6WvTcfQFQOja+PwYsqo9OWfNY8Wc=
X-Google-Smtp-Source: AA6agR6+5Jt/HEhsHKwS6yRYBg3pZzsq5qoxJBUocjJfqztx7W5UEGhcQ8dKjCRbx1D9a4z20AR45g==
X-Received: by 2002:a17:902:c1c6:b0:174:92b7:bb3e with SMTP id c6-20020a170902c1c600b0017492b7bb3emr29197129plc.163.1662154542172;
        Fri, 02 Sep 2022 14:35:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h5-20020a056a00000500b005386b58c8a3sm2296077pfk.100.2022.09.02.14.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 14:35:41 -0700 (PDT)
Message-ID: <6312772d.050a0220.eb76e.41d7@mx.google.com>
Date:   Fri, 02 Sep 2022 14:35:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.4-233-g65485bdafd38
Subject: stable-rc/queue/5.19 baseline: 177 runs,
 3 regressions (v5.19.4-233-g65485bdafd38)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.19 baseline: 177 runs, 3 regressions (v5.19.4-233-g65485b=
dafd38)

Regressions Summary
-------------------

platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit  | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defcon=
fig | 1          =

kontron-pitx-imx8m  | arm64 | lab-kontron     | gcc-10   | defconfig       =
    | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre    | gcc-10   | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.4-233-g65485bdafd38/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.4-233-g65485bdafd38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65485bdafd38ea0e483264c5941d2d0bdadca8ad =



Test Regressions
---------------- =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit  | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/63124a206605d28e36355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
33-g65485bdafd38/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
33-g65485bdafd38/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63124a206605d28e36355=
664
        failing since 16 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
kontron-pitx-imx8m  | arm64 | lab-kontron     | gcc-10   | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/631246d2ad51b55e3c355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
33-g65485bdafd38/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
33-g65485bdafd38/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631246d2ad51b55e3c355=
656
        new failure (last pass: v5.19.3-364-gd819f988752b) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
r8a77950-salvator-x | arm64 | lab-baylibre    | gcc-10   | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/631246099230af9a1f355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
33-g65485bdafd38/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
33-g65485bdafd38/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631246099230af9a1f355=
655
        new failure (last pass: v5.19.3-364-gd819f988752b) =

 =20
