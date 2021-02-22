Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F078A321E2E
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 18:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhBVRfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 12:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhBVRfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 12:35:02 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E65C061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 09:34:22 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id b145so7024819pfb.4
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 09:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L3YQX2X2lnDYXMSN3EcPX6boFwS5i+2sUaoVuOMWCdU=;
        b=PP16ZE3OK/8EmYdh+jZAD++3zriYLsH6WNkynmC2jlYjr4hrlHT4ryPzjG8vyI5wU8
         nJ26mSji6QzcPF2qDCYvoYyJ28Hj4nN4AvanvXEhrPxPLXda4Y/ANJF/FrUFhsAnCOhX
         c26W1Qfk7EXKpEzoptd91kv5BqN+B5RywMEZqvHC+nEGZQQ4XimVe8K0pHCbuSi5JRUo
         e/LgoR2R9xntuJ6Vi/oaXtWCHB9WVUsCmr+KrsJcJc+EkivZV4UA4LQr8uzJyDp7Ur0I
         xJE8HdFBXd1w+NP4fd0adLCf33OwlT0Cwi2QGadxgvk4kbeIpKRckla7dW8SrKnkL7mF
         Q0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L3YQX2X2lnDYXMSN3EcPX6boFwS5i+2sUaoVuOMWCdU=;
        b=T7xMNPc5W4UrDfInYgAJLo6OH66H7NngUZZtbV3j9Vz8KX7aprNnSlEnYA1GoFgZx4
         CzYWfbZ8tx7BG0x/l6DM7b9W8qHQM/Z+NLqbz/018Opyr+kiNyDF1Qjg6lMDxSSBgpT2
         43Bc1nQOCvp5rIBlQlLkGn+Wl5RPXRRWnFEG6hPE1RMWtwMXGKssqmEqaqFJ2OvXqZKq
         Q1l6RK7/7ifd3KLbopq9WBJZORCV0A05QDCjQD+GOCAMgq1kyLwGlhY14RTE2UDG9/Cx
         pKoJnVWCc1dPR4upKmAhSirWVHrvxoTUYB89cutagc1mjKk/rhhY36+nrdNq8+xgcPb1
         SAAw==
X-Gm-Message-State: AOAM530l9ACByaXVi2AMwveBb2cFLlWiC+433ft0SQXpe7CrnVaRF6iH
        3akKUAWT/9ONtfWrKo6BjyL1TEolaPC/KA==
X-Google-Smtp-Source: ABdhPJxH9KvWeBWaECLeFS0e0Z960nBmp10rDyxTLipgiOLvuDDXBwq26Uh4wm9g9nvd3BOvajojKA==
X-Received: by 2002:a63:515a:: with SMTP id r26mr20969250pgl.257.1614015261333;
        Mon, 22 Feb 2021 09:34:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v12sm5202pjr.28.2021.02.22.09.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 09:34:20 -0800 (PST)
Message-ID: <6033eb1c.1c69fb81.fdc0.002c@mx.google.com>
Date:   Mon, 22 Feb 2021 09:34:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-57-g22a72a19d7dc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 72 runs,
 1 regressions (v4.14.221-57-g22a72a19d7dc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 72 runs, 1 regressions (v4.14.221-57-g22a72a=
19d7dc)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-57-g22a72a19d7dc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-57-g22a72a19d7dc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22a72a19d7dc5e092c9a36a7aaf39b27c58eab9f =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6033bf79b167a65fafaddcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-57-g22a72a19d7dc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-57-g22a72a19d7dc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033bf79b167a65fafadd=
cb6
        failing since 76 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
