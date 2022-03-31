Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EE44EE212
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 21:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiCaTsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 15:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241087AbiCaTsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 15:48:04 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0182663526
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 12:46:17 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id h19so579914pfv.1
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 12:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+tJ4Zu4Ri7TFVtQ7B8kFn/mYNKWrW2Qi1SiugoyzFck=;
        b=TDXcvjvY3izNJ0wqrTOiJAJI15ZrurbRjneG3+aOzesvsJFmjtOxzgcTc/iTRAufTT
         h/jYzluH86Y4bEieGvGsAWTYEIn1BrNtKilAPX1JFsl27aG8hD6lwJywyucLZ95XECgH
         woLxRRvEktMyNnM6OIG4J5RcpU2tnhKstkc+7jXps0nZx3o8KmUs945SEIXaBJ1nDIf8
         k8RKUzvbmB1GqmY/oaAVaDvj6aF2coxW4/kfYs6Dz573Q8mzbnw+ZrQiaVsCbapOZIcF
         hi301VUrX2Si1/llfyqOd0RmaHhJZjWUooMV10wH0KiRd67iX1IX71jqXTCSaDuAmlj1
         xR8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+tJ4Zu4Ri7TFVtQ7B8kFn/mYNKWrW2Qi1SiugoyzFck=;
        b=s8BUVgPMrhvrSwl1KLk3EmKnUTQwf2Z6nKFFua4TvPuJYbLyK/VyQLsKONahCsQNnV
         sU8q1h7POhljND6/L59GNQvjYUEn/jhPcRxnJGwj7rt5HDpizRXkAC6zzcms4gFX2J6F
         7/kMPJ4gLbL0G0y0KmlPkRJtJy3c5JHsIAdHpmy1AY6E/fj0iaUR7vjvl1Tbp9Lde9Hh
         PQ7LRxXuyPf934U/+ELa3DdO0we7J0bT2uFIkPY5pdYOww+cZ2CUJJsn8JJM85ZBWs+X
         hg4m9YnBvMy/TWTbP+Vp2lkuToLZ9viTkL3gj8Dv1nciLOqCOHC+QzkwqnrPkk0DQIFp
         jwSg==
X-Gm-Message-State: AOAM532Ng+Knwi/RtaaG4pTKJ1t1fKx+tHTuJBTliK1ProE0tjm1gmZ2
        Me+/uti0ljqcjU1h4qNlmIwM0f43EfmDIq4V7yE=
X-Google-Smtp-Source: ABdhPJw2lof86MFUPWXh8Bzhknc+kQngmv+/xVUDxpr5qnSmf3xIPHMAJLHtAztCL1ZOUekj52/QUQ==
X-Received: by 2002:a63:6e43:0:b0:386:4801:13a6 with SMTP id j64-20020a636e43000000b00386480113a6mr12095390pgc.403.1648755976323;
        Thu, 31 Mar 2022 12:46:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y14-20020a056a001c8e00b004fa829db45csm235057pfw.218.2022.03.31.12.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 12:46:15 -0700 (PDT)
Message-ID: <62460507.1c69fb81.bb77e.12b9@mx.google.com>
Date:   Thu, 31 Mar 2022 12:46:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-15-g3c6b80cc3200
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 103 runs,
 1 regressions (v4.19.237-15-g3c6b80cc3200)
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

stable-rc/queue/4.19 baseline: 103 runs, 1 regressions (v4.19.237-15-g3c6b8=
0cc3200)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-15-g3c6b80cc3200/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-15-g3c6b80cc3200
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c6b80cc3200fc53db015e9de8df4d2e5bbdcab6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6245d5ec3138407e91ae067c

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-15-g3c6b80cc3200/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-15-g3c6b80cc3200/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6245d5ec3138407e91ae069d
        failing since 25 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-31T16:25:01.569398  /lava-5989095/1/../bin/lava-test-case   =

 =20
