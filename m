Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7575975AC
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 20:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbiHQSZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 14:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbiHQSZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 14:25:09 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9029AFA3
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:25:08 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f28so12760304pfk.1
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=sKINvIimlWedvo7eqp8I6sjyXv0aJvhHm58z5XjOVWo=;
        b=49m7uyu5UHjUktsaPgPysqYue2+yzISnSGa2Z81KefLtnfmXQZbAHjiU5WxFJwOruA
         MId5VzZOv7mzgUp/q2uATDb+05QcFwRsBK0UsRaYO8VBv4A+aTz7JSLFVg13CvIOH8y9
         0PvspyP238E9JK9V7lTlpgtMl1gAol9Xr1bwo0ZGGRdgnAfDCBhDh6vh452cCFTuHBW4
         HwhY4ZMh0mtKVXgBn1yuByHlMpKRRsJtp/49zEtHsMqAAdhXCBRRcS1OWB8DTfRcW0MO
         5lGh5PjgwbDkkVTsP8J9dubVQ6KHpA4sZghnXSRfJQsVw3UrGictCDHIP0GFyejbWj+a
         rJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=sKINvIimlWedvo7eqp8I6sjyXv0aJvhHm58z5XjOVWo=;
        b=gQgI39c+s5eYFplaO3ZdHRG1YO2Ys5NN3riAIwv/v5hh6Felgo52MNxwO5nVfTKp4f
         UzVGkSGmvXRn30mAL0B+3TSqOMG9I1F+aeqzSFYmXmZc3MCOZcCiGOW7aYgGAbxP8CRJ
         qjHQhK9EIWWATQ5mIi91hLfLz1K9jIVyQumx1RUEqDdLFgonZQ8wLkj8LXtUdSjXSO7d
         gYz65PDdneQb+Gyehzu/n1bbnFf8IVKaO7bUFrcnsNoH/BmXmdLuVJUPuoCQ9Pw0XuAT
         i/pLFVXFxlJLj8/C7EcnekcPXSDCee7q7j8BBIuKNvQuhpVeHdFPWNZYuYPNXVdgYLd4
         eJdg==
X-Gm-Message-State: ACgBeo34UGdRiOuzl2scB9QB+dTFSvLHiTCfDZRU4r52eynFAQUo/wqv
        XGev/VrcxSPVWjSnAaFkhC9gp0YBtGCwGDnp
X-Google-Smtp-Source: AA6agR7GOZ8swaHXCrLZVFZtgboRsl0TnI7ZPq7ORLYzipc7KOUhMQJtb95OliUky8a6P8veeTF5jg==
X-Received: by 2002:a63:5359:0:b0:41d:b5a6:23c5 with SMTP id t25-20020a635359000000b0041db5a623c5mr22675356pgl.128.1660760707391;
        Wed, 17 Aug 2022 11:25:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c15-20020a17090a8d0f00b001f1694dafb1sm1844630pjo.44.2022.08.17.11.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 11:25:07 -0700 (PDT)
Message-ID: <62fd3283.170a0220.2ff3a.3011@mx.google.com>
Date:   Wed, 17 Aug 2022 11:25:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.17-1094-g7c0c8517a5443
Subject: stable-rc/queue/5.18 baseline: 121 runs,
 4 regressions (v5.18.17-1094-g7c0c8517a5443)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 121 runs, 4 regressions (v5.18.17-1094-g7c0c=
8517a5443)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie     | gcc-10   | bcm2835_defconfig =
 | 1          =

imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =

panda              | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =

rk3288-veyron-jaq  | arm  | lab-collabora   | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.17-1094-g7c0c8517a5443/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.17-1094-g7c0c8517a5443
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7c0c8517a54431dd06c887bdf31c7975fa93a74f =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie     | gcc-10   | bcm2835_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcfaedcbed512dc0355678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g7c0c8517a5443/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm28=
35-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g7c0c8517a5443/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm28=
35-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcfaedcbed512dc0355=
679
        failing since 0 day (last pass: v5.18.16-7-g7fc5e6c7e4db1, first fa=
il: v5.18.17-1094-g906dae830019d) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcfc830da3024b43355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g7c0c8517a5443/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g7c0c8517a5443/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcfc830da3024b43355=
656
        failing since 42 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
panda              | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcfe092d1eb74b8d355699

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g7c0c8517a5443/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g7c0c8517a5443/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcfe092d1eb74b8d355=
69a
        failing since 2 days (last pass: v5.18.17-134-g620d3eac5bbd1, first=
 fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
rk3288-veyron-jaq  | arm  | lab-collabora   | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd2eeec4adad44ed355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g7c0c8517a5443/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk=
3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g7c0c8517a5443/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk=
3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd2eeec4adad44ed355=
643
        failing since 2 days (last pass: v5.18.17-134-g620d3eac5bbd1, first=
 fail: v5.18.17-1078-g5c55e4c4afa02) =

 =20
