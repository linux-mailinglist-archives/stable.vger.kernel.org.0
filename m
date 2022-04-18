Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98736505C0A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 17:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345857AbiDRP5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 11:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245161AbiDRP4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 11:56:50 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E776220D2
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 08:47:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso14397279pjj.2
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 08:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SgbIxIBEhRCXF2oWN3CJj5L34HzBKzby5BVIA+GPd0Q=;
        b=V9NA6/nKK+Lx08tggiHL8dlWIp8LacJh6Di6aGOVreccf4tAYI779b8k5cwceBSvrN
         op2Rp9BQCiEOXjIAoYwh7PPZM70Oo/dJsiy0c1uXjHsNpAmL4xtuUA+sZR24TSZ9s8en
         RkU49DiKPhKC1WeA44x1+hrbhnwszjI0lU6vGd2YN+favt+nsdi5EHh6GonLL9o508I4
         mq4nBbzFq71F6DCDUhZmmrL5808f8koVGQXDjN7f7ueSX+NP3DofVRt6h69v7Fr81GN7
         baFPndQcNFPMbIm8IoKP6ssne/GJ1096nFC6seLRzw0KM7Wnbb0eXiSyAwxLeuzX5DfO
         FH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SgbIxIBEhRCXF2oWN3CJj5L34HzBKzby5BVIA+GPd0Q=;
        b=HhM8HG9pT1/vdHArsg5hm5SdbVW5svBRMt3p/8WPWPBsAMt+4YTKP/37UA3nccbweS
         wadG5Zp7OyfdtZHWKfAJ1aaW5m/LRpxYMjvYdQvudfQpk2Gz8EHDwb+AqgODamq7w8Qu
         oqNWZxg5pfv3UlQ+6hyweCsPTWvQTZxslGG5OT4wQNmBcBFotzTH6Cdye2HDBbHFQ9eP
         JAmXJ8lcf97c1IFUyaNMr4r16nqyAThP/E31Y6iTlaEjCZGPhLBLewlYFxmyM4goM038
         nemK0yjiZjlEZ1JzGvVsETlU+nVjiAq+tsSvxLGcB5T6xPZDjl0AoYULI9Gqh1hQkVcz
         7UPg==
X-Gm-Message-State: AOAM530dNNH71+8iw0vdQceICLYxD05SBiseye1PF/vt7YmLOj7cIJyq
        S4tAavnKodp2Oz+nBw+usPpa7Kol7FSqBlZR
X-Google-Smtp-Source: ABdhPJy7NKjulyiU7t0+nX/q1TefD2WQOkaegUbGIbTfZAEMQ4Xqz4zp6fMrebis30F/MOFoL6rg7A==
X-Received: by 2002:a17:90a:510e:b0:1cb:b1de:27a0 with SMTP id t14-20020a17090a510e00b001cbb1de27a0mr19184151pjh.196.1650296827484;
        Mon, 18 Apr 2022 08:47:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x8-20020aa784c8000000b0050577c51d38sm12621692pfn.20.2022.04.18.08.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 08:47:07 -0700 (PDT)
Message-ID: <625d87fb.1c69fb81.70fed.d863@mx.google.com>
Date:   Mon, 18 Apr 2022 08:47:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.310-211-g705ada580b779
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 93 runs,
 1 regressions (v4.9.310-211-g705ada580b779)
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

stable-rc/queue/4.9 baseline: 93 runs, 1 regressions (v4.9.310-211-g705ada5=
80b779)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.310-211-g705ada580b779/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.310-211-g705ada580b779
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      705ada580b779c2d725b2c5b6fe509826f3a0e22 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/625d1aaf02b1fac498ae067f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
11-g705ada580b779/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
11-g705ada580b779/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d1aaf02b1fac498ae0=
680
        failing since 12 days (last pass: v4.9.306-19-g53cdf8047e71, first =
fail: v4.9.307-10-g6fa56dc70baa) =

 =20
