Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A55508BFD
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 17:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356593AbiDTPZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 11:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379997AbiDTPZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 11:25:22 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FDA4578A
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 08:22:36 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id bg9so1892725pgb.9
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 08:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Sj4nHfEVp8kCbFr4KPM6Zp7mH1waeJ4Curl20BqY1OE=;
        b=gLtK/dcka+5ckYmV0F4LRjrKgIb3ROuHKNAYH6gHlrwVq+GZaB3aV+cNpfo3BXavfY
         CxxoE52364qfqziPm7jJLUL8xagtd1RmDfnbEQgPQw2fPcJ2wnVVbpZsWPcu01pyipMc
         tK1AlGMRTr/Lj7D0ofajNxdj/CVkUJyi//MlY+9tpBHYOPKf3X5qG5zpGiszhhjidov9
         QCrHxPY5nVPtW4Et8fomBHJZchz+haDu3ZE6puAiUyAYidDtu1hER8i39irB5m7GV9yx
         AAeWT3Es46waNOKvzJINmqLXfHqtg4COBYf6TVWBgdtCJxRmxTKVDx0arvyHbE5v6xU0
         rwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Sj4nHfEVp8kCbFr4KPM6Zp7mH1waeJ4Curl20BqY1OE=;
        b=rIkBgEql7nZv6VW6ODwY7TNhNPuZ4cvkWm3yYHZ2YTlWHvl3t6Yz/h8PaJr0k6jSGL
         N+SQDEbOyv75lLuEr7bAtyAquHdufA8eB/mZxe1rfHkQ2yB5ZAghyJwyPwcegVnR5iYA
         uaCnVbjOaladSgdzedmCiNp4BuAoIlCMfXgSXKUw2oPrwA/B2g1E4aetgy7MQ/f8WJgI
         V4fxLpvZxjG83aeXDIGWxkP12z0bTq05WqGjZuSWIx23tIGe1EQKAQCIM41bpyPfy7kr
         JZ2ldVOUUBPEu6jUJV0gmCxKbvqa4J4d+md4KHiKh2qrffJurCStmYhSVkx2Pp19juwj
         yLRw==
X-Gm-Message-State: AOAM532/WySUkv6NECwrWVeHC4OBiMazjb0kReYWKt+i8unOVhaRwj3R
        CrhtdrLjGhX9izN3udWYN/bgLskrHkjgzuDmWbk=
X-Google-Smtp-Source: ABdhPJwxpHt9efJYmf/dKdC06vmTyysTiXiSWoI1jDok6pOWYG1yB6vOK+YkUx4myTBsZqz/ayCXJg==
X-Received: by 2002:aa7:8094:0:b0:505:b544:d1ca with SMTP id v20-20020aa78094000000b00505b544d1camr24212499pff.26.1650468155383;
        Wed, 20 Apr 2022 08:22:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j20-20020a056a00175400b0050a5e20ffc6sm14784077pfc.10.2022.04.20.08.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 08:22:35 -0700 (PDT)
Message-ID: <6260253b.1c69fb81.4aaa6.1e34@mx.google.com>
Date:   Wed, 20 Apr 2022 08:22:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.276
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 74 runs, 1 regressions (v4.14.276)
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

stable-rc/linux-4.14.y baseline: 74 runs, 1 regressions (v4.14.276)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.276/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.276
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      15a1c6b6f5162f7b70cf9a77cd8ed9771c1f0b53 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/625ff5b8353d62c8cdae067e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
76/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
76/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ff5b8353d62c8cdae0=
67f
        failing since 13 days (last pass: v4.14.271-23-ge991f498ccbf, first=
 fail: v4.14.275-206-ge3a5894d7697d) =

 =20
