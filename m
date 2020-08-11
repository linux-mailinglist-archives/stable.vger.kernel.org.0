Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A938724149F
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 03:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgHKBrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 21:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgHKBrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 21:47:08 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB18C06174A
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 18:47:08 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id kr4so1040422pjb.2
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 18:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jYtetaBJ6LdXp6PdsDC8FwfWQSTQzF6+ByiaR+Ed6nQ=;
        b=mH4BFVxRQ1WLs0iiAqSBWpbP9DqcHjYOuw+nwRrbO6xKqWsnbiQqK7b8n6nLkq/dnx
         dZN6T/FzUDh7aUZlyZn5pfSKq4dS4aiCxpZNBAQqwm9xfnW1rTOC7OZxbOky+5xE75xH
         BfoI8gvmMwXh88rQsQwBnJhsCVbVwDjHM5wnBBNSTQDGGe0+qlZBRG9knx3ips4kvbBa
         VlK4doj4qKe2ZkYTq3MBwwWEbu+ubbVuc7Qfqkhh/CtyCQETB+jiQmtiqnRn5IYkR6yr
         citbS+C4qKc9TxJzgA6LXh6sAP5yowuCzNdFsecA+sZ/2yXUV1Rq1qQNSTcoxMZlAlf9
         Ce0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jYtetaBJ6LdXp6PdsDC8FwfWQSTQzF6+ByiaR+Ed6nQ=;
        b=mCPxZZVgAptjxo7eFt3eAGtgn71pXXWZCipjI+9C1r4fveite9x6+iWRFX9bvbGxTu
         QVOqeVF1IYM7XfVw9++WK0HXD7j02zuzFUuLr8JONjRcYu+Gk2V/eV60SxN8vLo0CJPr
         uqPcuDPn9eV4cP1aoq2VAD1D+pzim2PaG/mv7tIOqLqjGnRo+1NAnLZ52SGYOOxCUZ2M
         5eJ0roe+cKZufWFICYGJ50WC4WBTEF2D/5KTOGrUdBOR/Sm1auilNwvenbxEN3gdbCg0
         93edTa0kKXpASFCJg30Gi4GhWQGgGgkfi/z3zP2ZRKbsUIemOQgq5G0BZU7uf8hY7OKr
         9S3w==
X-Gm-Message-State: AOAM531d2a7n5Ed0g+IpzY6OBEpDXfMCjaNNdNiVCeeWwv/PG2oF43d6
        9G+qQ/z5w7zrkM8EhrdnE62QHDpfNmg=
X-Google-Smtp-Source: ABdhPJwDY9eeVIVa3PpnRgpswTVTUHWtN63xM1wECYQVgRZf23pOxej0SjCGqZFhnzGpNvraXguTBw==
X-Received: by 2002:a17:90a:c201:: with SMTP id e1mr2165654pjt.142.1597110427436;
        Mon, 10 Aug 2020 18:47:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x20sm19224205pgh.93.2020.08.10.18.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 18:47:06 -0700 (PDT)
Message-ID: <5f31f89a.1c69fb81.e6493.33b5@mx.google.com>
Date:   Mon, 10 Aug 2020 18:47:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.232-54-g437925754341
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 109 runs,
 4 regressions (v4.4.232-54-g437925754341)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 109 runs, 4 regressions (v4.4.232-54-g43792=
5754341)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/=
1    =

qemu_i386-uefi   | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/=
1    =

qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.232-54-g437925754341/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.232-54-g437925754341
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43792575434177a00b4ae91453bcb7a5e94e781f =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f31c66addff3caf7a52c1b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-54-g437925754341/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-54-g437925754341/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f31c66addff3caf7a52c=
1b5
      failing since 7 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_i386-uefi   | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f31c656fd392cd5cd52c1cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-54-g437925754341/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-54-g437925754341/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f31c656fd392cd5cd52c=
1cc
      failing since 7 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f31c5ad157be53d6252c1ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-54-g437925754341/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-54-g437925754341/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f31c5ad157be53d6252c=
1cf
      failing since 7 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f31c5c12b3951ba5652c1af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-54-g437925754341/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-54-g437925754341/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f31c5c12b3951ba5652c=
1b0
      failing since 7 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =20
