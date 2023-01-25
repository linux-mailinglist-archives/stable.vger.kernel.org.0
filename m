Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED22567A9F2
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 06:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjAYFYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 00:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjAYFYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 00:24:16 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C050E2386D
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 21:24:12 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9so16866326pll.9
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 21:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sfdwFKiSB8CLiZabGXrW+/4q48LaPZDiTqdaD/ypWGo=;
        b=Kx/wvZtak55onA/uw5f6HGondhLBl+Hvit3olaTyaFYtmS9QYZiI0LqV6I5pJjuoKO
         RzybbbIaOW0arFdodmE2Gn/+gRJ1u0DoY3QfFj+9s2tboy1kgiHYrtjBCHli1+Cj2ePK
         Fra8HMnbLKDYbBboC7hdDwGJkvSFm9Agn2kqm1MmXp7QaXmGgmNuN1AH50t8XvMb/Oo2
         r76FG86Dpm+zE1Dyf4u0BZp+2/xUA+MIf1kToTsOokiSEbYJ6xNVBMdKKuOqAlvKPeye
         EQ4PSYKiwzj79ZWFNe/kOF4lM13t/m6RQLL6e8Zrp8WI6MQghWvbFrFDigAuGNcO83/q
         W/IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sfdwFKiSB8CLiZabGXrW+/4q48LaPZDiTqdaD/ypWGo=;
        b=0GWLR2YqDforjFfSbGjbMhG7+TdmV9E3U5Qa1gWUgqulEHIU7Cp8QGQmZv6c0Kyb85
         ckFsM9mVJh36dgb1CWXXVs4N1IfFxZxQXT1HcA6/mN7qXyUlu2VdrTNjVEgQToiUGYtA
         cwDYFFUnXMzDt8rPTz9cZmpWwiXX8seNrjv7Aun9GP8x22dD7yVqxMayy3GvWwDRVGyE
         dSk85zedFI5JJlJ+CmAGZkXUsAAbUIOpRFCWdbOZbLuCXuNadExxr72wxZdpp6h0iJ4f
         D+XbJSJoMAYRHEgoEzA6KlVPttMbwf9RhRWoOF4MEYlsfnugIIHABv39nP4J68F92bJ3
         qX/w==
X-Gm-Message-State: AFqh2krCvkpqzFXLdzT49QUOtnn6i9UzPT5uct7p5uA4lB4piQOX7hs2
        1QwrspuPrJi/434szxbPjNZgm4TR7xFZtkgwzqE=
X-Google-Smtp-Source: AMrXdXuvf68eLsFQEbzY2VGGa5BhVYtXpv1rnq3cBxmY3iYvlcJD0qj5qI2EPIy26kgJmptj500DRg==
X-Received: by 2002:a17:903:3304:b0:193:a5b:cd00 with SMTP id jk4-20020a170903330400b001930a5bcd00mr26482308plb.47.1674624252100;
        Tue, 24 Jan 2023 21:24:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jk14-20020a170903330e00b00192cf87ed25sm2632451plb.35.2023.01.24.21.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 21:24:11 -0800 (PST)
Message-ID: <63d0bcfb.170a0220.380d9.5252@mx.google.com>
Date:   Tue, 24 Jan 2023 21:24:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-340-gfa4b05a4e8be
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 147 runs,
 2 regressions (v5.15.87-340-gfa4b05a4e8be)
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

stable-rc/queue/5.15 baseline: 147 runs, 2 regressions (v5.15.87-340-gfa4b0=
5a4e8be)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
cubietruck         | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig |=
 1          =

kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig          |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-340-gfa4b05a4e8be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-340-gfa4b05a4e8be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa4b05a4e8be852a99693b9f54b54170b5934bd2 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
cubietruck         | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63d085d1ff4b53d6fb915ec4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
340-gfa4b05a4e8be/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
340-gfa4b05a4e8be/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d085d1ff4b53d6fb915ec9
        failing since 7 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-25T01:28:11.271750  <8>[    9.978080] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3206315_1.5.2.4.1>
    2023-01-25T01:28:11.381650  / # #
    2023-01-25T01:28:11.484802  export SHELL=3D/bin/sh
    2023-01-25T01:28:11.485173  #
    2023-01-25T01:28:11.586418  / # export SHELL=3D/bin/sh. /lava-3206315/e=
nvironment
    2023-01-25T01:28:11.586926  =

    2023-01-25T01:28:11.688363  / # . /lava-3206315/environment/lava-320631=
5/bin/lava-test-runner /lava-3206315/1
    2023-01-25T01:28:11.689784  =

    2023-01-25T01:28:11.694440  / # /lava-3206315/bin/lava-test-runner /lav=
a-3206315/1
    2023-01-25T01:28:11.781938  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63d0863e2da774b9bb915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
340-gfa4b05a4e8be/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
340-gfa4b05a4e8be/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d0863e2da774b9bb915=
ecd
        new failure (last pass: v5.15.87-342-gce672ebc0240) =

 =20
