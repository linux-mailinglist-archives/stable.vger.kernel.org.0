Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146EE4FC699
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 23:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241321AbiDKVTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 17:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiDKVTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 17:19:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B701B7B8
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 14:17:37 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso565394pju.1
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 14:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b8pfaGZY1J3hu5I8dg5ykRVHC7+7iKkJp/DeF20todI=;
        b=A8ULwUrehU8jrseL0vJ36zAUOwbFlWac+HeMWashbiCjpxX0WlwbCLZQ0xQFE5SuWR
         /nMHNUoDen2WMUt2+YOXg8MAsE4r7dg6J2n3tsTazT3Wdn+yNN23cBlhTivRXA6bmF18
         uONbdpu3P/+ZihSr/KQVJ4u+VO0Ll272bKxKb88rn6x19Hy4Mxa9O454A3rCrxLwt3to
         1igBce96L5oO3J2d0bDhUij04WlTQeHsXXqUvY2GJ2rEhScIq22lmzMPNr1uQ+V9JbHg
         VOfzKCxnwRLtKCmd0Mz2EJK7y4MHYHPEyeGiHCbE7xOgDjE6xBqU8EM0aLS9NQfxUtLD
         4mtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b8pfaGZY1J3hu5I8dg5ykRVHC7+7iKkJp/DeF20todI=;
        b=lnYapXF6545xbHm/YpwWlWplEYTVLPOkjXkbtRaZY7qBcENcx5y/aAmtZy262i18uk
         t6KVBkIxfnm8oI6e2xGI/eJ42ZBZY0m6pnMy4MsRN7VKgeDhkVBlywhntP/uyM/bI23i
         H1L5KmFbW+xbOsSxTCOJThfgFB0mmHXemv/G8n7tVn/nBAJpHeSrCywzsheul/dsuLvF
         FgKcK0q/jNohpV/ituH/WlrJCATROCOAKFJmtXu3mo+PcfDk3KhNxz6FVr1zMGXezAXQ
         YtWpp1hkcn5YuiLis/GWgRSGcszOVotPlDfRZ2J+oDVugQrqxkER+USHvc2R3kHiZ851
         4W1A==
X-Gm-Message-State: AOAM531bBtD4AMG9eS1EWjdoreBUBu3LGlSr2zD+xhLPbJAecHyMK/9v
        5Urh9UaZWBlEehfByMskWYIpEM8fwzqwtBhE
X-Google-Smtp-Source: ABdhPJwNMG24YAPC3EYFnwuqzaDHnLLmC9nCjm5q+W+B6AxOmH7CaPHEZTLUG+jXgALmC+RjQRdS9w==
X-Received: by 2002:a17:90b:4c8e:b0:1c6:8dfb:3cb6 with SMTP id my14-20020a17090b4c8e00b001c68dfb3cb6mr1264072pjb.72.1649711856613;
        Mon, 11 Apr 2022 14:17:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r7-20020aa79887000000b005058f7ec852sm11505569pfl.157.2022.04.11.14.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 14:17:36 -0700 (PDT)
Message-ID: <62549af0.1c69fb81.5bd29.c527@mx.google.com>
Date:   Mon, 11 Apr 2022 14:17:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.110
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 140 runs, 1 regressions (v5.10.110)
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

stable-rc/linux-5.10.y baseline: 140 runs, 1 regressions (v5.10.110)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.110/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.110
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3238bffaf9928c10173d88415f6815f6df3e7771 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62546809520104fd67ae068f

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
10/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
10/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62546809520104fd67ae06b1
        failing since 34 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-11T17:40:13.017046  /lava-6064424/1/../bin/lava-test-case
    2022-04-11T17:40:13.027993  <8>[   61.067349] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
