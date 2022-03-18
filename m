Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670D64DE3F5
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 23:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiCRWYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 18:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiCRWYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 18:24:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77E153A4E
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 15:23:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p17so8154781plo.9
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 15:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=llaNUL9B6zw84PLyEx53OhdUU/fw9nnXhH5NgrW8GYs=;
        b=CLDBM1oL3W4tZKyTYiTVD2rCDu9/Xqb+Aq0SzAzfgzbo6VjYevuLRS8e6JaldsFUVO
         lCHnnRWUyhE34c2+zukv/Li2HuFjMKlS6NdvD1AlrkbC1m6hhRL5JbPQyNETqGlUAUl5
         eZvDOIFByyrmmHlwJ3KRYfGmKH+eUqC/ul32k+gOS52KYu/EaipGBiBLr4peilEKhiAH
         tSuG1MuZBvlbM8N9lr5zvjc/noeNMEI1pPhFD51OCFsSfp+MFxCPmZJggD4YXvJTlpag
         pAWbSVK7Vq4ldsFavORX0D3cTSGL3RfbiREVTzCraN2jF095fPolpd7G5KfueKHV+7Qk
         0+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=llaNUL9B6zw84PLyEx53OhdUU/fw9nnXhH5NgrW8GYs=;
        b=U+gd2OPXg/cpjYxLQbb7uj3nsfC9zYuex/auV9DnYSZjyMBVrVT6PN4ePZXvfSL+ai
         PRdxBH8UkrLS25E1ssWBE4aC5Uvv1riA9I3Qr82IlWhF+/IeZ6e1Jja8FrcLyZPXl4qo
         yYGP2gG5IQZ58hnPy7aJeHBW8wkwqlKTssxQ+CXwfRugfP/RVL6rfuiL1uSOYGdfVWq/
         SAKKCWYdFzumgAf8H05S5dTYVh+1H0M6Y3GYhyOJbSZHpDlE0k9cAMLmRu/PDunM8lfi
         my2fd+f8bxnOdlNSXA/qN/BSBBOd8sUTMvCzoXnGi7jNy7ibPeGICwcYRnJtr4LDk+E7
         fN0w==
X-Gm-Message-State: AOAM532ScjoMMtQfNeoGDzENpVe8yXXjEJyfOIWOpuQ64tYvB45qdto4
        cfdwtVdkUVkhNNrH0QsNRXgqpu+fretU+t8GVoA=
X-Google-Smtp-Source: ABdhPJx5lgyenXcJWzVyk3iQFsJcb7DTrGiUfKvZ3tQB8gnhzPPgSDLHbyXzrMB4VX/3yCYsjiZjdw==
X-Received: by 2002:a17:902:da90:b0:154:1510:acc7 with SMTP id j16-20020a170902da9000b001541510acc7mr1691803plx.103.1647642199629;
        Fri, 18 Mar 2022 15:23:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b20-20020a17090a489400b001c6d50bb5e0sm193077pjh.46.2022.03.18.15.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 15:23:19 -0700 (PDT)
Message-ID: <62350657.1c69fb81.915bd.0bf5@mx.google.com>
Date:   Fri, 18 Mar 2022 15:23:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.29-25-gedd0bb633e6e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 88 runs,
 1 regressions (v5.15.29-25-gedd0bb633e6e)
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

stable-rc/queue/5.15 baseline: 88 runs, 1 regressions (v5.15.29-25-gedd0bb6=
33e6e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.29-25-gedd0bb633e6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.29-25-gedd0bb633e6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      edd0bb633e6e6212f1e35bb512aa47f3daadc836 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6234ce0fab2c237b4af80081

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.29-=
25-gedd0bb633e6e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.29-=
25-gedd0bb633e6e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6234ce0fab2c237b4af800a3
        failing since 10 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-18T18:22:48.850335  <8>[   32.659245] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-18T18:22:49.873619  /lava-5910397/1/../bin/lava-test-case
    2022-03-18T18:22:49.883885  <8>[   33.694024] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
