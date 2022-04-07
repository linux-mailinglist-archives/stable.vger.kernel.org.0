Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8564F754D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 07:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240869AbiDGFZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 01:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbiDGFZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 01:25:38 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AB812925C
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 22:23:39 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m16so3922817plx.3
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 22:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=etn8Aoam+/45Ali4KibX1j66slVxtkHfrKbN5vEub9w=;
        b=XEAcwJt6sRP57DHY41gkPxFd9kW52iFHnzaS+8/OgUXqiwWmG1GLwlgwpBBJi9ytoR
         PgnsRDn4soNHeXvmz8jHVQpbdkZohdUPHdtl0VTqEFPPYeSy2k0YbwE92rIpb8iBbjfR
         OKIulKUxSmL6nV8J0W8Y1QUIUkfvLxAjnffon6sKxBluNo+mLfUyI/WioaFTVKd+zI3d
         bv060QtQ/nMsvmANJKJZGutb88WWvNMP/j4Ct6vch3jaf1Rts653gJu+J03bQvkc/mD/
         GW/uLeaQK2ezx0p74q2rkgIlg/kIK858WJ1tq0IjHOI2YSuo3yym8HfSdNpVM3gn8Tjr
         TGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=etn8Aoam+/45Ali4KibX1j66slVxtkHfrKbN5vEub9w=;
        b=r3UMWAzZf3DiyGAlmD2kNLoC2cLcqtVQuMRq+ULteqVza4oxYhsL+AYJ3fB4szgXCI
         OjDTvVLbPiWS98GadpIWlfo8xuYGk2nqhD3RuEAfESGTM56cA1L1xAzNcft1ql6EXMnS
         F8hlxnbN002u67R552j4aXhPSvl0LJg8eSbDuCxkBoVxKmtgPnUxchBh2m7rrWTSKQcT
         5bicqM0z/3oU6HBHoIgaYmRnzSgRBzGfwE4vfXKx4b0cfWSbgg9VAV/RrB0LBgBDppjY
         ImAt2qmCvL73S5a1nx5mFDuxLy6f4C7iJNVcUSNoJm/K+Iu9ZhIYE5N/ExRfPFrUt2vC
         BClw==
X-Gm-Message-State: AOAM5309EcezLfRSPW514huUGeSjt6Rh0/fHHsvq5zIa0glAda9H6/qL
        72zV31ZIrKBkpYqe3LpebCOMXnZ/lEVhGqlxgy8=
X-Google-Smtp-Source: ABdhPJybFpAX8zPYyCmRIubdHhy5ZqtrdDCA5wGtHQ/+OrAHf1l6MUJ7J8F9LpLCaulv1YCkspTONA==
X-Received: by 2002:a17:90a:5291:b0:1ca:b45d:eb3e with SMTP id w17-20020a17090a529100b001cab45deb3emr13929687pjh.207.1649309018843;
        Wed, 06 Apr 2022 22:23:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bt18-20020a056a00439200b004faad3ae59esm20352682pfb.95.2022.04.06.22.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 22:23:38 -0700 (PDT)
Message-ID: <624e755a.1c69fb81.6e78.7b6e@mx.google.com>
Date:   Wed, 06 Apr 2022 22:23:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.109-597-g69c44fc1122df
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 95 runs,
 1 regressions (v5.10.109-597-g69c44fc1122df)
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

stable-rc/queue/5.10 baseline: 95 runs, 1 regressions (v5.10.109-597-g69c44=
fc1122df)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.109-597-g69c44fc1122df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.109-597-g69c44fc1122df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69c44fc1122dffa0e75f69b7bdce98b1dab959db =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624e44440c9968abf3ae06f6

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-597-g69c44fc1122df/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-597-g69c44fc1122df/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624e44440c9968abf3ae0718
        failing since 30 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-07T01:53:54.984356  /lava-6042271/1/../bin/lava-test-case
    2022-04-07T01:53:54.995377  <8>[   60.807714] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
