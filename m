Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA796C5D25
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 04:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCWDYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 23:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCWDYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 23:24:00 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB5FB449
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 20:23:59 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso655134pjb.3
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 20:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679541839;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=F1IfMCSEuJQ98faPKAcG5l7AT9XhVHvDuU2iU4KJgwI=;
        b=u2UQAjZZmwNIasc9zr8T0wMm7QKVn9mjxT1rTYGELPWHC98/VXGnyysux7ggdTYlR6
         VlyLOIAEYa87MY3RwU6CGnS96foceHuEEVpoU+AQ4+9V4lXQfNAdj6PykxBHjMtiKg9q
         dtuflEUCaZaxv+/ejw50myXsgajVDl+vwupVJbxPTsQbSDv6oLcKMqB29Wd2PfPovhUe
         MnXNmAc6NKlT8ybvUw297Z60QnrD2hole/IxIZ4B3ahfpZ73VowZ9bQXqt6qJULsFmvt
         p5rKFjfxGBQsh/dYvvHP2TTCsAXjQTaVgCzeY38Di1UFpjdE3VFrje5S1TnIgAc3UyHp
         Sqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679541839;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F1IfMCSEuJQ98faPKAcG5l7AT9XhVHvDuU2iU4KJgwI=;
        b=pcf5p+pyKF5H6D7h9OKvjmquezUm1UAHBLYROfA0ZWKEZHkeJpr/I0iF2Y6Bbhff8Y
         Y6fQvlVoGoWqT9oP8q9bzCtRbzhjcq8Iw53Ec1t6yXdGCjY5HYqpuh4pz2zcIn8Q3mgh
         6m5f+sWrmyn6jB3huX1NcrI5aFYc9WQtk+c9jN4CbFAIDneDZEdcqAXbuQc32WksDatR
         Z0a2G0utqt+xXi39HN5GkzYzZsj5o1CRAC5n6xbIhMcMjSCokAnwieOQv8U6I73VBK0i
         wEBF9DVUxmcPPQ6UP2DB0DDqvCDlXx8JBbCj6MXzFjlGhiUw/2wRHbX4mX1Ep2uuVdOK
         hjzw==
X-Gm-Message-State: AO0yUKUkqHc98kO+ev+5b3ZsSUlLbiuYp8XzmxIB3ZNR3tLnOgHMB6L8
        /Aoc+vN6cvlfb0KMNFiu97q8PmW4+5d5Ve3kL3C8SQ==
X-Google-Smtp-Source: AK7set8w7Rx6bqOEVi9OyWwlNc8dX3hM0GgeF+fyNiL6/q53GL6NVcWdthys55CjNHwnhVTNt/6DIg==
X-Received: by 2002:a17:902:e545:b0:1a0:42c0:b2a5 with SMTP id n5-20020a170902e54500b001a042c0b2a5mr5445486plf.24.1679541839039;
        Wed, 22 Mar 2023 20:23:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y21-20020a1709029b9500b0019b0937003esm11311155plp.150.2023.03.22.20.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 20:23:58 -0700 (PDT)
Message-ID: <641bc64e.170a0220.1769d.4acb@mx.google.com>
Date:   Wed, 22 Mar 2023 20:23:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104
Subject: stable-rc/linux-5.15.y baseline: 182 runs, 1 regressions (v5.15.104)
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

stable-rc/linux-5.15.y baseline: 182 runs, 1 regressions (v5.15.104)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.104/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.104
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      115472395b0a9ea522ba0e106d6dfd7a73df8ba6 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/641b9216d92e59470b9c9512

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b9216d92e59470b9c951b
        failing since 64 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-03-22T23:40:57.548911  + set +x<8>[    9.985492] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3436214_1.5.2.4.1>
    2023-03-22T23:40:57.549622  =

    2023-03-22T23:40:57.659073  / # #
    2023-03-22T23:40:57.762348  export SHELL=3D/bin/sh
    2023-03-22T23:40:57.763396  #
    2023-03-22T23:40:57.865556  / # export SHELL=3D/bin/sh. /lava-3436214/e=
nvironment
    2023-03-22T23:40:57.866557  =

    2023-03-22T23:40:57.866993  / # . /lava-3436214/environment<3>[   10.27=
3449] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-03-22T23:40:57.968997  /lava-3436214/bin/lava-test-runner /lava-34=
36214/1
    2023-03-22T23:40:57.970808   =

    ... (13 line(s) more)  =

 =20
