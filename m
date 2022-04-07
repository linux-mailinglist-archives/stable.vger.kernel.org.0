Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A82A4F6F5A
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 02:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiDGA5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 20:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbiDGA53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 20:57:29 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93B1C9B68
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 17:55:31 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r66so3644405pgr.3
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 17:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j158tqm/GZZmzJujnpGknRKsvGx0xxubTVyuZ9JTIkA=;
        b=nT0ViW4Fioo4KF+ni9Cl6mcnfBTOFlBTufeusIN0f1P7ttHTgBikwY2beEM5mG4JKz
         7GpnPVF9C99vbjLbIvV8omh5qGUFZIa4a387dqKp49Idcaq08KU91qS3oQqauy/j8u9t
         L+qdQ2myY0nZLDzv4pbbHtfHhFAA/PGMm5UOMLimttAQX3pzjCRd63m5foach8WYYmjB
         NFg6opZV3W26wn0hludjDsXDYrPR5pp4+HzOtPBekCHcwnb7r9I/pP2sZG74q0GZqO6F
         zV2XZp7kVIqrdU+TbLWacbaRczRFymSFks36D1PYJR2568DOjC7NC2EeteQRd/XFONjE
         6qSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j158tqm/GZZmzJujnpGknRKsvGx0xxubTVyuZ9JTIkA=;
        b=3ok1h1W8yzPOceEyu7jH3dltKuCj3pS3cVSk7PGRbwp4CTosIV4je7ZUDgXIdR7TO5
         eDWi5s5aQLpEVwJY2aMgi10ej0Wrr3c9qBdxvTmpl1QmVCdbljy0bxnbpKUFjJYn0C0N
         BzT0V8V4rpR6lJ8IVpMtMDv0FCnogvzq2ybRf5Y60gJUIm5LTxYG+AmTrj+dLLGZjAjz
         TFcE5yKqRQaw/0v/bRJxq07jKOjmPoLsbEakgJ+F0nhdCXM81nJfzGU4B+oeuE9dlSV9
         CE2aHKJ3rpSLBBazho+O7n7VPGov581fvDSPEALrvpQsQ4gcq3zzDPJtM672U0/Gq/Nh
         VzCQ==
X-Gm-Message-State: AOAM530OGip5dHi9dBuWwAvwoBdIICMcDdH7aDhc+Eg87/fNes5zkGzr
        TG5ns0/TK+IGkZFzRHJ96jsqdNnnHe+1IElrHaY=
X-Google-Smtp-Source: ABdhPJx7gony659yzEdGcWXn6fUuPuP8m0bQpSMs76wjmweLTpJ/GxFJ28XwGXNlq35YhFgZdaEi6g==
X-Received: by 2002:a63:5145:0:b0:381:4051:1f5a with SMTP id r5-20020a635145000000b0038140511f5amr9439773pgl.300.1649292931134;
        Wed, 06 Apr 2022 17:55:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d21-20020a056a0024d500b004fb0e7c7c3bsm21666977pfv.161.2022.04.06.17.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:55:30 -0700 (PDT)
Message-ID: <624e3682.1c69fb81.dc978.9472@mx.google.com>
Date:   Wed, 06 Apr 2022 17:55:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.18-1015-g18299e64680a0
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.16.y baseline: 77 runs,
 1 regressions (v5.16.18-1015-g18299e64680a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.16.y baseline: 77 runs, 1 regressions (v5.16.18-1015-g182=
99e64680a0)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.18-1015-g18299e64680a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.18-1015-g18299e64680a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18299e64680a0cbdf745fd73c5345d9a029928b9 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624e05fc602177fd5bae067f

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
8-1015-g18299e64680a0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
8-1015-g18299e64680a0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624e05fc602177fd5bae06a1
        failing since 31 days (last pass: v5.16.12, first fail: v5.16.12-16=
6-g373826da847f)

    2022-04-06T21:28:15.100899  <8>[   32.739889] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-06T21:28:16.122948  /lava-6041095/1/../bin/lava-test-case
    2022-04-06T21:28:16.134163  <8>[   33.774753] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
