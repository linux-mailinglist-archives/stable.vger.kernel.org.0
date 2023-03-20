Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2936C240E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 22:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCTVpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 17:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjCTVpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 17:45:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F5223C62
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:44:37 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x15so3279777pjk.2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679348676;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DcV7qOsLSp/hUNMnqF0syf5C0BHpwM6O/qIA4bJLMLE=;
        b=Uo8Ofla0zpIm5fUlutwDdEf6Kd+9G92t36zHfe4xhDYVUm2uJcHOYiwFts0bxIpUOY
         O5fzqWmSRcFzQlzGamvSJ5XD98E67sVuQCuE8bmOJ4X9DvCkcomYbfKPVvF1oIu4brnF
         O/YneGvQMOr3JydhpHMet0I595Dpxjn+SsSJP5/tCLDsAZ5Wvxi6IkFYr1jBCATyzNaX
         Ok48/jKJl+1bjkq6ptqYphsVI+NtzeSvc3lZgyscXYCoi/Nb+OS1hSjILEFtY2+OrCpG
         wxfCDsoHHsy/MgFYPJByH5K+hqT3Fy+kwywL0MKG8+RlXvZLKTfHuhyrz5xPOtdlu/Kw
         rXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348676;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DcV7qOsLSp/hUNMnqF0syf5C0BHpwM6O/qIA4bJLMLE=;
        b=wf8qQ5D9jCmcixUOjc/G2qpqt0YxqSp96j4fHtFaNdgc4xXDwXh5dUZFsuUWqdAco3
         0xYHhJ7xkn+wdUCpnks9s6BqLjo9+CrpWA5ZEmGlfdQHTEtYh3q2JOH0pno6fGyVmEtM
         9HAZkwwM4wXuMq7wbXeKzc/2m7fniW/wjrWg+XCXQkwbUkL834PfPA+eqi470FYRFy7k
         LaML6E2z/lps/WX3bscUe17ohmIar/mQczDQByrsMdLM9FP3MpnjYgwjzyUOiD4j4Zs0
         8ACOR4+uKLwe2wDfXeEn2RnhIVSXzjut3KlsFF+KGroif0a0s/axhmlg81aoVTRpi01F
         H9hw==
X-Gm-Message-State: AO0yUKW0wX+r1g1exFjh+Bi9BuNCk7QgPbz4iQVoJug0aCPjk7ZyOqJe
        hccPbpWmgqytbHL2xUZZlNRIi+kU9c+ilNmUV+4=
X-Google-Smtp-Source: AK7set8tn+W8ENvW2DHceLJd/wTBUl0EFN/vObLu5iynHR4EjHVcc6hfLZ2DEmTUgn2A+VUTEJltqA==
X-Received: by 2002:a17:903:2847:b0:1a1:a5e7:a7cd with SMTP id kq7-20020a170903284700b001a1a5e7a7cdmr13251414plb.5.1679348676561;
        Mon, 20 Mar 2023 14:44:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c15500b0019f9fd10f62sm7226554plj.70.2023.03.20.14.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 14:44:36 -0700 (PDT)
Message-ID: <6418d3c4.170a0220.f8919.c86c@mx.google.com>
Date:   Mon, 20 Mar 2023 14:44:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.175-100-g1686e1df6521
Subject: stable-rc/linux-5.10.y baseline: 178 runs,
 4 regressions (v5.10.175-100-g1686e1df6521)
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

stable-rc/linux-5.10.y baseline: 178 runs, 4 regressions (v5.10.175-100-g16=
86e1df6521)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
cubietruck       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

fsl-lx2160a-rdb  | arm64 | lab-nxp       | gcc-10   | defconfig            =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.175-100-g1686e1df6521/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.175-100-g1686e1df6521
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1686e1df652191033a9fc46dc7cf43cd169baa1a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
cubietruck       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6418a0cfacd9e47b198c8638

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75-100-g1686e1df6521/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75-100-g1686e1df6521/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6418a0cfacd9e47b198c8641
        failing since 61 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-03-20T18:06:57.470139  + set +x<8>[   11.009871] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3429789_1.5.2.4.1>
    2023-03-20T18:06:57.470435  =

    2023-03-20T18:06:57.577054  / # #
    2023-03-20T18:06:57.678783  export SHELL=3D/bin/sh
    2023-03-20T18:06:57.679151  #
    2023-03-20T18:06:57.780128  / # export SHELL=3D/bin/sh. /lava-3429789/e=
nvironment
    2023-03-20T18:06:57.780514  =

    2023-03-20T18:06:57.881766  / # . /lava-3429789/environment/lava-342978=
9/bin/lava-test-runner /lava-3429789/1
    2023-03-20T18:06:57.882457  =

    2023-03-20T18:06:57.887099  / # /lava-3429789/bin/lava-test-runner /lav=
a-3429789/1 =

    ... (13 line(s) more)  =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
fsl-lx2160a-rdb  | arm64 | lab-nxp       | gcc-10   | defconfig            =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6418a34f9f9eec7a748c86e5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75-100-g1686e1df6521/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75-100-g1686e1df6521/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6418a34f9f9eec7a748c86ec
        failing since 16 days (last pass: v5.10.155, first fail: v5.10.172)

    2023-03-20T18:17:24.555612  [    9.692375] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1179474_1.5.2.4.1>
    2023-03-20T18:17:24.661398  / # #
    2023-03-20T18:17:24.763211  export SHELL=3D/bin/sh
    2023-03-20T18:17:24.763793  #
    2023-03-20T18:17:24.865274  / # export SHELL=3D/bin/sh. /lava-1179474/e=
nvironment
    2023-03-20T18:17:24.865807  =

    2023-03-20T18:17:24.967324  / # . /lava-1179474/environment/lava-117947=
4/bin/lava-test-runner /lava-1179474/1
    2023-03-20T18:17:24.968228  =

    2023-03-20T18:17:24.969878  / # /lava-1179474/bin/lava-test-runner /lav=
a-1179474/1
    2023-03-20T18:17:24.987251  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 2          =


  Details:     https://kernelci.org/test/plan/id/6418a1fdac0ce6c1f58c863a

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75-100-g1686e1df6521/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75-100-g1686e1df6521/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6418a1fdac0ce6c1f58c8644
        failing since 6 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-20T18:12:07.859492  <8>[   34.061649] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-03-20T18:12:08.885767  /lava-9703041/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6418a1fdac0ce6c1f58c8645
        failing since 6 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-20T18:12:06.822446  <8>[   33.023897] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-20T18:12:07.848822  /lava-9703041/1/../bin/lava-test-case
   =

 =20
