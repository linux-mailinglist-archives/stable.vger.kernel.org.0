Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FB74EA14F
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 22:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbiC1UV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 16:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239886AbiC1UV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 16:21:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137983DA48
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 13:19:47 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id y16so2528483pju.4
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 13:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ydm9vX98065TawJ3gqAPM+joTIFnw27sksr4LtudQ7c=;
        b=izPNXS1MJ0Bz5tWLVQFWv7D9tejh+3pm1LRdO9eUBcjKj83gJ9sj9M2YGmnVEfRwq3
         10PJgVgmp3zjrNma7v0Jg2Vs6XM8qlL29mzM/EJ48fRfGZyyflNJf3QzxAh81+ASdR3r
         qmPSTan2xeTFE9iaJ8X5R7e2ggn2RDHnQ23z70sEWsGgdB70Qpx2Npzug1D/neReBU+q
         YJI8Sx6Hgs5jy8VPbVafeKMzPnQUMan4A12iElc+cVnNHbn4wY+GCAHcSsJM8R5hsjgx
         sKXUC0s0MAROJ0dLf10BZyTJxo5FASIkRMfgae3ft6vkJAd1sx/QFau/dFVQcmPcfgDT
         QZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ydm9vX98065TawJ3gqAPM+joTIFnw27sksr4LtudQ7c=;
        b=b+uEWpLCtj3KS/LHofRDHBeooY7hr74dx6uC3a3KJUDGuZQHjpVS4I0Sq3/uswl+FM
         NFyMl6ZSDy5vHpp4PzxtATP1O6mIMXvIkX+bAOe1GRFug2pLQGbHRf8wMLJS+2YJAhme
         gLDP01Yb1Yyh0MzRnQjDukBzQ9tRfH4ueqd8jOL5PfJ3lamGqcLgDUFjZuwtKrll7Ivl
         2pkbcJwfAbSAApqJ2Kje11hwosXIoui+lCH2P+jpPeIEQM0aolwW6dymlTjvCeITup4d
         Nqr2AaxkDq1V6eLboGzhid3Tr+DbIdUIffwypclwUFoPC/ErjFrkLi+OlLSbtfP8oeWf
         93eg==
X-Gm-Message-State: AOAM530ba/Ya67aa0t4gzlP16mh2TKZv4mSNEMSqg77LAum7/8Jl3jpq
        wBNTGD9KORaG8iR2n0vFkb/++llzKgDKQybY6vc=
X-Google-Smtp-Source: ABdhPJzddhJ2OXGaRfvbW6sBKX47neB4fpK3dnZpeUStZj3Grk6504MdzPQH1Q0VPzPKwMHg2PPJ8Q==
X-Received: by 2002:a17:902:e84b:b0:154:6222:98ad with SMTP id t11-20020a170902e84b00b00154622298admr27606173plg.26.1648498786475;
        Mon, 28 Mar 2022 13:19:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o24-20020a17090a5b1800b001c6aaafa5fbsm345625pji.24.2022.03.28.13.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 13:19:46 -0700 (PDT)
Message-ID: <62421862.1c69fb81.f34d5.1878@mx.google.com>
Date:   Mon, 28 Mar 2022 13:19:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.274-9-g8dc373232be9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 59 runs,
 1 regressions (v4.14.274-9-g8dc373232be9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 59 runs, 1 regressions (v4.14.274-9-g8dc3732=
32be9)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.274-9-g8dc373232be9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.274-9-g8dc373232be9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8dc373232be900bbaf7264915946a97feab3a05c =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6241e5985c5d24b12eae0693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.274=
-9-g8dc373232be9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.274=
-9-g8dc373232be9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241e5985c5d24b12eae0=
694
        failing since 43 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
