Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10A945CF74
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 22:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242955AbhKXVwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 16:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245566AbhKXVwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 16:52:39 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1F0C061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 13:49:29 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id k4so2948347plx.8
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 13:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=np32vU1WML+AHUWmK6gKzv7nttc53FrTPOVu/ofXyKo=;
        b=EsX1y4zz0soIYSh9GhojGH2famGAfOADJKe7qSi/yV02eNhrcGoTa9uy2BiTON1yUH
         4QiUnbi6hxxcPslg0qx4cRH8NOGCsrEvajnKUORJi2glRtxGR8D0ADubGsWqCzxNw8bF
         dSgyicKkFUqff+PsqbWloOBNDJ0fbJxMhiQG+IyOigDk4bqn8s1tPtWNJoQ/DHnwIsQ/
         kGy7EQ/zvUikzzJcUwKCmolDIgVCdVUeJhh0O7E6dIR7kcMaHCnsU+nnlIVvi+ZxF9Xv
         XJT25ZS/eOOHAYDWoJ8jOfO46DBsXtyZ4iquOBq92r8pemmd0ZdXSpZ+HJoboh8pbvv4
         DjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=np32vU1WML+AHUWmK6gKzv7nttc53FrTPOVu/ofXyKo=;
        b=cknO5NCTnYGnKHOKjlm/Tx2WFHzwi3EvcTbZhmA0I+joxLWpICr0AdA10ZT26le2Zo
         ebmcQZ/wrp/ESWEseuRLWiul3PT4y7HfFLCT4YXuNYPfyLKGDAjG1qY+5cx+Tat09ynN
         oU9QHf3uoFNFbpZ+3VA7fdTxmhFiU3Jln++f360pYYBmXfOLWkKl72VhexlWp1JqloQ4
         htA62xO3dEW0+7/sg9NErpDPHix3iaC5k+iS5y3FXDyOdJHf9rzXhZTgZLwTAM6fzP7R
         zWT8haBe5HW1JbiiPg/3BXruA8uij16hnTremXXwBaZ4t3nFGnGOvtiPP7xDIcfuWNv7
         bBQQ==
X-Gm-Message-State: AOAM530Ko+I612iH4ohKagVRxbUkOguw+2WiIoI38+tg2bc7XN4Hz2kl
        OtDoro9OzPNXyLH5eLv2M6aKiKsInwNE8wO4M7s=
X-Google-Smtp-Source: ABdhPJw+M9KjFvG/dY1scyTYhgiaapseDi2625mv4Fan/Gn/N+PTlf+wXffjRZkmhlU0Z4l3wgXQRg==
X-Received: by 2002:a17:90b:1bd1:: with SMTP id oa17mr345159pjb.246.1637790568722;
        Wed, 24 Nov 2021 13:49:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pg13sm587443pjb.8.2021.11.24.13.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 13:49:28 -0800 (PST)
Message-ID: <619eb368.1c69fb81.4b13c.2273@mx.google.com>
Date:   Wed, 24 Nov 2021 13:49:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.81-151-g9b8ab16e6d99a
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 174 runs,
 1 regressions (v5.10.81-151-g9b8ab16e6d99a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 174 runs, 1 regressions (v5.10.81-151-g9b8ab=
16e6d99a)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.81-151-g9b8ab16e6d99a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.81-151-g9b8ab16e6d99a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9b8ab16e6d99a3f75790b61814ee31785cf2bc83 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/619e7cc58d114e5595f2efaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.81-=
151-g9b8ab16e6d99a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.81-=
151-g9b8ab16e6d99a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619e7cc58d114e5595f2e=
fab
        new failure (last pass: v5.10.79-539-ge1c22b684563) =

 =20
