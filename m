Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9816B89E7
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 05:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCNExD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 00:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCNExC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 00:53:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D24B756
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 21:52:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so4811838pjv.5
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 21:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678769579;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=s0MVd63We7Y91oWQ3Vw5YeM2toyrxshay7m4hy/y9pc=;
        b=AsQJZVHs5Fq/jlPBIgZxEnMPSLRnMqVmRVJK7oyyo6g8dACOWnfl7W8vtMvv6adEeO
         ALvg6ogmun9NTMi/Eb3nHdlaMOD7wr5tq5A7q3aBfPNDvOVnNJNStP6/CnwURtkGXCVc
         g9tS8V4ufzBr4VJq4by6Pqsb+dpc4Z0KeVK3PxFeDdzQGpfWHCq5Rdkjwcqi2eh3EViH
         /f1wCcc26cGoLNG8/T6tGzksDhT6z/T6KGxph0bTxj44prM2lPPeqBuAO2MEKZsaes0h
         m451ZAqhU3+96+CUQL/U+sjcimmO+/lhgGmY9baH8SKv9tsMK1o987jSLP99sx76bcik
         DJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678769579;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s0MVd63We7Y91oWQ3Vw5YeM2toyrxshay7m4hy/y9pc=;
        b=hXeMzGJvan/0hAx+8yf8Vhe8mBsgnmfnOaBrf316eX86FQBWzVh7StbXBKaqgKvwbT
         3Xtp4Ek7n6MepSURalU24fulcsoWJ3c8H1ds19m0RqtdHZHe9TwRudQ8C9N9lawtuNa5
         aYFW5wuMM95Wyu+JOqkws0jfTtRMWwhMMKpuvhhz2jhElZWSlzEzP3e1bW15QuJm3wbR
         WntNS6vNQPjbozCcx1r/4J9zRH1kEwIkSrQUCxDT+zlJR7MM3SnIBOwO9L6Ef5P3czqN
         Xq8Gtg5b7bzmcE/Ybcdpvjm/p8TS8WHveMRZ2RMXXSTwHVkexxUFqTm+B79Bwmp1HO8M
         Om2w==
X-Gm-Message-State: AO0yUKVgouODnF3kSzkmiuq2Y9QT4r++Dzm6fgKQzRRg7DOhMDYK/ee9
        n5XM5sKOvErEoxzMSgb80kuGmb0Fr2JI5MU0WP+sKg==
X-Google-Smtp-Source: AK7set/tyiG6lqjfLBpesUQDgWi/h9WbuUrSsdluPrvBDVsvrGMymjJx9rn6NIyUy5NcG2usoHfQAA==
X-Received: by 2002:a17:902:be13:b0:19f:1871:3dcd with SMTP id r19-20020a170902be1300b0019f18713dcdmr9182906pls.5.1678769578876;
        Mon, 13 Mar 2023 21:52:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o1-20020a170902778100b00198e12c499dsm642925pll.282.2023.03.13.21.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 21:52:58 -0700 (PDT)
Message-ID: <640ffdaa.170a0220.c6c6d.25ea@mx.google.com>
Date:   Mon, 13 Mar 2023 21:52:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.18-120-g5af7213bd7fea
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 131 runs,
 1 regressions (v6.1.18-120-g5af7213bd7fea)
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

stable-rc/queue/6.1 baseline: 131 runs, 1 regressions (v6.1.18-120-g5af7213=
bd7fea)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.18-120-g5af7213bd7fea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.18-120-g5af7213bd7fea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5af7213bd7fea68ac1b65df187abcdc68be5d825 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/640fc62f64a1c074ea8c862f

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-12=
0-g5af7213bd7fea/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-12=
0-g5af7213bd7fea/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640fc62f64a1c074ea8c863d
        new failure (last pass: v6.1.17-200-g45d6ef55e66a7)

    2023-03-14T00:55:50.471267  + set +x
    2023-03-14T00:55:50.475141  <8>[   17.562935] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 154833_1.5.2.4.1>
    2023-03-14T00:55:50.592079  / # #
    2023-03-14T00:55:50.694835  export SHELL=3D/bin/sh
    2023-03-14T00:55:50.695392  #
    2023-03-14T00:55:50.797189  / # export SHELL=3D/bin/sh. /lava-154833/en=
vironment
    2023-03-14T00:55:50.797767  =

    2023-03-14T00:55:50.899607  / # . /lava-154833/environment/lava-154833/=
bin/lava-test-runner /lava-154833/1
    2023-03-14T00:55:50.900601  =

    2023-03-14T00:55:50.906805  / # /lava-154833/bin/lava-test-runner /lava=
-154833/1 =

    ... (14 line(s) more)  =

 =20
