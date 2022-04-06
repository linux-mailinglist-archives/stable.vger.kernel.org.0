Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1178D4F65F9
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 18:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbiDFQxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 12:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbiDFQw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 12:52:29 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35721F0454
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 07:16:33 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h5so1368305pgc.7
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 07:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jUiPsKMfq8R49tzQx4iobqmZ99vPJeLus6Ut7vrAlpg=;
        b=WvNSIUhhQIMm/KrQAHfztxGcQyk3McmS771LGwYQ0fQfiF5kzTo3In+/uC/IiXvQp9
         bVqgRE+Lw5ZsdWzLxegr2bVEf9MQXWKjw+84rv0GXCrlIHoIahDJJJlKngOswdiAmMg3
         9PzMtzD2OInAC8LdyTf4bW4BYH4EQTo/bQPXB4AEeU1HNg8QFHGEGVwLcZB8COEsYbXR
         WNRbIkEejXuoCHAxEKW2G9AMr0wKR/4/YEl7PIFm7YejKH/45OCUR3GQMDa5uXYyT+Fy
         ncVzHxZKkajzslXJ2VaixR9EGjJb53x7UlVvibXxIdwBx+xOMQxlKOGWGQEpdTu4NY1v
         CUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jUiPsKMfq8R49tzQx4iobqmZ99vPJeLus6Ut7vrAlpg=;
        b=oOoDGnG0Rzs/UKc0xagiGh8R/QoEtbV6+FUQboVSbdZWcTDhmqCz5IjxuMvovn7LPM
         W5AiB5hKPZdO7cXSew0U+//T9QC+Bc06I8zg/1XffEs2v+y3HUIGAzZbR4EKWMz+XN2H
         8fP1iUiYIBG13LBrbF7BBnR0KFF1HbBrQujlC/iDKe+F9OS1I2fmQf+5ljpc3jLceMBA
         rMVEz16KtMYV7lUrcPuROQNlBp95l/26bY9mOJt1fusFdn8coyFIkscO9xp6kMp5du96
         2Ea0AY3hX0ZEtq//ou90jtNN24LR4/1yQNJ6/t7ZRplx7X9emP0Zse3MDqxk0zkKOK63
         iWng==
X-Gm-Message-State: AOAM5309QmUr1e/tmcS+qMb3oPPKH1B7Jb+rjRAQ/VWoTDnPoT+yuO8v
        M1D3Zjvn5HgSFI5htGd3lPyjVR9RwykH6ra7
X-Google-Smtp-Source: ABdhPJx8ixcVD+JBl8sqkyQGp2pu800JFtdZFPw4JRyK5YT+sm54eNHQ+rMBnuQ8Ha8PZCrXaKwfBQ==
X-Received: by 2002:a63:4945:0:b0:398:efe8:3b7a with SMTP id y5-20020a634945000000b00398efe83b7amr7357019pgk.106.1649254593078;
        Wed, 06 Apr 2022 07:16:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f19-20020a056a00229300b004fb157f136asm20240180pfe.153.2022.04.06.07.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 07:16:32 -0700 (PDT)
Message-ID: <624da0c0.1c69fb81.2c86f.48e2@mx.google.com>
Date:   Wed, 06 Apr 2022 07:16:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.109-598-g8bc400ada1ffc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 67 runs,
 1 regressions (v5.10.109-598-g8bc400ada1ffc)
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

stable-rc/queue/5.10 baseline: 67 runs, 1 regressions (v5.10.109-598-g8bc40=
0ada1ffc)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.109-598-g8bc400ada1ffc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.109-598-g8bc400ada1ffc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8bc400ada1ffcb232114207449ce7e84c4b390ae =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624d6e2c6405e10d1fae06a7

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-598-g8bc400ada1ffc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-598-g8bc400ada1ffc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624d6e2c6405e10d1fae06c9
        failing since 29 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-06T10:40:31.315120  <8>[   32.997848] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-06T10:40:32.341735  /lava-6037103/1/../bin/lava-test-case
    2022-04-06T10:40:32.352548  <8>[   34.036786] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
