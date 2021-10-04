Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9BC4204A0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 03:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhJDBUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 21:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbhJDBUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Oct 2021 21:20:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD1AC0613EC
        for <stable@vger.kernel.org>; Sun,  3 Oct 2021 18:18:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k23-20020a17090a591700b001976d2db364so10963274pji.2
        for <stable@vger.kernel.org>; Sun, 03 Oct 2021 18:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=StnxTGziFOxeNkRtgEPwZgoby4w7puwDO9GcefObSo0=;
        b=RhxpVj98bmklLKIGhUfecoNTuZMILhfHXjYI6F8pUUZ3AqdFIpVtunXF05icQ80gzP
         x/Rrg4OJuhqgqmiFBxmx48AgK799mLkZtRxdtNEcsoopM4Kbpy4HsW6KE1VItzneBnpH
         pHJ89xBmLPE+8SDHfb1Y8pL2JqC2EVjGg0IQYhNlyBB4xql6ey2tE6BqHJPzvyy1Eebf
         3DRmwEkYbKaUrA7HJcq8z/ot/T+Gflx6XU3yVYYj3XbCcw4OmiTZb5dF4qq7wG+8aVu9
         kFtcefiIRHX9YLzcRLwJaqIlN9iI7f1PojGBtY85h0zKYYwmFN86fawMemInQZj2qxdZ
         oOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=StnxTGziFOxeNkRtgEPwZgoby4w7puwDO9GcefObSo0=;
        b=CL/YFNGJhv3Xx/DEe1AWmrG7bBrnkkDvRggSniuqO3N8o8ggRpStVtqt2hPhAzRDa1
         sd8c7muyZMLi98lmd1kBD/zr6S/ei2iBNk6r1DIQ4qwD0mOINenvU6GbOPiBWj60kjLG
         WxpH7CbNM/C63UsYfkN5bwD4Tdr3dAQGGnXNKOi7LG9fCXQBE7aKQX2qceuJJx6TLEfF
         TcnJJKYR3zxMF8mSgvgxtVaEE5etl2qjTi2tbv3paxrQVS60Um+VhVAqhP2Hw3ZRZ7+B
         8tMCy5Pv77YxXHbrIarrevm856/mR/Hdh9mHxKMTNhNkKzqhqT5sPOkXcNWcxDo5DY5p
         D2YQ==
X-Gm-Message-State: AOAM531OnrGC7/8Ss4BT/bqK9LCeLyS81BGrnvqyig0XKY+Xw1kBUfIH
        Va86ysaAPbHpcn6Zh02Iu2JOr+k5lmHZsEyn
X-Google-Smtp-Source: ABdhPJyuR459jEyPnN9nH1p0LYZ92Qbb2EYT8IYSberK2UtNWdPmEkFm/2/vsGutcKiA+jLlwNVCzg==
X-Received: by 2002:a17:90a:fa0c:: with SMTP id cm12mr10720454pjb.101.1633310331534;
        Sun, 03 Oct 2021 18:18:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm11836596pgf.14.2021.10.03.18.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 18:18:51 -0700 (PDT)
Message-ID: <615a567b.1c69fb81.77532.426c@mx.google.com>
Date:   Sun, 03 Oct 2021 18:18:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.9-74-gb50148bf3122
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 117 runs,
 1 regressions (v5.14.9-74-gb50148bf3122)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 117 runs, 1 regressions (v5.14.9-74-gb5014=
8bf3122)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.9-74-gb50148bf3122/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.9-74-gb50148bf3122
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b50148bf312269b30d2321ca1bd0c9c6054cee32 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/615a26726c1fae0ac499a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-74-gb50148bf3122/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-74-gb50148bf3122/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a26726c1fae0ac499a=
2df
        failing since 11 days (last pass: v5.14.6-169-g2f7b80d27451, first =
fail: v5.14.6-171-gc25893599ebc) =

 =20
