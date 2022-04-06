Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4324F6BD6
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiDFU5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbiDFU5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:57:49 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316A8EDF1F
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 12:19:34 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 7so3317574pfu.13
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 12:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4HG5FpOS76xuUdO5FzeP3kgrJUYAN9/WhI+E/eGYLm0=;
        b=WkBmSFFneuGuxZsK29r+aUspxE3fyCVUOLXfbJpRlQcXdfU7ZkygLkzMQ/7Yacy8vV
         y1D38zpMMm/j1u2KHZ/XWSa+B75w5z/cD+KHh1AyOCUIuwC2w2Gv5/bb+BaduFX5Fkml
         8jy0Wr7D3MG46mVYKiSgsnPJOR0oJDurk/hkvHch544AQ7df49a1Jw5OarZCENLy5axc
         R+ZTwzdphkOm9I8pqau+sbqNBC+rnzMnF6ea5PsUioHSUF2jGJOj1YLcBqyHGn3Xe+Mi
         YqvozjA3MTjHFcHOrpnDRLd7+R9Q7aEKITEoLwh+38fgVnVst6rrkp47ApzKDzyw7srg
         OBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4HG5FpOS76xuUdO5FzeP3kgrJUYAN9/WhI+E/eGYLm0=;
        b=lAcLtlOA4lNaLpCvkqRQbm499+rSudVvoYzV9XZGjOWb/qFxyRWAehyVELbvSaWeWT
         Q0Gn+SSboEmI7/ssUMWnt9NG3s9BTMeEOTmQcj8IFkNN74jKLrl2Gtjpah2ocpsTzxS3
         WUBU5f/EmEbsWiQVn5NpZscvCc5GQEtSoyBJbpr2lD2xZXhGIP6Z7ma6QSTCBpbdQYxI
         YzP/VG5vYi6HZFX+EbBcbFEXIRM96nQ6kID9BzL6Y/htReGsMg2xlBbIpKM57X7y4sRu
         7J1+EUXRyMv+Wv0NZEj6L8Q0xEVKpQr8gsg/6Csv1QKsS78Q1p0/5OyCMOXj9JQZR6ln
         /+9g==
X-Gm-Message-State: AOAM533sLog/SQi9l4ZMjnFfMKmwVmNezaDa9U+p2Q/S2WGNAzuaccX/
        mtRvTO6KofnD1IZLxZmPNSAgM0cA1+pUjUu28fw=
X-Google-Smtp-Source: ABdhPJx/YKhVZjceMXyc5iu3WlZfDAkgOpM6myLflmQMTg+xNWNcqlUtsJJFvdH6A4cNMpmpmXF2SA==
X-Received: by 2002:a65:6e82:0:b0:381:71c9:9856 with SMTP id bm2-20020a656e82000000b0038171c99856mr8460305pgb.316.1649272773434;
        Wed, 06 Apr 2022 12:19:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k15-20020a63ab4f000000b00381eef69bfbsm16879594pgp.3.2022.04.06.12.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 12:19:33 -0700 (PDT)
Message-ID: <624de7c5.1c69fb81.19c2d.db58@mx.google.com>
Date:   Wed, 06 Apr 2022 12:19:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-255-g0345f74963eb9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 57 runs,
 2 regressions (v4.19.237-255-g0345f74963eb9)
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

stable-rc/queue/4.19 baseline: 57 runs, 2 regressions (v4.19.237-255-g0345f=
74963eb9)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-255-g0345f74963eb9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-255-g0345f74963eb9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0345f74963eb9130942381ae3a23f739dfd44764 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/624db5c24825ae3c69ae06dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-255-g0345f74963eb9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-255-g0345f74963eb9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624db5c34825ae3c69ae0=
6de
        failing since 0 day (last pass: v4.19.237-15-g3c6b80cc3200, first f=
ail: v4.19.237-256-ge149a8f3cb39) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624db78e53a8bdb37eae0698

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-255-g0345f74963eb9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-255-g0345f74963eb9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624db78e53a8bdb37eae06ba
        failing since 31 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-06T15:53:43.488904  <8>[   35.963140] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-06T15:53:44.503419  /lava-6038729/1/../bin/lava-test-case
    2022-04-06T15:53:44.512266  <8>[   36.987952] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
