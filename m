Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195C46C1631
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbjCTPDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjCTPCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:02:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C855425B83
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:58:56 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id ja10so12717018plb.5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679324325;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nxUJYaLZr+GRRXINqzHoEjsNnaVagMqkPSiO47ed2jE=;
        b=4xEgJEqsTbXS5BNEHM8q6sfopdY5rFDwnzfcEPkqXbDtLVXQ/mOFmSS1Jqk91HM1Oe
         98T+Vw9JcXHwYyF9URJsmWwnOUFAtFQZA1eHPno4f1ZMjY/wsNAk7rRZWoTHmnxOxpsN
         8+PJTYLKPqIzlc1GbcPhLPPl5IAXEHjTrd6qFK9V1HKCuMKsn9epGv198shhk6eZ4WgM
         hQy9+3+Um9ldtuKXXlIAe3EY96F3sb+Z1WUmRGwL+BKDTixp+B3AkBsk6chuU63dzYLl
         AVjugKndNb1u/PRrHQWQ3YzbJhRA5BEXWxVTtTC0zPcwGa0VrT3c2ZB3dMYj8p89sLFK
         h8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679324325;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nxUJYaLZr+GRRXINqzHoEjsNnaVagMqkPSiO47ed2jE=;
        b=cvNASQOf4LvGHSWzXlVvI5M3FiUokBDurZKsb75SD5MembLFr7SrtFaNJeiOckk+Pf
         1ffvRbjBlKkix9pDNdzLCVyfb8wrmwMWphIZXXG4oz9t9BlzKXCvTPUMgYk0XO9bsIe6
         BlLznt38h/qmDcqu6ugFWV9Xb17hWZOtq6h9jtjnzPlxeHNeywk/vYZH3MBOrNX5W58W
         7KwAYJ+6qGCst5TwQIbr5B0OMyI3sPJsZi3hoNrZGbcpyVyXzJgVnNuK5Frq7GoOLgb/
         NVMPkEE2sDBO+S6x4dDpBUdNyMDiNiLxhollugqHDjEbE9LZNWq68PGPxiqn8KfF3EAx
         qcdA==
X-Gm-Message-State: AO0yUKVf9DBIHJ3joPEfAYXQAa9blQlZ71hjVD9O1aCT/6TBLaTctBT7
        w+myr8ek08asJlU9+L9fvAxyL8bGrBqOLNdQKG6C8A==
X-Google-Smtp-Source: AK7set8+iLXLVJqtHjvMLMIFEg33N9UG8fsQ8TG/kTLSjRHFzCIkoahLlWeABPafN8nFtou+f11k3g==
X-Received: by 2002:a17:90a:1a49:b0:23d:2d68:1d6a with SMTP id 9-20020a17090a1a4900b0023d2d681d6amr20367489pjl.37.1679324325293;
        Mon, 20 Mar 2023 07:58:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10-20020a17090a304a00b00233acae2ce6sm9648176pjl.23.2023.03.20.07.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 07:58:44 -0700 (PDT)
Message-ID: <641874a4.170a0220.79ac.0d09@mx.google.com>
Date:   Mon, 20 Mar 2023 07:58:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.20-142-g50c2c02e4ebf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 188 runs,
 2 regressions (v6.1.20-142-g50c2c02e4ebf)
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

stable-rc/queue/6.1 baseline: 188 runs, 2 regressions (v6.1.20-142-g50c2c02=
e4ebf)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 2        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.20-142-g50c2c02e4ebf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.20-142-g50c2c02e4ebf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      50c2c02e4ebffd872bed5401840f8f6acad80b41 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 2        =
  =


  Details:     https://kernelci.org/test/plan/id/641840b247faaf45c38c865e

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-14=
2-g50c2c02e4ebf/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-14=
2-g50c2c02e4ebf/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641840b247faaf45c38c8665
        new failure (last pass: v6.1.19-139-g6d04fa2f2978)

    2023-03-20T11:16:47.904545  / # #
    2023-03-20T11:16:48.006843  export SHELL=3D/bin/sh
    2023-03-20T11:16:48.007449  #
    2023-03-20T11:16:48.108869  / # export SHELL=3D/bin/sh. /lava-299308/en=
vironment
    2023-03-20T11:16:48.109317  =

    2023-03-20T11:16:48.210671  / # . /lava-299308/environment/lava-299308/=
bin/lava-test-runner /lava-299308/1
    2023-03-20T11:16:48.211494  =

    2023-03-20T11:16:48.216450  / # /lava-299308/bin/lava-test-runner /lava=
-299308/1
    2023-03-20T11:16:48.280350  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-20T11:16:48.280670  + cd /l<8>[   14.511226] <LAVA_SIGNAL_START=
RUN 1_bootrr 299308_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/641=
840b247faaf45c38c8675
        new failure (last pass: v6.1.19-139-g6d04fa2f2978)

    2023-03-20T11:16:50.629575  /lava-299308/1/../bin/lava-test-case
    2023-03-20T11:16:50.629937  <8>[   16.953852] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-03-20T11:16:50.630183  /lava-299308/1/../bin/lava-test-case   =

 =20
