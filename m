Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046464D293F
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 08:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiCIHFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 02:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiCIHFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 02:05:13 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494ADE7F63
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 23:04:15 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id s8so1425809pfk.12
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 23:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+GeIvlpE2jKh9TwYcB6Ebb74hxixE/MNVGDQWIjTFps=;
        b=ZYK1dpnIsEtDATYplXOb/G9ah99sLMuJ8ObEYPFAhzATiLbTUE37hg89AXIqoSpvM+
         vZbMKDP0HMPYwCBQSVWj943KAYs7NJHn+NZuCOCUZ9S8xWZG5RfII7Vz1LhvQ1C8A5Ox
         utDn7qQB42m3XuaJRrSnx8+bupm5DdCaJkvx5sgE0fkGMfCufD4vMAPzEt6VTGngggn7
         ef5mAFHxMmJkyDX8LLd3UnJLsWt2GnB4UQoZriGd3CdjupqXakGwjKklD9o1BseZQ4Xr
         NlXx8GaKH5ZY3G8UMwMViXpn0WhFs5McEiHg7G9aBOkE9dZ7m4D5U1Dz1OONxUnbrQ+1
         Gelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+GeIvlpE2jKh9TwYcB6Ebb74hxixE/MNVGDQWIjTFps=;
        b=orq87P4LKMhF7l9mJMcQmModtB03Q94i5v84ioPyVW9PPbWRPwWkt/kQ4t6Izj6QEq
         yXLNy3Zhzg/z5YQ0OrxyD+c79bm9NvLUSQNkCshSqWDv+9YW9nWPHt3KBIP80prKmdNZ
         R8N4UT4JKJ3GeS2N0GNGhV4uSnoZtRcw3cpN0ELKq8ewJDigOloEOf4Xmy40Z81PG0dR
         XC1mC749pj7r3qpVYfVeZkYSlm1qMrUC/zUEU5oZPFT2URyMpiGaP8Yg8tSOTPtZRblG
         IYvdWbbIaQgOGKmeHsi70Io/brNXtmHyUBHI5SMriOFh2n8gsW+MiDVNfSPwOkJGeTzO
         pb0A==
X-Gm-Message-State: AOAM533/fJi7dO0tvnIuiLCHbz++BJG2j+NozE2lF9Bigs8gjKcQDsPo
        lp9Wa6zu/FL8gLgZWhWFQQ+w7AvXjni70So0anc=
X-Google-Smtp-Source: ABdhPJwuyZF5a7ZN4Hyx+yRSip92Ugn7VwlIKd94q3psLDlJU+BUX8KmRfgUy3V1+BRTAa/dNLwVEQ==
X-Received: by 2002:a05:6a00:228d:b0:4f6:4ea6:851f with SMTP id f13-20020a056a00228d00b004f64ea6851fmr22379231pfe.37.1646809454611;
        Tue, 08 Mar 2022 23:04:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13-20020a056a00114d00b004c122b90703sm1384012pfm.27.2022.03.08.23.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:04:14 -0800 (PST)
Message-ID: <6228516e.1c69fb81.2bd20.3e8a@mx.google.com>
Date:   Tue, 08 Mar 2022 23:04:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.13-37-g22f5a43617b1
Subject: stable-rc/linux-5.16.y baseline: 16 runs,
 1 regressions (v5.16.13-37-g22f5a43617b1)
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

stable-rc/linux-5.16.y baseline: 16 runs, 1 regressions (v5.16.13-37-g22f5a=
43617b1)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.13-37-g22f5a43617b1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.13-37-g22f5a43617b1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22f5a43617b1fdd0774c4fb3a358c58db0742d30 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622817e204755275bbc62976

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
3-37-g22f5a43617b1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
3-37-g22f5a43617b1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622817e304755275bbc6299c
        failing since 2 days (last pass: v5.16.12, first fail: v5.16.12-166=
-g373826da847f)

    2022-03-09T02:58:22.551342  <8>[   32.605704] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-09T02:58:23.571689  /lava-5842778/1/../bin/lava-test-case
    2022-03-09T02:58:23.582863  <8>[   33.637388] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
