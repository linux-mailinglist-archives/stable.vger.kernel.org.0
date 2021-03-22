Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956FC343AA5
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 08:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhCVHew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 03:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhCVHeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 03:34:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1604AC061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 00:34:12 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 11so10358055pfn.9
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 00:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f1zSzrCC8H8ADYahNEFR6XvwveJ1kARqXDHv3NmFJIA=;
        b=AaCfvnUFOWXj7Ne31qOpZmENXcW/MW+Mre6c5yafIOSV36FFjGTMBT9Pt8PEsB0TR4
         GwbdWmH2bNV+qjqk4aMjHyM9p8TxfEqk/qNMBh+dstDZzZRXgoS0fndeF7fvvcoJ75g5
         V1gxpHnfWxh1QNJylbmLbjQmiCkcvFZ9HUUmifAKEZdmTt16pMnQCSxH7+XYjfvHlWGn
         XNOijwOT5ImSYkImhfpE61DWkU0vTdfipoxGUtiCKfWECAQLjWlLI1KC8XC0yx3LmxEv
         BWj9elPqVjfi5HUZz2Ie5i9gULwRmfXFJvpjyH8JWiMaRX0a8nmg+9if3lETgTRwUojO
         ss4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f1zSzrCC8H8ADYahNEFR6XvwveJ1kARqXDHv3NmFJIA=;
        b=n0dABM/yjvgeQvlZlmRYpwIZvOFPvXrKzBzn2X56mZX8Y7/qqs/xZaPDLc82W2jdVb
         IjP27CH5D3FjiCPbW1Wt5t7V6qHPk+1ru+tTx+8LmPmoyXqyFzpVPeY33ek016rJmg9Y
         5bfQ7V1d8kVeDsiETOW+y0ZVzPAmU+9cAA5KV/1dfRf/czMClf/6ldu7l4hawS7fjK7e
         NQpiJtDE3eeEOiqMHPoMyytJNLsvZstblrBpXhHXxG7GrHr5GqPtS+VP48hXIZDZWA8F
         qRw5Z8EW7SK80tBB0aNgrZK9xjgLzCJV9aRVlEG/Eeug1BtSOnKn3L9+mgq5kDLCjH3g
         iSCw==
X-Gm-Message-State: AOAM532viAKE4nu2Kjp4IopIvG47DAUonru6aUceKfFGLZL8bHffd74J
        IGJuipwGCZFHnOyg6zS8XCjyBVXtEaTBpg==
X-Google-Smtp-Source: ABdhPJwX3X/1VGssVmmOGD18aL11gwHxDvOtQ8UFmf2hxQ3uZRSUZLWWBZ/dnrDRNPU7crSzTi2SQA==
X-Received: by 2002:a63:db02:: with SMTP id e2mr21558318pgg.18.1616398451486;
        Mon, 22 Mar 2021 00:34:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m4sm11242204pgu.4.2021.03.22.00.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 00:34:11 -0700 (PDT)
Message-ID: <60584873.1c69fb81.cd316.bc44@mx.google.com>
Date:   Mon, 22 Mar 2021 00:34:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.107-33-g7716d8962401
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 168 runs,
 1 regressions (v5.4.107-33-g7716d8962401)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 168 runs, 1 regressions (v5.4.107-33-g7716d89=
62401)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.107-33-g7716d8962401/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.107-33-g7716d8962401
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7716d8962401708a59e2ffb6933f89257251de89 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6058141b293f618267addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-3=
3-g7716d8962401/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-3=
3-g7716d8962401/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058141b293f618267add=
cba
        failing since 121 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
