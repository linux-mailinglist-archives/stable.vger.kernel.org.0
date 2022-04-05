Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9444F47D5
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343717AbiDEVVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384608AbiDEPO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:14:58 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDB93EA9A
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 06:29:59 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 2so4701624pjw.2
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 06:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=taii5VRMvjVJ1mPPn3HdZLqHVWoxT6IOzNO3e9Yh/fg=;
        b=dNC9OXKMhC4/A5UPAGjLctqC3VXIFYy5c1NS6XLX+EasD1UZglcUdSiTwIo7mcGIsl
         57u/cbbk9tfttNgc6H7mYiatqZUq7ZYS7MOjN4Ra8zqZGm5mLSrvbXzwTZgt3OfGZXc6
         2yN1UHnUXOb7s7v9QI3f5UR2NdDQvkIxzELYzqkYSLhTyCrnKw9LQeiE3S9JPIlEQwr7
         PT8mwCLVea7aonnTJb8fIIYsqjcvg/jKK6vXCxQH9DMZwdRI9Dk8rQUhUPJ3UbxkQCOE
         VmOq2d3HjsnDS9xDVAH5xPsuLBQysWrSXMK303i5w/eK7/O129ClKrqwekNuYWTiaRNS
         DE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=taii5VRMvjVJ1mPPn3HdZLqHVWoxT6IOzNO3e9Yh/fg=;
        b=Nv1r6GwLuZ9IC9SE2bBiuMXpxMXPpvYXZLokHKIMjq9kFUjpXxyk8+oLmKUAZqh54s
         fu39qzNQ0p+5w6zT9SYUd03Kzm0ctURwBgCZJzzmi0p2NHwuChWuuBcH3ScCarvEXAJ7
         w10J/97qIhknLF2byOvZgUu/asIioWMzYkxi2o+3YJgv92qBqS+G5j5IgYd6iz8uPoKZ
         pzX+WbxTcR4IKiWMS6/3Jo6BuE/VT9h9AdvS961x0TsWCxkBoOCaUahWHklWBEPsZS6l
         cyUP7bysicKK/Uz65ncuNTpgnupgkzj3OXEYK1r0b1bRsqnDfhRxLJGJIoFTyDZCnhgz
         L2xg==
X-Gm-Message-State: AOAM531aH0q/9c+feM234E4np5724+m7Wg+QClBD/DdpbgzjNGm7fsa3
        haqLfUYKd8gP5qVDkHIsH7p5JPzGt/cZzna8Hck=
X-Google-Smtp-Source: ABdhPJwJ8Aowm71NcCKrTY8pHNXCq5jEbsxZHCse9L81N13o7RbV8TZ/KcgVNhFjDAJbddt2xgL7xA==
X-Received: by 2002:a17:90a:d3d3:b0:1bf:2e8d:3175 with SMTP id d19-20020a17090ad3d300b001bf2e8d3175mr4221810pjw.2.1649165398620;
        Tue, 05 Apr 2022 06:29:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q28-20020a63751c000000b00398da17dcffsm2468816pgc.58.2022.04.05.06.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:29:58 -0700 (PDT)
Message-ID: <624c4456.1c69fb81.bab03.6762@mx.google.com>
Date:   Tue, 05 Apr 2022 06:29:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.237-258-g1376b0e9d2319
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 34 runs,
 1 regressions (v4.19.237-258-g1376b0e9d2319)
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

stable-rc/linux-4.19.y baseline: 34 runs, 1 regressions (v4.19.237-258-g137=
6b0e9d2319)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.237-258-g1376b0e9d2319/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.237-258-g1376b0e9d2319
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1376b0e9d23193f0dff6107fba4c042b338b5676 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624c1a6840e9d850beae06a4

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-258-g1376b0e9d2319/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-258-g1376b0e9d2319/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624c1a6840e9d850beae06c4
        failing since 29 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-04-05T10:30:47.422798  <8>[   35.918459] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-05T10:30:48.439348  /lava-6025435/1/../bin/lava-test-case   =

 =20
