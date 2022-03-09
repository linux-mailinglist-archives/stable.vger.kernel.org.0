Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF89B4D3A99
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbiCITtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbiCITtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:49:52 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4C3205F3
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 11:48:53 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id n2so2899433plf.4
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 11:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZI5ehzzSbF6OBOImLxghz0+YUuamO4nNgn9cmBR4lJM=;
        b=ODezJgt5SBnO/QKgev1PU5RKU91pWX+yfQQmwfyE9y3gntB5BQXfm7cJ6IBdUaHxs/
         MuI3yqaUvcCn5uiZ5pJNd1wPAe6H1izunktFdEeJwbcTcjkR1BlHxn2WvnhdY7W19pEH
         1aLa3+InOXLOCv87gD+OA04ijYwGfneQ5h4xnr6uoIYrWwrvKs0hPdIle1aK3zQ9zBbN
         ygKXCoMGtTA/7ED3q2RYnjbYoYnO4YqfVRIcq5IGtBu4l6uDq5Fg1FSr0KbrZ7jNImXb
         OEYf+CdqzgA4GQc7Dgz+ldZ+3ZCbL0xQvmvl3aoxqB/Wi4Iacio6cfkIkYceLpjSAoAx
         Mpgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZI5ehzzSbF6OBOImLxghz0+YUuamO4nNgn9cmBR4lJM=;
        b=7tJUtUnidrkX3O65/fdW0Wg+U6UovmkWeaEGuubicaQWe6IRA757KjUSeKr/cEbwCD
         hMxFuLq8hnKruXVa/SPqRMuKvcGdHRo6R5Uh+aB+GzBIHLUAs7ui8zma5EILGobXha5F
         HmSGYp1Ad3TcrgXBV7hRTb7VoQxcGztlIrvFzAaugUCMnylbfJzlyVvMrkLU6vRekXKu
         oTGZc4Z3LtzhZ3K5Kuu3WHrFhH/QCI8HNbYGvCD7kFFQbQVP9k+/KzXr0Ycw1R2RMCNR
         REof3NuiqaYBiHsC1AMZHVAWr6JEf7K+whPnPFxZdauW43TMvSRCQOb4IxLgM+Trzlhr
         sW9Q==
X-Gm-Message-State: AOAM533WFEAQUL8hJkxw9q9LH6Z/2pTUG1cdeksIVyWVi6e+6F9yp697
        5GvQPa/rUB5dfu3YRblD0D/d/G+W1gIIYuo1u2g=
X-Google-Smtp-Source: ABdhPJxnOZ3R5px+Mg9L7TIDAK6oo+Z9zkunmYfBc3xCTX+q+52gO6z7SyxpuiZdD0NYnFrxn9T60w==
X-Received: by 2002:a17:902:c947:b0:151:a988:f3de with SMTP id i7-20020a170902c94700b00151a988f3demr1108384pla.104.1646855332593;
        Wed, 09 Mar 2022 11:48:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10-20020a056a00114a00b004f701135460sm4082375pfm.146.2022.03.09.11.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:48:52 -0800 (PST)
Message-ID: <622904a4.1c69fb81.155bc.a9ec@mx.google.com>
Date:   Wed, 09 Mar 2022 11:48:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.13-37-g9a829312dc29
Subject: stable-rc/queue/5.16 baseline: 72 runs,
 1 regressions (v5.16.13-37-g9a829312dc29)
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

stable-rc/queue/5.16 baseline: 72 runs, 1 regressions (v5.16.13-37-g9a82931=
2dc29)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.13-37-g9a829312dc29/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.13-37-g9a829312dc29
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a829312dc29e4470c5c098317a2d870a8d3e4bb =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6228cdccb3babd79f9c62997

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
37-g9a829312dc29/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
37-g9a829312dc29/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6228cdccb3babd79f9c629bc
        failing since 1 day (last pass: v5.16.12-85-g060a81f57a12, first fa=
il: v5.16.12-184-g8f38ca5a2a07)

    2022-03-09T15:54:35.254272  <8>[   32.409251] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-09T15:54:36.276068  /lava-5846012/1/../bin/lava-test-case
    2022-03-09T15:54:36.287349  <8>[   33.442613] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
