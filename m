Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21956BBD89
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 20:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjCOTqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 15:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbjCOTqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 15:46:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BBA7C965
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:45:47 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so3037721pjg.4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678909544;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Kdq1ej00dBX6Tb9V3Cm0DFDgBy+iCRAHfpE1a4POtIM=;
        b=5T+EmOVVrL5s/p+EHyUdYD9K7jgfjwsQ7Wy6ve2JSZUz3JVbzpSFD39qYWJEcmBSvF
         AJySj0rIL5LxMxxSDlnf1mbe++LNUoUTROjbm+FklZywIzpE4AMxVNGM6mGMy2+BzBpe
         SWI5wbbykFA9ibl4VyuTswXMyG8cM22VBBIL8hJ/SP5A1VyARdbpXmJ/F6tOcPX24S9i
         kmI0iKvsQ3/WtISdDB/ZUnkRGORy6SiLDGFVOZv+etCOEvGCZhwUgLlxOLqE9O8rDJoR
         1sViIPy5t2nLxLNR4FnhaBsMLFf2RVXWGOoQTROlUPKJOaEchYNqejg1iprRlIZ/KAYO
         8Nrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678909544;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kdq1ej00dBX6Tb9V3Cm0DFDgBy+iCRAHfpE1a4POtIM=;
        b=mLr+I+ibXY5B4R/vUFpeO+c1UUI+1OXMxFR7SELopnnwU2yKwDVs7OGs6gYDltNiYi
         YhzNXacKYl2JOA3xUNbH+py1Iqc8KPpOrKxBuytToqzJTjrtou0GxJdvcsMPGl5ALAJb
         fpN+hN6SmlLzQgjP31DRQl+gfjTcL2O4N3Zu41ORMTf8Atio1G21MUQfeK1d2gMov71q
         OtEd7kgXgUNe7m1O+gl5TovCAhybnRPrlZ7PDITI1axW7Boif8Lb4FGaGDjTwZ8gIMsm
         7fbb2ZIsYpqvSziZMb+YOKhvgEGlUzbSe6zMae1plxp6c4AWA0KkLMZQEPaAofmJlhRX
         KLkg==
X-Gm-Message-State: AO0yUKW/T4KJGta5NhvzEaRtE2XRnVxMJzhxhPvJt+eeuZhdM4917I6o
        P7WZK8geUdcec8I7GwvJPAjHy1jqLbEXrMCodvva06aO
X-Google-Smtp-Source: AK7set9nnwiBqTCtC6TDxY9fVGsvuPg0L/HQl1MvE0g8/stPsZ5+Ubm47ERj5IDW6Bj3mDxoSHhP5w==
X-Received: by 2002:a05:6a20:1604:b0:c7:1821:1b7d with SMTP id l4-20020a056a20160400b000c718211b7dmr1379635pzj.2.1678909544300;
        Wed, 15 Mar 2023 12:45:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s20-20020a635254000000b00502e20b4777sm3725574pgl.9.2023.03.15.12.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 12:45:43 -0700 (PDT)
Message-ID: <64122067.630a0220.859a7.8382@mx.google.com>
Date:   Wed, 15 Mar 2023 12:45:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.276-43-gae1ce2ac93b6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 60 runs,
 1 regressions (v4.19.276-43-gae1ce2ac93b6)
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

stable-rc/queue/4.19 baseline: 60 runs, 1 regressions (v4.19.276-43-gae1ce2=
ac93b6)

Regressions Summary
-------------------

platform         | arch | lab         | compiler | defconfig           | re=
gressions
-----------------+------+-------------+----------+---------------------+---=
---------
beaglebone-black | arm  | lab-broonie | gcc-10   | omap2plus_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.276-43-gae1ce2ac93b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.276-43-gae1ce2ac93b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae1ce2ac93b63e3a5e749d2bc075f77ca0b8fcad =



Test Regressions
---------------- =



platform         | arch | lab         | compiler | defconfig           | re=
gressions
-----------------+------+-------------+----------+---------------------+---=
---------
beaglebone-black | arm  | lab-broonie | gcc-10   | omap2plus_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6411ecde7224b22dbb8c8630

  Results:     41 PASS, 10 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.276=
-43-gae1ce2ac93b6/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.276=
-43-gae1ce2ac93b6/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411ecde7224b22dbb8c8662
        new failure (last pass: v4.19.276-43-g8bedf0e3bdb74)

    2023-03-15T16:05:20.563278  + set +x<8>[   17.685800] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 168068_1.5.2.4.1>
    2023-03-15T16:05:20.563635  =

    2023-03-15T16:05:20.673929  / # #
    2023-03-15T16:05:20.776163  export SHELL=3D/bin/sh
    2023-03-15T16:05:20.776666  #
    2023-03-15T16:05:20.878267  / # export SHELL=3D/bin/sh. /lava-168068/en=
vironment
    2023-03-15T16:05:20.878786  =

    2023-03-15T16:05:20.980431  / # . /lava-168068/environment/lava-168068/=
bin/lava-test-runner /lava-168068/1
    2023-03-15T16:05:20.981432  =

    2023-03-15T16:05:20.985824  / # /lava-168068/bin/lava-test-runner /lava=
-168068/1 =

    ... (12 line(s) more)  =

 =20
