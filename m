Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738F7314862
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 06:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBIFxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 00:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhBIFxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 00:53:42 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C843C06178A
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 21:53:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id my11so959880pjb.1
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 21:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H4FC1SaomZ81jiij7ftTieu0piADi1Y61Wb/9bHh0dU=;
        b=TshCUSePfZVwy0OGT9Ci6hB3Km8i7NhH3rUtkJQvY6YLNXlcCYVAzT1tV7VgyByyFt
         el/W5xdauGNGS88PTbMzMy9hP/khhBnSXVqAH0NDiC4vwUR8g8XtcZdcGtQT7EFlAdrk
         YaZejgzsfyMr5HxOyksbWwVc77nc5tY/pVNo/zhFTl3f9M8eaYBlC3+TrcrobiwXJbbR
         bnWtszrUxSz/YYdJjdR9Lma77NKw9eYJbvPkS03s2+Y4tpVn+l5tcxUNZLewF5iruRIz
         pyTvYEwU5iovWKtL7bTxZv2SfYDHWKSBbD2buNwTxZh0POho5hweutCjrmqoOrEC7dcH
         KCyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H4FC1SaomZ81jiij7ftTieu0piADi1Y61Wb/9bHh0dU=;
        b=GqjE/0sNcmReWtZKTn/ucDh2EXKnhuEibBjFPK2btbdEl8d+dbgqEGRkSpU/8IKsvn
         Mp8HoEWO+bKfYRSZX6lihEUgSb2Yu61FD80zGQldVKbR5awe78Lgnh/Xp+fK3PBE6yoQ
         ttI4Z3g+g29wJGTusr5GKxubSX0cYv+/wDUTh2/TbHRPkj+3f6ZgOc6oqqV2hans5n1G
         jVarp08Mzys566MTgVlTRy7VE4Fl0EW/cfelMprS0eDQct9uILrUnQvuME7q7LUHQRWz
         dQFHq/e+IMO4Lsla3OxqhraKdif0px3pHl5pSMh9z3N1OKGrzdMN6XxJh6rv2vRnUBe0
         BeZQ==
X-Gm-Message-State: AOAM532TfpeGnaXd7GRfAf46TGtoI5An6kLlZ5PHs7EixJ8BlGA197I9
        IWvhc1LB7jGu6b4oEwnzLU9JtpwzIYQHvg==
X-Google-Smtp-Source: ABdhPJzSrCiTQ7+q+VRDSVI9JAwRHmufdiQJ+msv++N6JtjqMGMJ9w/yQm87xUQfSvzlK5gAxwQUCg==
X-Received: by 2002:a17:90b:3781:: with SMTP id mz1mr2480865pjb.178.1612849980970;
        Mon, 08 Feb 2021 21:53:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q126sm20281206pfb.111.2021.02.08.21.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 21:53:00 -0800 (PST)
Message-ID: <6022233c.1c69fb81.cd223.e376@mx.google.com>
Date:   Mon, 08 Feb 2021 21:53:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.14-121-g21cc9754fccca
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 112 runs,
 1 regressions (v5.10.14-121-g21cc9754fccca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 112 runs, 1 regressions (v5.10.14-121-g21c=
c9754fccca)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.14-121-g21cc9754fccca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.14-121-g21cc9754fccca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      21cc9754fccca82f1b3aae7baa6cddfdf4384802 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6021f320614b081aaa3abe7e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
4-121-g21cc9754fccca/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
4-121-g21cc9754fccca/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6021f320614b081aaa3ab=
e7f
        failing since 3 days (last pass: v5.10.13-15-g62496af78642, first f=
ail: v5.10.13-58-g58d18d6d116a) =

 =20
