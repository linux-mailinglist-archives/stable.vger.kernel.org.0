Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52201FC08B
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 23:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgFPU7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 16:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgFPU7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 16:59:47 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C00CC061573
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 13:59:47 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id k2so1999451pjs.2
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 13:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6sJStvKYbpH5QYoeI4Ws/CYD4MbleffChshCJ4oz9YU=;
        b=1OFihychMApK7j0/PrS8VPdd9EoUsdW2RINdR4QsB+uo7FuqH1Yzgh+otQj32XZU5o
         tLgmLa0hL2SQZe4dqemIqYKIiXVBH/HK4AjxsmeUtw60N0uGL9SQSVvXGzGo8Y/zGerb
         xlOY2+d5sIjq7dAKmbRZ4PAbKQBmMDXlHrrDn8+8afGn4wCgWpLe65ysZ+i3L15Y+H1b
         VdAxCafow2hYchSATj7ZPx4rGFukb1oP9uM6Bw9VEr5fbvvLhMh4jJfMAB54qThMJMBx
         vwttK6+x0tko/qtQFX+rbm8IPj5kHc0BDsuLKyoxwC55g9YT+pUkFLtU2+ftojNh2lP4
         PLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6sJStvKYbpH5QYoeI4Ws/CYD4MbleffChshCJ4oz9YU=;
        b=fEFIDOiKL0CfENLevu/Ko25Kw5VnEbo7o4Up9SePucWWo3D+GlCSvmVuV1BEOHAX5w
         5RdpfMUahRxjrYRS4vJSRWaw9kpKXjCx/IHAE/mpfo557GJbLudb8ku1plTeEHU5Wpvk
         g9L/4kFQLMPLV5Upt9R2juX0H21kZuyH/FjT4B1IIquCt3ciTMJcOi2hSYlmnFOlErKD
         Igriw9RwfZ+CDp7zp9zCB+jXtvbp+jlOQ4lLVFTEYdHq0MtZfdIfh0elwjqxjImRFc7K
         T8+lv/GxlS3F0WgJKDtqvdG8NuJ9O+OEGHE6pZ+Dqd0vnhbDv0LgATP+x9auHFxwz1Nw
         wF7A==
X-Gm-Message-State: AOAM530H3LOgR42R0eJTFyvc+PbtKbFPr+KVfigtKh2sh4eVCVk/FD4v
        zHJP4mGlHYQjgvnXJLFwiOFY3rTphEk=
X-Google-Smtp-Source: ABdhPJyA02mabU9ake/FPhiLaoW3k6pqjcHhjeItkG74u0OLnIffNu5mueJHqCZjpNH+XhtwXKyH9Q==
X-Received: by 2002:a17:90b:30d8:: with SMTP id hi24mr4602655pjb.78.1592341186282;
        Tue, 16 Jun 2020 13:59:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w5sm17541418pfn.22.2020.06.16.13.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 13:59:45 -0700 (PDT)
Message-ID: <5ee932c1.1c69fb81.d04ce.ab02@mx.google.com>
Date:   Tue, 16 Jun 2020 13:59:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.183-122-gbb81e4cb5570
Subject: stable-rc/linux-4.14.y baseline: 85 runs,
 1 regressions (v4.14.183-122-gbb81e4cb5570)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 85 runs, 1 regressions (v4.14.183-122-gbb8=
1e4cb5570)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.183-122-gbb81e4cb5570/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.183-122-gbb81e4cb5570
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb81e4cb5570c489657c5ce4ca6ab857282246b6 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee8fd7f85783f6b0697bf10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-122-gbb81e4cb5570/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-122-gbb81e4cb5570/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee8fd7f85783f6b0697b=
f11
      failing since 77 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =20
