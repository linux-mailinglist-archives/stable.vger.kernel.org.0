Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC5D5167A2
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 22:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349446AbiEAUJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 16:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245668AbiEAUJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 16:09:46 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D25329B7
        for <stable@vger.kernel.org>; Sun,  1 May 2022 13:06:19 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i1so4952386plg.7
        for <stable@vger.kernel.org>; Sun, 01 May 2022 13:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G0CTPrHHQFKoNaImJP5a9PVV1a3rNfj5zTzHQmmibxo=;
        b=JWK4QjXkxZdzgJWxV93JC/I1I8w7j+DZoWs3WeD8syAw7dQNKKGuYGvS96lf/c79u0
         zdupxb6xennXkasufQnwOc63NRXzNs1LsYhxG9bhCgq4w+nHxiScTqc7Z5H73HgafXRP
         K+ayB132FJHKw0PUhYHvRJxRBIqLGNMcANNfF0JMIJZWOO6ci/GMF0RtqUFWsGNSNLnA
         hWJHyogUKH7LLT0nM3BPLQQcXMZu6nslkpnlGPESe6AokVxdkj/8BEcqlX2LBRSuUM3h
         zG++NWYZrt/YdvRMSLWpQeTEnccbk4ROmniYUY00qGiyPXNHgcTT0jmTTwt+CX9ROyIa
         nBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G0CTPrHHQFKoNaImJP5a9PVV1a3rNfj5zTzHQmmibxo=;
        b=ldCZQ31QkQtksj+4Y43uNtZSaelyiFklZM4C2yk76FwtFT8J8kQOM9HxTt8vdG4E2j
         yeUEGJsmq+cV3Z50J9NRyoOyHWXmTDjZBfTvvSdUeQAk2r5WYt+bXCpaeTjWGeRKjmvD
         Ae4Bb6j3FBvYUVh8Aaia9zi1yO0qkphW1JdTfFhrzkLX0rMQG4OZAbFr9lbV0nTKNRdX
         jrx872uPJaqPnRDNcj9kgjtIwiiOj8RsrHmrkhV1MKMQ/zdyHgtiak/ORoQGNvsBoewc
         lroQpa6SD//1QtF6oLBt4a/QmX7spIwbduWgAED6RBMmo5f+qKuT4NM2KD6PtkGio1IY
         02VA==
X-Gm-Message-State: AOAM531NZxFXda9WVyKGbYh/lp9+DVLwTntorSO4wVtCOCKxEBintyQi
        sn5ZrnX9QnWKSiu5diaN90fgMjOqK+KdXv0xdK0=
X-Google-Smtp-Source: ABdhPJy0WVhCtdESBLWpl5M1UWz2zr54WDKfc2vTcV4mMNL9TgzvIrW5QWAkQyrUi9oEhpPTmQqrjw==
X-Received: by 2002:a17:902:ce92:b0:15e:9601:dc02 with SMTP id f18-20020a170902ce9200b0015e9601dc02mr5426019plg.79.1651435579092;
        Sun, 01 May 2022 13:06:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h8-20020a17090a3d0800b001cd4989ff4asm14459434pjc.17.2022.05.01.13.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:06:18 -0700 (PDT)
Message-ID: <626ee83a.1c69fb81.1fb53.1972@mx.google.com>
Date:   Sun, 01 May 2022 13:06:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.17.5-1-gdb3b2d5e27c0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 93 runs,
 1 regressions (v5.17.5-1-gdb3b2d5e27c0)
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

stable-rc/queue/5.17 baseline: 93 runs, 1 regressions (v5.17.5-1-gdb3b2d5e2=
7c0)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig        | regressio=
ns
-----------+------+---------------+----------+------------------+----------=
--
odroid-xu3 | arm  | lab-collabora | gcc-10   | exynos_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.5-1-gdb3b2d5e27c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.5-1-gdb3b2d5e27c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db3b2d5e27c0aea9baa59d4fd8a4f3f544cfb0db =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig        | regressio=
ns
-----------+------+---------------+----------+------------------+----------=
--
odroid-xu3 | arm  | lab-collabora | gcc-10   | exynos_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/626eb18cd5a6686f8bbf6012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.5-1=
-gdb3b2d5e27c0/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-xu=
3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.5-1=
-gdb3b2d5e27c0/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-xu=
3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/626eb18cd5a6686f8bbf6=
013
        new failure (last pass: v5.17.5-1-g7114c675b252f) =

 =20
