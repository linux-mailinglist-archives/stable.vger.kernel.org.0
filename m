Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0564F21CF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 06:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiDECrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 22:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiDECrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 22:47:35 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC0532469C
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 19:31:59 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r66so1048519pgr.3
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 19:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S5Ft7vkLiBE/B5kd1gTyHDqyJHbI9BN41DFJnhDyp3Y=;
        b=CcSvUhsECL39G6uQrH3GjJuY3WNc3fEOxf5obU35VJYrjn9Kr3Xjz5temReGSlZ/26
         Z1uC1DuDdM22NQPdYHoSd6ngtn6im6nRqQsszmBBnfby1VDBFTR6TnD9zurUtpP+qwp4
         4vAXT+J9/r2S6vOhw9/JQgseWLsfCEDZ1aYzkLDrpiVNowhDJBwcdRh+xssmz41fq6NQ
         4MkF9B7hMlfpRbxEr5CI5xG3MGUmpSQsVIt1UmUr3ClKvhScOutVR/elOyDoDeS3OyTX
         Fv9eA9Bnh8FQisMlX7RLOniaHqSHH0Ixu1x5smRUR8qoifL6jy0HN5ImVNdcHKXVBvJr
         FpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S5Ft7vkLiBE/B5kd1gTyHDqyJHbI9BN41DFJnhDyp3Y=;
        b=3Bl7TtxdzqTes8n3a1IFu5wen3NEw6mhnqU77Y8qYg2ap/6szyDQQ92+vxmMpxpXrI
         HBKJ3FCsD2yksi4YfBweUPmUHb3ZTG+PnosZNbmjIElO5BsTh+IUvzacNxap+VP3ibL3
         lkvgIVWQjfDNmiJlScAeyyYLSnJvOt23NlRElcY4VR9xkqqCbT3U5G+E2roKvcFag/87
         d6mQBEuJygW0/uNTR39uxF60M2Zh+uW1lcysdGl3XEZR9FLBplnsAgfJ8o55klm3TSdQ
         vo4+foVGXeYculuoT1jlooTBO/xSY1bT0qgobqJx+DNO0nArr/bwYS2oDZyetIh7tE8w
         ey7Q==
X-Gm-Message-State: AOAM532z9B9kUxCDHmOQ0ElcPZJ7SIvGqnNHt3GmwoG8dFAmLAJ2xwU3
        mSXyOUhTumPr+HROo11/C57EZZn6m7urtG7AHCo=
X-Google-Smtp-Source: ABdhPJy4nGXQcP1kUVpS02rYVl5Sn+DYzjReTYkgzUgpxxL2xaZuAloPs9y5pWFQdaN+A0GdHEWxmw==
X-Received: by 2002:a65:4b84:0:b0:382:65ea:bb10 with SMTP id t4-20020a654b84000000b0038265eabb10mr996645pgq.50.1649125918763;
        Mon, 04 Apr 2022 19:31:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm14115453pfu.202.2022.04.04.19.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 19:31:58 -0700 (PDT)
Message-ID: <624baa1e.1c69fb81.932f4.523d@mx.google.com>
Date:   Mon, 04 Apr 2022 19:31:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.109-592-g78b72badb3402
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 31 runs,
 1 regressions (v5.10.109-592-g78b72badb3402)
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

stable-rc/queue/5.10 baseline: 31 runs, 1 regressions (v5.10.109-592-g78b72=
badb3402)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.109-592-g78b72badb3402/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.109-592-g78b72badb3402
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      78b72badb3402b9e2d2928d8c05df9ab7728ad72 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624b779183e5f7ddfeae067c

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-592-g78b72badb3402/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-592-g78b72badb3402/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624b779183e5f7ddfeae069e
        failing since 28 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-04T22:56:08.422820  /lava-6020719/1/../bin/lava-test-case
    2022-04-04T22:56:08.432987  <8>[   34.049403] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
