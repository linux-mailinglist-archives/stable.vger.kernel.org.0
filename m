Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3843D4EC874
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 17:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348343AbiC3Pkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 11:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348315AbiC3Pka (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 11:40:30 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013D733A05
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:38:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w8so20757554pll.10
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PH2IKug3msVmhqATi4898BPFtOeqgwURjayJxZ+tkKo=;
        b=vQyrHerDR3v4gdTlsmN6gCIu74HpxhPUKl9g5n/dx2n09d5+N1DdBJmAB7QkNPfu+y
         NRhJw7Ig0FDl6Q69MQjOfDtv0BzxtzM7zZVG9mGeV7UH8EggqbzTH5KwT5OIY3j43joI
         TvZqp48lmn+qK1C+NX0gvu7IyboyPcDMwwhfNTo6Jzao2RyPAETQKWnO75RN0BU4skbl
         zdB8Htl0u12AvIGeIxbfW/zmjA6pkMZLc1AFt98dmc4DdamR+HdtQScq6sjYrgxavuDn
         Ko6fwzSSXE3qR4Uss4mpaepTCLXFooH282MeW76MIv6GAfv2AfHS6GK5hnHpkkJTR/xi
         clEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PH2IKug3msVmhqATi4898BPFtOeqgwURjayJxZ+tkKo=;
        b=KfMUS8g5RQacF/pFOwvaYLGgdtCARncDe4A2KL21iiq10m1KHqm6vjkx0/flPvQSj/
         UE6JuLlIfCMmD4kRh+3f4m+8W3rKV8c+AnV3gDCjj8ihYmSuA1//V5v2ViI0HnVNVvAa
         pKqt9gPt8ehUXpTbINL6/5N5DeO5d013bB3SRfcUfuTFcW7dV5n+rUOq77haqa8wjHC2
         gLYfj6F/Ed5ETxW7nQLpa8+1RsZdKoxtm1LDqxejT+8onzDjIQhFUac1AGeMXLN4FRpZ
         cbk3viLIloH60Ef+CTHJor/6uLw7fLQ+QBy0mvUIGRSXWTuhF9gwwwECsYmYSEfGAfkF
         qaPA==
X-Gm-Message-State: AOAM532inVpe692pxWC5O+d5vHjomOqpzMnhPNlVFVprgkFpzLIUkDxy
        tQKwn96yUctFa1A8hQmT07Q1s8QMKVNAX8k3icg=
X-Google-Smtp-Source: ABdhPJwwByix5e4xoeyWicBmcQt89nGCDH3aWfvZ8z3Swz3hFDHRKIj0CSV23BgDAXFuaCNi2c+zIg==
X-Received: by 2002:a17:903:32ca:b0:154:7cee:7737 with SMTP id i10-20020a17090332ca00b001547cee7737mr143329plr.173.1648654722127;
        Wed, 30 Mar 2022 08:38:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f12-20020a056a001acc00b004fb37ecc6b2sm14671156pfv.29.2022.03.30.08.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 08:38:41 -0700 (PDT)
Message-ID: <62447981.1c69fb81.45d06.3365@mx.google.com>
Date:   Wed, 30 Mar 2022 08:38:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-11-g040550c29a1c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 50 runs,
 1 regressions (v4.19.237-11-g040550c29a1c)
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

stable-rc/queue/4.19 baseline: 50 runs, 1 regressions (v4.19.237-11-g040550=
c29a1c)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-11-g040550c29a1c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-11-g040550c29a1c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      040550c29a1c16f89ac60a484928d10ff4b52119 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62444d5439f166b3d6ae06c7

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-11-g040550c29a1c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-11-g040550c29a1c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62444d5439f166b3d6ae06e9
        failing since 24 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-30T12:29:45.973313  /lava-5980128/1/../bin/lava-test-case
    2022-03-30T12:29:45.981467  <8>[   36.857084] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
