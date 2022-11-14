Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CDD628884
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 19:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbiKNSpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 13:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236375AbiKNSpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 13:45:40 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C8295B9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:45:39 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id y13so11849856pfp.7
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=p+duY+TqWeUgkrV7XEDEftU6NLO2YIFjHaObrTgqSvo=;
        b=jGX2dDrSHRSVTic702nzmwDC2l928I8n94TEXjrUrCT0Mh2OUWflX7KWJM0yXShG9Y
         7wxHCbTOuJam4wAsvanhhRNypHv3T1Kkkcu1nHxOVSCJverEVklHwV/l/c2qft7zHacY
         PGxqTjVpud1AQQvbzMuZK7vG5YCSvGsJelTKJsXtxccfiI1Uw4+HxW92I0nRPpBWJjQG
         JRMYQOZXVR7cZkmScy+h6xGou3+P3uWCspIOlyg+qU/WdNPRog9T0R6pVcYGgy2svMW2
         kQ9jYmQIUuiRUNmnDGYyC1DI/YpfrBAErH2NvC/8sVpgB9LW6YYjtPPu2HetWAYCsMNZ
         oSEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p+duY+TqWeUgkrV7XEDEftU6NLO2YIFjHaObrTgqSvo=;
        b=rt7HOjHawOoOYEDAl2iP30UHlU2hndj/H55M/kSmW3l4Jn0XrmGPMjQzx1Ew2v8rdr
         PI6mnxvGCJLkUlR6Xj7phXUXwcOUl0hO9H0Jd5Qr++e/RgAkF2YGsD7/fkILufE4pr+P
         fwV4rSHAX86kxSEquYBE958zSRyMkjQK5jyoH/bc3liTEmPKRdhhdMRzEJy8w3T2FSyf
         iqNO7lAI9hVGlLCDJCqiC0IAqbskFyJg0xdzRwzFHJT1tBnDJWLbhBqVAtg4+5fVeBDS
         Z4VFzK5v+7sT9yGG49KYKVmw4WKPn9FR2jowTWa1T6dkUaBbG5N5nHvyPlDsu6OFOgRn
         jX/A==
X-Gm-Message-State: ANoB5pnVHpGvRc99vcI7jKRuTM5cGPVic0VroRK60Pv7KsDqbS5O74PM
        onlitveGVQxOIUIzY3muk0ed7G4rfeFosVPV8uI=
X-Google-Smtp-Source: AA0mqf5s0BDZVqLV36Ig/JG8zuOmLSyMtfGemKilBcLrijHEbcsn6l6YNmgIY8+25Qd4SCKj42yDLw==
X-Received: by 2002:a63:5745:0:b0:470:250f:e7e9 with SMTP id h5-20020a635745000000b00470250fe7e9mr13099681pgm.112.1668451538884;
        Mon, 14 Nov 2022 10:45:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902edc700b0018693643504sm7879392plk.40.2022.11.14.10.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 10:45:38 -0800 (PST)
Message-ID: <63728cd2.170a0220.ccdba.bd66@mx.google.com>
Date:   Mon, 14 Nov 2022 10:45:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.78-132-gb6ea7e152210
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 171 runs,
 4 regressions (v5.15.78-132-gb6ea7e152210)
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

stable-rc/linux-5.15.y baseline: 171 runs, 4 regressions (v5.15.78-132-gb6e=
a7e152210)

Regressions Summary
-------------------

platform                | arch  | lab         | compiler | defconfig       =
    | regressions
------------------------+-------+-------------+----------+-----------------=
----+------------
at91sam9g20ek           | arm   | lab-broonie | gcc-10   | at91_dt_defconfi=
g   | 1          =

imx7ulp-evk             | arm   | lab-nxp     | gcc-10   | imx_v6_v7_defcon=
fig | 1          =

imx7ulp-evk             | arm   | lab-nxp     | gcc-10   | multi_v7_defconf=
ig  | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe  | gcc-10   | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.78-132-gb6ea7e152210/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.78-132-gb6ea7e152210
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6ea7e152210f358e39d05a567697a098aa16e7a =



Test Regressions
---------------- =



platform                | arch  | lab         | compiler | defconfig       =
    | regressions
------------------------+-------+-------------+----------+-----------------=
----+------------
at91sam9g20ek           | arm   | lab-broonie | gcc-10   | at91_dt_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/6372575fb26e3bf723e7db78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-132-gb6ea7e152210/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-132-gb6ea7e152210/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6372575fb26e3bf723e7d=
b79
        new failure (last pass: v5.15.77-145-gf98185b81e48) =

 =



platform                | arch  | lab         | compiler | defconfig       =
    | regressions
------------------------+-------+-------------+----------+-----------------=
----+------------
imx7ulp-evk             | arm   | lab-nxp     | gcc-10   | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6372586e72132fa27be7db63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-132-gb6ea7e152210/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-132-gb6ea7e152210/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6372586e72132fa27be7d=
b64
        failing since 48 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =



platform                | arch  | lab         | compiler | defconfig       =
    | regressions
------------------------+-------+-------------+----------+-----------------=
----+------------
imx7ulp-evk             | arm   | lab-nxp     | gcc-10   | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63725b03bd3f43b646e7db4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-132-gb6ea7e152210/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-132-gb6ea7e152210/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63725b03bd3f43b646e7d=
b4f
        failing since 48 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =



platform                | arch  | lab         | compiler | defconfig       =
    | regressions
------------------------+-------+-------------+----------+-----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe  | gcc-10   | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/63725ce9574a73cfa7e7db5b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-132-gb6ea7e152210/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
8-132-gb6ea7e152210/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63725cea574a73cfa7e7d=
b5c
        new failure (last pass: v5.15.77-145-gf98185b81e48) =

 =20
