Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B31658818
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 01:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiL2Acc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 19:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiL2Acb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 19:32:31 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EF811A3B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:32:26 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id jl4so11205910plb.8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KWQfRBl5Kw7YhovDTTd+y8Hv9LkoCz6XgePjh+C3wx4=;
        b=VTnPYIACtcAcVojvQeAl/waUN0AqFeph9exX35GT6lYqgDfHQ+Cla/QfymvkwMIYk1
         8WguuguHzWg3XWga/UiHJbTTD6uBIKp9KG3EVaa4OnoQ2ZPUkLmfbanISOzcyI9dddBP
         xhV/hSJZMxaz6QtcSHdF2IOiXCTyQvSSRBOT7ECItI9X05Y6ntnsZGVza+8SUs1zEnos
         r1K7lnMCG9KwpLgPHgiRaKkdFgNJ3SjcOZf9d7sWofkQdeo6awcwZfQX1zb+zhG7l+xP
         +ZBEIMKnlRLtGliSbClC6aeMxtEgYEI57s9vOCbPQl8mMftbJdu4mVVjT6vJ5djo4LyZ
         58Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KWQfRBl5Kw7YhovDTTd+y8Hv9LkoCz6XgePjh+C3wx4=;
        b=s/B5JsOxCgXLrBGeenrccg1ebOeoW9Mh9/BcF+wQ8cPYMnOY0DjtusuYWGv2T9pXNu
         WB87uPBDvERBTytKJAMA/GszMMr2zUPoUhpCQV6eNXkK3nEYK7kkGzhedKMmyE9jZdvm
         xuxfz243exXLvvoNFBAu6V7l+VdbjMwWcQb9RsREIXhaVusyuCaFtcexvO43DrqI85Dy
         dUDiut5IUnN253YkN+diIqlsCtXDGDm6rNbttiUkcWuVF7LZd7qOiw90tXz5nCmPMt+Q
         M0fn9eiNFd/GAAa3FIUkC/CjSL8usAGPUzsKcsa91GhUpsN7wbEX3418IWyFyqniWESq
         n1dQ==
X-Gm-Message-State: AFqh2krQJAU6iISq7lBShkG2u8v2pvr79XfLGDbsP9CaEpna7OxE5iJz
        FK7EMbFx4enxP/Cys1lHuZ2NMiAQPwF1wx+RFbs=
X-Google-Smtp-Source: AMrXdXv9/TtdDYwOwI0yJsGRdPw1NhvX/87MJbtUyYRTqqNj901DtvGAGN/mBYELUYfxGL9mIu0K7A==
X-Received: by 2002:a05:6a20:e61b:b0:af:7ed7:d370 with SMTP id my27-20020a056a20e61b00b000af7ed7d370mr32065229pzb.43.1672273945729;
        Wed, 28 Dec 2022 16:32:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e18-20020aa79812000000b00577c5915138sm10731198pfl.128.2022.12.28.16.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 16:32:25 -0800 (PST)
Message-ID: <63ace019.a70a0220.ff806.2fae@mx.google.com>
Date:   Wed, 28 Dec 2022 16:32:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.161-574-g9a42a4fed495b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 118 runs,
 1 regressions (v5.10.161-574-g9a42a4fed495b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 118 runs, 1 regressions (v5.10.161-574-g9a42=
a4fed495b)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.161-574-g9a42a4fed495b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.161-574-g9a42a4fed495b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a42a4fed495b9e846c6c0cc778f41f54fb892bd =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63acafc460a71fec0d4eee1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.161=
-574-g9a42a4fed495b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.161=
-574-g9a42a4fed495b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63acafc460a71fec0d4ee=
e1d
        new failure (last pass: v5.10.161-574-g4229da0aa8e7d) =

 =20
