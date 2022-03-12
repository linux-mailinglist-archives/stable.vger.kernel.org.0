Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE1D4D704F
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 19:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbiCLSIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 13:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiCLSIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 13:08:11 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692E771EEB
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 10:07:06 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id l8so191537pfu.1
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 10:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yXPe4HvyoobNlGOglN6JU1gXJYGp47wDL91GxIQoi7M=;
        b=vjzV1fyHhzmhQe054FcC/zn9At5KiK2eRfrJj2dqnNsdiX8bulOJNFGZ0TlrCNXWXR
         u8m6rlG0En2pTio/htK04drmKwAnV+KecISA6qjRvpmsS1zGkjeCuB8AVchtUxUxaZLn
         6tAaCfONUOSLoFY8jRiGdbDxaEeamhM58Ud7P0nCNR6rJOvu6ZP9azFaxTHwA62Sy/Wv
         9mTQEFx78PtpIg2pG57XR6d+aSNQjgrT3I7817e1XAM2GEHUyaPZh0Riz8VFscckHh1i
         r05ffQ8NHUxRyZ1+aGIHtIHRNm47wVRmnIUJxsxVepQb6glHjYl40NSPvB2/FPTqJeCh
         qJug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yXPe4HvyoobNlGOglN6JU1gXJYGp47wDL91GxIQoi7M=;
        b=PbMH8fva5/RLs2nqWGyULUFSb3b3s6cqnjbvzro1WT09jU1AgUGqB3r7LcFT9NcE3T
         mNTwtlKgsiDbrk/uX6lxDHpJSEkfYP/QbaBlwI/gr78lKPB26Dkv+JwNZRqg6UnV4Lf8
         WWY2ZHjeispowFFkVQjj6ME34iz+ut3QgxPTI2f8s4uDvrimVQ2xmKevoBze6qwdlqQ+
         XQCcUshc9V1Bx4r6BsKu0FsDZi5uk5PL9XFkgMyNndU0yP7vPkoDmXA2IhBWjFthP1eG
         cw+N6eOYvBUMnGe8X2Wenp15ryBrEorYXEVQJv+LTPQD5SBinWM5Mxx/Z/umzo1seG5p
         Ch3g==
X-Gm-Message-State: AOAM533ukzhcG3UJh6gGfs9v+9fBVIk8amCnPQRxwK32mwgSEDHr5486
        A5G6gd7ONCpyDC5n5ppsFJrwBGB7iTC6KcvIdjk=
X-Google-Smtp-Source: ABdhPJxvOr4jFrBLFvqjVl30D+NjogWkAHuKQ8KKJIMxjDAY82grH84QErAiX8UsEzMtog+KKwLZjQ==
X-Received: by 2002:a05:6a00:1146:b0:4c9:ede0:725a with SMTP id b6-20020a056a00114600b004c9ede0725amr16110584pfm.35.1647108425674;
        Sat, 12 Mar 2022 10:07:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x135-20020a62868d000000b004f7550f7f60sm14369476pfd.110.2022.03.12.10.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 10:07:05 -0800 (PST)
Message-ID: <622ce149.1c69fb81.41d56.4802@mx.google.com>
Date:   Sat, 12 Mar 2022 10:07:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.105
Subject: stable-rc/linux-5.10.y baseline: 61 runs, 1 regressions (v5.10.105)
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

stable-rc/linux-5.10.y baseline: 61 runs, 1 regressions (v5.10.105)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.105/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.105
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67c781d938b850db236f6eb0bccc9737c29df57c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622caadc765ea9f80fc6299b

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
05/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
05/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622caadc765ea9f80fc629c1
        failing since 4 days (last pass: v5.10.103, first fail: v5.10.103-1=
06-g79bd6348914c)

    2022-03-12T14:14:37.095450  <8>[   32.934249] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-12T14:14:38.119201  /lava-5866300/1/../bin/lava-test-case
    2022-03-12T14:14:38.129737  <8>[   33.968922] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
