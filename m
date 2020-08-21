Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833B824E17E
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 21:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHUT6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 15:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbgHUT6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 15:58:02 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D781C061574
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 12:58:02 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id o5so1493359pgb.2
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 12:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cEwWM2Q7bEsnNBgVhRNuLtpLgTHUuU6BnMds7XNjHns=;
        b=BYM6uNGRr8wFdWSwso6Af3g6XwgxBhnZT4bdZdFGFJW4jTUCwIp2u5izbbZv2Rdt/c
         ywBoGRTTryVOQQMFIRBsBv+kaR/HKP8eCE1JwkEOiSN+YKeSahcjsEfWxx+VqN0qRDsk
         8sGYNQvAvwhiERqAmOTNpKigVYsfR7kY3UP0/yZbMdS+Hlke0PzaUFFDMDU5MtvamPQh
         5/jv2PXS6XY8DsZczGQnRhrLM5Ch3Q/YSr6QhbbAxXZhEeEsSYi+uPMTKyjcY62UUtWG
         fo43v48WFdcbj0AGJiJX7vvJDKVhjnFfMZ+OFhH8kL/pIzO69u3Q5SApNfXxxWvmI1Ua
         NaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cEwWM2Q7bEsnNBgVhRNuLtpLgTHUuU6BnMds7XNjHns=;
        b=pamkJGClU30w4+kb6bTx9C2K3XVUz9F6rr48fTeoXj6Z9JspzhUTpEqZrq0xBbeEVq
         5Pri3Db9RdrghgsgvEczZ7aowayrtZUNww66U03nvJ2U+ZDxYkud30ztaId4HjkYB8z9
         4JiolMAb971ZBCd8sm4w6NY/rupPB50ibQlORIuSrsRPMjejILzuZpfsc6Nt9hQv0JW9
         ie4CiTC+PfgPipiB4n59ukNmFAPstYF74AUQfy2NgG1dcjLU8gQxH8rs2YXxyLdLjAub
         6dim/3jnS688E5oLWMU4GacJNwC9WwV2DxsWDrgTA/zBcAH9xD/HxkT3S8AB8Az9Hh6e
         /CLg==
X-Gm-Message-State: AOAM5336tGLAiMciS0+FtIlB8/GGKqCa/i0I3Fe+udrTDmGnN95dzqST
        PYgKB6kRMPx6alM0+8eGZQagLoVHyblI0g==
X-Google-Smtp-Source: ABdhPJyGzuaT/IiZQmylG8/N8YlnOBtSqZo8F8ZDQWhHv0Xr6Zd2MLJVBXkhO1rWZU+yujaN8wgMCQ==
X-Received: by 2002:aa7:9386:: with SMTP id t6mr3895581pfe.220.1598039879444;
        Fri, 21 Aug 2020 12:57:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t25sm3345433pfe.51.2020.08.21.12.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 12:57:58 -0700 (PDT)
Message-ID: <5f402746.1c69fb81.99d0.9321@mx.google.com>
Date:   Fri, 21 Aug 2020 12:57:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.194
Subject: stable-rc/linux-4.14.y baseline: 153 runs, 2 regressions (v4.14.194)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 153 runs, 2 regressions (v4.14.194)

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
nel/v4.14.194/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.194
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6a24ca2506d64598eac5d5219e99acca9bde4ca5 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3ffdd3a610bee0d99fb467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3ffdd3a610bee0d99fb=
468
      failing since 28 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3ff14caf2e4e47609fb441

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3ff14caf2e4e47609fb=
442
      failing since 143 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
