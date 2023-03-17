Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75746BEF76
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 18:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCQRTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 13:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjCQRTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 13:19:46 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3202611651
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 10:19:44 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso9728138pjb.3
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 10:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679073583;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GPeZh3MT0h/T/SVXJSTNfYTV8AgCCOIgMb+PN/5KqaU=;
        b=xEqgIecpg8m+MqtBz40H3KgEzHXsUa4k2iC6IaKDucv+EQE1Q+Vm0XjZuNzhENP73l
         c3E7LxIwj+X7OnZxnohXf2iCSRlSKtoeYgevoL8a2HvCeT+3WtF+ZJOj0mOy0LD3/vq+
         hECQbgpfdYJWg0mgru59ZkdyfDMYWSf02+j7nePn69pxIQwyK2CPiV9BxMPFn2CRW+gu
         tIrEF8f0mUytDERPO20JKU06/ep9liFq701XSU8rR/KsyW0qlHz69BzJ3JXgTXhr2sRi
         rZchYi3LqAzznHq5yXNTf1RU3mY9l4i04q8NTWcjflABZWOmJ2mlMQRsibE36EQup1hh
         yC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679073583;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GPeZh3MT0h/T/SVXJSTNfYTV8AgCCOIgMb+PN/5KqaU=;
        b=s6f/sXxUqnoS+0a3xIqnBDFYk3+EZgBoC62GP+xLKIiCbi0eahz7ENREWc9PjKWVCd
         l9BKfAF1MIF7gY4IaOo3Enm1Rdcw/CrT4YSA+1l6Su/a2/2aG7D5nbfPX0pROllB6r8f
         knf6oxrh2/7zpo72XgAYA/OwTmUpK7a2ULSLxTzbG6GopDUtGFaFHkeX6uaApf2fr3y8
         9uLp7Fus4nDxSsJO8QOjCkYTQtlGlWDrR4IeH6YFFwqxyHTcHZulQuwsg7Q1euzyLjvI
         IOt0RmEoS7dryU2StuMPrsPvTVRvZYSTuK6QE5tmabUUJH/NesRQ/rgRZ8q+6AuH6dZO
         jY1g==
X-Gm-Message-State: AO0yUKUD03gmH987UvZQSVk21CpRIfXqC3anSffX2l/ieFBSd9lbYb8A
        zbMcdwfnWI7UnxEICaJqLVDA5m0WxFJVql9VU5k49A==
X-Google-Smtp-Source: AK7set+Sc7M0LzyRdZICIfDMUXdNNvilLa2ReZarrCRlZMV0YVT8lQ9X3qfMy6e0lUVpg991uq+wMA==
X-Received: by 2002:a17:902:e887:b0:19f:e9e7:4cb with SMTP id w7-20020a170902e88700b0019fe9e704cbmr9627859plg.45.1679073583102;
        Fri, 17 Mar 2023 10:19:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v3-20020a1709028d8300b0019a6e8ceb49sm1775123plo.259.2023.03.17.10.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 10:19:42 -0700 (PDT)
Message-ID: <6414a12e.170a0220.18f77.3df6@mx.google.com>
Date:   Fri, 17 Mar 2023 10:19:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.103
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 243 runs, 3 regressions (v5.15.103)
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

stable/linux-5.15.y baseline: 243 runs, 3 regressions (v5.15.103)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig             =
       | regressions
----------------+-------+---------------+----------+-----------------------=
-------+------------
cubietruck      | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig    =
       | 1          =

fsl-lx2160a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig             =
       | 1          =

mt8173-elm-hana | arm64 | lab-collabora | gcc-10   | defconfig+arm...ok+kse=
lftest | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.103/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.103
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8020ae3c051d1c9ec7b7a872e226f9720547649b =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig             =
       | regressions
----------------+-------+---------------+----------+-----------------------=
-------+------------
cubietruck      | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/64146c8f34a3ae23748c8654

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.103/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.103/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64146c8f34a3ae23748c865d
        failing since 57 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-03-17T13:34:49.305191  + set +x<8>[   10.036331] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3420751_1.5.2.4.1>
    2023-03-17T13:34:49.305731  =

    2023-03-17T13:34:49.411843  / # #
    2023-03-17T13:34:49.515268  export SHELL=3D/bin/sh
    2023-03-17T13:34:49.516252  #
    2023-03-17T13:34:49.618420  / # export SHELL=3D/bin/sh. /lava-3420751/e=
nvironment
    2023-03-17T13:34:49.619278  =

    2023-03-17T13:34:49.721209  / # . /lava-3420751/environment/lava-342075=
1/bin/lava-test-runner /lava-3420751/1
    2023-03-17T13:34:49.722945  =

    2023-03-17T13:34:49.727866  / # /lava-3420751/bin/lava-test-runner /lav=
a-3420751/1 =

    ... (12 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig             =
       | regressions
----------------+-------+---------------+----------+-----------------------=
-------+------------
fsl-lx2160a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig             =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/64146b7af5d8e8d07e8c87c0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.103/=
arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.103/=
arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64146b7af5d8e8d07e8c87c7
        failing since 14 days (last pass: v5.15.79, first fail: v5.15.97)

    2023-03-17T13:30:26.449307  [   10.616395] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1176556_1.5.2.4.1>
    2023-03-17T13:30:26.555100  / # #
    2023-03-17T13:30:26.657002  export SHELL=3D/bin/sh
    2023-03-17T13:30:26.657422  #
    2023-03-17T13:30:26.758673  / # export SHELL=3D/bin/sh. /lava-1176556/e=
nvironment
    2023-03-17T13:30:26.759229  =

    2023-03-17T13:30:26.860654  / # . /lava-1176556/environment/lava-117655=
6/bin/lava-test-runner /lava-1176556/1
    2023-03-17T13:30:26.861408  =

    2023-03-17T13:30:26.863171  / # /lava-1176556/bin/lava-test-runner /lav=
a-1176556/1
    2023-03-17T13:30:26.881232  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (13 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig             =
       | regressions
----------------+-------+---------------+----------+-----------------------=
-------+------------
mt8173-elm-hana | arm64 | lab-collabora | gcc-10   | defconfig+arm...ok+kse=
lftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64146b89db49d63ae38c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.103/=
arm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt=
8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.103/=
arm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt=
8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64146b89db49d63ae38c8=
653
        failing since 52 days (last pass: v5.15.89, first fail: v5.15.90) =

 =20
