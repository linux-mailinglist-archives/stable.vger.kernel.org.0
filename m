Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E3E68803B
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 15:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjBBOfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 09:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjBBOfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 09:35:42 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5048E8B315
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 06:35:10 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z3so1331472pfb.2
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 06:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hzFrRQhxLDyLXM5A6waRsVUjj06wX42nhKMhkpX1vv8=;
        b=5FmEXRJlLBDMzo3CYz9DIrtYCktwQx6ertpbMIXpE8e2lOLi2wx6uRCbj6DfiOItoy
         iOxACdcLUWCSEfa3k6uhSheuBuNuPcnvWSOU29OHbyxwAUSlzZ2GXWiU1SL2SG8SFgg0
         h1dGyC2LvtS+ndF38X0jhooov/OKZ81DM9mdn2gh1AMI2Kpyy1tPlFMW0IYCLgGaeowL
         39fNGBWjZpNmZHxkJmC1wtFfnTjvzHDpUti/3TqvuKLu+w5FKGHGSoOggNhJJymnKJld
         GOHy3StEV9xsGsGEhMMaRGl11BBqVo/64+PTiyH37dHYc7gFVjelcFRnqAtwa6wDgQTM
         7oxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hzFrRQhxLDyLXM5A6waRsVUjj06wX42nhKMhkpX1vv8=;
        b=KbaQrG1Y2xhUtbRuEIbRELgL/lVGZ6BnPA7fdNt5jxbnMz0TcZVQ7hWkSYropwrbAj
         eXitxgeorngm9JJjNl8JKbc1XNODJpX5WnIPFTmMXi6xGk7Gt8qjpVRLdqmNWHiaS6hR
         KPKfmOePSk8Yrfw9tyt2jorw9ytma2JMDTkjZH6DOMIr5mW6g8EwLlzor3jch+T/y9WU
         IUWVdsVdL8KD14mdDLvaqNvqICpLaJHBKzupNTPddm2gzpta/QFbn4YHj2okCvRQPqqd
         Ur7bIKATa978CnUdOrO4kTHPW8tgsoi/9DSa6ponmIz1HxY0/U4YI82ZwMrhOkw4jtlf
         DSsw==
X-Gm-Message-State: AO0yUKW01Bmurl52kgMrhV+IuP/9jsba6d+U8cVR5g+9RC1mKL96Ndr2
        S26dpuEgvo4ppfxg+J2ppEFJQG96QpHNzn6veCZo9g==
X-Google-Smtp-Source: AK7set9zz3AP7vgXuNjXMpOeZ1ehQ0xZ3ZPcElmUQFI6yxUDJ272DSGkziJ7KnNTlC21fZKc6wZ/DA==
X-Received: by 2002:a05:6a00:8a:b0:593:d1c4:c164 with SMTP id c10-20020a056a00008a00b00593d1c4c164mr6121942pfj.17.1675348509574;
        Thu, 02 Feb 2023 06:35:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id dc6-20020a056a0035c600b005897f5436c0sm13873238pfb.118.2023.02.02.06.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 06:35:09 -0800 (PST)
Message-ID: <63dbca1d.050a0220.36a5e.8aa3@mx.google.com>
Date:   Thu, 02 Feb 2023 06:35:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.166
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 126 runs, 2 regressions (v5.10.166)
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

stable-rc/linux-5.10.y baseline: 126 runs, 2 regressions (v5.10.166)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig | regr=
essions
-----------------------+-------+--------------+----------+-----------+-----=
-------
sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig | 1   =
       =

sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.166/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.166
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d823aaa220eebec88c9f307225d3e163252ea95 =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig | regr=
essions
-----------------------+-------+--------------+----------+-----------+-----=
-------
sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/63db9bc9408629ec2a915ef1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63db9bc9408629ec2a915ef6
        failing since 2 days (last pass: v5.10.158-107-g6b6a42c25ed4, first=
 fail: v5.10.165-144-g930bc29c79c4)

    2023-02-02T11:16:44.443120  + set +x
    2023-02-02T11:16:44.447113  <8>[   17.084290] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3272538_1.5.2.4.1>
    2023-02-02T11:16:44.567066  / # #
    2023-02-02T11:16:44.672574  export SHELL=3D/bin/sh
    2023-02-02T11:16:44.674067  #
    2023-02-02T11:16:44.777485  / # export SHELL=3D/bin/sh. /lava-3272538/e=
nvironment
    2023-02-02T11:16:44.779036  =

    2023-02-02T11:16:44.882472  / # . /lava-3272538/environment/lava-327253=
8/bin/lava-test-runner /lava-3272538/1
    2023-02-02T11:16:44.885185  =

    2023-02-02T11:16:44.888510  / # /lava-3272538/bin/lava-test-runner /lav=
a-3272538/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig | regr=
essions
-----------------------+-------+--------------+----------+-----------+-----=
-------
sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/63db99d5caa9d62236915f20

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63db99d5caa9d62236915f25
        failing since 2 days (last pass: v5.10.158-107-g6b6a42c25ed4, first=
 fail: v5.10.165-144-g930bc29c79c4)

    2023-02-02T11:08:44.661257  + set +x
    2023-02-02T11:08:44.665359  <8>[   17.159553] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 236343_1.5.2.4.1>
    2023-02-02T11:08:44.776882  / # #
    2023-02-02T11:08:44.879965  export SHELL=3D/bin/sh
    2023-02-02T11:08:44.880808  #
    2023-02-02T11:08:44.982947  / # export SHELL=3D/bin/sh. /lava-236343/en=
vironment
    2023-02-02T11:08:44.983535  =

    2023-02-02T11:08:45.085845  / # . /lava-236343/environment/lava-236343/=
bin/lava-test-runner /lava-236343/1
    2023-02-02T11:08:45.086996  =

    2023-02-02T11:08:45.091193  / # /lava-236343/bin/lava-test-runner /lava=
-236343/1 =

    ... (12 line(s) more)  =

 =20
