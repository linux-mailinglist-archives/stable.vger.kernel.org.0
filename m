Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA2B34C0D8
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 03:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhC2BIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 21:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhC2BHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 21:07:47 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A596BC061574
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 18:07:47 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v10so8353241pgs.12
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 18:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KEhO/N6DoPCTPuTCTYGd4LFpa/lIllsyGkPKtFRhz+8=;
        b=GGFZ7irWfHC6H46As7DlGp+1cOAiw2E85uFXgUj7neC607oaCoYk9qoZVq5SMBGpmu
         6yMcdPg+mP05a7q4fovP8Xs9oYTAqwStwkd588KoAdEMcJUbxdQR36oRfG6jZ90n5cAI
         ZhcJdU8e/45vvxCZxUZQI34nvqPuqu+W2XGCmOPq6FzJnqFmyqhFp71dzB4LzyUdvnGd
         WSNuTO+lDm53S56VuswWZNcq41fuLjj15/EW5KtqZ5JK/KE8d9gIHqzaHxSdDipm1/+3
         cBQCyjVKGXydXYe+ESQjrPNa5r0fBzUI/yc2kWvRlFh/ZvMTBIknvdeFE5yzyhZWiUYm
         eM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KEhO/N6DoPCTPuTCTYGd4LFpa/lIllsyGkPKtFRhz+8=;
        b=sF5ZFhb+Rf45jrWS920M8y9lkzIE3/Zut6Pc/oqcl0ikyezaAZsK79RnRb/CZAZm5P
         PRotfBH+0a4pvrx4CUfP+ienOpQjHXIxfR59PkqOFnHyktYuVjozeIgNom8wsJTSJCyn
         R9hPZU5yvFbhvm6CJUzv8mEBsD/9m6x3ghKMhwktqc7vG4PJCDJiiXW/+3lASppRXFA6
         jxHaod83amy5bPlHoK1flIMbUhgCBVLR3Lar9awzHqYvCWj895dwrMhJv16S6ik5h2bV
         NcgTu9guSUqr17CRPxpaCWFWutxMPm1AcmHF6zaMM/8zIFWVX7GxHkOb6XtMMIu1kUhY
         N7fw==
X-Gm-Message-State: AOAM5333Ugfzw+KCWSDEw8ZFeT9odc9sdL2ATUonTRwVEXC4EeU+z/MM
        Ajoq9hpXD1BNQ45Y1N/49gughCIh6oiG1A==
X-Google-Smtp-Source: ABdhPJw3les7Mx5MMSD/EF28P3aDNfxGOHK0e+q5EvoG9/fNSGV8E1xlGWSU1ChpQS43xnAZg1APrA==
X-Received: by 2002:a63:5416:: with SMTP id i22mr22361553pgb.43.1616980067048;
        Sun, 28 Mar 2021 18:07:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z4sm15059697pgv.73.2021.03.28.18.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 18:07:46 -0700 (PDT)
Message-ID: <60612862.1c69fb81.f78a1.5ddd@mx.google.com>
Date:   Sun, 28 Mar 2021 18:07:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.26-195-gfedccd8a07e7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 191 runs,
 1 regressions (v5.10.26-195-gfedccd8a07e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 191 runs, 1 regressions (v5.10.26-195-gfedcc=
d8a07e7)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.26-195-gfedccd8a07e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.26-195-gfedccd8a07e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fedccd8a07e7d6203b034f52e8c99e25108bbd85 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6060f17de726f9a706af02ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
195-gfedccd8a07e7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
195-gfedccd8a07e7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6060f17de726f9a706af0=
2bb
        failing since 2 days (last pass: v5.10.26-56-g525a07fb82ba, first f=
ail: v5.10.26-61-gc7b7b08c4bb5) =

 =20
