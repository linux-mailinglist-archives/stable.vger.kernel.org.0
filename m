Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B964ED29A
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 06:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiCaEXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 00:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiCaEWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 00:22:45 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6161AA070
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 21:11:38 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k25so27231708iok.8
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 21:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mX9TscJv/mdp3ns0XM1/+OqIMY+YmoIVJKaBHHfiIg8=;
        b=1dhT1BB36EVx/K4ut0W9SytKnout5gioNcZ85FEsWr8gd5ak96Bh4dNYCNq8Sy9kew
         W6cveLqkarO2TFoUV4DT1lN79SxZIdjY/xB5c2SXIhfQ0UUT9QcR+kOOR9JAa60hCgdr
         Y/862CeiS+j8lRpeLabdDavrxc2b1wW9HkoRtJu5vknkhxH35F85ZvAb7y70VMxp7zqM
         6j41PnN1OEerV0yCaowmveDboJHY7gE2H/+jzeZBa59udt411EAcQwNty1GQ0lwa+ReP
         gyhpVT+ikCTZegxSDmbnJtlw//HwFC3EMukR7/L0tLcezNt07Lsz2rKN74giqvhv15sN
         Xb9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mX9TscJv/mdp3ns0XM1/+OqIMY+YmoIVJKaBHHfiIg8=;
        b=kCW3ugfCb6Qb5Z1wz0dsI7AKW5hpM+EFIt32MbnXQq/55XS8XTLMzk3s1gKt4xT2ek
         Cw0dAKdPHpj3EzHhkaXrXqoex1ovn4lbivh22P8FQfrK8/2UXdNqya57kphJnMCOmFAS
         a/DLF2jHh0sHfFFmSl8AZPKlbLvV2lnj90BmwhkYqm+8jJvnQIYSdvS66Q87umxx8heM
         SjU5sejznO3SODyssvmO1nU++WOnrfTwVzHlJay28KLbp5Fn/VpQulAEvf2hCqtPnZQn
         K1WGLpku96UbD8p0yrrfdiTEyYVpb5s0yZ4zICjP+HsEyQ6nFeY6/260Kdk0MAXWgBYK
         zwKg==
X-Gm-Message-State: AOAM533ZLXMkztM6Ov8RQPPsWi3FmaSMw5jMBz8n4miOzckcSKccVT4Z
        O/7pL8K+xupjqIVyHcgblQRcuJrtffmt9IBwxOU=
X-Google-Smtp-Source: ABdhPJxzgf7ynt12pc6s26KWeqSsO38oIbVGvqKneRt/5XTgKtuLQuRTLJLbOOePIi5GmrdQqZHmDw==
X-Received: by 2002:a63:f923:0:b0:381:31b7:d914 with SMTP id h35-20020a63f923000000b0038131b7d914mr8848053pgi.121.1648696219004;
        Wed, 30 Mar 2022 20:10:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y30-20020a056a001c9e00b004fa9246adcbsm22630723pfw.144.2022.03.30.20.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 20:10:18 -0700 (PDT)
Message-ID: <62451b9a.1c69fb81.1f002.de92@mx.google.com>
Date:   Wed, 30 Mar 2022 20:10:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.109-22-ge3a27d59f151
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 116 runs,
 1 regressions (v5.10.109-22-ge3a27d59f151)
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

stable-rc/queue/5.10 baseline: 116 runs, 1 regressions (v5.10.109-22-ge3a27=
d59f151)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.109-22-ge3a27d59f151/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.109-22-ge3a27d59f151
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3a27d59f151b757feb380b82fe561633bd4019b =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6244ead22dbf4e4001ae06ae

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-22-ge3a27d59f151/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-22-ge3a27d59f151/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6244ead32dbf4e4001ae06cf
        failing since 23 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-30T23:41:43.528809  <8>[   33.014250] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-30T23:41:44.550085  /lava-5983397/1/../bin/lava-test-case
    2022-03-30T23:41:44.560833  <8>[   34.046598] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
