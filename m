Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31304ED33D
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 07:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiCaFdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 01:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiCaFdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 01:33:14 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2292ACF
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 22:31:26 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d30so5963252pjk.0
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 22:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IHgvKaAhT5MraFgfX8sJGtBxN5X7SFv+uPppmoJTVgc=;
        b=Fo931xB0TtNC9YNtkbF3VCVFIzJFuKSZreA1WhQNrHl9UUaJgQQcgIn45ynGNYLnUQ
         /cWIMVw6OE26hlkEtvj24mFBjCnxnrgF/Yhi6b8KNYMeAbxFjxPIVuiUWf0ltDO8bnBE
         5nL+0l/Mu0HX1mOWxw3avJjnYEQxcgQ1B5azHxYVE1f9WAscsd7HcFD8Tij/JbRa0hjE
         ZkmrCvHKmK9RfaQqCbJbIoGgnxldzOYH6zQKpNdUfVpdzrOU7dkIlUOof/yO272mr/Ej
         YETSWf64bUzkwiSl6naZiHag6MyEPbj5bha0NBetuIVUOdgNTVDp2+v6Wl5my2mwrgwy
         qGog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IHgvKaAhT5MraFgfX8sJGtBxN5X7SFv+uPppmoJTVgc=;
        b=dXwPS9WKAwwPODD+CSdU0cReGy3tC1642Ijpvx6iq1V7ixsHPcGOFGR3n41cDcd81j
         x9Jnv6AjBSBNw59f2zCVMBz7Rjj7C3AcGJzcMpKbW//p+UfyDi0yLQqnISvQMHPYSxMM
         7jeBuS3CUc5EYRI4i8eRXDsFBKkuujxv4XpoBl6twihNU+C3NQDr33dayqtVdvvbdPpC
         sOOLjzDhPy6zqBmjfqVJnvGtrTaj2Wj9rBIwzMtLBiinR39X6bMlmpVtgGbpuu6rQgDh
         uV+kwEgTlotMoW+ul9GdEuR/mn37Yry7NhVrAO/m9GkiPdZcpi2WoycCxbKfTWP/Hw6Z
         rLaA==
X-Gm-Message-State: AOAM532sqSlAErIOsRziK/xUa1xv0UOLizu2FFn8b9gTJpbzvvwLv4Hd
        Y4HCElTfAhdORfsc3RMu+EnOAQXQ1Qht4g8b+fM=
X-Google-Smtp-Source: ABdhPJynL7sl0qwea9shTsI1tzm7YctB+uzDIc5EtOpM8m/PWE0NeIttHKcAqmLWFn2nYPs2DiKLsA==
X-Received: by 2002:a17:902:d2cd:b0:154:418d:e3a4 with SMTP id n13-20020a170902d2cd00b00154418de3a4mr38728513plc.34.1648704686066;
        Wed, 30 Mar 2022 22:31:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ip1-20020a17090b314100b001c7b10fe359sm8821101pjb.5.2022.03.30.22.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 22:31:25 -0700 (PDT)
Message-ID: <62453cad.1c69fb81.bea52.6d0a@mx.google.com>
Date:   Wed, 30 Mar 2022 22:31:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.18-29-g64fb031e2099
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.16.y baseline: 83 runs,
 1 regressions (v5.16.18-29-g64fb031e2099)
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

stable-rc/linux-5.16.y baseline: 83 runs, 1 regressions (v5.16.18-29-g64fb0=
31e2099)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.18-29-g64fb031e2099/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.18-29-g64fb031e2099
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64fb031e20993afa055417d9eaab2a6ab0d8e327 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62451059fc74270051ae069d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
8-29-g64fb031e2099/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
8-29-g64fb031e2099/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62451059fc74270051ae06bf
        failing since 24 days (last pass: v5.16.12, first fail: v5.16.12-16=
6-g373826da847f)

    2022-03-31T02:22:03.081381  <8>[   32.384924] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-31T02:22:04.106420  /lava-5984839/1/../bin/lava-test-case
    2022-03-31T02:22:04.117345  <8>[   33.420904] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
