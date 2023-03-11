Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F21F6B5D1B
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 16:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCKPAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 10:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjCKPAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 10:00:50 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BC8E503E
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 07:00:49 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id i10so8528372plr.9
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 07:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678546848;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5Ykn/UDuIYsBNvU7U7r9zr5oPA03Xonj7nV1NmXaITc=;
        b=AuQTocJbKs/SUj1HAVzMIseAzMczDTpa8Q9mTrqo5Nt/5JrG7hQUVxp9LZUGa1fpHY
         j9YbRHUBSuHKgxGzK8ZdImI5yrfwan5M3dvQOBW08KQxdxcUjsUZOYSxQt6monexAZvl
         dXQKEvM8CQd4/73IH8I3RFYBs5OInE6hhDUgz3BO3sAtrW3njbCyoQ4u6z8+H+IAw8MB
         FSZl5Bju/1Ifagwxln7g6+bAw8O2MKDQNBqjqz/r3/GQMqSoRzgus1OYZymw9g/bQ5nS
         a2PI1rf3jV0V6FAEy25pIdWcr98KFh5fKJhOZwmy1Z8azdZrvcvBrnNoYHn47gL2pdGr
         EnwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678546848;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Ykn/UDuIYsBNvU7U7r9zr5oPA03Xonj7nV1NmXaITc=;
        b=Sr3gaCPglYJqLjTmEVXWxYToCJvOQLwf+1XUrkxbMPLfW5K8Yrwto+PUtjnZ5slto7
         2aPzM5r/XF+bAnakRyT+ByADfeizlpjfOnjN/Rw2+9r6XUKCDnDnAdmpSsTCnH87nkrM
         FMh0rYjQJqxKHKDy0gh/zuPABsiEFOGSlxHEXx+tOhuy2ToX9zEdn4JzQ5wCh2PWAxSu
         mLNnmgONOo/cfCQsFJf39yiuT2tJa/n4PBI3GfotHF3eDzvFKU7ugk1hbSMaTGamqwOv
         M/xpp5SDPdCrqn43F5kygUea2y0DrQg+R49sAVOHJIxGApfngF1ob0oEinkkqJqUQov0
         qtPw==
X-Gm-Message-State: AO0yUKW1EOkAq78Q+/aAq6chzfqUn4jIs7sHLQr9sc4NMVPfXgvqdhBz
        x955PpCuYl/QRmqg0S7/H9u5KfMvWhbe1zjsiNChUAzO
X-Google-Smtp-Source: AK7set+jp2F9/XrDqt4jqfqNy7KJGUljjhr90dT1OJBM1Oc1/qfF1xzJGw3CX99xjXxnexV1pw1NaQ==
X-Received: by 2002:a05:6a20:258c:b0:cd:202c:5085 with SMTP id k12-20020a056a20258c00b000cd202c5085mr32962754pzd.55.1678546847563;
        Sat, 11 Mar 2023 07:00:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bn9-20020a056a00324900b005d9984a947bsm1592674pfb.139.2023.03.11.07.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 07:00:47 -0800 (PST)
Message-ID: <640c979f.050a0220.ffbe5.2b0d@mx.google.com>
Date:   Sat, 11 Mar 2023 07:00:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v6.1.17
X-Kernelci-Report-Type: test
Subject: stable/linux-6.1.y baseline: 180 runs, 1 regressions (v6.1.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-6.1.y baseline: 180 runs, 1 regressions (v6.1.17)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.17/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      11585e2f8b9d5b4f0a4c51f12adcaab1573811f1 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/640c5f29d53cce0c698c865c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.17/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.17/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640c5f29d53cce0c698c8665
        failing since 0 day (last pass: v6.1.15, first fail: v6.1.16)

    2023-03-11T10:59:28.583614  + set +x
    2023-03-11T10:59:28.586497  <8>[   16.595058] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 144161_1.5.2.4.1>
    2023-03-11T10:59:28.703120  / # #
    2023-03-11T10:59:28.806457  export SHELL=3D/bin/sh
    2023-03-11T10:59:28.807207  #
    2023-03-11T10:59:28.909664  / # export SHELL=3D/bin/sh. /lava-144161/en=
vironment
    2023-03-11T10:59:28.910423  =

    2023-03-11T10:59:29.012879  / # . /lava-144161/environment/lava-144161/=
bin/lava-test-runner /lava-144161/1
    2023-03-11T10:59:29.013967  =

    2023-03-11T10:59:29.021188  / # /lava-144161/bin/lava-test-runner /lava=
-144161/1 =

    ... (14 line(s) more)  =

 =20
