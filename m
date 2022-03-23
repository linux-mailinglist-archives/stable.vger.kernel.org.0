Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531644E5AF0
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 22:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242437AbiCWV66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 17:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345056AbiCWV65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 17:58:57 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CC88EB56
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:57:26 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t13so1048812pgn.8
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MGaTSp8vhZLtsi+A6+dNCUTtQi/tPgkb2L99Vv9++aM=;
        b=raqOAvA0ApC6TMIaHjNXbX0arBBLFxuLsxgRhPa0VXXZH5/D1FXSKmFzIz95rI7RLG
         OxqIcdBC9q+kid6PWINfL6kYMzJ9sgRg8M9m+dfuOu2QlrLZ5T99CuBpmrg8YhPwYZI4
         oMCre8hnqDwa6Lx/HysilVt1Mt+F9IBF8/WMHfICxqt78SznZQNy60XFYVUhGIUpz0bc
         3ectuQP6vQiBCpbN2j+5u/INjbDO5E0Os0yFM6OxxFRLvjWAk77zaBYTkwNYpyGVbTsv
         vZ9wdmd/4ygnljW2JjHveIxkEMHi1Sm2GAZRxR50ZXM8S420tYqjnnmUpADkpqkvxvV/
         EF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MGaTSp8vhZLtsi+A6+dNCUTtQi/tPgkb2L99Vv9++aM=;
        b=fjiAfdWrlSrEg0OE18aK3FN0h0D3YnBzX2gs/yJm59ylDHUikPiYs3H9AMT5io2SPB
         nhGNEnqGILPfmT0+TYZxlsHAvVuVVvaUDgXuRTXIFBRZoQzj8L2Mewki1DjBUOiN00Bz
         5WW6scjlR3NqMAA+aiVYpGVdlLtlw5oVVNiMV4FBiv0fdce5sv+VZcyr0bOVCHXQxt6z
         DgnuK1r9A5rX+/MQV18Lq/lp0e3ObI4IpZIytEKFAb6/vfYpKUQGZ+CAKg1KXcrZaR2I
         F1oX/NZY2FSaeVl7cGB1gOciOSocRXuGQSjtOQG188G0Qy4ziyPq6SFUSrkLh2O8+DoH
         /fEg==
X-Gm-Message-State: AOAM531zleO+viUo+0NKJmLAOkHPE4405vK3mA7IifnMmhfGFF6+fwsz
        s2lShgk1pv1L+FuFpWfYitYM0n847Ud0I6fQ5eI=
X-Google-Smtp-Source: ABdhPJyO+RQOZDObRsILiLSq0qKpB5R5QmFJPFAnRj6AA6c/jrtEywc0v8ulzxowL1+g5BUU6hW6rg==
X-Received: by 2002:a05:6a00:130e:b0:4f3:9654:266d with SMTP id j14-20020a056a00130e00b004f39654266dmr1539715pfu.59.1648072645940;
        Wed, 23 Mar 2022 14:57:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c14-20020a056a00248e00b004f77e0fbfc0sm795467pfv.185.2022.03.23.14.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 14:57:25 -0700 (PDT)
Message-ID: <623b97c5.1c69fb81.bc88a.328c@mx.google.com>
Date:   Wed, 23 Mar 2022 14:57:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.108
Subject: stable-rc/queue/5.10 baseline: 52 runs, 1 regressions (v5.10.108)
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

stable-rc/queue/5.10 baseline: 52 runs, 1 regressions (v5.10.108)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.108/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.108
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9940314ebfc61cb7bc7fca4a0deed2f27fdefd11 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623b6b0057cdc5573e772542

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.108=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.108=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623b6b0057cdc5573e772564
        failing since 15 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-23T18:46:05.486968  /lava-5934248/1/../bin/lava-test-case
    2022-03-23T18:46:05.498077  <8>[   33.993820] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
