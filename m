Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF3C297D79
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 18:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761836AbgJXQbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 12:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761824AbgJXQbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 12:31:17 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A28AC0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 09:31:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x13so3620367pfa.9
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 09:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D1K+9umwD9L/sNLEEBns0jtcnuXztPU9GQeYntlCLQs=;
        b=LdB+MGl5FgQsxYCv+bRMt3l3JnV8MNNoP7bLzLgOBDuZatTmmiZQ65csgeMCyUJgpR
         r8pSycsIKmbZTDKvJduRPwDNRFot9590cOPFbWW5FdigdWbK5oEglaAfRuraqgCYXEcE
         HnpeEfNsV1rnIl8FYI0I9X+caN449Mhsguejw1vV3aYBPc/u5FAuneuDUXPFQAzKZHaq
         dK6+XZCSm2x9Zg1Y/GhfW52V+8Nu4rKht9vT7K2jrieVvo7MeCetcnx3Bw4cYjMEkkL3
         U2AUqlvJrt2G93swFQUj4c4A7EG5ohIDDvTLN/qW/JGkF20FRpHIOnxaIRusgRQgOnZo
         AtGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D1K+9umwD9L/sNLEEBns0jtcnuXztPU9GQeYntlCLQs=;
        b=nVwLAzJfOdFyBpmF5ETKzHBEG7alr0n8TH8wROxMDIiIgU+yQx64yGCrn/Nu1swLB3
         /+g9391fBWWzSobqjqJY3SclSL1A+goFTTVF3e3yROG/kLpGKANce0JnxvI2YTsL/ovc
         NvYi+rh1d8EOEoIMJeSr1hlEi5iGk3t+/3ZFV1UeMop/BhYXcPnnYQYwfAx3OOxJ98Ih
         4XMKtpT15EjQ51TkApUTRgylbEF1S9yScjg110d5A/8fdadx80Pn+nspgxCIzoyYpZs9
         ag1bZ7hk+Xe7i4Z1MGHBONi0Xk4EwpRIPoBMpb/WS1Ftdy3gnC+0d5Pg/xx+4lyMnGW1
         +vmA==
X-Gm-Message-State: AOAM532gGJC3rh1VkBtS8AvNxxCTYDDGNnmsgIEnaecowSomAn7HFzWd
        FhKODhLyaMNFcJdFoWuwuGYzTL28zYsY+g==
X-Google-Smtp-Source: ABdhPJwWJr8+CPgwc4bjT/8BdGS9idvb0q+FAZECm6CAZZdCAdNhBRHyOITygl/YkQjhJ6sNXNTrUQ==
X-Received: by 2002:a63:1d12:: with SMTP id d18mr7738900pgd.314.1603557076716;
        Sat, 24 Oct 2020 09:31:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kc21sm6749161pjb.36.2020.10.24.09.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 09:31:15 -0700 (PDT)
Message-ID: <5f9456d3.1c69fb81.d9650.bbae@mx.google.com>
Date:   Sat, 24 Oct 2020 09:31:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-80-ge394f106fdb6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.8.y
Subject: stable-rc/linux-5.8.y baseline: 126 runs,
 1 regressions (v5.8.16-80-ge394f106fdb6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 126 runs, 1 regressions (v5.8.16-80-ge394f1=
06fdb6)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.16-80-ge394f106fdb6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.16-80-ge394f106fdb6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e394f106fdb6a465ecf4e0de3ed79c8c3c41e380 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f94225ef65be3cd7a381027

  Results:     68 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.16-=
80-ge394f106fdb6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.16-=
80-ge394f106fdb6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
5f94225ef65be3cd7a381030
        new failure (last pass: v5.8.16-30-gcfc6983c9555)

    2020-10-24 12:46:55.878000+00:00  <8>[   14.907794] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>   =

 =20
