Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C41289BF4
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 00:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387857AbgJIWyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 18:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731960AbgJIWyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 18:54:44 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6B9C0613D2
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 15:54:43 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id x16so8441350pgj.3
        for <stable@vger.kernel.org>; Fri, 09 Oct 2020 15:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rpBAzFxyaQKjKeWCbetE8M5FuySw/tsJKIfTLMabRS0=;
        b=S80/k1xdYSP8w8BjM0ZhImaZTOyY7NhY8foLsqY1IvWdcLJZaXLGnFdcY8pbjCRbcn
         9XhMzYqb4bdgao4BZc5TrJkAih19W1bx+wbRuYQhTlh3XNl+Kz8gr3D0sYi/2w0T+H0G
         yXUfrTd9JyUG0ZI2MJS2VAOVZa5m4kBkDcTiMorDpW6Ov1YIUO7Ug6Vkdx3ysoKoFUhY
         OFan7sNk5yY440FUfsdfd6xhYl0Ke1nVRUyyp0ucjyYzoukpfcKMa5qCerJ3P9CEsUy7
         EssAuGN9peiUlvMJZSCgfGUIoVMuHkfq8s6qQoyHkMq9K28j9w6sW2wqEAlklLBMOI9f
         Zc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rpBAzFxyaQKjKeWCbetE8M5FuySw/tsJKIfTLMabRS0=;
        b=XVqfJjghuIP6UiCUUeDcd75iGgiEk2mq7+63xCI6ZyZm1celgk7Xu1wLvHYOpgYg2A
         3MzdCmWXZRy6s4oTx2wBexLRRWsar/lcygeKwgTlzXj+dGnurhCKKGqVkJJDzBZtzPBo
         5h/OxbQpD15Utruko0gfht0SSzmUq6AfM/RpPy718FLM8jmir46Fg8bpnHm/ElTBfVVF
         OY/o4QPXQASZ4ijYNCVipvKaMkTlXVDoXqQX9MBwi/wLhXiIuVtn5eq7kngEfGV/bNK2
         eJZY1NMMJMmOVe2PwcFum3GxnWgP6/AKRJeuRef0UBzfQBvBe19XcRiHgZt72Y3puRAf
         xTtw==
X-Gm-Message-State: AOAM53124jFDJsbCyVBLFgycyYcFwZ7Pqqkj6/IN9O1R0IZzKg0kyoat
        8lUoFwluaknnbQqy0yHbOF71Aqwm75ApZg==
X-Google-Smtp-Source: ABdhPJzq7JMnmPDAw2m0tNKzy1v/unGQwP9xxU9BFo07zOArtWEzSLqH9qBmunoVJAczXfKKmAVxTA==
X-Received: by 2002:a65:5881:: with SMTP id d1mr5173259pgu.193.1602284082034;
        Fri, 09 Oct 2020 15:54:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d129sm11984906pfc.161.2020.10.09.15.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 15:54:41 -0700 (PDT)
Message-ID: <5f80ea31.1c69fb81.5db6f.6d31@mx.google.com>
Date:   Fri, 09 Oct 2020 15:54:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-27-g1d9c092d06ca
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 80 runs,
 3 regressions (v4.4.238-27-g1d9c092d06ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 80 runs, 3 regressions (v4.4.238-27-g1d9c092d=
06ca)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig        | r=
esults
-----------------+--------+---------------+----------+------------------+--=
------
qemu_i386-uefi   | i386   | lab-cip       | gcc-8    | i386_defconfig   | 0=
/1    =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig | 0=
/1    =

qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-8    | x86_64_defconfig | 0=
/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.238-27-g1d9c092d06ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.238-27-g1d9c092d06ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d9c092d06ca9c2f101d442d7d686d56b4b509e0 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig        | r=
esults
-----------------+--------+---------------+----------+------------------+--=
------
qemu_i386-uefi   | i386   | lab-cip       | gcc-8    | i386_defconfig   | 0=
/1    =


  Details:     https://kernelci.org/test/plan/id/5f80a58bd6c1388d124ff3e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-2=
7-g1d9c092d06ca/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-2=
7-g1d9c092d06ca/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f80a58bd6c1388d124ff=
3e8
      new failure (last pass: v4.4.238-24-g7d118d33417a)  =



platform         | arch   | lab           | compiler | defconfig        | r=
esults
-----------------+--------+---------------+----------+------------------+--=
------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig | 0=
/1    =


  Details:     https://kernelci.org/test/plan/id/5f80adc2c81c22f79c4ff3f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-2=
7-g1d9c092d06ca/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-2=
7-g1d9c092d06ca/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f80adc2c81c22f79c4ff=
3f2
      new failure (last pass: v4.4.238-24-g7d118d33417a)  =



platform         | arch   | lab           | compiler | defconfig        | r=
esults
-----------------+--------+---------------+----------+------------------+--=
------
qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-8    | x86_64_defconfig | 0=
/1    =


  Details:     https://kernelci.org/test/plan/id/5f80b4cd3c3443ca034ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-2=
7-g1d9c092d06ca/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-2=
7-g1d9c092d06ca/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f80b4cd3c3443ca034ff=
3e1
      new failure (last pass: v4.4.238-24-g7d118d33417a)  =20
