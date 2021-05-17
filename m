Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6F1386BAF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 22:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbhEQUwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 16:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhEQUwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 16:52:23 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8489AC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 13:51:06 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pf4-20020a17090b1d84b029015ccffe0f2eso326072pjb.0
        for <stable@vger.kernel.org>; Mon, 17 May 2021 13:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dp7lFIQPWjssUsHbAKUL+L9CF+lBElQxCg3ARXkQzjs=;
        b=1LEmmXzpmAtfLNiJIisQDHlMldq2lHx3HS0SLGyEY+TWgCrKj/nZxsdfZ65r/4EXMT
         TygbJ0gRWGZufZ35RGoO+GzfEgjTCf60qfJ2Z6+rBrXrQEA7MLt+gAdJlxtzgl3mSyFm
         S2lkKNnVxlubotX5MeevngYtOyXE2nB5zNio6t4t5UDO57CNEN84jLIfuyghCL6Ux59R
         5x9ujYnonluvGYr8ov2Cv8I9Hv8obOpqe3nz/2oywFVonqbbwDJk4SZw+Q5gkAgROT6A
         z5fttabXY1GmF/ntEi+WJGDPW6+PF2J0rheyH/qA96I3YbOeoeq72BEgrMVdC67ikooO
         TeXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dp7lFIQPWjssUsHbAKUL+L9CF+lBElQxCg3ARXkQzjs=;
        b=fiqYndO1MneTOrsxdTZ/MNSv7gioP0ymR9CHzgCIofSwrYEx93qPbfxM9LWajbyRhh
         df9P/WACLBVXbdRBkPNuo89hJlGlzuUz6PQt/Vha7GxiglE+NTLmpezfKJM1zUhcjZkp
         2EsWAN4WhkoaWGNkxhm1L1szx4GClyKkZrLmG2b1WO4ju0Vu4dj0FSwhYWSuvf3F4aVI
         jtGRS8cGhLWLZDQYjFkro81ObWX9hyeaZmNGrhGPXXQc2fZdhjrp3llfOkKopWWK4btN
         npEErpdWuoblSdX3xWu5piL1cklbhwCssgfY76i6OLiz/L7I2eRi5zhIbhzCMMeQvSDt
         Wpnw==
X-Gm-Message-State: AOAM531/AFPppfAt+Ff1yFxX2OlSeaNyHVFmdLONGwBUXuTN/vrtuMKE
        Jued413fJRXedFzgpzUpqJlMbHBI1Rx0gIaj
X-Google-Smtp-Source: ABdhPJy0nEHrk/h3xGp372RAtFT4wS2InzEtDXLojb48aRuH5z9VXJtPMLuyUhZywi9J2kLHN5f1rg==
X-Received: by 2002:a17:902:b683:b029:ee:f0e3:7a50 with SMTP id c3-20020a170902b683b02900eef0e37a50mr369597pls.7.1621284665995;
        Mon, 17 May 2021 13:51:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8sm10384413pff.167.2021.05.17.13.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 13:51:05 -0700 (PDT)
Message-ID: <60a2d739.1c69fb81.dbaad.3a91@mx.google.com>
Date:   Mon, 17 May 2021 13:51:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.4-364-g8c6ba5015aff
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.12.y baseline: 133 runs,
 1 regressions (v5.12.4-364-g8c6ba5015aff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 133 runs, 1 regressions (v5.12.4-364-g8c6b=
a5015aff)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.4-364-g8c6ba5015aff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.4-364-g8c6ba5015aff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c6ba5015affe5c570b32cf542f58218e4dfebf1 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2a646d80088e3f8b3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.4=
-364-g8c6ba5015aff/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.4=
-364-g8c6ba5015aff/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2a646d80088e3f8b3a=
fa9
        new failure (last pass: v5.12.4-343-g1fa9b48b0d6a) =

 =20
