Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA654DB859
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 20:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbiCPTFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 15:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242117AbiCPTFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 15:05:52 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F1F3DA6A
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 12:04:38 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so5889154pjb.3
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 12:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4NKpY3q3OxI4Tnv6sCsgpKKOlKRo77MsOgbA3XWkKi4=;
        b=xxr1cV558oNUrRvoDRYLdWW51SSEij149sT7RB6Xl13OohUtWYrQWrPWh4y/PlQi3t
         CF7tLDSvVfQVIsYQri0baa4aMsMPrsU9KLKoA+km7z+laoeZMY/0S1s+EY6SdYjRvm/Q
         47ZAK0PB4vOvxWEsI9RIHnJ4HUGruHgpkG4AfyNLkWZLdsCX8X3Wd9G5N1ad46wMbinE
         Lo6rwOsI1fipUyepq/SZxC4vffk9LLAzbwdciA4K0OHuySZ369/MqlEXETlVyJ9qQZ/J
         Lu/vSIVqITXrYUvFfU7rsQF/DzqoclCkpvC6WoUjVvIB7cC7QN9WWPrk+8JmBFYt7vBq
         jl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4NKpY3q3OxI4Tnv6sCsgpKKOlKRo77MsOgbA3XWkKi4=;
        b=3jb1vHjKLLW8nmllbwsp34DXdK+ym/wh98oIVtJY0biFswghHnIw7sN0lhi27/j6o0
         6Y/y9FNSjZR8BjOpw8XK0RhSQwZdGsYmYiqcxfcwMd85Wy6sgkyXwfepIs/c7pnytOQa
         Ol664Ikv6I5AmsGhPAv62jZB7mVPbX//DyKL4vjaL+W4yMsefF4/sl2ieOZkqZ2/NZyp
         i7CKj3Ln1em2cj16f/JX8HPUOXLtyvV4DFWQ7MTNsQ9kalb56npbZ9iNfym6kPjEvnwr
         mYZwKzmtv0NBf8xi843e2LhaZN4H/YAqveGrkTmFpkXuj4cfKyEK3hsUXKCN6vGayFLU
         s4wg==
X-Gm-Message-State: AOAM531q8L0WnRLEzwNGlBag33qOKYBms1di1PFTBd11vrSTiQ8mUMD6
        zlpZqIKft5Hk8EurH2lDpI4yo/ZcO5GBDw8d70c=
X-Google-Smtp-Source: ABdhPJzmWs8WJ6PkdLAxp0kmcLG2EEqGER7Fbcm6LjwyeayA8dcQOPxCXju4NwjeUYD80OEI9Yvntg==
X-Received: by 2002:a17:903:244c:b0:151:b4ad:9632 with SMTP id l12-20020a170903244c00b00151b4ad9632mr1131744pls.30.1647457477338;
        Wed, 16 Mar 2022 12:04:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h10-20020a62830a000000b004f73c34f2e8sm3705116pfe.165.2022.03.16.12.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 12:04:36 -0700 (PDT)
Message-ID: <623234c4.1c69fb81.f879b.9270@mx.google.com>
Date:   Wed, 16 Mar 2022 12:04:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.105-74-g9f062fdb5347
Subject: stable-rc/queue/5.10 baseline: 81 runs,
 1 regressions (v5.10.105-74-g9f062fdb5347)
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

stable-rc/queue/5.10 baseline: 81 runs, 1 regressions (v5.10.105-74-g9f062f=
db5347)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.105-74-g9f062fdb5347/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.105-74-g9f062fdb5347
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f062fdb5347d4286ad9cceb7f6a7c5766248df0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623204d565879cc99cc6297c

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.105=
-74-g9f062fdb5347/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.105=
-74-g9f062fdb5347/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623204d565879cc99cc629a1
        failing since 8 days (last pass: v5.10.103-56-ge5a40f18f4ce, first =
fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-16T15:39:43.187408  <8>[   33.113965] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-16T15:39:44.209817  /lava-5891477/1/../bin/lava-test-case
    2022-03-16T15:39:44.220549  <8>[   34.148555] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
