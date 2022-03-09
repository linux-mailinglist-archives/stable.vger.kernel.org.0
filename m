Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEAE4D3A0A
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiCITU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiCITU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:20:57 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8229E27B04
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 11:19:57 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so6164214pjb.5
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 11:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tYSsGnOy1M/Sh/9OWf1xao15bEunDhKt2ftpi1zESms=;
        b=ISwPHvz9KqexAc96vd9AulOwtOUU8Ki+twmInSd7gpeREMdNm5y75R70IG0dC5iH1y
         XPpEEw811D7y6UOrxyV+co4QdKDJ4uhVzaCk3xhsDcSLhXfnjPFXIttUn1X/5m6WQA1m
         wOGnh+vR+x7NnSj2mX6/rRWSrTUEy357c1XDbjruk7De/4/Sz85RSsBjGV6Cj4R1Y0ED
         Msgc62DtfGlhvz87kbI/H1MOC3xp4FS/daDA4ocT7nmKYP907f6HXlypgbpd08Vhxv3w
         3hPGYRRWcyu/7by86Fnk5bUgEX6TFC1AMeC2JotaG6Kl/qDhElbYN6NOW3dGhQzNMTxY
         +KiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tYSsGnOy1M/Sh/9OWf1xao15bEunDhKt2ftpi1zESms=;
        b=5Pd22AMyPiD+WWp9XSLaaqjZ3iVJ0cyOwZzBwdiGQFDJLHyWiFq+Il6sJYbOHnuLGL
         q9VTejIzj6nV2bpjKVI1FKmduDfABnzVJcVOPIaE4deorjOUwmfytVTgBiLrTuij7F0L
         nlrEzqiKqHApT5edyQmR7Q/zdLVIqf+pI/QgcjuxAoLPzmS7edgttgJuXHYJ4UiZBRUm
         dR0xKBy+bI3rD1wDmrNEvIwnMrZkMbzyRI04l94+EFYfZ4JJYK7vslnVHEfTCvpjgD/c
         v5S72l0NFNwpdUxZJjPMg1irpZLfMn0dGMqrnAQZPpkQu8YMD+rUVIj4lcC4iciXlpCw
         hdDw==
X-Gm-Message-State: AOAM532hnpfwSY0xwahvl/DrhSNJvQ6TG58XZRX1XMN7425BweuO0sAd
        oIRoxOaRAavQ7ITXh2SfML6Nf9ukYHz+n+VSwik=
X-Google-Smtp-Source: ABdhPJwJulQQvQdvFCnajRtn6BxB/7MK+DYTtQubmi6cAe98vIRM8tUdkZOi6cVzynwi+h+SlfzALw==
X-Received: by 2002:a17:902:f78d:b0:14d:522e:deb3 with SMTP id q13-20020a170902f78d00b0014d522edeb3mr1067618pln.173.1646853596836;
        Wed, 09 Mar 2022 11:19:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d32-20020a631d60000000b003650a9d8f9asm3023581pgm.33.2022.03.09.11.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:19:56 -0800 (PST)
Message-ID: <6228fddc.1c69fb81.21352.7f21@mx.google.com>
Date:   Wed, 09 Mar 2022 11:19:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.104-43-g417963ee9709
Subject: stable-rc/queue/5.10 baseline: 101 runs,
 1 regressions (v5.10.104-43-g417963ee9709)
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

stable-rc/queue/5.10 baseline: 101 runs, 1 regressions (v5.10.104-43-g41796=
3ee9709)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.104-43-g417963ee9709/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.104-43-g417963ee9709
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      417963ee97095a716a0acfee142e233dac32b4df =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6228c886d057177bd8c62978

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-43-g417963ee9709/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-43-g417963ee9709/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6228c886d057177bd8c6299e
        failing since 1 day (last pass: v5.10.103-56-ge5a40f18f4ce, first f=
ail: v5.10.103-105-gf074cce6ae0d)

    2022-03-09T15:32:08.790821  <8>[   59.922824] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-09T15:32:09.812887  /lava-5845956/1/../bin/lava-test-case   =

 =20
