Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6ED595EDB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 17:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbiHPPQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 11:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbiHPPQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 11:16:05 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E860785A7
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:16:03 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id f30so9608768pfq.4
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=yBQQMESSj9PBy2hXdGr2F/SQ0cpouvVh82jHpjZVphs=;
        b=jpK5y8fGdZ3YGRp9QWxQ8hm8t0m2X9SmNcWqEjnr9R1pk+Qv6wMWdUA/IPo65ug73i
         Crk4UT5iwJ+dNjUU6JXQQn9VWJJ/pMTwqNPBafFaLF2VWg4hW5EabI2UhCNNL8z1bVN/
         cJdelAPZOqXykQ+qEscbMZ6CJ3xoH6UUAkzvlmx+KU1lqOIXLGMpV8VNejBDs0rQPaBp
         5jGKOw6J6Ib4vsDjKJFSp+9Mi4j5Rdu7S5+gcGt0qUnIxWK/g/J3RYfg6d7yxHbK5XFD
         VwAL3j+wbXWbYdhXQRNFn6B560NYE8mn8eoL1Jef11Uqa6Av3YQx4VhwNs50uRZrVg4x
         tqgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=yBQQMESSj9PBy2hXdGr2F/SQ0cpouvVh82jHpjZVphs=;
        b=JGb5zqH8bt7gaoP4QnQmwz5ITA7TiLyGTPU8bgbnTmPTE5m73fyBoj3k0XfUUpsI5p
         k0VFvbs3UOu4C4Y90CU/caX2O7IBn0U9ej7R9+SOwuSOqbukyBzBY9nMtkhakC7WJddI
         evnMh/ZuqT9ENJEiFH75ZSNaAlHAKLdg2lwCYQn/nCEk1kvqjFWGgZaOqjxOzLC9AAC9
         g4y3dwVFVSRAnu1xDW/2RwV79Qz0YbAGPj95dkcbIDWd2y/JdXbWUaYSUtNfDWBB4qRg
         7uyEzCiGVB8fV3CDJRP9WvMDrQVprw1Z5+11nZAXHVTNhmfR80XBKHdniIpVCaxWqANZ
         4B1g==
X-Gm-Message-State: ACgBeo1110YK87tC/A82xGH5oqvR3A4OwkgO9LIO3R2Qad2m07J7YygI
        kyMJIVcN1dBIApavu46kE4OAr+x/VE7BktvA
X-Google-Smtp-Source: AA6agR6/s2e1J1jJ7duHJvLUuBBpREGxsaojtzRh34nWfYiJJ11zyxgoEaa80YC4onBLBpzy+ovigw==
X-Received: by 2002:a65:458c:0:b0:428:ee87:33a8 with SMTP id o12-20020a65458c000000b00428ee8733a8mr9153373pgq.272.1660662962830;
        Tue, 16 Aug 2022 08:16:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e5-20020a170902ed8500b0016dc6279ab8sm9205741plj.159.2022.08.16.08.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 08:16:02 -0700 (PDT)
Message-ID: <62fbb4b2.170a0220.e6763.f7b2@mx.google.com>
Date:   Tue, 16 Aug 2022 08:16:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.17-1093-gaca547a6744f3
Subject: stable-rc/queue/5.18 baseline: 161 runs,
 2 regressions (v5.18.17-1093-gaca547a6744f3)
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

stable-rc/queue/5.18 baseline: 161 runs, 2 regressions (v5.18.17-1093-gaca5=
47a6744f3)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =

panda              | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.17-1093-gaca547a6744f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.17-1093-gaca547a6744f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aca547a6744f3ed857a1a38540ca4cf6ad330c1b =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb810887f02e089e355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1093-gaca547a6744f3/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1093-gaca547a6744f3/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb810887f02e089e355=
672
        failing since 41 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
panda              | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb7efad627e35dc8355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1093-gaca547a6744f3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1093-gaca547a6744f3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb7efad627e35dc8355=
656
        failing since 0 day (last pass: v5.18.17-134-g620d3eac5bbd1, first =
fail: v5.18.17-1078-g5c55e4c4afa02) =

 =20
