Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A4E321E13
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 18:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhBVR2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 12:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhBVR2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 12:28:06 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240A5C061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 09:27:26 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id t9so4367363pjl.5
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 09:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wivdd+VlLET2GLARTOBHuhkuGeIUV+e06qQFNM2sowU=;
        b=gzhj6ztiftiFn16a4QbvMciE7oTNgeJJcdHPDJSA1kJ6v/3F78RnuuiPHdt4tAKbIb
         LgjwIlqNwh8btBXhqvz90euFeiYJgsY1D87sT/kc7Qrj+TMCvLVXMBKNyvsFy6TD6yMu
         Rj9S0NAtz9MwbSFQ4s8zkP7mvjpXR3SU2s3aJbCxGDBDMqROVxcF/+u0WhV+RUTgyxTb
         A53op+s/GhptVoon1ZYgqinBp9OfPNjq+Bz0xp0U1WIEqj/iL9eGHIpG51odZkXffkLC
         FpcpuZBrXCyjJxN+h3C/dBJ2Z2uxYztapjdd5zbD5OKQvjJaIsmBYoIKxEQqCeDvzCnM
         I3/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wivdd+VlLET2GLARTOBHuhkuGeIUV+e06qQFNM2sowU=;
        b=cnRxuLcoY9goDfhtDka9GtT9hqJvwzu+WCh4/BoYahfpRJk9ixlEMdCd4RZK7VDqtc
         PYXj8gHkfI/VQM0VWOPhk1mA6TsDmHaP0h1tmAR13kMAGCDqOkzm395vF8TJfP2SMF8n
         +78i34mdKOR4wm4GvJQ9QtOlrbF/PyFlQnmE0QwNKhZ3sxAjeRmfRobTt7fY6ypghFxE
         HOf2vV/hC18LJeqsQW/10eGFIg6FgcmYLkygygO6y86i0EZk4tWbQ8bsGhWRYrxA4ymu
         4nK9Sm8+zElgxt1hHiK+u52/XSoBCUUA9VYWnv3J63k9E8iMFddBCglRVlAxhnaVqGvW
         +l5Q==
X-Gm-Message-State: AOAM530kR7uRnbzBGT97KRByI0aqXkt92mpPtpP7jWEMCuGBeyAZ5yL4
        UqsVfynHvYBejTbH2gxae6xCHN3m879BHQ==
X-Google-Smtp-Source: ABdhPJwtxbn50w0urOTUN4rK45VT3ecMCG8jwl0VNq8dDNEZ/2cALq9pTxT4okfyo1s5yEm06jEC2w==
X-Received: by 2002:a17:902:e8d3:b029:e3:cb77:2dde with SMTP id v19-20020a170902e8d3b02900e3cb772ddemr15025026plg.78.1614014845411;
        Mon, 22 Feb 2021 09:27:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 4sm19944300pjc.23.2021.02.22.09.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 09:27:24 -0800 (PST)
Message-ID: <6033e97c.1c69fb81.6d99f.9f6b@mx.google.com>
Date:   Mon, 22 Feb 2021 09:27:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.17-29-g1b13e2554bc40
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 115 runs,
 1 regressions (v5.10.17-29-g1b13e2554bc40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 115 runs, 1 regressions (v5.10.17-29-g1b13e2=
554bc40)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.17-29-g1b13e2554bc40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.17-29-g1b13e2554bc40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b13e2554bc40dc3b1609bd93afd84020dbd30d7 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6033b7411deb4c7c52addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
29-g1b13e2554bc40/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
29-g1b13e2554bc40/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033b7411deb4c7c52add=
cbc
        new failure (last pass: v5.10.17-29-gb69cb72e5303) =

 =20
