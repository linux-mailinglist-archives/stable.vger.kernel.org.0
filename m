Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5CD53D7EB
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 18:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238765AbiFDQnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 12:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbiFDQne (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 12:43:34 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE03BE14
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 09:43:33 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x4so865814pfj.10
        for <stable@vger.kernel.org>; Sat, 04 Jun 2022 09:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mSuABO0BSsuD3VdiBkJFrxYFRT/psouiFmEVh1kGkPs=;
        b=6yaqU3W1wCCsHQWNU70eLudCGFtffopySNF+uYOmUUoqQF2WE08vNnjSpqM/RaobHx
         UpTFeAo4fIfRVZC2aqj73RhHUeSEaNNyxGGqArJxCL3Mzcr2boDot55pB10sfdXwAW1T
         845Km56eQCfdLwOJDQnyATMfqBB8sa4uT4MnR+ZEBfOne9uxhgcp9Qc2qwh3s4xharG0
         2fWFRqIullm14+N1phvITv+CVoSpot3WgPvtBerHvkiBZRnLoyvjxIHDzuA6mIep5abt
         jna5GHIVPua2mHPy7pNiSJLqYyEzzNhumBlXeTw35YT9yN0TMFgugKUYGvWf0IFMIL3m
         tQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mSuABO0BSsuD3VdiBkJFrxYFRT/psouiFmEVh1kGkPs=;
        b=M9oT+iwEcN8yhmD45p33t3gKtt4zE6RiiJKfzjyJ90alBGiBYWmzA7rkf1IyjMkmyu
         O7bK+N3Yc/xjhVsSihZKoLcKVI5VeVJnkw1LTAvEgE2E3AsSjiluYFRrzA4qrxYpVifP
         KbLXdP5/Y52yn+fSrvjzgszOk6PgGOVQ+63N/ygsL5wIyVH4ROwojs5maEvX0g77L+FZ
         KTDehCvZ6x/GW24gkcQ5iFWQFLGg5fePmfB47gwO1cr5qtoCY753yivqAALG+aioQHZ5
         u4KDoR5KQ52ZrgDp8TuV/zITIxjYv+A/UXCBGa7gjXPwSZBSHvuSq53moKDskn0YRrT0
         z9Ww==
X-Gm-Message-State: AOAM532L9o5j43gYtSBOzNfQ0op0oFpVq6MK8qR035WcI0axdEbzIcof
        g9Lif1lyrEbnrsvFjJGI6zVZVzGL00DSWW3d
X-Google-Smtp-Source: ABdhPJzCWJKaQ08mPLqJWc8OZUldODUemxQ3PvBIzG7hmXyR76sozMT3Kc9fJrYR2Ueqr8TkEETH6w==
X-Received: by 2002:a05:6a00:1744:b0:51b:d4d5:f34 with SMTP id j4-20020a056a00174400b0051bd4d50f34mr11404006pfc.0.1654361013244;
        Sat, 04 Jun 2022 09:43:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10-20020a17090332ca00b001664bc2e2e6sm4570188plr.154.2022.06.04.09.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 09:43:32 -0700 (PDT)
Message-ID: <629b8bb4.1c69fb81.855d2.9522@mx.google.com>
Date:   Sat, 04 Jun 2022 09:43:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.11-186-g31ab69ffae8a1
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 120 runs,
 3 regressions (v5.17.11-186-g31ab69ffae8a1)
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

stable-rc/queue/5.17 baseline: 120 runs, 3 regressions (v5.17.11-186-g31ab6=
9ffae8a1)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.11-186-g31ab69ffae8a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.11-186-g31ab69ffae8a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      31ab69ffae8a183c5404e65af8f8484071a926ca =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/629b547c0881c2fd69a39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
186-g31ab69ffae8a1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
186-g31ab69ffae8a1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629b547c0881c2fd69a39=
be9
        failing since 8 days (last pass: v5.17.11-2-ge8ea2b4363353, first f=
ail: v5.17.11-110-g77c86f3d903a) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/629b53ee488ae8b060a39be3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
186-g31ab69ffae8a1/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
186-g31ab69ffae8a1/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629b53ee488ae8b060a39=
be4
        failing since 11 days (last pass: v5.17.7-12-g470ab13d43837, first =
fail: v5.17.9-158-g0fff55a57433d) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/629b8602553a01b138a39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
186-g31ab69ffae8a1/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
186-g31ab69ffae8a1/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629b8602553a01b138a39=
bda
        failing since 8 days (last pass: v5.17.11, first fail: v5.17.11-2-g=
e8ea2b4363353) =

 =20
