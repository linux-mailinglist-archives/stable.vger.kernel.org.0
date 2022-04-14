Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA75500343
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 02:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbiDNA5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 20:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239325AbiDNA5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 20:57:40 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3933841602
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 17:55:17 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c12so3383488plr.6
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 17:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hedPjh26g65+h4wgRH15+DmoHhKOH2amxRo+mMjXiyI=;
        b=UwtdnG0Si6vtI5GyFGzKSD29upccJZKnEoqyxxsXcgtRxGx1Y0ZhAkMq5a4d3IoMLz
         DXFxT6YbT5pdGNHYsyMU42eOQAq6rKLy24bjxtQpe0LF49lBblMWEVCQzVgY9oHwovpr
         aqarp4WO1NVrTCXrafbF6YyrQv+Ij8uGVz4XQq1Npyf0imqms+VCZwni7VPbOq7syY4K
         Lp+dqLtEta/7Z78IoRUIJxYfSYLsV+ysbxJa1neXHAPAOClLNk4iLa8b+NSLLFn4hprm
         gd5rvi7wzAlSIpeVlJbdx57180L8s/ccV0W4J79QFN64wF4wjFfGqzT58oan0XIbqwyb
         DzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hedPjh26g65+h4wgRH15+DmoHhKOH2amxRo+mMjXiyI=;
        b=ZVq26SIVZ+J9gvs0mQDysW7xqX67Lqtp8lpQToyMF2l9DwjTnseEMG63dWKRWcfTPe
         mLGpazA/4NtccD4mtsNj2IaDkdBUptmlhZ3PspPCbQtaErur3/eksEklAublm4Hxfs17
         o64HXosg7HPkAZNAZ8LmbMsBQg4HYwpCcJYqIONV7wqj3tQYDPIjDFZfb8t7RhlWsqcA
         jejNCvcDJjAPlEuRTePeB4gxB/ssk5Rgh1fcCKYwkwDqvtqQVLPiM4zyQ/SQ+4upzHl7
         x8hfvojSXfSLjh+lV6ZPwO9Un5mNzL9P8RBA61C2NM73/Aq9UYk4wEQyWmg5VhpnS2hm
         RS+Q==
X-Gm-Message-State: AOAM531+rH3rSm6Kn4u96zNum0XiSzK+eRKkLBTCC9xdMqljHSfkO7qZ
        U76RJHDg7JuhHHGJW8ZSVrPl6qfz37pHcR7W
X-Google-Smtp-Source: ABdhPJwfKQ7UZu+ugznpfUqS0G2hu1K5EILePEJegVDM06pVJnxUN+8RrcXMWSz7ZJAtNzG2EmVFZQ==
X-Received: by 2002:a17:90a:5291:b0:1ca:b45d:eb3e with SMTP id w17-20020a17090a529100b001cab45deb3emr1495674pjh.207.1649897716620;
        Wed, 13 Apr 2022 17:55:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h19-20020a632113000000b0039d9c5be7c8sm282051pgh.21.2022.04.13.17.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 17:55:16 -0700 (PDT)
Message-ID: <625770f4.1c69fb81.ef984.124d@mx.google.com>
Date:   Wed, 13 Apr 2022 17:55:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.20
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.16.y baseline: 106 runs, 2 regressions (v5.16.20)
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

stable-rc/linux-5.16.y baseline: 106 runs, 2 regressions (v5.16.20)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | at91_dt_defconfig    =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c19a885e12f114b799b5d0d877219f0695e0d4de =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | at91_dt_defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62573cf699d2024132ae06b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
0/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
0/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62573cf699d2024132ae0=
6ba
        new failure (last pass: v5.16.19-286-g4a83e2cd9b74) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6257476631de1a29c1ae0783

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6257476631de1a29c1ae07a5
        failing since 38 days (last pass: v5.16.12, first fail: v5.16.12-16=
6-g373826da847f)

    2022-04-13T21:57:46.464048  /lava-6082537/1/../bin/lava-test-case
    2022-04-13T21:57:46.475426  <8>[   33.510958] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
