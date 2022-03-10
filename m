Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB184D3F2F
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 03:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbiCJCNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 21:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiCJCNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 21:13:24 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BC411B5C5
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 18:12:22 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 27so3478508pgk.10
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 18:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B4cJJhLxtn63al/C4WwhgqvVXLm+p4OjmrqS63ZIa18=;
        b=I2mnQdyhddZcb1ZeeTcKsrxKKdFOyU+LApcqQHLon0I6gnfpIjm3jKjF3p9ZLUJxwc
         Mksp6FmhyTVKvBfquPU3UTH/atLhcEOSmyPu3ha6aCkAnF0wqb+0dTDwLrC7zlWh9ouG
         A3Sr7co1wdnQn28hOI2iqIkFMt46Rc06aDNgU9FyYccIWlPPBd2Cqzr2uqDRn6/kA/wC
         ujVII7kr9jYhT0wjOe3KzT2W0ENA6G2LxdeW5gTn2ZoAsyQknOceBYM3JMriAwDA065z
         qhHuBi/8ni48+czv8zAA/SRxcG1S3hdyUzOeC4u81ta2qR+g3//bk71LSNsII8hrg4Ed
         0lww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B4cJJhLxtn63al/C4WwhgqvVXLm+p4OjmrqS63ZIa18=;
        b=BPRbMzwqFudMjBjPlr5rFS26IAeTi1nR3fhrjooa5qwBLfVGEx4DfoNALTT+qaxxfl
         Plp+bCsVx3wktCY1vK5asHaq+IYBgQsmeQe8oeMCD05X0jB11AlLEzNtWOKJM4BB8Onm
         FcUZcYhxQeFqTAyQott+If6r7O5WHDPgA1aYXbEAh1IpRc3MFsHhUl7F4IpKMfR+FVRX
         BM1YIHZEsRWhzNodT4lMK5MQG5qwom9A2yxyKj62BNCWkJNuMJta17fOI4O/rw6ud5qF
         TljTfPIP3LPiyt7W7FitKqLMj39QUh4Q6k1NZBMf5XrL3Oj1JLCLx9dC9osCol9bw1id
         22Bw==
X-Gm-Message-State: AOAM532N6W9tbkVAwqaWAEuyGzC6FJdkldMU+E8Rg47jOnBej7IPUye9
        TBsFjo9aDAHuX61jxQyKC854CgxwfyXb901fuB0=
X-Google-Smtp-Source: ABdhPJz3+OHDdxrvyLERN+DFUfuzYUfTJiw7+ACelD+zQfhpwIwUdyMRxbJxpNaeiE0BZzYLSPisEQ==
X-Received: by 2002:a63:a22:0:b0:362:b5d4:fa89 with SMTP id 34-20020a630a22000000b00362b5d4fa89mr2223844pgk.372.1646878341122;
        Wed, 09 Mar 2022 18:12:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l20-20020a056a00141400b004f65cedfb09sm4606728pfu.48.2022.03.09.18.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 18:12:20 -0800 (PST)
Message-ID: <62295e84.1c69fb81.87d9c.c5ca@mx.google.com>
Date:   Wed, 09 Mar 2022 18:12:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.104-44-gcb860ee1d45c
Subject: stable-rc/queue/5.10 baseline: 93 runs,
 1 regressions (v5.10.104-44-gcb860ee1d45c)
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

stable-rc/queue/5.10 baseline: 93 runs, 1 regressions (v5.10.104-44-gcb860e=
e1d45c)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.104-44-gcb860ee1d45c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.104-44-gcb860ee1d45c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb860ee1d45cb76c2d131d9d3545b5f812e5db8d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62292787d9867d3126c62969

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-44-gcb860ee1d45c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-44-gcb860ee1d45c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62292787d9867d3126c6298f
        failing since 2 days (last pass: v5.10.103-56-ge5a40f18f4ce, first =
fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-09T22:17:24.803016  <8>[   32.903727] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-09T22:17:25.825479  /lava-5848549/1/../bin/lava-test-case
    2022-03-09T22:17:25.836434  <8>[   33.937673] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
