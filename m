Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341F76CCF19
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 02:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjC2Asy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 20:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjC2Asx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 20:48:53 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454F12D4F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 17:48:46 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id fd25so9232008pfb.1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 17:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680050925;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gy+P7dJENnSh8pqlI3azQP+bBxHzuSIHinBZ9jAtEkg=;
        b=jz9ohF9buh/M2HHz7CNulaC7VKoqrhWkCq5CSHHBka8SEtzEPssS+mq1oZCUxBf+cc
         LY6QX7BnSvuQ6MTMyBHC8rp81m3BE/61ypOrn3LzekWbW5BD2bHhReevvMzNIaVkgARb
         hc/pGjCORItr0FtO39mWT7ncUBfQX7DS3Sc/Jn1AWOpi0q3iwtJKNYzxZYVC01AsMWe8
         CZSG/tMxsl+8El3SaOHcT3Qdgg/kV1/F3vMF4DjQJypBiV1yPSowl7a02ZmGUqwPM4uo
         SzPcqMnUd+iToeu2Q5jjEnL1vHGcAsigXup8AXfnxMC+fifI1m8mXGVv43P7qgBXMDyn
         MUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680050925;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gy+P7dJENnSh8pqlI3azQP+bBxHzuSIHinBZ9jAtEkg=;
        b=2iKfYm7hSA4Nugef6IxTcJGJRbbFYbfZhiDWsqA58wcWNywfKuZGIG5MNlvG507KZQ
         7uT/vMvDczo0UuUBMjZDlng+QjbNEIBqA20ifzqyZsuqWDWIITmG+XNG3ZYmkB0/UHJ6
         gIsefnQOHFLVvWT/1jztGW+2oyxiMO72ZihGY76MrBUQvsgbxZJxGT/QuicRtYjhhvHI
         9dkDxyBxZpHdAG0zrWiNGDmlDC78Ifj6sat8EodaRAR+aqtXK5zvr6gVFQ7pRkdY740y
         ZFgWjaXbfjx13mZRbPqtHJMyVSRO66OoFBFcZWy/h9eIRDq6wnggWGGZg2fglD5LXmly
         8WhA==
X-Gm-Message-State: AAQBX9fP7xTFY93pzUgEiSFRMcbzbUdeFK2vMY2jQcVbUW+NTmSeAf6F
        Bvb2cx6lCLaPUNeJMOHEI/hzxTd1iMSxWlsBm2jsZQ==
X-Google-Smtp-Source: AKy350YX4A54yuzAZz7bWVUkJgnBy9zlmHnV32sdHXM8JcoLz3J324d1xd67AIHuphPS/bSWJb0i6g==
X-Received: by 2002:a62:1cc8:0:b0:625:8b35:3f32 with SMTP id c191-20020a621cc8000000b006258b353f32mr15590024pfc.18.1680050925534;
        Tue, 28 Mar 2023 17:48:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23-20020aa79297000000b0062bfd840e4bsm7759280pfa.37.2023.03.28.17.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 17:48:45 -0700 (PDT)
Message-ID: <64238aed.a70a0220.961fe.e54e@mx.google.com>
Date:   Tue, 28 Mar 2023 17:48:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.21-225-ge6bbee2ba76f
Subject: stable-rc/linux-6.1.y baseline: 125 runs,
 1 regressions (v6.1.21-225-ge6bbee2ba76f)
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

stable-rc/linux-6.1.y baseline: 125 runs, 1 regressions (v6.1.21-225-ge6bbe=
e2ba76f)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.21-225-ge6bbee2ba76f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.21-225-ge6bbee2ba76f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6bbee2ba76fd6c97025903e3b04b1461f02e8af =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/642353f6fcec03bcd062f7bd

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.21-=
225-ge6bbee2ba76f/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.21-=
225-ge6bbee2ba76f/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642353f6fcec03bcd062f7f0
        new failure (last pass: v6.1.21)

    2023-03-28T20:53:48.971064  + set +x
    2023-03-28T20:53:48.974950  <8>[   16.763101] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 241589_1.5.2.4.1>
    2023-03-28T20:53:49.091211  / # #
    2023-03-28T20:53:49.193416  export SHELL=3D/bin/sh
    2023-03-28T20:53:49.193920  #
    2023-03-28T20:53:49.295023  / # export SHELL=3D/bin/sh. /lava-241589/en=
vironment
    2023-03-28T20:53:49.295652  =

    2023-03-28T20:53:49.397230  / # . /lava-241589/environment/lava-241589/=
bin/lava-test-runner /lava-241589/1
    2023-03-28T20:53:49.398071  =

    2023-03-28T20:53:49.404196  / # /lava-241589/bin/lava-test-runner /lava=
-241589/1 =

    ... (14 line(s) more)  =

 =20
