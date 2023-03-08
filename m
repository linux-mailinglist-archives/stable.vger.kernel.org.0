Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBC36B134B
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 21:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjCHUnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 15:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjCHUnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 15:43:23 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C07D5A92A
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 12:43:22 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id y2so63737pjg.3
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 12:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678308202;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+A3AtZti2PCqmdIYgNre4htS7aEfSODdk6XIsliXGR0=;
        b=NjjE44Cq+X+3ws4COGwfuUrlCOkJ/rp2yP4ci/PFnUpl8BA5guW/KBt0eggEKMmv6g
         BpHcKokqdAL2aMGxcFqVQ6v5F42oVXNw5enGVlcCJOFshcRNX1gDMCjaNOtRP0dwIVw4
         RhtsN194Tja3hWviZPIcKcryMGQO9vJaPhisHB0VquLkl99J6bDRmJVzsNPEgLAMHdv6
         HpGfVJU9LS5hYabZe/9To8ti/QbrL//Igc7ZG+Tpvq9LVnYFbN23WA2MNukb4OTh2t3Q
         9CUiMg2Nb1qeqoxZAyG+m+QxoyTJWiVBQTMGTRjiJPxgxvlJzrNvHIrJpCOgu90+tZAq
         +Z3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678308202;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+A3AtZti2PCqmdIYgNre4htS7aEfSODdk6XIsliXGR0=;
        b=xNo5P3JITDd3neghTpqMODmhATVXBXOPyJiVrMvGJIah8LboppGmR0pQyMHsASkZD+
         6m4qa6KAG4qvyRgL48+6cihDBYQTtZjbm5Bem/fhcgp2o6qHEUvry2tkf9B3rA9YjgQ8
         wiY2CQu6l1ZfgHXGVNWBF1VC6iC6xMnLF7paPV1l0i0WdJMpSHN7P1ZCHW0oog1Id1Wo
         8f6b3lloYYfDL7GF1dBxqc83dRLPnMhV+w4dMpnDXnj4/fEchhIrtTer/OED8FblNZGz
         evc48gzJudTi9AwNZiHj3e42BudkfLcBiIWywmkEnOPWE0WFcqttDpMvSTOyx0wBXDNB
         GRDg==
X-Gm-Message-State: AO0yUKVwA91v/QSymhKw/6uHyQdJWn/OG/phMkRW3uws4d6jUcngJ6F5
        lZicIrdBS/sKWGawmUST31pHjvqz2/TnecaSAgvyNw==
X-Google-Smtp-Source: AK7set/5bRmjrU7uKJt1EzKNzhsfPsE5B5pD570yhpFlVTdxJUQGX3eXSxtlJugWH5j7O+v5FlkGAg==
X-Received: by 2002:a05:6a20:5487:b0:c6:d37c:2a62 with SMTP id i7-20020a056a20548700b000c6d37c2a62mr26141306pzk.11.1678308201807;
        Wed, 08 Mar 2023 12:43:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13-20020aa7854d000000b00592543d7363sm9787036pfn.1.2023.03.08.12.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 12:43:21 -0800 (PST)
Message-ID: <6408f369.a70a0220.877c3.28bf@mx.google.com>
Date:   Wed, 08 Mar 2023 12:43:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-889-gbb4e875c8c41e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 179 runs,
 1 regressions (v6.1.15-889-gbb4e875c8c41e)
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

stable-rc/linux-6.1.y baseline: 179 runs, 1 regressions (v6.1.15-889-gbb4e8=
75c8c41e)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.15-889-gbb4e875c8c41e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.15-889-gbb4e875c8c41e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb4e875c8c41e8f41325722722e6a9cf02850f50 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6408bda4614c7460888c8671

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.15-=
889-gbb4e875c8c41e/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.15-=
889-gbb4e875c8c41e/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6408bda4614c7460888c867a
        failing since 0 day (last pass: v6.1.15, first fail: v6.1.15-886-g7=
ff82f8ebd2b)

    2023-03-08T16:53:39.501847  + set +x
    2023-03-08T16:53:39.505361  <8>[   17.716314] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 128033_1.5.2.4.1>
    2023-03-08T16:53:39.623183  / # #
    2023-03-08T16:53:39.726717  export SHELL=3D/bin/sh
    2023-03-08T16:53:39.727678  #
    2023-03-08T16:53:39.829492  / # export SHELL=3D/bin/sh. /lava-128033/en=
vironment
    2023-03-08T16:53:39.829931  =

    2023-03-08T16:53:39.932307  / # . /lava-128033/environment/lava-128033/=
bin/lava-test-runner /lava-128033/1
    2023-03-08T16:53:39.933677  =

    2023-03-08T16:53:39.939889  / # /lava-128033/bin/lava-test-runner /lava=
-128033/1 =

    ... (14 line(s) more)  =

 =20
