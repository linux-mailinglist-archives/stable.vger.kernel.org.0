Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7744E6DDC
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 06:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbiCYFqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 01:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiCYFqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 01:46:44 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C3945AE1
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 22:45:09 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y6so4461829plg.2
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 22:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e03S00ihYqhXKsUlRPBTIjMLe4HapyNKHdoPxhlqVF0=;
        b=wfoi/SNL8m1V4tKUBqJnX0WKAKrUHz44nLvQbugV9XFTy4IZ0UulFPpP0C4hA05v+q
         BiSYztMo2jE6g37ONa1WCqTz6JV41Oo87bTj2sb+EZb7vnwCAs5CtDuS81HTDNTj5PDe
         3lKxoWbIP254fPNh5lw+0V9RHMo+45TnAcjdNiJnZRZ9q4dpQ8iPgmu1851VQ5AeNNcF
         1sr3vyufmQ1s/EfYyiY00fta7E65Qq0yVNOelwWvbJ9fjwuR0JYGy13CrVdMe2NPKo1G
         Eoow6Ssz0Cj3L1stye3zBL4A0Y9u6HMIgYjJXpNAA7tpIbxLgeUm0iqFGNVH3GJ6hQNv
         T91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e03S00ihYqhXKsUlRPBTIjMLe4HapyNKHdoPxhlqVF0=;
        b=bSiHo63Zbc5WJWNJEihD0a11/kj9+RqOgKRwjkDKq55/q3emm2yM/SYb5SzE11MOdG
         sT5JzxbxUJ1qiU1jk3l671paglnkOct/C2ppC8/AJYygRu79lZgrE4oTTxXfB7dzKc6l
         be9qSH84El0mxmFtYmQDPTsZPEOOljMtke5sQelADme6e6xoQZnwCX2ITrAn6Yadsov4
         Qdrq52whCUy43ZpCD1kjZNLy4wIHJGhv6T7T06SIslIs1J91cYzEIKgJjQnPIuF0bKbr
         7cjnw1mBL/1d0F5hc2gDbU4dAvB4VItpZBD1ewI7Z1c+vpsaFHHWHWXcdKKgVo9OaK5x
         pSZA==
X-Gm-Message-State: AOAM533DvjekpZFpqLQjLesEEuhT7UmfNlsfxHlaoSdSWMeMEs8Psnig
        zjslE1ZhVI7MHzIJUzisXfWO2AYSjhBIACcVPjw=
X-Google-Smtp-Source: ABdhPJxRwbkmY9aNKXzhTJK3Ft3pMsYlm33kb9fwgFi7c/zd80nHiYVl3Gq7JzTf1gZKw8ZyzeS2QQ==
X-Received: by 2002:a17:90a:6849:b0:1c7:5640:9c0d with SMTP id e9-20020a17090a684900b001c756409c0dmr10600194pjm.188.1648187108856;
        Thu, 24 Mar 2022 22:45:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2-20020a631342000000b0037487b6b018sm4101945pgt.0.2022.03.24.22.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 22:45:08 -0700 (PDT)
Message-ID: <623d56e4.1c69fb81.677d3.ceea@mx.google.com>
Date:   Thu, 24 Mar 2022 22:45:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.17-3-g38c8070eb777
Subject: stable-rc/queue/5.16 baseline: 88 runs,
 2 regressions (v5.16.17-3-g38c8070eb777)
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

stable-rc/queue/5.16 baseline: 88 runs, 2 regressions (v5.16.17-3-g38c8070e=
b777)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =

rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.17-3-g38c8070eb777/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.17-3-g38c8070eb777
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      38c8070eb77784be25c393062d35bed7c6e8ec75 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/623d2293f10084ec8c772517

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.17-=
3-g38c8070eb777/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.17-=
3-g38c8070eb777/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/623=
d2293f10084ec8c77252a
        new failure (last pass: v5.16.16-37-g2a1b62676c09)

    2022-03-25T02:01:36.369422  /lava-102757/1/../bin/lava-test-case
    2022-03-25T02:01:36.369773  <8>[   11.329999] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-03-25T02:01:36.369978  /lava-102757/1/../bin/lava-test-case   =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623d2a0685abc7b0c977252d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.17-=
3-g38c8070eb777/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.17-=
3-g38c8070eb777/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623d2a0685abc7b0c977254f
        failing since 17 days (last pass: v5.16.12-85-g060a81f57a12, first =
fail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-25T02:33:23.959572  <8>[   32.524126] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-25T02:33:24.980064  /lava-5944196/1/../bin/lava-test-case   =

 =20
