Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAA367FA47
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 19:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjA1Szw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 13:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjA1Szs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 13:55:48 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9503216301
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 10:55:47 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso7640682pjb.4
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 10:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Co4yP9RMEAPFdgVoHV9mkMpCOE7vPQhQisOyDz1vNIY=;
        b=x9wVqn8NdalnOla+q6qHzYppjFYIm9fJE0teRYkiMb0PA1O6hzf9PoF9IyN4xjslhB
         CJKlS8p/j8x6BzWpCerme3qzoT/d7AmElRxwttw5AmWB0UzNHvAlwo6EmmwGq0FVn9DY
         /UanWO1SXBa5AdS31ELq3ftduUCixgVLDNpsQDX4/5XxQIsxeSKWbtlsPrWE5eFlVSCu
         8HiZy7VyBoREG8oZbirPXYE8c9AC3WNFImAxBGq38y1NF4/NQryU3NwaQbkxl8U3AY0n
         IMAf8DbtBjmzrdjWF8qLUeTe+eU1VDF0gcEJtYepGWj5m0BUBEiuo+iUNaV6YlInNE7p
         d+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Co4yP9RMEAPFdgVoHV9mkMpCOE7vPQhQisOyDz1vNIY=;
        b=7hAMuFsPmkUJF/akQ+tHJ/Q4h7Pq4VSSywwwJYthiG8w4U1rs1kHcW9xslNP32dhEE
         NpehRFxC3FWxCgbplA5hRzZgZrkHJxtl9a36XchEadWWjiPL5cj0HtJ2Vv+l6y/b4WZX
         LESBiNGfowoXs5DFDkjrB/9OY7nF7sD2bIQ8TUsVbKgqR2Wzjy6DEf87S6OCRhkToU1X
         g7q387uJKFnfd4bYDSfvFR+NfRcTucFdEUsd4Qh2eMbnshx8FwGiFU1T5l0dNhF/90CF
         Hs1Yu+xbq8JKFuVhZSziWR2gVFAhAUE7Dn9mg51SWtLDw365QnaG2gfnVhfd0PUxZcmS
         gS+w==
X-Gm-Message-State: AFqh2kquPagPskyRcey52cdDo4v+PomdWNypnu6efL/LOfwgNyWR2Nez
        RRzmTIqT6yAsqHZ/2DQ9hCeOrotEJymQ62nX0FK+Og==
X-Google-Smtp-Source: AMrXdXt6XRrFx24jSbFttKA9/C4Gg2NW/MvBrytABpAb+pktVwULf9DtgYoxpQQT9QJQI/iXJ5rPgQ==
X-Received: by 2002:a05:6a20:8e05:b0:af:ae14:9ecb with SMTP id y5-20020a056a208e0500b000afae149ecbmr68466738pzj.17.1674932146804;
        Sat, 28 Jan 2023 10:55:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g5-20020a1709026b4500b0018b025d9a40sm4788938plt.256.2023.01.28.10.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 10:55:46 -0800 (PST)
Message-ID: <63d56fb2.170a0220.81f63.7b61@mx.google.com>
Date:   Sat, 28 Jan 2023 10:55:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-153-gefa1f8bff26d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 171 runs,
 4 regressions (v5.15.90-153-gefa1f8bff26d)
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

stable-rc/queue/5.15 baseline: 171 runs, 4 regressions (v5.15.90-153-gefa1f=
8bff26d)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-153-gefa1f8bff26d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-153-gefa1f8bff26d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      efa1f8bff26d9cd24223252db137b5080c6cfa97 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d53dbd50666d6195915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-gefa1f8bff26d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-gefa1f8bff26d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d53dbd50666d6195915ebe
        failing since 11 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T15:22:22.192035  + set +x<8>[    9.983087] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3236365_1.5.2.4.1>
    2023-01-28T15:22:22.192289  =

    2023-01-28T15:22:22.298856  / # #
    2023-01-28T15:22:22.400472  export SHELL=3D/bin/sh
    2023-01-28T15:22:22.400879  #
    2023-01-28T15:22:22.502105  / # export SHELL=3D/bin/sh. /lava-3236365/e=
nvironment
    2023-01-28T15:22:22.502548  =

    2023-01-28T15:22:22.603874  / # . /lava-3236365/environment/lava-323636=
5/bin/lava-test-runner /lava-3236365/1
    2023-01-28T15:22:22.604429  =

    2023-01-28T15:22:22.609416  / # /lava-3236365/bin/lava-test-runner /lav=
a-3236365/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d53c93cc86220630915eee

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-gefa1f8bff26d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-gefa1f8bff26d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d53c93cc86220630915ef1
        failing since 1 day (last pass: v5.15.81-121-gcb14018a85f6, first f=
ail: v5.15.90-146-gbf7101723cc0)

    2023-01-28T15:17:14.613443  + set +x
    2023-01-28T15:17:14.613673  [    9.324325] <LAVA_SIGNAL_ENDRUN 0_dmesg =
890670_1.5.2.3.1>
    2023-01-28T15:17:14.721283  / # #
    2023-01-28T15:17:14.823100  export SHELL=3D/bin/sh
    2023-01-28T15:17:14.823718  #
    2023-01-28T15:17:14.925130  / # export SHELL=3D/bin/sh. /lava-890670/en=
vironment
    2023-01-28T15:17:14.925515  =

    2023-01-28T15:17:15.026763  / # . /lava-890670/environment/lava-890670/=
bin/lava-test-runner /lava-890670/1
    2023-01-28T15:17:15.027261  =

    2023-01-28T15:17:15.030199  / # /lava-890670/bin/lava-test-runner /lava=
-890670/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d557ef1b653d3bd4915ec7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-gefa1f8bff26d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-gefa1f8bff26d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d557ef1b653d3bd4915ecc
        failing since 10 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T17:13:56.024369  + set +x
    2023-01-28T17:13:56.028487  <8>[   16.100076] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3236334_1.5.2.4.1>
    2023-01-28T17:13:56.150459  / # #
    2023-01-28T17:13:56.256877  export SHELL=3D/bin/sh
    2023-01-28T17:13:56.258504  #
    2023-01-28T17:13:56.362047  / # export SHELL=3D/bin/sh. /lava-3236334/e=
nvironment
    2023-01-28T17:13:56.363752  =

    2023-01-28T17:13:56.467466  / # . /lava-3236334/environment/lava-323633=
4/bin/lava-test-runner /lava-3236334/1
    2023-01-28T17:13:56.470341  =

    2023-01-28T17:13:56.472695  / # /lava-3236334/bin/lava-test-runner /lav=
a-3236334/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d53be1846448faed915ee3

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-gefa1f8bff26d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-gefa1f8bff26d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d53be1846448faed915ee8
        failing since 10 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T15:14:27.965531  + set +x
    2023-01-28T15:14:27.969645  <8>[   16.016187] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 201728_1.5.2.4.1>
    2023-01-28T15:14:28.079297  / # #
    2023-01-28T15:14:28.181545  export SHELL=3D/bin/sh
    2023-01-28T15:14:28.182027  #
    2023-01-28T15:14:28.283834  / # export SHELL=3D/bin/sh. /lava-201728/en=
vironment
    2023-01-28T15:14:28.284330  =

    2023-01-28T15:14:28.386009  / # . /lava-201728/environment/lava-201728/=
bin/lava-test-runner /lava-201728/1
    2023-01-28T15:14:28.386961  =

    2023-01-28T15:14:28.391422  / # /lava-201728/bin/lava-test-runner /lava=
-201728/1 =

    ... (12 line(s) more)  =

 =20
