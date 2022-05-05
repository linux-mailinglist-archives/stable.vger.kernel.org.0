Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C935E51B601
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 04:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbiEECj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 22:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbiEECjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 22:39:51 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7854665C
        for <stable@vger.kernel.org>; Wed,  4 May 2022 19:36:13 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n8so3160219plh.1
        for <stable@vger.kernel.org>; Wed, 04 May 2022 19:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CCVIMbOe5McnK5WnP+bZ62jJTfL7ur02JLtNU2m7Z+U=;
        b=UgtmWIZSl+Jfedz+VtDPlWaIM6KsaqMZe0HVK7RibBaLSEYYtcq4AgiHWtisEiY7lD
         /31Pb1mjTbAfSv3EGLpYv9/BH6ATs8PZ6W8YJhnHzvYTRjDLSU2M6y+7iQ9wAOsnyUvb
         rcTDasJqpXUsuzp06ttq+AD82XgalYcysicDTQXdzQatj5WCjKIwLZ/6WWXLy77OZk8x
         3WIXPf2MjJRQIEyKD1SccFxkrZDRv5B1emgzs5PEh12+szmZes4kJkQg9/vfVlYEAmiO
         8S+LTMD7NSSFB8bOdxYwClYS+DbVsjRo6lXoC4EaQw77oQjIFdIWwWV5+u5gjQCSTWWc
         Dixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CCVIMbOe5McnK5WnP+bZ62jJTfL7ur02JLtNU2m7Z+U=;
        b=bBfrRRBPcyB7PhI6ECeA3iJkwv7cQCpTIFcZozae9sNuGu23icoTWiOwJxIhPZj+dB
         OfhGidvMHNV3qzKNR11mPhcjqck8WvRCOFH2FCwTiy+Tg4FRqt8++dcxmulaLlIFiAka
         n7KDc15dIVd4uRyLK2zAx5QeF4dukAWsIx8b/2W6DZTpOAEkW7AyU61BpgmYy3te6Ycg
         ucbr6qMy2qunKORbEOeTPiFDBjqM+HyalqjQVtXP7hbKoMh0rAFDbfeGEymIja1HwB+1
         G4TWZnjesNvBZda+JuZVxSvglLNmYetMciweE72yHRpijyV5SXvEbjw2z8rlA9mM4Nsl
         kCgA==
X-Gm-Message-State: AOAM531iJIopsOVJMIhvA9nWeJ4r+Hh4E1nRt7SfxdeC8UdRnqHE3XF3
        d5u23hkZ9MtIdHhzhgf0CUQs/Xw8ngxuL27WR6U=
X-Google-Smtp-Source: ABdhPJwAdyAPTI3AWxkxkNSpzI2jdsqxV9282wd/EyS48tJOs9R8Npa1RMDolnQJ1E74jTqUyindjw==
X-Received: by 2002:a17:902:dacf:b0:15e:baec:a6de with SMTP id q15-20020a170902dacf00b0015ebaeca6demr10293380plx.32.1651718173127;
        Wed, 04 May 2022 19:36:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s14-20020a17090302ce00b0015ea8b4b8f3sm177142plk.263.2022.05.04.19.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 19:36:12 -0700 (PDT)
Message-ID: <6273381c.1c69fb81.3a8b0.0a0b@mx.google.com>
Date:   Wed, 04 May 2022 19:36:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.241-58-g8b40d487da7e
Subject: stable-rc/queue/4.19 baseline: 89 runs,
 1 regressions (v4.19.241-58-g8b40d487da7e)
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

stable-rc/queue/4.19 baseline: 89 runs, 1 regressions (v4.19.241-58-g8b40d4=
87da7e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.241-58-g8b40d487da7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.241-58-g8b40d487da7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8b40d487da7e33cc8ef202741c3e18645edae887 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62730a7f5f486008668f573d

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-58-g8b40d487da7e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-58-g8b40d487da7e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62730a7f5f486008668f575f
        failing since 59 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-05-04T23:21:29.196028  =

    2022-05-04T23:21:30.212199  /lava-6266903/1/../bin/lava-test-case
    2022-05-04T23:21:30.220020  <8>[   36.899323] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
