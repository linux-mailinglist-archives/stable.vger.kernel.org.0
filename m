Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F854562BE
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 19:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhKRSqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 13:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhKRSqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 13:46:47 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73679C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 10:43:46 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso6517616pjo.3
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 10:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nA//zHLTEgBf7yKGow45L8g0BcshoXzAaFpPowHFv08=;
        b=fDYJh1smHynaMzcPzh8atz3z5oKI8/TCsiDvL3gAGSW6wU7O5LEPY3ToqGg6owXqyO
         BNwjje82FyoSFNNROdJV3gJ04PCyDz7Qe8KZTXU2OEV4ghEleV0Z/mmFfuN4k9C7w5UZ
         ilGrIeWGkTDH4UMRNAxqjQq675C6TEgbDGvMmJ4qYMrXv9fOI3qzmjjGTAfGeYjHteR0
         zcAZpe2pXI6U49xESg28CuERDO1zAP5hsJA+6RH45mdo1O3QZ/Dz/uzZCV07o8s5lKls
         FQtELkzBJYA93QXkY1+aWvjAnDG4tsTezNfotQqwnTe2VQEMg9CtQBg8bDzgb10eV1+v
         3tfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nA//zHLTEgBf7yKGow45L8g0BcshoXzAaFpPowHFv08=;
        b=0TfeT6omUm+zuUKbvT+WwjA09GoOzfD+li4NJCspa+Xrp8wbgtS64isgtvu5qj0rWM
         HUofIzGbFrTk4pH+uF5DfgxLvDafI607vLCkmAtHWiv7z8+GbsgNz9ecBfix7hb3tsXX
         KS01tSYJtegyUkwnwCxLR2bDIzsnji+6J5an/ugFpaUywa3xWRGrpFZSfRLQL6D/pS29
         9EPQd4x7iK71PpnHff6ErynfplI6m7yWzpN6zDCcsvNn5AV7VX70/AvxwAc9tMDCTTKi
         zrO9J58AT2HqYB16kZkm9j37p/mrxGr2vw3cPsW86mkx2FLw/OSiHqgj0dxlVVocbjQ0
         Ol0A==
X-Gm-Message-State: AOAM530o57PoSVHZsWxhLYfMB6+J9t7B/UVq83GZYsFU5uW4jc9/cfll
        p4ZpJa0/izK57GVzeGK/OvdtesQxe+BrNF/M
X-Google-Smtp-Source: ABdhPJwcBPkp3I/dwrd1EOkVUWbBREkltyUL1J1hxpwuknTzMe3fF0YlScdpvswiBZ8v2x1IhtXUZQ==
X-Received: by 2002:a17:90b:3509:: with SMTP id ls9mr12949857pjb.99.1637261025935;
        Thu, 18 Nov 2021 10:43:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u23sm314168pfl.105.2021.11.18.10.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:43:45 -0800 (PST)
Message-ID: <61969ee1.1c69fb81.dcf0b.152d@mx.google.com>
Date:   Thu, 18 Nov 2021 10:43:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.20
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 166 runs, 1 regressions (v5.14.20)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 166 runs, 1 regressions (v5.14.20)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff7124b91f52412696e66683b37a5724c303cc11 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6196685ac2aea2fe9fe55202

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.2=
0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.2=
0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6196685ac2aea2fe9fe55=
203
        new failure (last pass: v5.14.18-858-gc82fd5d7547b) =

 =20
