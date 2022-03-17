Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D42B4DBD7B
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 04:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiCQDXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 23:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiCQDXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 23:23:06 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC3F27CC2
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 20:21:50 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g19so5729182pfc.9
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 20:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y7dIRSs7dzFLmX2bc2DOvRrp9twNQX3Gnht0cS71MH0=;
        b=wwIQto4/ByqhUnMdRYUK3wwugeNeatZRGe+5KWx+vcbwudXVm6+UqM8ul94ceQbt3K
         UMqqcLdNxl4j9IOK4cDuBXaF3VAWXr6psjvuPLxjzZcSPpxZDIDjJ2iQCPeQNHXMaxCb
         6IJhxb6kxacbSlyl/+XwqEiO1rIPOyKe9Csb4ZdnRmpazSbg07LDCPFCvHZ8d7gY4Ku+
         GhG56Q00Qc8l2xXF1NV+hxIYwJCBNacEwFG2rj56E0taEUXgdB4CpEGcEicG4g1P1E7b
         Orxf9NQp36kHjRI53RQnmkVhKLInSJYmcg2BhafV8iEHA1+SrcYhndqecZ1Mbe3aNKQc
         QtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y7dIRSs7dzFLmX2bc2DOvRrp9twNQX3Gnht0cS71MH0=;
        b=iiOZhvzEhSMffPmHxh66nZTM2UrOYCBIz1/MkJFxUH6SIccpyV8PZqGR/XT1I0ZaJq
         B3y7dajXCZpBurgdEwtL6XMftpfKjHz3gY0LEIfornsfl/DL4JVWJGunREqCsKu+twsU
         Fl5y/5R6AFpq9XOoc/tyBraUIgLP4wn0w/24R+ionQ61qEbl8zZFRsjhzmuqpR8pjS1V
         672AM8OIBBWKOyFjV7+lTBblnMJBKImU3KTjqd6ZeYbb/j06Z1ZccKV3ziPkjfjNwbVB
         NHXRefGYN8+DEHNQWh1OFt0V0cxQiGMqTZqvit/+eDQGkbdu63QU58JGfFlgrxfLDHDi
         sBRw==
X-Gm-Message-State: AOAM531/3kr3U7Q0k8j9yVA+AfqbKPw0/Jx4RztBpDvfK7tB685dTjTq
        OaYTGXqPSxv3AZhrTAitr0Grd9I2tT1Sfx4FoKw=
X-Google-Smtp-Source: ABdhPJw/erTUhd8AyE194lJoK3KDsBtbqm6DkALLxWiaDoH1gGYx6onknN52vI5ax9rs56+gnkBUBg==
X-Received: by 2002:a05:6a00:1350:b0:4f7:8c4f:cfca with SMTP id k16-20020a056a00135000b004f78c4fcfcamr2345405pfu.45.1647487309861;
        Wed, 16 Mar 2022 20:21:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5-20020a056a00240500b004e15d39f15fsm4906486pfh.83.2022.03.16.20.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 20:21:49 -0700 (PDT)
Message-ID: <6232a94d.1c69fb81.4e365.d367@mx.google.com>
Date:   Wed, 16 Mar 2022 20:21:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.29
Subject: stable-rc/linux-5.15.y baseline: 69 runs, 2 regressions (v5.15.29)
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

stable-rc/linux-5.15.y baseline: 69 runs, 2 regressions (v5.15.29)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.29/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.29
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b9a0208cb3e3e37def2abe4d602f084e0f746419 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6232762850d0166ebdc6296c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6232762850d0166ebdc62=
96d
        failing since 55 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6232796b5573c236edc6297c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6232796b5573c236edc629a2
        failing since 9 days (last pass: v5.15.26, first fail: v5.15.26-258=
-g7b9aacd770fa)

    2022-03-16T23:57:11.711673  /lava-5894438/1/../bin/lava-test-case
    2022-03-16T23:57:11.722776  <8>[   33.439428] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
