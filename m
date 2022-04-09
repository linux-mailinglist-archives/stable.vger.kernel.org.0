Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0814FA89F
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 15:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbiDINja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 09:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiDINj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 09:39:29 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069C516F07A
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 06:37:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mp16-20020a17090b191000b001cb5efbcab6so1985127pjb.4
        for <stable@vger.kernel.org>; Sat, 09 Apr 2022 06:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6MPlSvdXX6n5OoGh9CjLqPupKKyO6qjYIefTntRQuhE=;
        b=A74z5ouqfYhCCoKy8crAcTghGQP6SWR6pDEWTPFGU+Zucrkpp2+/GpGOXCDpQBctkI
         zhEaL3u14F6SmT8Xjt++07k3gvPXaI+DFO4GJiSBeIlo4EwrZr2myxxYb2pa1JVwgo8e
         idGCXhDLcXRhUaDd7G+8uuQYWVIe4l5m7Vhx89gHDzOKlQQz5sQAtGaQvcu0BvVq1VC8
         +1vVcnASIK4O64K2eJDBhCsi210F4mXI63ZX0L8ht7CMcdlxJGKHJdgl7MvG7GK0RgFB
         cnj1qSy6q/50Xo6aA8chnxVK7Ma7/Mj77QgTWtQZmxLSl4U7uhMj9kZPc6AMyxNKaX5U
         sk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6MPlSvdXX6n5OoGh9CjLqPupKKyO6qjYIefTntRQuhE=;
        b=Q6CmAUgiZEgIASJykLBk4q2lKZuFybR19pGBWoCYpn4H6x1IvQfbB6QPwkDUc2dej7
         cV0+omRCNOfZQGj34TEIxyBTvNwq6Vqj/ouia0zVPg7S2X2tLyaQyuTUmA1Q2A5viX7M
         WSgGPMiNPyfJTA4iBLpmniA4JWTyZr8uw8iO+ITh8q6sM5mARxQl7fU8qWrbRhrm0LEF
         eD/LFMNia3n5fAa6U5DfHc3xfzT4Z+Nmtl7UIz92EJPbfvElyIuAth8PkQdM1qw/C7lQ
         NkS1rJBa+1qtxZXELc2u+3EnRczw6/pk2oeLAdGQJWIFmRY5DyokPxwecxT/N4+wQ8WH
         CF4Q==
X-Gm-Message-State: AOAM530LFfQoYwptDCmoDrfpTeP/DDvkIi07l4boKLipJ0Pu0b7VqEWK
        x/qIlwfclAokqA9herOM9lQNyTxHXZev9ERp
X-Google-Smtp-Source: ABdhPJyrdgOsw6SWV93b0Fs1swkQfMQVA5Uvswy6TxVsQfHYWoZh7/GMIHAyleL5j+EKWWdOtzLpdw==
X-Received: by 2002:a17:90b:1e4e:b0:1c7:3512:c2ac with SMTP id pi14-20020a17090b1e4e00b001c73512c2acmr26792651pjb.61.1649511440413;
        Sat, 09 Apr 2022 06:37:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w4-20020a056a0014c400b004fb0c7b3813sm30286402pfu.134.2022.04.09.06.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 06:37:20 -0700 (PDT)
Message-ID: <62518c10.1c69fb81.88d06.fce6@mx.google.com>
Date:   Sat, 09 Apr 2022 06:37:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.19
X-Kernelci-Report-Type: test
Subject: stable/linux-5.16.y baseline: 90 runs, 1 regressions (v5.16.19)
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

stable/linux-5.16.y baseline: 90 runs, 1 regressions (v5.16.19)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.19/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      73be23491df081be0311e65c7744c9f1ec6ad412 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62515d81756f7229b9ae0693

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.19/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.19/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62515d81756f7229b9ae06b5
        failing since 31 days (last pass: v5.16.10, first fail: v5.16.13)

    2022-04-09T10:18:14.706329  <8>[   32.428791] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-09T10:18:15.728963  /lava-6055275/1/../bin/lava-test-case
    2022-04-09T10:18:15.739930  <8>[   33.463933] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
