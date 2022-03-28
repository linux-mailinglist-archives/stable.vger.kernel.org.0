Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF8D4E9F58
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245414AbiC1TDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245413AbiC1TDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:03:15 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509273B033
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:01:34 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id h19so12592948pfv.1
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WT6bbSBux/ZMPXy6ohwR9nDtIRCG37rur3azrfs3hPs=;
        b=teUxSCYwBfpSEVtW8FLZxK4lNOxnDO8jEGPhwrWQcEvJC5b+44Ch7C3iiN6Ue+30B6
         1UqhBj5upExyD52lTyn2WUXth8K6hjefqIJRQAcEGjNLb3mU72BBQjBocH55INlAoUK5
         tDcmAe4lGTekr+g148c2TDUpyvSg6PevisbU9xu/5gZEDb0KWMQHJrvznONc306/W7Tb
         pkkxonN0T6Wz0IztRfLb3Q2sAUuF0SEAoFpMLWnE3TMRfjNNOGpx1vdh2qGTg7iBzuFk
         NVl/3irIBXCb+K/NxE3+NSEAwI3F3rRvq8N3ElB3Nh5v5Nk1dS8k5NOVyjBPT/I2tVN1
         9TIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WT6bbSBux/ZMPXy6ohwR9nDtIRCG37rur3azrfs3hPs=;
        b=kIOxG72W3u5pQSE27AcqqjqcaZ9jOLdHFY0Ab81/xm1P4qFRjvUdEQdWaAiav7IDHN
         joBgJeJThTOCjLSK7h40zs4kNoefQLri+3TN5LSb7ahYzTnW4pAaO1sbi2NQk97qn2U+
         0Q0IvluSXlc+BPZlyuI1EQGwqVNvo0gj5QNNjOM1HnuJsb2zsEI9cgvIrY558UtNRmS9
         FUeF+7PnHJ5y33PwecfdVNLSxcOy7/c2Leihwp0dIXpy5JVp0nPQUahx3P287+WAjY6o
         gjeArf/wKqPjALhZUCj26bIXl29c8PTfKZsCwVkcfu0G2hIRnTiQtg+HB6bG1O6ri0Gc
         QdQQ==
X-Gm-Message-State: AOAM530Johme5TXKEGtMG8o91rRTltxou6QHBaFJBETaAordHplJrkK6
        zPb8eSeQz/v9LiNU5Wg8WBGb56MiiEe4YrU/sl0=
X-Google-Smtp-Source: ABdhPJz6uAeW1Sf/BGrq9yeBnPEOKrTccnnJWJBuwFAjcYDjiP/sKsEtnz/Y/qwQLdzHkpnyN6Ki2w==
X-Received: by 2002:a63:d306:0:b0:34e:4330:efea with SMTP id b6-20020a63d306000000b0034e4330efeamr11261567pgg.174.1648494093532;
        Mon, 28 Mar 2022 12:01:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11-20020a056a000acb00b004f35ee129bbsm18644814pfl.140.2022.03.28.12.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 12:01:33 -0700 (PDT)
Message-ID: <6242060d.1c69fb81.d827a.01c5@mx.google.com>
Date:   Mon, 28 Mar 2022 12:01:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.18
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.16.y baseline: 131 runs, 2 regressions (v5.16.18)
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

stable-rc/linux-5.16.y baseline: 131 runs, 2 regressions (v5.16.18)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
odroid-xu3       | arm   | lab-collabora | gcc-10   | exynos_defconfig     =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9fec77b5f094c1bbd0432c3f98d20cca8fc07321 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
odroid-xu3       | arm   | lab-collabora | gcc-10   | exynos_defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6241f22fedf3116573ae0706

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
8/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
8/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241f22fedf3116573ae0=
707
        new failure (last pass: v5.16.17) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6241d65852a236baedae067e

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6241d65852a236baedae06a0
        failing since 22 days (last pass: v5.16.12, first fail: v5.16.12-16=
6-g373826da847f)

    2022-03-28T15:37:41.866608  /lava-5960176/1/../bin/lava-test-case   =

 =20
