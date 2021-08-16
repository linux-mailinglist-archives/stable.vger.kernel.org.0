Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0DE3ECCC1
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 04:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhHPCsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 22:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhHPCsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Aug 2021 22:48:36 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66345C061764
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 19:48:05 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id f3so19182715plg.3
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 19:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0z8StMIMAb6lrV7olRFl4y8eHDakv2JHcvP+b8vq2nc=;
        b=a7BVFOsy+ZR+znTy38BxRlkyzc5wk8FH+DadCG5aAPMdhI+f9zrYG4pCiouiIR98T/
         I3sFxIe6TIWR6KnFmyYfnPDcCmL0UMM7GKV6g0BDzwCB/yhqAsn9wlsDZWyYaqKcQzkS
         Xhu5taRUgbA8pN0mWB+dzE7vHTxnw/A96KpQzT6JwG6HOdyyYg1CSO5KQ0mP3aBqe3T0
         CkfwIygzdrU/cdOAYXpKwqoYaO6oockmqH2SE73CanrDwMjy/Aw9bnCyFu2xOdlcuKRk
         BRIz2ZuCny0dPyQ7fT6Qmu4ZjMKxpTTfR7ayUcIKMqfA1gx1IozaEo6uQpCffCdRIDPH
         PGsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0z8StMIMAb6lrV7olRFl4y8eHDakv2JHcvP+b8vq2nc=;
        b=M57Bme+//j3p+zw6l+Jfna+M0ezR+5aShCCJDu3gnSjITQ91Mr2O0GWKIJWSxCkn69
         1/c7dhP3IRBb/7DpUQKE3ZTHdaiBsT34O2ZIWz9w8HgO1yDAuSi1yHCxRWRPhfptVQO6
         8S/2GPJ/2XsFz5Cudg7tUXhxlfi1RQcjdG4cbWggNMqGERM/49FS6KfAYyjJGKtLNzO5
         HN8mUuv3nX/i7D+ps1C5/HlCuwwRJ9TZLi4WYBi7JHq3RwJ6+IT/jDNGM56Z2uABRZ0O
         LHyPVwsqasCChh27damTBkKXHxzToQ/tGnp8sOPWmg2Iy5yw2OtcLwXvWNOg4MLOWc36
         E3GA==
X-Gm-Message-State: AOAM531Jp0n66hw9bYULKbC7jTv45rQxbVVT2+4PQVjcfsGAQKEWWXOQ
        vp6AfCj8Ma6TIpiAeoRLMWpogClhs11TwYVJ
X-Google-Smtp-Source: ABdhPJwgHTFn5PaRU3EAy2yleiqJjeo5CF3kOnyzeiy5dTDZywvZ7XCgeuBeYrgyGi2N6vl1ecOtMA==
X-Received: by 2002:a17:902:ab52:b0:12d:92b8:60c7 with SMTP id ij18-20020a170902ab5200b0012d92b860c7mr11469778plb.44.1629082084788;
        Sun, 15 Aug 2021 19:48:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j2sm9270604pfe.201.2021.08.15.19.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 19:48:04 -0700 (PDT)
Message-ID: <6119d1e4.1c69fb81.7d073.92b1@mx.google.com>
Date:   Sun, 15 Aug 2021 19:48:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.59
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 142 runs, 3 regressions (v5.10.59)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 142 runs, 3 regressions (v5.10.59)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
hip07-d05                    | arm64 | lab-collabora | gcc-8    | defconfig=
 | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-8    | defconfig=
 | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-8    | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.59/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.59
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5805e5eec901e830c7741d4916270d0b9cfd6743 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
hip07-d05                    | arm64 | lab-collabora | gcc-8    | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6119a0d1ab678d21b5b136d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.59/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.59/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6119a0d1ab678d21b5b13=
6d2
        failing since 39 days (last pass: v5.10.46, first fail: v5.10.48) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-8    | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61199ee83095254f5eb13667

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.59/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.59/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61199ee83095254=
f5eb1366c
        new failure (last pass: v5.10.58)
        2 lines

    2021-08-15T23:10:12.807397  kern  :emerg : Internal error: SP/PC alignm=
ent exception: 8a000000 [#1] PREEMPT SMP
    2021-08-15T23:10:12.808476  kern  :emerg : Code: bad PC value
    2021-08-15T23:10:12.809545  <8>[   16.270024] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-08-15T23:10:12.810678  + set +x
    2021-08-15T23:10:12.811771  <8>[   16.278794] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 696455_1.5.2.4.1>   =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-8    | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61199f6915451a4ca9b1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.59/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.59/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61199f6915451a4ca9b13=
670
        failing since 2 days (last pass: v5.10.56, first fail: v5.10.58) =

 =20
