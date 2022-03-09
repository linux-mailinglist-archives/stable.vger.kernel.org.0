Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B034D26F7
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiCICFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 21:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiCICFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 21:05:53 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E90A66F1
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 18:04:56 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id r12so713436pla.1
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 18:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s6OhzIT1zcMYpCcLiNIalMMoksljUZ3sXSP1a8kJAzg=;
        b=ubdCq0ht/i1Afym417nNLmZ+3EMGuHBpQfFHXvpPDhXA+veuudXFgNiauTHOLdEyPT
         BiLz+hjlV3WM3+Vy4yjo5iJMm3nN7NAE1mQUGPD9Zgq79DP/Smz0HEHzCrPkpb9z/oah
         F8ipLmbPROYzQZRPgrOaGKdu3SZugi3shzcl3WoXMs5tMvK5PUXO9RKFU+4y/DMIUOkU
         9l5gPN/bEAkkMuvUGOOIP40VoN+nv3/gxgEarWiKorqhLlfPh/Hn+JTaVDFgeSBKi+id
         xDSSkngqYQMHtsgt1TWFDevq2BN6XRygUELYeCanuj1ANoFjVQPoMxMQ3nLnF8Gcx6WS
         14mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s6OhzIT1zcMYpCcLiNIalMMoksljUZ3sXSP1a8kJAzg=;
        b=GNhw9vNiIWPFC9SiWSggDbMGLQXD7WkrBl07SYgBp4Bd12ps6SZLV/mkZtb1yfKW+n
         Bp4PcM/UGsoiy8dcWViHu0wnMt6JXM8QTTZfOGGWAHZjCB+SxTwe4kqbGm3HKaTuGCmm
         owidZhEPXhHQU0XGKrOPev9C/HNil4gD26v0KKXKnTPcBgS5BZC6eFSmYl5xTzzve8in
         nvO0PiDxuWqWuLP+Ayh3ZQDov0qBL8C3nX6LJH+u853hQhcjpggl/fes7SwhQ9uxvItM
         v+C4Lqre7emP9xGtYebAqD+Gya1Ln4fUs4/3encX8kFUOvaOUXcACHzXrturT/sOpV25
         LmPQ==
X-Gm-Message-State: AOAM532t+oKSRqgimzLXTEXwlQ89T/s1mwvb45b5k9f4bv6VOWoeOs8f
        /j2FMZIkIcIDS5mxwdfpF27iTaRvrjNTqaH2JRc=
X-Google-Smtp-Source: ABdhPJxyHHjLA1GP+o0Pkgk/WR3KqQVRTNx4bN+YdWI2DFWv0cXe6DGk7pvpTNo6NTMYcfauV9Vt6Q==
X-Received: by 2002:a17:90b:2246:b0:1be:f92f:b23 with SMTP id hk6-20020a17090b224600b001bef92f0b23mr7837957pjb.71.1646791495664;
        Tue, 08 Mar 2022 18:04:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z12-20020aa7888c000000b004f3fc6d95casm409640pfe.20.2022.03.08.18.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 18:04:55 -0800 (PST)
Message-ID: <62280b47.1c69fb81.b888a.1cb6@mx.google.com>
Date:   Tue, 08 Mar 2022 18:04:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.104
Subject: stable/linux-5.10.y baseline: 99 runs, 1 regressions (v5.10.104)
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

stable/linux-5.10.y baseline: 99 runs, 1 regressions (v5.10.104)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.104/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.104
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      97581b56b59fc79d6c376994a2e219349c31873f =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6227d5d2dff82732a2c62988

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.104/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.104/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6227d5d2dff82732a2c629ae
        new failure (last pass: v5.10.102)

    2022-03-08T22:16:41.654817  /lava-5840927/1/../bin/lava-test-case   =

 =20
