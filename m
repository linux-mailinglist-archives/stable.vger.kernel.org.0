Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D6C4F4282
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbiDEOgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 10:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388227AbiDENVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 09:21:35 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F465FCF
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 05:25:46 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id d185so377600pgc.13
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 05:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0TcpqvPJ9djm3DrLS5MbunluH3ne6WP49cQJlfJ6ZTw=;
        b=UWAwy+jkFa8xlEoZOCR3fLYSrc2pngCWCLzyftoSkhuMo1OgkmQ5v0y22QRp5CXelq
         BZd1L9LzY1WLQR/ASZYVTBdKxGPnWITsKq38JBNxZ1m31qC8TKm6JTPUThLsasJRZCRi
         8vbnCRjoIRNtLDa6Ll7xe/u9hpxWaJGuM0dDtu2/oz7M55TCatcdoNlraGfnkgYfMTBH
         z/IlOJQqLjThvCrlQA3X6YpO1zLi6/iUDTwMRRBiKja1wCbzwk3gZggXN29HCSCA0KRW
         RwFWm+LbbPjXpzl+E5VgDKM3gsYq//Znv1poRJUl364BCaplBEsFLODHPQbYLEvwonx2
         Np7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0TcpqvPJ9djm3DrLS5MbunluH3ne6WP49cQJlfJ6ZTw=;
        b=UvUqvN4A7zxb1UFjTSxJzlakWV2r7QDGlDaV5zztEako1/1HUWFQmTrvRrtSnNl6Yw
         yubGnuz0fF8XTB7UqzM2skTc/fb9jfLqSZ4qTV9+Ej7z0JWjcKdW6evaXgVcsxhHnCbR
         mQYvxlrJRxeEfyVrkz7df3cvW1SKQysCZUysMEPaLHFAXQQ9yUi33gY1UlHqycP3lBut
         JZx30LUTXisOiIFzNs0F8HFXnJJkKRgxDyKqwnGu3JvGbNsoaCKmLfN3U3MKEOVCNREU
         HkmzD1fgr1eg4J3DQVq/aDW1tGlizpvx132nrXfB28krl85pfDPnpu/zY8xXNWHM2I70
         jltg==
X-Gm-Message-State: AOAM533v6kNNv+Zd5A8oBOdeQNnz0rKYNgyeOTmchbaVG2TgbWpM+I3a
        aeQUqiAmnU43n5TQA2BZFyDM6EfmhEvKFC0SSBA=
X-Google-Smtp-Source: ABdhPJxZT0AhhT/PngUQ884q9LAPwAt9GlxlZFRX+6dRCrgeZDVwoZnAcALW1H2/ohgmMoEF0qQAig==
X-Received: by 2002:aa7:9522:0:b0:4e1:d277:ce8 with SMTP id c2-20020aa79522000000b004e1d2770ce8mr3503050pfp.16.1649161545355;
        Tue, 05 Apr 2022 05:25:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id me5-20020a17090b17c500b001c63699ff60sm2526470pjb.57.2022.04.05.05.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 05:25:44 -0700 (PDT)
Message-ID: <624c3548.1c69fb81.e7654.5fee@mx.google.com>
Date:   Tue, 05 Apr 2022 05:25:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.109-600-g45fdcc9dc72a
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 60 runs,
 1 regressions (v5.10.109-600-g45fdcc9dc72a)
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

stable-rc/linux-5.10.y baseline: 60 runs, 1 regressions (v5.10.109-600-g45f=
dcc9dc72a)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.109-600-g45fdcc9dc72a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.109-600-g45fdcc9dc72a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45fdcc9dc72a44448666a2bcff4030a659e29e46 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624c057ba5875e11e4ae0690

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-600-g45fdcc9dc72a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-600-g45fdcc9dc72a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624c057ba5875e11e4ae06b2
        failing since 28 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-05T09:01:36.894536  <8>[   60.098121] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-05T09:01:37.923661  /lava-6024261/1/../bin/lava-test-case   =

 =20
