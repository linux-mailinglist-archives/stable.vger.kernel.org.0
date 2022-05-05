Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACFC51B6DE
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 05:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiEEEC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 00:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiEEECZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 00:02:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E82749F00
        for <stable@vger.kernel.org>; Wed,  4 May 2022 20:58:47 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id s14so3268020plk.8
        for <stable@vger.kernel.org>; Wed, 04 May 2022 20:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pijfzsV1/gE2g3n3zFcRPTEBUORNbzAHyws1WMcvHuM=;
        b=2rJqarrslWvlPuRhUUCNIMAkaGHJX8jBZMSj0bKkKZE+ez9YMUkYGgK5oGSZOQ/Uqj
         O7fBnWqNQ/YthTQk6ZvJjdtZmOApHPDwv9ZxCPXz2damGFgppyvJr1CZUe8IPydwYWHr
         ci1zVAmuX+vFhahGvQ/o659H3nr9Fq1RTUMlJQRa5MgXZ4Pi5keh+8oOfTu8vzTWzvhm
         BV+japZuKjv0RaY6fwhsoEQkVGtfQe3HYNwK/ufPwx/bJ2ycwwJUBFpgP7klNjZktr1O
         bVYs8KvGLOR5fVnFIntXdQ58btdSACRlbF20qbl2PR52Q0ONr8lAHyWplYAyR9rb0DYM
         ZLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pijfzsV1/gE2g3n3zFcRPTEBUORNbzAHyws1WMcvHuM=;
        b=hyxFXnpLghC1PIDGlJwZHometH7da5YDtkHl5v5/nCIISJ1KukIzDgiUqR52t1BrRt
         Jw7D8K6Db03RttPuJXkj3/Wl1V3Y63UhDmlvVl9HlT3kxEJ4xgBTOb/pwfrN40Az3xIn
         wILxcC57TcfDQO595FLImvTWp6C7bCbxldldz7HSVNH0aW2pxfA2MvSjMsyXQYIIp81N
         5PCqCvSj4I9ulDeW2IxBro9Ox0SGqMaLg000jBKPVECtQZeYh/+XwnyV0qzDm2xQcaf5
         n02EW0+d2fG8BFrdnOOkR2fvfWz1SBR31ZDUfaERkBuBtCfqLIN4Gc6KuGo3U9fP7RTj
         xUkQ==
X-Gm-Message-State: AOAM530JLIloGmp09RAOsc0W+OCx6L32Yip1HF9UTBw1pm3h4cwb6AlB
        T9I5TdjJSy44BsrqLFFcGIAO5jo1nWaBLea5dZ8=
X-Google-Smtp-Source: ABdhPJwJDbjfn6cPIrLVFqdJedB4HaFCQWt/MYPhGdiKccuEQjIanJhQ51rtzgHNoLL/VKpTkgsGEA==
X-Received: by 2002:a17:90b:4d8b:b0:1dc:a9c0:3d53 with SMTP id oj11-20020a17090b4d8b00b001dca9c03d53mr3550353pjb.29.1651723126466;
        Wed, 04 May 2022 20:58:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i3-20020a17090332c300b0015e8d4eb24esm296539plr.152.2022.05.04.20.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 20:58:46 -0700 (PDT)
Message-ID: <62734b76.1c69fb81.16aa1.0fdc@mx.google.com>
Date:   Wed, 04 May 2022 20:58:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.113-129-g488ef7a9d9c3
Subject: stable-rc/queue/5.10 baseline: 110 runs,
 1 regressions (v5.10.113-129-g488ef7a9d9c3)
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

stable-rc/queue/5.10 baseline: 110 runs, 1 regressions (v5.10.113-129-g488e=
f7a9d9c3)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.113-129-g488ef7a9d9c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.113-129-g488ef7a9d9c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      488ef7a9d9c34e0dc0c77eee88b9b02dbf42bec5 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6273235331058a14e68f5752

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-129-g488ef7a9d9c3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-129-g488ef7a9d9c3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6273235331058a14e68f5774
        failing since 58 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-05-05T01:07:13.526235  /lava-6268054/1/../bin/lava-test-case
    2022-05-05T01:07:13.536863  <8>[   34.542040] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
