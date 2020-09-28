Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7CE27B70E
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 23:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgI1Ve5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 17:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgI1Ve5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 17:34:57 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143DCC061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 14:34:57 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id o20so2379129pfp.11
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 14:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NdXy9x1hD+iXq9BhUvpWwc1vlDtbg0eH8pg/CtDpVrI=;
        b=VxhuQGFF/jYn9ZqConxMgJ3AiznaeBkyInTvgx36Kr0fFP5AfeI8XckgV6bu44xMR0
         h3ROEHWwzxrBnovgn7nVuhTL0OYuFLHfcAa6kHcnhaqvLW9prepQeF9xrrfiCIjZ3KhC
         gXa0HjHvXzQg3MpurKp/svvNsOexazrBjzCZpck3V5D3/f/Z4EKkpdVKVG9ylIRO6gTT
         3mI21xkbI4DjzkRwoDNBAJg2qgQzxiwrExyr77te6/qwoWe3FVUrqjdF2O5ZHiWjatZP
         ONkucbzWBa5By9sbOhQ/2H/P5mzqAcn8MyOcPZnPxihJVUN/Yxpk44IteUo8R+T2le20
         +PJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NdXy9x1hD+iXq9BhUvpWwc1vlDtbg0eH8pg/CtDpVrI=;
        b=LFSP7p1hvC4lI184YGoUr3mkowXOaUsk7/9AWE7fLJZFl6Yl/PkKT07vTKflDDx01m
         Lpz7Ln8qHOqEfiBJXFbzx3fOD+3/Beu/yTWXiL1r2JBB7WVmHlb/4GcNtu7yllIAZA3K
         7/wvlyygFYlRA02ogQuDFCg8k7FyboDJ4D9aikyxsD7lItEq8QWjqd3DpZKV9rEDfnax
         sm1I6NWujHDJBwKlbLhjqh6mtRzEmhlpRZ4QAMw4BCePB4sC/yTezpX3NwwFvCp9pKoG
         W7BldfyBVOomHboOr/u8UAtbr/Jlxp1OUMNI8n+8+Cq0UG3+mWQ00ldHFDQDwQeFw53S
         iowg==
X-Gm-Message-State: AOAM530IDSqE2R5OWHrEFV3gsQ0N4eRjH1jlxPZH7YmF/GN+zm5CZPxS
        sspRwcI57vLsii9CWEW3atgMm5z2Z1LUVA==
X-Google-Smtp-Source: ABdhPJyFQrAXTeARGo7ZcQUbwMyOhFFiRl/Mympmy1Q4ojR4g2L9yGgNxEkvVcqo6hOk2Rj2BF8s8w==
X-Received: by 2002:a17:902:b688:b029:d2:43a9:ef1f with SMTP id c8-20020a170902b688b02900d243a9ef1fmr1309260pls.9.1601328896304;
        Mon, 28 Sep 2020 14:34:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u138sm2763102pfc.218.2020.09.28.14.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 14:34:55 -0700 (PDT)
Message-ID: <5f7256ff.1c69fb81.337d9.553a@mx.google.com>
Date:   Mon, 28 Sep 2020 14:34:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.8.y
X-Kernelci-Kernel: v5.8.12
Subject: stable-rc/linux-5.8.y baseline: 179 runs, 1 regressions (v5.8.12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 179 runs, 1 regressions (v5.8.12)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig        | results
-----------+------+---------------+----------+------------------+--------
odroid-xu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.12/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c52d2a4d9e9c5659feb05f718bb37d3eab6f591 =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig        | results
-----------+------+---------------+----------+------------------+--------
odroid-xu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f722b5a7c1a78f302bf9dd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.12/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.12/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f722b5a7c1a78f302bf9=
dd7
      new failure (last pass: v5.8.11-57-gcf9938637c5c)  =20
