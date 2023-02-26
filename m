Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5976A3435
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 22:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjBZVAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 16:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBZVAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 16:00:01 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA2D14EA7
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 12:59:55 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so4302928pjp.2
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 12:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RyrtmDpmnRvbaO6XNft8SeDYVR1r5UBBKuKvTBFaqfA=;
        b=Xsjr3aMFpxDYtzCpnQ4JnXErjT2f1b+x/7VZOw2qfbUUMeTf89ajoQ2WCVUR/1woFx
         DlmBcGl/oUc3uQLbTLoDJOtbF7cwZrTZec8VTZJQqX98F/cJ62utp//jG0Bow7E5wGW6
         UNsPDG9tmdLJuj03PbSIrojyqc4dxk3y2WyUAMwJhRg2maw15T0hA+yQNzbbdEN4gNpE
         Q2223Gf9QrrAIkiqeXHhG+7J6v9zD7pGOnLNUWhzqhYwbWgVCm4wfXR54pRZ8tjSAwI3
         Ex5y8sF+bfYjH+bI42dbdiQPAJIi66D91GgyDdr3kpkOoSAV24lzxegJxt2D22BtoE44
         g9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RyrtmDpmnRvbaO6XNft8SeDYVR1r5UBBKuKvTBFaqfA=;
        b=DkdyY2l1HlOuKuwbY23TP0AAAjeNLiA9xCfZX4M3+w5o2XlRqbNF6hUCqsKgJpnxWB
         KR6Y/hBJzpXCjk7R/lmD83uh4SUY/kBl1eNfuDbBj7W0odeDAp4k8ZoxUFUClJ3jbjm2
         dzbU/NoW175tB6VYrraSa4B7GhWEaclHs3KiynPRTG4Uuy6T1gQgOZV7aHGRnm+jgkRR
         cAJXASAhmr/L8MEOmFBhQTLqmV4RiXaf6PCpfqR478N91ujdX6rT5NmO+9dE6pX9AhhJ
         QzJg/4JGNDXhN9ep2dNOLsEHPW+qFnlFDPphnDh1pkTo21OpQanmGyTZtNrvg6feT7es
         6SMA==
X-Gm-Message-State: AO0yUKXPS5s7tJfJ1R7OO2ZS1HMb6ZnrGLtLb9vohsd1RvD8KN7kPuGT
        i9jtWPrk+zGupjyuuq7Z4s0D1YIHc2qXmWxo
X-Google-Smtp-Source: AK7set/K0uG+e1eXsOICluqdpp9JMv/lLtNLjkZ2KzmymEXrhwyN7lwnrpxHUwKrZHPoOUEvPhgheg==
X-Received: by 2002:a17:903:42ce:b0:19c:e842:5ebf with SMTP id jy14-20020a17090342ce00b0019ce8425ebfmr5712908plb.9.1677445194606;
        Sun, 26 Feb 2023 12:59:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a2-20020a170902ee8200b0019926c7757asm3027172pld.289.2023.02.26.12.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 12:59:54 -0800 (PST)
Message-ID: <63fbc84a.170a0220.b4bd9.44f2@mx.google.com>
Date:   Sun, 26 Feb 2023 12:59:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.14-24-geb03a39b11de4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 171 runs,
 1 regressions (v6.1.14-24-geb03a39b11de4)
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

stable-rc/queue/6.1 baseline: 171 runs, 1 regressions (v6.1.14-24-geb03a39b=
11de4)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.14-24-geb03a39b11de4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.14-24-geb03a39b11de4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb03a39b11de4fcdcecb8f76c4cc35ced251723b =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63fb90ce9a496952d38c865d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.14-24=
-geb03a39b11de4/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.14-24=
-geb03a39b11de4/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63fb90cf9a496952d38c8666
        failing since 1 day (last pass: v6.1.13-47-ge942f47f1a6d, first fai=
l: v6.1.13-47-g106bc513b009)

    2023-02-26T17:03:04.045241  + set +x
    2023-02-26T17:03:04.047910  <8>[   16.122906] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 78469_1.5.2.4.1>
    2023-02-26T17:03:04.163918  / # #
    2023-02-26T17:03:04.266856  export SHELL=3D/bin/sh
    2023-02-26T17:03:04.267563  #
    2023-02-26T17:03:04.369364  / # export SHELL=3D/bin/sh. /lava-78469/env=
ironment
    2023-02-26T17:03:04.369743  =

    2023-02-26T17:03:04.471177  / # . /lava-78469/environment/lava-78469/bi=
n/lava-test-runner /lava-78469/1
    2023-02-26T17:03:04.471581  =

    2023-02-26T17:03:04.479149  / # /lava-78469/bin/lava-test-runner /lava-=
78469/1 =

    ... (14 line(s) more)  =

 =20
