Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756CD31C460
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 00:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBOX01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 18:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhBOX01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 18:26:27 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC13C061574
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 15:25:46 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id z7so4515675plk.7
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 15:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QD9KBOxdt2ekplL52c9IWP8vxHy1VVqs4Ffk/HBOz1Y=;
        b=zePa0Fdaz9FeBDLz/O/OvV0rhxYTiWNO8zmNzmEDiNGfVN7dYOvjArjMMbtfQ4VNz1
         M+XDnwohqAx9nW4pr53uCbaWpD7LWIrMbm2+nVoDxM3c5w7a7uxTGguJL3D0qEhAhjO6
         kWV/HIwzPPMgdUL3iIvtQ1eun+NTLvlvwapnZCZ/kIxQtvbJcxZXaxtnFhoqXqr9kgjX
         c4jf9qbyBjUEJcPXI6gv36qdACOwEoXwAVDWWtn133ZkUCa0SW1HDSmljy2yFv/0N8Di
         i7Nxg4KKC6zMDzvBzeo/mRsIM7uTajEDgq2SPAhcgSJ6J2bGfwdoaiyPSyhII/S9JIBb
         m6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QD9KBOxdt2ekplL52c9IWP8vxHy1VVqs4Ffk/HBOz1Y=;
        b=WVXONMO+0Ow9bq1XIHHzTIO0djnZpGr2TMyEK3AbL0zB8v03/Gak0ssnlxt6KAnjqO
         58Mdm/iRXXV7mYbOONiApsL/+vOnahxHIaP988e+3aN+B+XjNdQGB3ek9Vn1XM3AHWc7
         lt4yyoDs9U+POJxqRT6tMp7Ui2Loc6FlXoGXNNdI3iAVHSl3ioiUtU4BcLUZPMTBQFVd
         KKd2nAzELwBEBe/k5qOk3Est81yAMrcx9a/o5vgPPbUCg7cnCfw0Y16VwlSLLk01s2Zg
         y2E6ONPkSJTuGmSLDnak6FbGiIbu3IArXDsaOnciaaCT8WaQkRV6dJz8YDGPwdGcwqwU
         qErg==
X-Gm-Message-State: AOAM530ZRMLk+0YO1NdV1GIgQhsis+bC4jLQX+prARaBriOvFkq7nSCc
        Aace/+YqIuDAK2hCq3KyzD/+0m+UbMl/3g==
X-Google-Smtp-Source: ABdhPJyHP53890AwdgwNVJEm+5excxbd5vm6ZL0TEucQnv+LhfxnFh6ZMZXnQZ89KDyddFWLRPj0Sw==
X-Received: by 2002:a17:90b:4a4d:: with SMTP id lb13mr1130812pjb.44.1613431544879;
        Mon, 15 Feb 2021 15:25:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gk17sm549608pjb.4.2021.02.15.15.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 15:25:44 -0800 (PST)
Message-ID: <602b02f8.1c69fb81.c402b.191a@mx.google.com>
Date:   Mon, 15 Feb 2021 15:25:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-40-ged78750302ee8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 61 runs,
 1 regressions (v4.14.221-40-ged78750302ee8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 61 runs, 1 regressions (v4.14.221-40-ged7875=
0302ee8)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-40-ged78750302ee8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-40-ged78750302ee8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ed78750302ee892c06b57916a507fa94a2b73771 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602ad00764343a79d5addcd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-40-ged78750302ee8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-40-ged78750302ee8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602ad00764343a79d5add=
cd8
        failing since 69 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
