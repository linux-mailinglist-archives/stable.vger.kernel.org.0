Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75617505794
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbiDRNzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343945AbiDRNyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:54:33 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE9D49244
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:04:03 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id md4so12943017pjb.4
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AQyIL2leGiuU2tra5UixkDoJG/7L4n2cGo0vCnB02EM=;
        b=5HoGQ7uLn2c84RiyOhkmC57itnT1qVRLCFnqOLpTMhe6wVrK1wHEhNSseBYKw+wsQe
         R6L02o1DenNi01uU6ibI4JMeFAxh20yu5dn5IR+61F31g7CxVg4M5LC4u63MH/n7rOdf
         eQLXW3A6rdCG/OP47ewSvo9xpH8JkZoyny1EoDir+FnQjJdDEtE9Fi3lDNQKT1GoV98Z
         l49gZS/naGxc0ateXmmRgYL91KYpXqaK6Q1G2VA+LJr+97WvF5jO0Zz+JOHj/rHY14Kw
         vnYZ8sVku5eZf4TTZMYg2BroMJ0w3P6ATIOjKHZuyXqOp9K2zvzWKQKCMWbtLTTkUSZ4
         eC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AQyIL2leGiuU2tra5UixkDoJG/7L4n2cGo0vCnB02EM=;
        b=RjMhZqoTEQKq0ESCTgDS5sH0SRBzFNdl51GzBPxltKy+s49Es/bFiIW5C7K2Vd1UOE
         iLdhlcJvVyr8RDxgBKR6r8qkrZK4jSTlVDoWibIx15b+XoHrzj4+i5/y5Fa6F6AOenrR
         RcQyzlnfeoA8D6gJue8RKH81YOsPd48PTuMiT9wh/jeXd88Rtxqcq9y6peGeUoXY7r7Z
         WNHMDnlyY4R88noU8Lgt2eWaqR8LVfoY8ZhvwwQ8PJtvAaj1vBbYc1A9LpdJtjLYJH/P
         vyogRKspvhq8JBuJhRMCFCBO5Kvkn9w2UCtKk7GGyRMPlh4wwLw5QVf6SnL7y2TZR2xX
         RW9A==
X-Gm-Message-State: AOAM531KKVnvKGVTFY2fpvX9M4X3pV7qXskT2bwrUS0pJFJlJjvp+f/3
        JTe9KT5rbZdBd/yeTx8VrSPjEtyubNWB/Z0C
X-Google-Smtp-Source: ABdhPJzAUkBem507vmcTPd/b/Ueu//ZZ3NFFheRHzTe3l7mAKKRKEwlMaw4uQ8zAdRwI26Erb9qetg==
X-Received: by 2002:a17:902:e94e:b0:158:91e6:501 with SMTP id b14-20020a170902e94e00b0015891e60501mr10837213pll.29.1650287042701;
        Mon, 18 Apr 2022 06:04:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c6-20020aa78806000000b00505fd6423b2sm12375983pfo.95.2022.04.18.06.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 06:04:02 -0700 (PDT)
Message-ID: <625d61c2.1c69fb81.86c34.d1fb@mx.google.com>
Date:   Mon, 18 Apr 2022 06:04:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.111-76-gc9eb31debd4dc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 134 runs,
 3 regressions (v5.10.111-76-gc9eb31debd4dc)
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

stable-rc/queue/5.10 baseline: 134 runs, 3 regressions (v5.10.111-76-gc9eb3=
1debd4dc)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | multi_v5_defconfig   =
      | 1          =

meson-gxbb-p200  | arm64 | lab-baylibre  | gcc-10   | defconfig            =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.111-76-gc9eb31debd4dc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.111-76-gc9eb31debd4dc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9eb31debd4dc39e4eea27183cbd08c24ccebfea =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | multi_v5_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/625d2d7bb06d998445ae0689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-76-gc9eb31debd4dc/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-76-gc9eb31debd4dc/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d2d7bb06d998445ae0=
68a
        new failure (last pass: v5.10.111-6-gfd52dd72478ce) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
meson-gxbb-p200  | arm64 | lab-baylibre  | gcc-10   | defconfig            =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/625d301bf6b92b9cd3ae0699

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-76-gc9eb31debd4dc/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-76-gc9eb31debd4dc/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d301bf6b92b9cd3ae0=
69a
        new failure (last pass: v5.10.111-6-gfd52dd72478ce) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625d33524ee6770ed3ae0680

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-76-gc9eb31debd4dc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-76-gc9eb31debd4dc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625d33524ee6770ed3ae06a2
        failing since 41 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-18T09:45:40.390738  <8>[   32.623375] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-18T09:45:41.411714  /lava-6115152/1/../bin/lava-test-case   =

 =20
