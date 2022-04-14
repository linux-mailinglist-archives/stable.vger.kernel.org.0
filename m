Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9865018CA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbiDNQkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbiDNQkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 12:40:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBF61081AA
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 09:09:14 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso6122242pjj.2
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 09:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V84GWA3pQpYA1Z0qNsQt09AtYn9mhZtfQsNj0dmjDLg=;
        b=AYaZ5ebGEtBSvdeiljgVsViGgTErkX9bW4V9WxhRBIevWxDEVMWAwiBBT5wYFY8qiK
         rlVly2CeIv0byGUNis+AYkMeE2D+2sQzi10h1mhIAyJsjE+R7MVuUqGxQc/Z0PXPY1PT
         6KUHDHK1V1DIA4TiOQr3rM06OPX5kQGD6lENhDrQI+rmSTVLXz3JvrD+facmSOh2vtV9
         he36FM7wiZg7KBc4c9pISYSmzjenjTBBZKJr5OoMQWj80CTHreN+xybZJ28DNpAyQUgA
         MLpW6KyFVszEkWtv/zNiUqiTj5xqcR8SER4JWITD/ZBqngvoxoy75Sq6hV4BLzMxcWTM
         +J1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V84GWA3pQpYA1Z0qNsQt09AtYn9mhZtfQsNj0dmjDLg=;
        b=c9TFHrastuFJUGQwxrLOPMZdSsRNQaS+2Il/UbelP4rhU/ZW4gEQR7Cp6QKiWuMRIE
         Pohdps0OTS5mRMdJHm/sfTR7NXHGZOVwtHe7hL8IT6KwZz215Cw2wShsw8DBnOGVlQx3
         F6AbxPvC8PFMnodzqmzAJhDpd1NpzaKZzQLLhfyz5SK0E9tbA2iBt7Bknx8BnnwYwTwc
         rlr4PgNtUH5bMdYm8m+4C4pQxYLKK8DKB3fLryfiXQq1o8DoDkaO436fp70crSJB8Q5Y
         8PzRhG5s+lLLZ5Yk0xrdWEpCFmpmgtxQNwAAaXBx1xjCbEu5WQ6qOiqfEy4hP5o1GnJ8
         ezKQ==
X-Gm-Message-State: AOAM533+nZ4TJZkoqOn5zqXTtOZGG5N1J9FK9n5vFT3QnRQuB8w8Mrrf
        Eo3Yd5R7UUWiYk3Pe5qdIZJIL12FjCD65KkD
X-Google-Smtp-Source: ABdhPJzrc4BCQC3MkT3HNrno2EDNtyUhbOurHZdEICTR6FEtTLJbI1t+ZiO6DItgJzJe4EeCgadw5A==
X-Received: by 2002:a17:90a:d584:b0:1b8:7864:1735 with SMTP id v4-20020a17090ad58400b001b878641735mr4441924pju.126.1649952553814;
        Thu, 14 Apr 2022 09:09:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k8-20020aa790c8000000b00505d6016097sm353974pfk.94.2022.04.14.09.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 09:09:13 -0700 (PDT)
Message-ID: <62584729.1c69fb81.f7c3e.135d@mx.google.com>
Date:   Thu, 14 Apr 2022 09:09:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.111-6-g0fda21cc75afa
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 88 runs,
 1 regressions (v5.10.111-6-g0fda21cc75afa)
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

stable-rc/linux-5.10.y baseline: 88 runs, 1 regressions (v5.10.111-6-g0fda2=
1cc75afa)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.111-6-g0fda21cc75afa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.111-6-g0fda21cc75afa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0fda21cc75afa09d07d90918a2c74a399f1be485 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62581570e38797cbc0ae06a5

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
11-6-g0fda21cc75afa/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
11-6-g0fda21cc75afa/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62581571e38797cbc0ae06c7
        failing since 37 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-14T12:36:45.941103  /lava-6089664/1/../bin/lava-test-case
    2022-04-14T12:36:45.951456  <8>[   33.683230] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
