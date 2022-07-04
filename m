Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563A7565FB7
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 01:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiGDXU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 19:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiGDXU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 19:20:57 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71134BC3F
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 16:20:56 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f85so6196502pfa.3
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 16:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rkdJ5eu96Pgk2Nqg6xrNlGdJNhCvW7s8XmLvwf2xiTg=;
        b=ZWYZ0oYReofdotTZgyQr4Hpw3nJKDy3yk1fVK1gBvOjcIXceUjsTE9bnouteXO/XgD
         7hBYv6M8Yb/HtkoMdu5sGTA7QFyzvICKLJ+Cfrj7sF15wPIpuGs8nnFIboLCp6VBVPYK
         TwdMOstVWo0Bs0AttMGchZnootWFO4+K3LPnbR4KibpXTh0jdsv+VAn1rc12ukPqKpom
         uYDW0O0bbeiSvrRA8U5AsHtcD2RXDS6MUtth+oU3Lqpnv3Urz27w/FLpVtMbBEB+6ett
         +yGoukZN+vSEVLBfX+eBEYf+/3MLYV6T4KLCf9zt/y5zgQ5RIJvz8ny3dZaqY8AhF+24
         5QXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rkdJ5eu96Pgk2Nqg6xrNlGdJNhCvW7s8XmLvwf2xiTg=;
        b=JIC2joLyUQEwAZ1t9l0QzMVNh2gnXVxGRn66MI760i+ukJQPbK92YxzgHRKyyrbi2y
         k1mk6CuIvfPJgXkpBNifnksSuJRKtQIR5krjTUijF8hDfDZ0WEWHe/SIUMijw+sC8GW/
         J2+7TfqU3dKW2v9HmXAUMH3aV/mWBu/U1dsV2bIdiuvxjkmQ1dBFOkREaIT1tbJQHgP8
         BRs9wwPDH0aq77IRVdWQdpqg7tG+IRd0niVSLl0HcX+eZNjxsXuL4BsFrZyNstr/fUAP
         NYcOYO/h1Fkzsqoi4azwBxZwqW2F38wPqJ4mHfQ0qh3b34mAGxembw205pHiHplsTji4
         +R2w==
X-Gm-Message-State: AJIora8OqETAXDVI5AS5F3Mp0hmrdYxXNLhDVl3Tl4F9r/pRXI5LJc9I
        AA7wTfs8Iyix908eJmu//KsozjJuN5/y9oKT
X-Google-Smtp-Source: AGRyM1sWjW0hzunXaBNY+2UgHmWGhUkvlKRd6RgMVK3odkmUvdp+3MaIXlXNJGCaDXAxZrhou5sARA==
X-Received: by 2002:a05:6a00:1808:b0:528:3ec:543a with SMTP id y8-20020a056a00180800b0052803ec543amr30229382pfa.70.1656976855763;
        Mon, 04 Jul 2022 16:20:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v63-20020a622f42000000b00528802070eesm404843pfv.17.2022.07.04.16.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 16:20:55 -0700 (PDT)
Message-ID: <62c375d7.1c69fb81.b8d1.094d@mx.google.com>
Date:   Mon, 04 Jul 2022 16:20:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.52
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 186 runs, 4 regressions (v5.15.52)
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

stable-rc/linux-5.15.y baseline: 186 runs, 4 regressions (v5.15.52)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
beagle-xm               | arm   | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig        | 1          =

jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =

rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.52/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      545aecd229613138d6db54fb2b5221faca10137f =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
beagle-xm               | arm   | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c343503e1c1a4df2a39c01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c343503e1c1a4df2a39=
c02
        failing since 53 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62c347966c0ccd9afaa39c2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c347966c0ccd9afaa39=
c2e
        failing since 6 days (last pass: v5.15.48-116-gadd0aacf730e, first =
fail: v5.15.50-136-g2c21dc5c2cb6) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62c3458af30768b2b4a39bd9

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62c3458af30768b2b4a39bfb
        failing since 118 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-07-04T19:54:42.974123  <8>[   32.240215] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-07-04T19:54:43.996580  /lava-6748558/1/../bin/lava-test-case   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/62c342e75845e715baa39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c342e75845e715baa39=
bdc
        new failure (last pass: v5.15.51-29-g49249bfc4d1b) =

 =20
