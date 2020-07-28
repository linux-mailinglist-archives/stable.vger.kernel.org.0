Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699732300E0
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 06:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgG1EwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 00:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgG1EwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 00:52:23 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B004EC061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 21:52:22 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t15so10784965pjq.5
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 21:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9RzI3vjifUF79P10h9q8ipwW+nARY8MgORI7bP4HDgI=;
        b=ktGuLi7aMlLq5XVubSCCJC4icRfZ7/F80unDaaYo5lR/xJIGpM7t8ESxj26mPsGoc9
         Vn47tuO5tGmnZRwbUvd0QwKvYrRrK0DMBcdxSwvIM65cTvqmYOO+IdKaBhBQYR0HUmXL
         8SfgvRg5ggvBgDxvcakFUbjX6K3C4/3a3dJySBq8I5vb9id+SazCdISIQJdh4Cyxqkdi
         EZGErvMYxZdc0i7ydQuGjK8sWb2kackTyaugfAJX7lfThEW830L41ZsiPgmzbdtMIw3t
         kofjbUSNI/isEfRMhDd1Clj90CPB7jliGMi8ncIV/eiGw1JaTSx7G0W5gtvMfmVYJA3O
         f6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9RzI3vjifUF79P10h9q8ipwW+nARY8MgORI7bP4HDgI=;
        b=uXR0uy75+V5wXdq/TBbG32yFVZVzFeXKbJNPXph+iwAmJWpBQGvqAKTvHWC81LosVn
         yjYBgcfnckn+tvCXD9KZBBs56avmC9N6YTaPlGM5ZdWLHScnsFvtzGeRQJCIL+mqU4AI
         b+L0aMeztGHy7D7P7lqcNxMUVoLG/uPwhjH8dWq2VUj0yA3ZFJOnGqK8DLonNWlqGdQT
         Zxo8HaqzvRL+DaJmLDIJtWaS1c/E3nRPLs6ce/LSUmr3gwgXky82uLCo5Ef/KUk2Du/J
         WISDIdQRgq6VuUyEsN3ksXTD+KaSRultlcXs+uOL6XaAmkO6u4RyJb212iNyMLeNlVmd
         q8dw==
X-Gm-Message-State: AOAM533QWQDOSm/mc4y57dWwVUjZucB1i9dM78+Z3GT+R7MRpe8gbF0i
        WqP2lfButXDDhmUBQGzYrILZQJhMCCI=
X-Google-Smtp-Source: ABdhPJwXSZKz3AAqmhKkqXCWqtwNpE7KPyV36ZIHpAblX0ZYatLPjUqTARPZ1U/eO/0SKoKXK3Z6bA==
X-Received: by 2002:a17:902:7241:: with SMTP id c1mr22455905pll.79.1595911940127;
        Mon, 27 Jul 2020 21:52:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j9sm4093820pfh.150.2020.07.27.21.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 21:52:19 -0700 (PDT)
Message-ID: <5f1faf03.1c69fb81.3c98e.1239@mx.google.com>
Date:   Mon, 27 Jul 2020 21:52:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.189-65-gf238f865e754
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 119 runs,
 2 regressions (v4.14.189-65-gf238f865e754)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 119 runs, 2 regressions (v4.14.189-65-gf23=
8f865e754)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.189-65-gf238f865e754/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.189-65-gf238f865e754
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f238f865e7549f70e465fb28f92c863900e76455 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1f6e67ef705504f385bb18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89-65-gf238f865e754/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89-65-gf238f865e754/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1f6e67ef705504f385b=
b19
      failing since 3 days (last pass: v4.14.188-126-g5b1e982af0f8, first f=
ail: v4.14.189) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1f523e67f85f15d485bb1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89-65-gf238f865e754/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
89-65-gf238f865e754/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1f523e67f85f15d485b=
b20
      failing since 118 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20
