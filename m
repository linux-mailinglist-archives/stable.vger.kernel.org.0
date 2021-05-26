Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CBD3921A9
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 22:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbhEZUwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 16:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbhEZUwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 16:52:16 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004B7C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 13:50:41 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q15so1956978pgg.12
        for <stable@vger.kernel.org>; Wed, 26 May 2021 13:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ve2TKzDSF+F4/DHvOhPxesx1pvkFcct8++xSKAFKYKA=;
        b=gmfrnP5akzwpsOQISaBOQerBLwSTuDrShUBm3LOeHQEPRrg7Dggi37W7iwd9Egwalc
         cCYiO8I9x/GFkfXw2Hzql2XKIH56nRdOOZYCq47kcn6m0xmArqqNW1qOWwsdTY460oAb
         No8FlvZih2uf8PEflf+Yo1BLvSHNIZgmSawbrkNjfidwZDx3bv5AAnkTohoupcCV0jRV
         SC/E267O6/HBY+IJdSW5NjWexxz4tFO7vwMh5+Bl4aX+1dAaw8kbDRpep+lztBNpSTJM
         ZsQH+AxdO7xxguiNMxjNQH6CbsVj8MNZ+XtgRFW23Mb8K78ac1Y49Qz1q20Slx6rTq0W
         6QEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ve2TKzDSF+F4/DHvOhPxesx1pvkFcct8++xSKAFKYKA=;
        b=jDjDz+iBGkskZCsFbmnM+IjVy+BSTeVGJIQpmcf83OW4aWM1A6zYy0cblBl74niIsk
         PfjPdnH7u7eORbLIhbB2k9ghRpvCK4fKSSXI3mg6YHSm+5KcCE6nJbp/SFijaNdCB/cw
         MOYwayx9s1CDWlJJ75jp2b8jJkfJR/Sxmo3LVXuDgk3aUGzihKvvlnSTCH/m9TWbvgYS
         H6/WhXTRi3uXqe3ovpka9g1243zhwkQpiP5OWAzRHrtC9wb/Xy/SBli7GXhmSO3TLfAa
         6CWq16DLrRpUeqh0ST/sJwpnEl1Z2wyXKeQr9PT6jmelkS4gMnmH9lK6uBfUS+k4Ijtx
         KqAQ==
X-Gm-Message-State: AOAM533wL+hWQay064yLRDABf+yWJfot0nJULM5IKGuodtUEVcFhNF6N
        4t8hkJ43gvOSaWC2Cu6UMQMij1zRahjwoNp6
X-Google-Smtp-Source: ABdhPJzlsjLsJeLDAM35lm6ftl6blPt6MlchnyhoA1CuFv2NwleIIvWpFzL7WWxqcijDvCaaUAN+cQ==
X-Received: by 2002:a62:8705:0:b029:2d9:5420:a1b5 with SMTP id i5-20020a6287050000b02902d95420a1b5mr283560pfe.45.1622062241375;
        Wed, 26 May 2021 13:50:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k1sm107257pfa.30.2021.05.26.13.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 13:50:41 -0700 (PDT)
Message-ID: <60aeb4a1.1c69fb81.b22c5.08ed@mx.google.com>
Date:   Wed, 26 May 2021 13:50:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.6-131-g816f6e402e24
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 119 runs,
 1 regressions (v5.12.6-131-g816f6e402e24)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 119 runs, 1 regressions (v5.12.6-131-g816f6e=
402e24)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.6-131-g816f6e402e24/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.6-131-g816f6e402e24
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      816f6e402e2479039db27dbd077698457b8359a2 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae81a3ecb0d56280b3b001

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-1=
31-g816f6e402e24/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-1=
31-g816f6e402e24/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae81a3ecb0d56280b3b=
002
        failing since 0 day (last pass: v5.12.6-124-ga642885de2c1, first fa=
il: v5.12.6-127-g3e985cc005fd) =

 =20
