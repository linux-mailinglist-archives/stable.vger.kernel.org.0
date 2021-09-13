Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D5F409B57
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 19:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbhIMR6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 13:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239959AbhIMR6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 13:58:16 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D0DC061762
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 10:57:00 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q68so10162246pga.9
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 10:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MWRcu8o0r3JAIG15sobbHEIC3Ton70iLZtcBgmSb1f0=;
        b=fXVuVmAyrIFhHvWEcYtBvfY1Ck0/TVVpw60BbxY72CYBcPbi0ujAgyGdTh/fNgM63/
         6HFf0oo/vBMAA1Gl+CnKUBa/OtwbQftyQw81a6rYyI30Y927HLyZ371/npZk3yvOFd1O
         55vgRFon8io6HkPabDfjcy5LKBusqfhIa2JDf7gdBfSB061OaUOjB0S5gR+EDlVdPhcr
         Q9Eah3vS/dwuBzo/f/E1Q6G6YINfI5AZzWTq1NNGVpsw2lTXePSxwbKPC8jm5lLJdAVc
         lremZD5hr2BejzRlU96YC4FG3S95lILTV8CX/EarJBgSHOetUmkRrfx2Kl/lGdMamVth
         xelw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MWRcu8o0r3JAIG15sobbHEIC3Ton70iLZtcBgmSb1f0=;
        b=WfcgWM1GgiJ/DqL038w6OnZkrmKCEjGk2zFsfbTiynqsJA26tukCJYEU8r350VahDm
         LZhoxsKqahfvXFEjCFlM29mVaXnHAn6v/EeKqJsxE4iFJBPDODdKt1KVuAmaKCPl59pw
         K5pF4XjgUUtvEtjZLw8mDMLUnXXn6RyyZzYrfW0MGnVFWIIqf5aBxo20znHoqqxSRFC2
         DZDoPSfvzW57DHuJrta5EGoaa+XQYMa7vKhxZbipmYAAeSmSHNetZ46xDBaj+WF7r/2a
         IRa7IN3cgY4ReVYAkCBlGONM0QB5JZGkPVsp3PKlp3f/r9MRexudsr2EQ/MLa7HCBHA/
         f9Ug==
X-Gm-Message-State: AOAM533EMC1f/7S2eOmWzPoR0fS0ifc44S6ixLb/vIpWXRVbfCVW00Nz
        MzSTdH+Z/Vd7Vr1IZv3VAyEEE/H2QZGh1SX9
X-Google-Smtp-Source: ABdhPJz8mHI5w7ib++8zKODoyAEBKBGc261Rm1Tj7pI49IXCWq6aBRGdD5NG8os5ADoBH3G1Pb2OGA==
X-Received: by 2002:a63:b505:: with SMTP id y5mr12064921pge.91.1631555819630;
        Mon, 13 Sep 2021 10:56:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a27sm7880521pfk.192.2021.09.13.10.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 10:56:59 -0700 (PDT)
Message-ID: <613f90eb.1c69fb81.7e0b5.6440@mx.google.com>
Date:   Mon, 13 Sep 2021 10:56:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.16-300-gcec7fe49ccd1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 175 runs,
 3 regressions (v5.13.16-300-gcec7fe49ccd1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 175 runs, 3 regressions (v5.13.16-300-gcec7f=
e49ccd1)

Regressions Summary
-------------------

platform                | arch  | lab         | compiler | defconfig | regr=
essions
------------------------+-------+-------------+----------+-----------+-----=
-------
imx8mp-evk              | arm64 | lab-nxp     | gcc-8    | defconfig | 1   =
       =

kontron-kbox-a-230-ls   | arm64 | lab-kontron | gcc-8    | defconfig | 1   =
       =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe  | gcc-8    | defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.16-300-gcec7fe49ccd1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.16-300-gcec7fe49ccd1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cec7fe49ccd1ea87d08216eae08b7c7622f5f30f =



Test Regressions
---------------- =



platform                | arch  | lab         | compiler | defconfig | regr=
essions
------------------------+-------+-------------+----------+-----------+-----=
-------
imx8mp-evk              | arm64 | lab-nxp     | gcc-8    | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/613f5ef0c3c261883a99a331

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
300-gcec7fe49ccd1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
300-gcec7fe49ccd1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f5ef0c3c261883a99a=
332
        failing since 0 day (last pass: v5.13.15-22-gd9f9fc203cf9, first fa=
il: v5.13.16-263-g6cdb0b2e1c97) =

 =



platform                | arch  | lab         | compiler | defconfig | regr=
essions
------------------------+-------+-------------+----------+-----------+-----=
-------
kontron-kbox-a-230-ls   | arm64 | lab-kontron | gcc-8    | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/613f5d492ea3ee0d9499a307

  Results:     92 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
300-gcec7fe49ccd1/arm64/defconfig/gcc-8/lab-kontron/baseline-kontron-kbox-a=
-230-ls.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
300-gcec7fe49ccd1/arm64/defconfig/gcc-8/lab-kontron/baseline-kontron-kbox-a=
-230-ls.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.bootrr.leds-gpio-probed: https://kernelci.org/test/case/id/613=
f5d492ea3ee0d9499a311
        new failure (last pass: v5.13.16-263-g6cdb0b2e1c97)

    2021-09-13T14:16:25.551202  /lava-44712/1/../bin/lava-test-case
    2021-09-13T14:16:25.551732  <8>[   15.798171] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dleds-gpio-probed RESULT=3Dfail>
    2021-09-13T14:16:25.551894  /lava-44712/1/../bin/lava-test-case
    2021-09-13T14:16:25.552044  <8>[   15.815739] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-driver-present RESULT=3Dpass>
    2021-09-13T14:16:25.552192  /lava-44712/1/../bin/lava-test-case
    2021-09-13T14:16:25.552335  <8>[   15.832527] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-probed RESULT=3Dpass>
    2021-09-13T14:16:25.552478  /lava-44712/1/../bin/lava-test-case   =

 =



platform                | arch  | lab         | compiler | defconfig | regr=
essions
------------------------+-------+-------------+----------+-----------+-----=
-------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe  | gcc-8    | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/613f5e4e12a053cc3f99a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
300-gcec7fe49ccd1/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
300-gcec7fe49ccd1/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f5e4e12a053cc3f99a=
2dc
        new failure (last pass: v5.13.16-263-g6cdb0b2e1c97) =

 =20
