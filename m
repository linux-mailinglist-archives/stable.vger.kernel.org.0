Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4846B63D0
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 09:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCLIH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 04:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCLIH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 04:07:27 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32C756786
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 00:07:25 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso14096781pjb.2
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 00:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678608445;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+TSufuPtAS06kYCW32bvRXw4zwQWXOLN3tbSEUEeVU=;
        b=z4wdb+X4IB3km4RmXWvbckFgbeDe+dRN2UGPhTLNl+ryOc0mOA2dogzcKYZFc18a8o
         88OUlAGKa+l9kBhufHHXXjiQfkqybKdmah8lKWMkbYeEWwSfGzyC47SZEyNoeu2xHWei
         8B2O1Y41NGs35wRE9pdczO3arEZGsWunoBywg30LeRYa/ZRlVj9TRFIZ0TKriATL36Zu
         9eDNvQFbEIol1CdNhjr9MNpV2B1qcoplYVPtQ4/hQQJivTI1EwB4mZp2q/5sZmSd/aGN
         Yq9vPeQ47ZXsEW0iZT1Sn7BRMLD1IF4X4AGBGDWQmP3DiDxRPR6RhHkHXM5J3XOURE/g
         aoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678608445;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q+TSufuPtAS06kYCW32bvRXw4zwQWXOLN3tbSEUEeVU=;
        b=oyabB2YsXmXlrAKOHFYfVUwGH5LOi9uMzkclioGNy135i6yFa8BFLuSTY7bh/z/OqU
         pJWChAVwQflvHjYI+Bj0QG+Mi8FLlW46OlB4pZNiBwPirkmXgyz0w7EJ54903NoFHuDC
         w4QR4d3y16b8PB7Q6EvpQa3JG8o9Fqaj6+ieWiKLUpx/wldMS+o8QTpBcHcc0TGySxkj
         i3Z/CR9kGJuyrvwtyivrZXsPLaU/ZwvTPNRTI1ox6ArFoCkaxQs2r5oaHSqQBuz0ZsgJ
         98IR/zOI44jbydNJRR57Z24o1Z8Jd27o+asylDbOlvwhizEZU+Up+iRLYLOOtAfs3Nfa
         RlzA==
X-Gm-Message-State: AO0yUKUBqpDJPmcJGbfp+hFWLn48MuDnb46m5YTi/pD3L0LHmSKJ8T+7
        UDH2HLjyvFEpyGD5/plBlqH69aSVpFeikwX/8sI=
X-Google-Smtp-Source: AK7set92ifzO1DbdC+L03gj5mmaMzfUPXcoBAQEqMHHsEm9ShVV1hRWskrlU80gTQwUtg9mksmYerA==
X-Received: by 2002:a17:90b:4b87:b0:238:b70:b94 with SMTP id lr7-20020a17090b4b8700b002380b700b94mr32701972pjb.11.1678608444969;
        Sun, 12 Mar 2023 00:07:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h5-20020a17090a648500b0023b15e61f07sm1988684pjj.12.2023.03.12.00.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 00:07:24 -0800 (PST)
Message-ID: <640d883c.170a0220.8d2a1.29f6@mx.google.com>
Date:   Sun, 12 Mar 2023 00:07:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.18
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 185 runs, 1 regressions (v6.1.18)
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

stable-rc/linux-6.1.y baseline: 185 runs, 1 regressions (v6.1.18)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1cc3fcf63192dfbf5ac13bc6134ae9120ebdcba6 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/640d50aec0cb0d5d2c8c8654

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.18/=
arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.18/=
arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d50aec0cb0d5d2c8c865d
        failing since 4 days (last pass: v6.1.15, first fail: v6.1.15-886-g=
7ff82f8ebd2b)

    2023-03-12T04:10:02.976274  + set +x
    2023-03-12T04:10:02.979999  <8>[   18.200184] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 147788_1.5.2.4.1>
    2023-03-12T04:10:03.095146  / # #
    2023-03-12T04:10:03.197501  export SHELL=3D/bin/sh
    2023-03-12T04:10:03.198132  #
    2023-03-12T04:10:03.299940  / # export SHELL=3D/bin/sh. /lava-147788/en=
vironment
    2023-03-12T04:10:03.300660  =

    2023-03-12T04:10:03.402457  / # . /lava-147788/environment/lava-147788/=
bin/lava-test-runner /lava-147788/1
    2023-03-12T04:10:03.403485  =

    2023-03-12T04:10:03.410239  / # /lava-147788/bin/lava-test-runner /lava=
-147788/1 =

    ... (14 line(s) more)  =

 =20
