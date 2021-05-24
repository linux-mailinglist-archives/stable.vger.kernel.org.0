Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2017038F52E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 23:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhEXVwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 17:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbhEXVwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 17:52:53 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC65EC061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 14:51:23 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id z4so13119961plg.8
        for <stable@vger.kernel.org>; Mon, 24 May 2021 14:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cwY2fm5lae2hawTVTL8YTUVa21rN4MmTMpake0rQaj4=;
        b=vXy/sF72TwueFpw1uSfNOoeXUQkmaA4lmXGTWCiCUh8gX1WTFdn4Oxn6mOm5Y2Lw3K
         3oMAkWjAbwPBZRQrUshAb07FmDbPAjVnbjd4CRfRz5naAx2j6BmLopKaYrRWvRSDX6k/
         QuZp7B+2Yi8j5xoMaQMUy3o1/7yW82lPiszTdoYDzGlstMHuX1V5mru+s0f7FqwiOKqT
         hTgsyzP+KnKBc6Rc7xlWRgAjhisBUHWWjKoOS9J6h5KfFlJdKkmGNTfPO8XqwCnV8cpM
         KBxs9WD2ThSY6PDQ5rxjmKw8Rb2rFHoTT3l/hHWXBgqtVEkXbSFn5bWdZL7OxrXsQgHm
         XDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cwY2fm5lae2hawTVTL8YTUVa21rN4MmTMpake0rQaj4=;
        b=aI/PgjpJVdzaFzIdZ80GxOvl5328SIt60wTPG4gsfFa7/eQUtxA4Hmy8G5oT1nxmW+
         WwwW8ys35gKXA14ft4a7OZnn/VMvJ77/ghyeWG7aZjtEcSdPdhAxD2CacmetUDxUEBT0
         aMoygPW1QMJAd3uXMK9qYWN2lew1I2BkTitzW2yN6ZVNKspP2OrGjdlqJ56S5BAZck5j
         cOprtCwUCx0HRShhIkw2cHkgQf8v4qeoO1DJZQC46BICmROn8TuoW3FRSk6Ybxhsscxd
         9mI6Xu3Kj2dWu+TKmfjucLQhynFwOD5hgvq2KKipa8QPaPS/YgD832Cis61J74wj7lgY
         XrSA==
X-Gm-Message-State: AOAM533PVWuuT/tpWCVtDZ096RFi8Ha6iz5pvK3+ENIoEtXHGFULObDC
        T2+gX2ybE3n0Um4kfnvWboBhhW+Ek38qUza7
X-Google-Smtp-Source: ABdhPJyb6dRTxXx74acKEEMeAlHlHhMyx25QFKcNMNgGixTA/J7vkOsp5cUoAFTZjQE33W6aP47CEg==
X-Received: by 2002:a17:90a:7842:: with SMTP id y2mr1328953pjl.68.1621893083181;
        Mon, 24 May 2021 14:51:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v24sm11422953pfn.101.2021.05.24.14.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 14:51:22 -0700 (PDT)
Message-ID: <60ac1fda.1c69fb81.b33bd.6b65@mx.google.com>
Date:   Mon, 24 May 2021 14:51:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.39-105-gd8d2794a2bd3
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 114 runs,
 1 regressions (v5.10.39-105-gd8d2794a2bd3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 114 runs, 1 regressions (v5.10.39-105-gd8d=
2794a2bd3)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.39-105-gd8d2794a2bd3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.39-105-gd8d2794a2bd3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8d2794a2bd357476a82c4d315ba323557fd5c80 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60abee518de9186758b3af9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
9-105-gd8d2794a2bd3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
9-105-gd8d2794a2bd3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abee518de9186758b3a=
f9b
        failing since 4 days (last pass: v5.10.37-290-g7ba05b4014e8, first =
fail: v5.10.38) =

 =20
