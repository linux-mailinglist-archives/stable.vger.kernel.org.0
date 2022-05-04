Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2849D51A4E8
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiEDQLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240115AbiEDQLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:11:04 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBB325C7B
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:07:28 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c11so1795204plg.13
        for <stable@vger.kernel.org>; Wed, 04 May 2022 09:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fjsqpSa6cLiFbrH9XmScd2cfFEH9uuoBHGqb6qsh3Bo=;
        b=tWTx4ZD27cHUkdzaUCGTvB/D029p6iZ0F52scxOn/Ho56QR+DFEIg0ZWPHq7X0VSnv
         4+FfhflADkpWAG6Ah57BrkMBYwLXbPsS7m93ncaH+KkmXAPa/GHVs9o7UL8NfVftd/11
         5zRF6IxCJxC+qtfW6bRPFaA+OD2UKPvqUpyidrrdl33sljOSm86wpEOEgPBUFk5whilG
         gsnlggCdD1a7Mh6GN4zWuTd52j9iic1Q6faS7RJuehR2Jw/ozJhPdXCxiHLaTsl3u3dH
         Q/1ERJDeQEchWrjYGeNLndgHcFNHDwZmKoYlE7Y8QG/D2+Tpu3jsoX+vmHJ0gOzcizOF
         HNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fjsqpSa6cLiFbrH9XmScd2cfFEH9uuoBHGqb6qsh3Bo=;
        b=v8HcUOiAQKMxOt9WuCmJCgKPMIzLmU44BfCXDtDQiU+G/DB9k5RaB8uh5pQNSSWTOU
         mrfDDLPrWNpPkUdZoLqJvJhRuvVuNJj20A9JnKaazTBYEMWqEpJPFBJAWb82RzONsLyO
         s38mYtALq0VjpPYAD61rzMZy65gP8+ZGe5BaMhuTAAEviKTMYhq/D2q2R7eQBf/s/Ohw
         L7FIiD74EVHMGzv/wbp1jEvd65KeB/WeoLAwcL6tWDPDkX9cHyHeKkANKSsa90F6YPid
         aT23SNneS2fqDl/6aKFfG5R06U6LxnqsAMZJX+HfEYqzL8eSKxJvvKTjSOnIq79MlQEZ
         9uZQ==
X-Gm-Message-State: AOAM530M9zQqx6UGxQa7ETidTfFyOJ4wDvt9G+eF05f3mH2SiPLQ01IZ
        5wlCbE53qHc3nlVRPXRYdhNGEsIssiZG48h+as8=
X-Google-Smtp-Source: ABdhPJwy1ziXJY600M+zl50Kv4Av2AiCMnAnAeUdEo86xlkxB/mX29khAJ6VUYjeiwIUrZKxfHAkpQ==
X-Received: by 2002:a17:90b:e89:b0:1dc:18dc:26a0 with SMTP id fv9-20020a17090b0e8900b001dc18dc26a0mr205820pjb.188.1651680447776;
        Wed, 04 May 2022 09:07:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ba1-20020a170902720100b0015e8d4eb1e6sm8509436plb.48.2022.05.04.09.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 09:07:27 -0700 (PDT)
Message-ID: <6272a4bf.1c69fb81.465f6.4c86@mx.google.com>
Date:   Wed, 04 May 2022 09:07:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.241-59-gc88d6395113f
Subject: stable-rc/linux-4.19.y baseline: 27 runs,
 1 regressions (v4.19.241-59-gc88d6395113f)
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

stable-rc/linux-4.19.y baseline: 27 runs, 1 regressions (v4.19.241-59-gc88d=
6395113f)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.241-59-gc88d6395113f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.241-59-gc88d6395113f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c88d6395113f2c87b00d927a8464a417bbbfd3a3 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627242a46ca04f24cadc7b45

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
41-59-gc88d6395113f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
41-59-gc88d6395113f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627242a46ca04f24cadc7b6b
        failing since 58 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-05-04T09:08:40.100216  <8>[   35.894792] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-04T09:08:41.115587  /lava-6258724/1/../bin/lava-test-case
    2022-05-04T09:08:41.124004  <8>[   36.918564] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
