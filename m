Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5ACC2FE453
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 08:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbhAUHsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 02:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbhAUHr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 02:47:59 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C42C0613CF
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 23:47:19 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d4so826394plh.5
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 23:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+HIyzLLuseNnYUN81Afh/pExj3Sw7Fbu5kh5Ob9Yn1U=;
        b=gmJCVXLhC+3kNSuhaYOI1uH2ct7DJy/yk2Dkna6/8zec4Zq3gdPVw0SfWjO9ngyBYT
         7jdxqusb/pNqbxDyKLeIU9duec+P8uMnsoRaTy1WhE4C7oVRYuNXWby9SAgJx2TTp7Ux
         EcACwrWMwwAPPF7RSJBIomyleJtJ+V+NPBjtw1NAzBHOuPl41Wrtg6dHnyT/lc3rTAqy
         T4rGdGrdyvLLmJrb3aLMqbu2M2eSC+aGhZj/pk2ASTUfNWRwBKL6EgWuyz8CkszBACLb
         ZpPTbRr8+TN1BcSwDAvKOUu6ybHyPzFqn4mT4z6dVfG6uk6uzkHkKrbss50uBScOr4PM
         /p2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+HIyzLLuseNnYUN81Afh/pExj3Sw7Fbu5kh5Ob9Yn1U=;
        b=rp9VI6wlO6ISnpFLDYfUsT+4loya7pTbPrSaH9r0xHL267ufxFepWp362V9uR4WScK
         DXHs4J+0MZ/Fks2BLfODuTonTgra7ioJm9vTcZ13Fwm3DDH+bnAln9tak+0W0MyGHtD8
         WLmfhvPjmodwY2SNyxT/DFuJd6ASZXqigjSPSGGFAg3Ypx+HIwhIjsVGF+PXml+C23SR
         s7GOGjINunlYY1QjWQXvWxo3rromR17Zyaxd1RmFcoM0Tr/R80m4ny6BWsIzzFQpgPse
         /d09B6K01GneOKkYu3nZWSFomwENJQ8I5QHCYEuZqT+WWk5qiv0HiqVVYGbrCdyULiNU
         cj2w==
X-Gm-Message-State: AOAM531jJOLfXm30oRnnxq2pPiV3ljeRuiY7F+k4RrAbZOJa+ZcZkPdW
        P5NMpdp0+GGlkPLRbXHutXlY87sTciePc5Rw
X-Google-Smtp-Source: ABdhPJy+Q7LeZZ6XfhNzkD2MLY97EQwNfMK4Oa/vjrsldBnL9p9HPh6RdFeiR+ShPWNvZIbRaR6mCA==
X-Received: by 2002:a17:90a:de06:: with SMTP id m6mr10138555pjv.167.1611215238258;
        Wed, 20 Jan 2021 23:47:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fv12sm3735911pjb.22.2021.01.20.23.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:47:17 -0800 (PST)
Message-ID: <60093185.1c69fb81.4a354.8535@mx.google.com>
Date:   Wed, 20 Jan 2021 23:47:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.9-2-gc763deac7ffa
Subject: stable-rc/queue/5.10 baseline: 183 runs,
 2 regressions (v5.10.9-2-gc763deac7ffa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 183 runs, 2 regressions (v5.10.9-2-gc763deac=
7ffa)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig | 1      =
    =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.9-2-gc763deac7ffa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.9-2-gc763deac7ffa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c763deac7ffa15b34932e2d61add92cf31f93e17 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6008ff547a6a210428bb5d30

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.9-2=
-gc763deac7ffa/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.9-2=
-gc763deac7ffa/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008ff547a6a210428bb5=
d31
        new failure (last pass: v5.10.8-152-g0a6b0acdd444) =

 =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6008fe87abe03c7486bb5d21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.9-2=
-gc763deac7ffa/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvato=
r-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.9-2=
-gc763deac7ffa/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvato=
r-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008fe87abe03c7486bb5=
d22
        new failure (last pass: v5.10.8-152-g0a6b0acdd444) =

 =20
