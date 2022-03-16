Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AE14DBB59
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 00:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbiCPXuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 19:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350541AbiCPXuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 19:50:51 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3E71ADBB
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 16:49:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so3955163pjl.4
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 16:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xySfkkWDKoqOLvBq9mj4jC5h68XPkUos5SCBLWnCgdo=;
        b=Z50BCaVWxy+scZcUj4f21/n+N18kwIkZ8W7L0lBGdXI8L8zlIIJAf5NBeIFN/THSXl
         H+DZU9l3SVI+OJ3F2cXLDvZdtkIFNhfJe7r1Bxw54557jlCzWVwRXO5R41vG02FTFHLj
         8/gGbQO0TXVLWmRMdZMAohTCux0V+QiPD0+PWFA7nOT9+7qQ5FJkPfGP1sN4vjuyOtLA
         aEH9KjCCXs2TZ5fcjpm7byCJhtmwC6nwRGbPMYSGMMu6jmBLqsWPCgwFwNnzDoW4uZxc
         Bc4gWZeo8TcaBCc8wgDumieuSXXh1K3ueSP49cWH0fRy/XKmY6eSubWciU2o11PeBfGT
         IJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xySfkkWDKoqOLvBq9mj4jC5h68XPkUos5SCBLWnCgdo=;
        b=rVKGTLZN/nL/+7FYBM+EeToLp596lzwg1aEuE+ajeWcGAkMTzT5hYKHIesphHfne8w
         0LK5GxebFaA0ia0jaRYc6QPiACD9tcwD3l7WicW6J9mTeop14b3+a7hQt5Nn3ggPUhbF
         olku854HEDjOMjTg4gcfd71rvIPxDijw/uMguREgrMVRHrfmMq4kdDG5KANTTmMh1cn6
         AjF4CBFb4u8tc0nTO7+eyuBfa4C1NmNAoQyYrijlAtwqr9ATxkR2E+9wVHQWcJXNYDud
         mgJxqnO15EqVHKq5bTto4O9MS+t1a9guMrYlceHpohji/HmPDDuPYPSlWfk8mpLVUBFs
         MeDg==
X-Gm-Message-State: AOAM531wvRZ6umJPFFZV4YTnoh/+Wq7eHr8Kq4yD94nS7UyxYxHi7sa6
        E5YDelvgmnuEwjgjzbNQAy2EuRHJp+BWbd5l89Q=
X-Google-Smtp-Source: ABdhPJzgDaxI//z6ksHqWUO2JHoE9CkBTGhUm79tugcnCH+IlG7ws5QaV2gdWYt9RqKuZXnA3JVp6w==
X-Received: by 2002:a17:90a:ab08:b0:1bc:3ece:bdc with SMTP id m8-20020a17090aab0800b001bc3ece0bdcmr2289687pjq.32.1647474576509;
        Wed, 16 Mar 2022 16:49:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g28-20020a63111c000000b00374646abc42sm3401050pgl.36.2022.03.16.16.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:49:36 -0700 (PDT)
Message-ID: <62327790.1c69fb81.6df3f.8d8b@mx.google.com>
Date:   Wed, 16 Mar 2022 16:49:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.29-23-g4e1bca35a00d
Subject: stable-rc/queue/5.15 baseline: 101 runs,
 1 regressions (v5.15.29-23-g4e1bca35a00d)
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

stable-rc/queue/5.15 baseline: 101 runs, 1 regressions (v5.15.29-23-g4e1bca=
35a00d)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.29-23-g4e1bca35a00d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.29-23-g4e1bca35a00d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e1bca35a00d091242a7a8b62d02d748b858f394 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623241b766ba88fe11c629ed

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.29-=
23-g4e1bca35a00d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.29-=
23-g4e1bca35a00d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623241b766ba88fe11c62a13
        failing since 9 days (last pass: v5.15.26-42-gc89c0807b943, first f=
ail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-16T19:59:26.147159  /lava-5893180/1/../bin/lava-test-case
    2022-03-16T19:59:26.158043  <8>[   33.483051] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
