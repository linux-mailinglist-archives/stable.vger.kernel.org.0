Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0511622A916
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 08:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgGWGqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 02:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGWGqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 02:46:11 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E99CC0619DC
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 23:46:11 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 72so2129918ple.0
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 23:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y0mzgTrYzfitmwWxvPkN+WjetIq4Ucq/l/xr8fmBMEk=;
        b=bPW4U49oV8vDKHhYkpvjjOxNTNpiBP7GNG3uu2RVmpfxxafj7i86TdJnnFy7US7H/5
         0x8qlTWASdGuU4hgSVeJNOpdAkVa/e4pgFocoq59bEypkolPp6WOzCnT9nDT0t2P1u//
         6vC3Dnd0Y8XPCkN6aWLuyS0TsEGWYBn+bzzXwZMpafU/E1zzLdr/CbGYtvgCKEWbIVBc
         YidTTwMo1aegYC5OaWrLe2f974wk5NgSEbQa3fKZvpuXsv7t9E8MVFlh3CjBzOlnaoTR
         atobkYRioK2oFFbQkXe2NdthMVdr8YA0CAWooSAPHOLsszGEbMBDW5rHjr+dx52KDrSG
         2arw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y0mzgTrYzfitmwWxvPkN+WjetIq4Ucq/l/xr8fmBMEk=;
        b=OKQ++lodBY5JRXRsDpBMkurUNq9TwI/V4jUaNZvZM3MJA+eAW/FdtUyR7cafiYQdTO
         b/g6XxHo6q9F78uCsoIvxcGrocihfG7dPM9jG9xrpb9M95DIfSs98p6Dq5uxdfcK7bRU
         WMC4wRCENUU3588YW4GL1YrsEqVkBf8qEkXgT2gJwx2MoQoe3SeDvwg5pRlLd0vjz5Zo
         HkNUzBQgzKN1p22GpJToUriMKodwdlHvgyxveDbWWDZ0SRxiQTUnwRRpxUsW4oQY4d8y
         08XrHVj8/N6ZrEqNWpOUNx314RgFGvNYFi+9v/podo+1qg0HhBJsHOzI6wuIpMAjkZdf
         Wb2g==
X-Gm-Message-State: AOAM531dMKFyvAjxtd6UccxMMmtDC7paPHk5sF8I0L6flAkpNbYzSU26
        4oGWKOZuaO+gxSrHqGHjbdeS70s10gM=
X-Google-Smtp-Source: ABdhPJw90Jdv6SBleGYTp+N0DYCuY7H8Eduz8If74zr466fVc1/elTZ03YU8nbEotiKQgRCZd19Tow==
X-Received: by 2002:a17:902:654e:: with SMTP id d14mr2781965pln.60.1595486770540;
        Wed, 22 Jul 2020 23:46:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t126sm1690213pfd.214.2020.07.22.23.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 23:46:09 -0700 (PDT)
Message-ID: <5f193231.1c69fb81.86439.56ce@mx.google.com>
Date:   Wed, 22 Jul 2020 23:46:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.231
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 116 runs, 1 regressions (v4.4.231)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 116 runs, 1 regressions (v4.4.231)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.231/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.231
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      554bbfc0d87fcbc842a18997c2a11a772dc3f003 =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f18e4bdfa8f03f14f85bb18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.231/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.231/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f18e4bdfa8f03f14f85b=
b19
      new failure (last pass: v4.4.230) =20
