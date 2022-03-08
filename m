Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A424D0D8A
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 02:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiCHBfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 20:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiCHBfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 20:35:00 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40DF2DD4C
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 17:34:03 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id k5-20020a17090a3cc500b001befa0d3102so741743pjd.1
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 17:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4ufyqbobUMhUQc+A5H0G30fLx8zc14wMXD/JBsuGxYU=;
        b=GSNwruJ5Gh0EpKRI2SRruM67d9NkS6GyclN8C/ayBQQcTaMvpw0v0PbmfzX/gfKz8D
         lA4flOpkNKxIMpZvMqhjmr2RpvgqaTm/1PIvU6UfAhcXaLExTrBvJXvGi/8T+TZfanKz
         xZ02DXTMbTn9ozYLqZP+Atgm93bqOSwLOsdllOlXW3eRx4+nhXrb88Y8IwD4dsuxaZ1m
         xNID8XfTmJkSLkofFTwyIMuDhL9tQfzOPJPDx+ZJJMOThsjMHth4SSKI6qpVIifQGupo
         dJ9pWpt/qLjE+/oTLYcSVQ/nBKPtGDD9aSuRl+7TukeQFeVC82qqg7EGDHxNWn0Ginjv
         uGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4ufyqbobUMhUQc+A5H0G30fLx8zc14wMXD/JBsuGxYU=;
        b=jW0cPQQy0pI+OVfNdqU+tfc4WwPudUDrHpp1MMY/OugieNnhMMcskEiT2xT2MDC844
         F26ManYVx++d3BF5T4BHGkK/8ZrGsSoylgGDI+g00cP66yqEJCYAQRoMKw2e0ipRk4x4
         KtdODL8AksUjWe/jRhSMvcBqzijSqHge0Abx9ZbgtBybZvmUEgsY3oLddAFr6apT858X
         0tp35TsC7qlFUtZEHGywFiBKPuRtWZYzD9QP4o8mwz9Tvs+aV0i3vngsKqq+EyDKaDDt
         U8wGf7avB/Ld1FNbkqtDSBD+UVXfLDcE0guzg20Ae1/TwZv2lw8O63dBoy9wMszVl0Nr
         DaSg==
X-Gm-Message-State: AOAM530nuNp0er9C3rSINr9uX48K8dZFJOfCxKayUjyTHOKOSCgGFmr1
        4l4TfoyuOxLFZMFugQIJG2uOqeCgZhL3Tvbca1s=
X-Google-Smtp-Source: ABdhPJxp5fI0RbeeIjcPFRRVS6H76Kgwux7ovGK815WaR25N+VuZQ3DxR4FgtimTJP0sY8uj7jMJuw==
X-Received: by 2002:a17:90b:314d:b0:1bf:1dc5:8e8d with SMTP id ip13-20020a17090b314d00b001bf1dc58e8dmr2014114pjb.204.1646703243163;
        Mon, 07 Mar 2022 17:34:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h2-20020a656382000000b00370648d902csm12904858pgv.4.2022.03.07.17.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 17:34:02 -0800 (PST)
Message-ID: <6226b28a.1c69fb81.38688.1ace@mx.google.com>
Date:   Mon, 07 Mar 2022 17:34:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.103-105-gf074cce6ae0d
Subject: stable-rc/queue/5.10 baseline: 117 runs,
 3 regressions (v5.10.103-105-gf074cce6ae0d)
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

stable-rc/queue/5.10 baseline: 117 runs, 3 regressions (v5.10.103-105-gf074=
cce6ae0d)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 2          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.103-105-gf074cce6ae0d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.103-105-gf074cce6ae0d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f074cce6ae0da57a1e46c555c2c25fa66b630463 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/62267cd1be3f2a7df8c629c8

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-105-gf074cce6ae0d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-105-gf074cce6ae0d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/62267cd1be3f2a7=
df8c629cc
        new failure (last pass: v5.10.103-99-g803f589c9a5f)
        4 lines

    2022-03-07T21:44:32.664688  kern  :alert : 8<--- cut here ---
    2022-03-07T21:44:32.695635  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2022-03-07T21:44:32.695893  kern  :alert : pgd =3D a43a2a39
    2022-03-07T21:44:32.696991  kern  :alert : [<8>[   14.609385] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2022-03-07T21:44:32.697250  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62267cd1be3f2a7=
df8c629cd
        new failure (last pass: v5.10.103-99-g803f589c9a5f)
        26 lines

    2022-03-07T21:44:32.748350  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2022-03-07T21:44:32.748618  kern  :emerg : Process kworker/0:3 (pid: 52=
, stack limit =3D 0x24fcbb5d)
    2022-03-07T21:44:32.749098  kern  :emerg : Stack: (0xc2395eb0 to<8>[   =
14.656402] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2022-03-07T21:44:32.749338   0xc2396000)
    2022-03-07T21:44:32.749561  kern  :emerg : 5ea0<8>[   14.667663] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 1656325_1.5.2.4.1>
    2022-03-07T21:44:32.749781  :                                     1e9b1=
0fe 862c74a2 c2394000 cec60217   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62267e4b1e5009e48fc629b7

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-105-gf074cce6ae0d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-105-gf074cce6ae0d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62267e4b1e5009e48fc629db
        new failure (last pass: v5.10.103-56-ge5a40f18f4ce)

    2022-03-07T21:50:41.806124  /lava-5831647/1/../bin/lava-test-case   =

 =20
