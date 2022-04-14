Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFA4501B6C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 21:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243102AbiDNTD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 15:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245685AbiDNTDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 15:03:25 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4F3E0AE6
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 12:01:00 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q19so5542018pgm.6
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 12:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XiIY2bpIl87rve9rCCsLMKA66tXDqjakf3CIq1AlcFY=;
        b=J8jBPE2Cp1547qCuZkJ3qnaWsp+Xpt20bHm8SBXRL6td9nulZEHfQxfP10VdT16UJM
         a58ncdDEHAVMsfUaL9b3ZdatJ8tVcc9NDTHhGeO+Yq/pURU8rKBNhW6OAkuG5BwSnmza
         t6ZKwc35KGmN8w7vuL9ndB/xz/himzDH/8CYwuD+77hliVAMsBnItXIFaKQXWvYimn3r
         hLelSDhh9QgAtShh4sjhLlhqavmOCBLaGlJqc+fl/u0jhpCo/nwyqMC366FoT74aiQGG
         rtsfxaIbo9rka+MTvqJhrXzYh9Huhue0T0LW7t2JKSa+6MPm0ybULB8jzA+/9lNh5kJy
         ePLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XiIY2bpIl87rve9rCCsLMKA66tXDqjakf3CIq1AlcFY=;
        b=qZ+TU46yQraUKFNKOP+tG9xN4CBSX6/qsiG62LVDb/VUrG70ZuVttAQGHBZK3FXwGf
         KdvPw+yieeg3w8GLMUyKpdcTLS9ClA7IeX8wtTvxINtfu/mQQjSDR6rSKPHw/hBMI/tB
         wpXRnRsTRmYTWLD8wS7QlfFsaM95jRHKMG+hO3tQF1kQ0ipcmmEI3h7ygQ7OlGT+euNo
         3JXTtXx6pXxLdJBHFck5FlQ9achNnNuessaxv7vElKh+bUzc270uw4I69T9+uhdrEceZ
         LjgJ//NoUc3cilrIez0UZYMUr7eQW/pouNKpftorFCANu+lDqAst/hRFJc+C1W8d5yYh
         eL6w==
X-Gm-Message-State: AOAM533S4qfwM1zS2Ddg6adrm8eBRN0gPrLQXPDXnF68/tr4EgfvyMiU
        JhoweFMYdMl2ojVNg6a6SYu8h775u50e+Om0
X-Google-Smtp-Source: ABdhPJwYRUku7lSCSFoHbdcTD1AI5CMBwNV97iDQyN0nrMp4l4y4Pwqwn3xPF9fLaom9rxPmkWkzzQ==
X-Received: by 2002:a63:de10:0:b0:399:4e32:32b with SMTP id f16-20020a63de10000000b003994e32032bmr3340675pgg.41.1649962859858;
        Thu, 14 Apr 2022 12:00:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j12-20020a056a00234c00b00505deacf78dsm602822pfj.149.2022.04.14.12.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 12:00:59 -0700 (PDT)
Message-ID: <62586f6b.1c69fb81.bee9a.2439@mx.google.com>
Date:   Thu, 14 Apr 2022 12:00:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.111-5-g5c4c2b7fc0e1b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 86 runs,
 1 regressions (v5.10.111-5-g5c4c2b7fc0e1b)
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

stable-rc/queue/5.10 baseline: 86 runs, 1 regressions (v5.10.111-5-g5c4c2b7=
fc0e1b)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.111-5-g5c4c2b7fc0e1b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.111-5-g5c4c2b7fc0e1b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c4c2b7fc0e1be6df91ac9c3a2d307e42d773388 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62584046fb87fd7e34ae0689

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-5-g5c4c2b7fc0e1b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-5-g5c4c2b7fc0e1b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62584046fb87fd7e34ae06ab
        failing since 37 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-14T15:39:39.378213  <8>[   60.004266] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-14T15:39:40.401544  /lava-6090381/1/../bin/lava-test-case
    2022-04-14T15:39:40.412216  <8>[   61.038436] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
