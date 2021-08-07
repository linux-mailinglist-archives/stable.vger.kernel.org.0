Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53643E3603
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 17:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhHGPBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 11:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhHGPBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 11:01:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1E3C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Aug 2021 08:00:56 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id j3so11281314plx.4
        for <stable@vger.kernel.org>; Sat, 07 Aug 2021 08:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c/7PX4ZU5GbU8Hr0h/c57RK2Sx1YJbH3BcDPMSVyC9M=;
        b=pYDm4d1oyTzFcDuI69Dc9gWxfXJkfiqfoDcOF0iTDqqnF9bFWRNid0cJ4LruNFYaDY
         BKTDt5JJ28Oj74pqN8m42BCitP43jVnfErHVLA574L5HRdcKtaJLkF12DxmNdft5iwhS
         0WU6jTilQyLKTLDQSC2dj4uU52hkgBCZzIbCG5yWVtp38f9vWjtrIBbI3M5g5k0dX1DO
         eq96NDMt857RJ2qa2+9z4ySajQ6w14Rn6cU2j2/kq1NmFQLYcKcFzw4BWtuiVqql3Aws
         Dp/7H7nDfSwrxoGkDEuirwlAkekHtDYV0jH5stinEeGgalwwe/XHMNG9AOTuOk3cgb8z
         lH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c/7PX4ZU5GbU8Hr0h/c57RK2Sx1YJbH3BcDPMSVyC9M=;
        b=ohg7jIDAz6JYiK44+OhS9NRSdz8e78H8Uz8FaSa661ANkYYAip7qyWdsMoT6LQymi5
         BnJuXXfd4OY/1NzGvrboVMQn4AWPcPcHZxjAD6INJ3NokEM6Ny005n/Vwk1ePWVnttll
         6RpMlHr2xBM9xeIZl00wdBS0cuWSBMyXNd00JsHA2TWpcQpeeqxxdjhzydf8xWymR8of
         Zr9RUiaF8Xus0lG9P+EGnzftXz2S4+iqWUFfRUimlTq1CbGk4McavBXX7uG/L2PoZzYH
         n+L6g+TBTxCCiv9O+B9cUhJIUeOBLzT+5TG1Cz6/0CcvbsrI47EejJoF92hQrCPXZ+9J
         0pVw==
X-Gm-Message-State: AOAM532AGWX/e6SYqILyK2Is+B/kN2fJPwPB+5JKNjMUqRyToxcGO7JC
        ADFKwF+oX9MUYyu86QpXJAuMihhavLSczZtP
X-Google-Smtp-Source: ABdhPJxviZ4ffrvhfIne1B6JVsHee9Ccwa8EA+Dz6wFm9wEGg7gkQAa4UIMxxNf/jDvtzFJu56J/fA==
X-Received: by 2002:a62:9248:0:b029:3c9:b72c:2b9b with SMTP id o69-20020a6292480000b02903c9b72c2b9bmr2537946pfd.26.1628348455531;
        Sat, 07 Aug 2021 08:00:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f15sm15643703pgv.92.2021.08.07.08.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 08:00:55 -0700 (PDT)
Message-ID: <610ea027.1c69fb81.a5ff7.ec91@mx.google.com>
Date:   Sat, 07 Aug 2021 08:00:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.138-23-gd308e0e9e54e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 134 runs,
 1 regressions (v5.4.138-23-gd308e0e9e54e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 134 runs, 1 regressions (v5.4.138-23-gd308e0e=
9e54e)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.138-23-gd308e0e9e54e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.138-23-gd308e0e9e54e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d308e0e9e54ef392cfa824f0260cbbea3728969a =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610e665f6ebda15cdbb13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.138-2=
3-gd308e0e9e54e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.138-2=
3-gd308e0e9e54e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610e665f6ebda15cdbb13=
666
        new failure (last pass: v5.4.138-23-ge3ae776a76c3) =

 =20
