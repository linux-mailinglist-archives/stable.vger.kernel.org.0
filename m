Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971C04D3C73
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 22:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238506AbiCIV5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 16:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238501AbiCIV5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 16:57:05 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646EC11E3E6
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 13:56:04 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a5so3442944pfv.2
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 13:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u10yaM/cixh1Zc17efOejXUE5MTPMUQNcP27DwTzjKo=;
        b=K96T97aW4p6LOd+ue9N3J5c1vtzBp+LhEKa1qUfTHf86mBs/fyreuEUoqXtK9GELVl
         LEbZfOAD0EDJq69O0FuxGtIjEuAeH+ayfnN143NmzQYSJHEbbp+veus7gJT9HeDAdcWv
         p36KQuUeQ895v/aoIMIcQR7oYH584MzYb2dMycBWuBwewWlmzUBqlQFquJ/SHw3zDvA1
         9hPyHQRjHYW2MmR3YriNyQ0dowRyGL3r0BYePITs7G+4u8zeAM1m5sa5Cu2C1PBkQeq9
         mBVfYwnbubV1/xmG4lMxPS0+JD/pYSmVHZhVjNMNQEmQN3hvnw2gmx8iV0sCe03JB1Xl
         InTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u10yaM/cixh1Zc17efOejXUE5MTPMUQNcP27DwTzjKo=;
        b=CEzBtMZxK5X9+7nknidv0i4OSDsEVuAKfqCx1mKx8oN0hq048SIWbwYFCgQuUhzHXG
         3cMztPdliJPshGDBYEvEMjnEugW46DK/0sJWboYc1VdJHsKaPS3O1Ik0S2SyHDeiKrIr
         af+E9QJSJDcnSla70bwQ43/wpZk3QKSvjgpDGxjSQfGDjYe9t971CCMC2q2FM2z3bhdJ
         JZarYyo8c6+3KvnEuieUtdSY9DOjmFEdriQRpLepIFUE/3ZdhkW+HJdZPRt290CNrKO6
         cqfh1QqVcghKhSnejBlkanv4BymK+6JxjldWSAmhr4vqPO01oi4+/Ml32OJymalym4J7
         Vz8w==
X-Gm-Message-State: AOAM5321fhtTNN0ySBetkJWkLTx210QaQO/es36QX3WgNNOe4Y+t/NOY
        aOXXG5ThqrcCEcy1T7shSOfjKKIvJ2vwtoJN5OM=
X-Google-Smtp-Source: ABdhPJxE39wbvG6bATXHs/q+kcQfCEobGSnmxVVCf62pwW8YhpRGKiTmtbqXO4n6pbf4CFbPJ8r28A==
X-Received: by 2002:a63:5110:0:b0:374:2312:1860 with SMTP id f16-20020a635110000000b0037423121860mr1505914pgb.146.1646862963711;
        Wed, 09 Mar 2022 13:56:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f20-20020a056a00229400b004f74434eae4sm4136800pfe.153.2022.03.09.13.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 13:56:03 -0800 (PST)
Message-ID: <62292273.1c69fb81.c9758.aa84@mx.google.com>
Date:   Wed, 09 Mar 2022 13:56:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.104-43-g97495999355f
Subject: stable-rc/queue/5.10 baseline: 103 runs,
 2 regressions (v5.10.104-43-g97495999355f)
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

stable-rc/queue/5.10 baseline: 103 runs, 2 regressions (v5.10.104-43-g97495=
999355f)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.104-43-g97495999355f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.104-43-g97495999355f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      97495999355f97571d40b4f54a5256131e511891 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6228eeedec01f58f29c6297e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-43-g97495999355f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-43-g97495999355f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6228eeedec01f58f29c62=
97f
        new failure (last pass: v5.10.104-43-g417963ee9709) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6228ebc768d3bd7bdfc62973

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-43-g97495999355f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-43-g97495999355f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6228ebc768d3bd7bdfc62999
        failing since 1 day (last pass: v5.10.103-56-ge5a40f18f4ce, first f=
ail: v5.10.103-105-gf074cce6ae0d)

    2022-03-09T18:02:30.672194  /lava-5846834/1/../bin/lava-test-case
    2022-03-09T18:02:30.683620  <8>[   33.527252] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
