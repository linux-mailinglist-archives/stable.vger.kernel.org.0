Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777AC4F6E8D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 01:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiDFXdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 19:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiDFXdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 19:33:06 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEAE129253
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 16:31:05 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c2so3462469pga.10
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 16:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xuB+X4uIVt58/cuZjBPGjLzkVqFKaW/yjNBJ2aFq738=;
        b=7J3XLaL6nNoZxJ2ywtZPOVzguwBPXyZHe6MvOiOSGS5hHpi1Yw+5APVmlc+ZWwJ1NE
         Og+hs5AzKxaaJoqYsmh0aDujHiQPzmxFldj9BYirRi/stt3L8ph3/v1S1zJa5XCY3XD2
         qOohZNM9XMFIpxenOVAqT74irQFv/dXWEIgHuechcAkGh4d5ZiiUoSkGgYuek0aeyuhW
         WOqzk8Yq5rT7iif6cTyNfsmyqqWV838iuLkgKxPiVQEaf+AbFrFjb8rMqV3VoQxh3avX
         M+BSBik7eHqGY8P1VFDq7tL/IPj0HkmJcn/gdJWHq7anEpDY6KwU3iFUM29IdKte11Rh
         4CAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xuB+X4uIVt58/cuZjBPGjLzkVqFKaW/yjNBJ2aFq738=;
        b=CswlHCXhM9dz3pfUaBbOzWbUF6pQKFqFd/oEurLoHCp9BizJSPY8QXtifp92H68w3h
         fgBu2anCbl/evg+mgsXqTbj1M4h6GgLoyTSpMcnMsKFxkWPeeilgmM6n0oBGTM9qyf4o
         KYSv4yeRVbDZ+5/+FU5fwUP4TO0YX5Cz1Ob4qNMDw8bv/e9f/Lc8bdHt+EO9ePQyydrW
         uTq1gLZjwMiPR0ce7MKhwgZt5rqOkaS/Iq6USMSiSVZK1U8V7/+IyJI1Vlx/fe7j8PH/
         OWQvADlkv7cnGpL8MH3s1dQW7irvxb6x8WWsW5zw6X+BNJ2FXJfY7OI3TwaeoaCQm0Aw
         W8mQ==
X-Gm-Message-State: AOAM5301KaRuLflnJSUCuxZAGKD4tz9JR104kEvO7A12NNIQ259PKScx
        sUSBaUUhNtG6bRCyc9HsjVTueh3Xx1C+lVKRcQw=
X-Google-Smtp-Source: ABdhPJzqGYi5wNg5ZNnqY5H+yvlkt5C6pgBk3xRG6/B+fHIPNC67W420mirTiosUqedKseIzhcIZJQ==
X-Received: by 2002:a05:6a00:2349:b0:4fa:934f:f6db with SMTP id j9-20020a056a00234900b004fa934ff6dbmr11208432pfj.44.1649287864742;
        Wed, 06 Apr 2022 16:31:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k20-20020aa788d4000000b004fb07f819c1sm20586608pff.50.2022.04.06.16.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 16:31:04 -0700 (PDT)
Message-ID: <624e22b8.1c69fb81.88f26.6feb@mx.google.com>
Date:   Wed, 06 Apr 2022 16:31:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.237-256-gce4238bb62f06
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 49 runs,
 1 regressions (v4.19.237-256-gce4238bb62f06)
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

stable-rc/linux-4.19.y baseline: 49 runs, 1 regressions (v4.19.237-256-gce4=
238bb62f06)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.237-256-gce4238bb62f06/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.237-256-gce4238bb62f06
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce4238bb62f06b43b7e116444e7716716bef2597 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624df22b712778f4d0ae06c0

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-256-gce4238bb62f06/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-256-gce4238bb62f06/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624df22b712778f4d0ae06e2
        failing since 31 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-04-06T20:03:48.628520  /lava-6040695/1/../bin/lava-test-case
    2022-04-06T20:03:48.637791  <8>[   36.772961] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
