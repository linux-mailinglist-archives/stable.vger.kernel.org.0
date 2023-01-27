Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE8667E0EB
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 10:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbjA0J75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 04:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbjA0J7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 04:59:50 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF13F1717F
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 01:59:47 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id lp10so4109838pjb.4
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 01:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gEGPLZEuxEjJcJbIWLQANzv7iRUrTzHkKONZD1XH8xA=;
        b=gjnFFUxlIHTfWyhqiZGUl30tSAAf+U4C5WPCq2jbpwX6JcgT+lFi8BxfeOa7DBVTZZ
         y4PtkfaJ+npemeLPJtjic3fReg5jtJ0fEfF+dz7KA4sza0WOmurpSWKhAhesuB/HGA9u
         5fLAVsFHDQV001ywUy1YhILHQDA1m+h4LNQQR1KS42ukPp3ylOcTHjk8bu38r4FJuOqO
         APc1knHqtuvZ5J9MadZU2X50ghFz29S62XZvS5n4VBIpnUebd1KSvXqQlnB/zdHVf+tm
         8x0vtb4Z4gMY31vSOILZX39MAsLhQj/G/VsZro5lgJAqYr/U1dhv1xo/i6Puyi4yQ2aQ
         w8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gEGPLZEuxEjJcJbIWLQANzv7iRUrTzHkKONZD1XH8xA=;
        b=Gx5HJ4bfT9cDqQYrjku1mBViarTluAXw1YrtivgY0QPVhlGmC00MlJkHgKRZQN8uag
         Ny9S/I42a2TKqf9cdvQfvef/gXq0XRcD/Et2G3tlwgdJLNKk+WWAjAPmkVwxptP9to3m
         nTxo3hZTQsT8gS63DciW3yyezroT/D7S3cazq5VhicLCeVyguB44zwK80F75fC37g9MB
         gsZ8n7OOjPsHFT7PrXRYe3eR4+spatORSsrh0Vkck6SZRGwR/oNuBlr2N7sGn14+yafI
         KU6qykvtnKzSREQZSA3TEZTUe4K9ryyoeCFFA5SkeiXEUBQEpluECA59NTc8PT3LeJDN
         loIw==
X-Gm-Message-State: AFqh2kpq2fIH1KpLop6ggxDhdyXaa1wvMrRBjcB56f3wU+Jqy9xcnEJk
        NmwXcs4eVSK45mTwKbmDWwANideRiiwkw7CRto4=
X-Google-Smtp-Source: AMrXdXtVNhaP6GiMvvSB4vV1Fdx610BqRJX2F0XUxVNgeKZVdVRe14cKUDDYyfEvJyQIRBtBtQewrA==
X-Received: by 2002:a17:903:22c1:b0:194:a662:259 with SMTP id y1-20020a17090322c100b00194a6620259mr48279990plg.63.1674813586950;
        Fri, 27 Jan 2023 01:59:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c13-20020a170902c1cd00b0019498ee0cf4sm2435937plc.109.2023.01.27.01.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 01:59:46 -0800 (PST)
Message-ID: <63d3a092.170a0220.60a7b.40a7@mx.google.com>
Date:   Fri, 27 Jan 2023 01:59:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-144-g699ffcc59544
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 170 runs,
 4 regressions (v5.15.90-144-g699ffcc59544)
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

stable-rc/queue/5.15 baseline: 170 runs, 4 regressions (v5.15.90-144-g699ff=
cc59544)

Regressions Summary
-------------------

platform               | arch  | lab           | compiler | defconfig      =
    | regressions
-----------------------+-------+---------------+----------+----------------=
----+------------
cubietruck             | arm   | lab-baylibre  | gcc-10   | multi_v7_defcon=
fig | 1          =

rk3399-rock-pi-4b      | arm64 | lab-collabora | gcc-10   | defconfig      =
    | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre  | gcc-10   | defconfig      =
    | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie   | gcc-10   | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-144-g699ffcc59544/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-144-g699ffcc59544
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      699ffcc595445b0fea576d85d342ce1a52859d29 =



Test Regressions
---------------- =



platform               | arch  | lab           | compiler | defconfig      =
    | regressions
-----------------------+-------+---------------+----------+----------------=
----+------------
cubietruck             | arm   | lab-baylibre  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36c091f41f35f57915ee8

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
144-g699ffcc59544/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
144-g699ffcc59544/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d36c091f41f35f57915eed
        failing since 9 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-27T06:15:20.728748  <8>[   10.000016] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3224726_1.5.2.4.1>
    2023-01-27T06:15:20.837907  / # #
    2023-01-27T06:15:20.941568  export SHELL=3D/bin/sh
    2023-01-27T06:15:20.942929  #
    2023-01-27T06:15:21.045464  / # export SHELL=3D/bin/sh. /lava-3224726/e=
nvironment
    2023-01-27T06:15:21.046856  =

    2023-01-27T06:15:21.149423  / # . /lava-3224726/environment/lava-322472=
6/bin/lava-test-runner /lava-3224726/1
    2023-01-27T06:15:21.151234  =

    2023-01-27T06:15:21.157996  / # /lava-3224726/bin/lava-test-runner /lav=
a-3224726/1<3>[   10.433582] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-01-27T06:15:21.158748   =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab           | compiler | defconfig      =
    | regressions
-----------------------+-------+---------------+----------+----------------=
----+------------
rk3399-rock-pi-4b      | arm64 | lab-collabora | gcc-10   | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36bd6e4236d0812915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
144-g699ffcc59544/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
144-g699ffcc59544/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36bd6e4236d0812915=
ed3
        new failure (last pass: v5.15.90-123-gf7d108c8efd6) =

 =



platform               | arch  | lab           | compiler | defconfig      =
    | regressions
-----------------------+-------+---------------+----------+----------------=
----+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre  | gcc-10   | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3777719318dfb89915f00

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
144-g699ffcc59544/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
144-g699ffcc59544/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d3777719318dfb89915f05
        failing since 9 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-27T07:03:34.553983  + set +x
    2023-01-27T07:03:34.558039  <8>[   16.086407] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3224707_1.5.2.4.1>
    2023-01-27T07:03:34.678623  / # #
    2023-01-27T07:03:34.784478  export SHELL=3D/bin/sh
    2023-01-27T07:03:34.786012  #
    2023-01-27T07:03:34.889634  / # export SHELL=3D/bin/sh. /lava-3224707/e=
nvironment
    2023-01-27T07:03:34.891235  =

    2023-01-27T07:03:34.994703  / # . /lava-3224707/environment/lava-322470=
7/bin/lava-test-runner /lava-3224707/1
    2023-01-27T07:03:34.997500  =

    2023-01-27T07:03:34.999790  / # /lava-3224707/bin/lava-test-runner /lav=
a-3224707/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab           | compiler | defconfig      =
    | regressions
-----------------------+-------+---------------+----------+----------------=
----+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie   | gcc-10   | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36b5eaab846511c915ee7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
144-g699ffcc59544/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
144-g699ffcc59544/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d36b5eaab846511c915eec
        failing since 9 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-27T06:12:33.697316  + set +x
    2023-01-27T06:12:33.701277  <8>[   15.975645] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 190758_1.5.2.4.1>
    2023-01-27T06:12:33.812145  / # #
    2023-01-27T06:12:33.914508  export SHELL=3D/bin/sh
    2023-01-27T06:12:33.915027  #
    2023-01-27T06:12:34.016523  / # export SHELL=3D/bin/sh. /lava-190758/en=
vironment
    2023-01-27T06:12:34.017235  =

    2023-01-27T06:12:34.118889  / # . /lava-190758/environment/lava-190758/=
bin/lava-test-runner /lava-190758/1
    2023-01-27T06:12:34.119863  =

    2023-01-27T06:12:34.123949  / # /lava-190758/bin/lava-test-runner /lava=
-190758/1 =

    ... (12 line(s) more)  =

 =20
