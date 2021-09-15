Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE87B40C84C
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 17:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhIOP2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 11:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhIOP2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 11:28:18 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0EBC061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 08:26:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id m26so3024884pff.3
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 08:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PX8FAdqQh24EdwnaktIqirCmpR22njuRbdM9EY19Ij0=;
        b=ZV4fnETxNyptj5QDoFgYMOoOyc+tUEhxB+4qtjRR5+dh0QovLn5J08qiwaM7Kz5NtZ
         NZtHumEcxWAvtTXwxb+sEFqFFI4udIIx/EC9DOH8iMa4LRj4IngYSZ3whigvfEmGtrvC
         08uTmJIGacrUm1UKoq5BXWENlW2QzwPkh4QwkpGTio8hkRncPMHcTMRI+rGCmIHNBGOe
         QwGQU0nFKpPYOiyQ8YPTx3MWlI4KUVp6qFtIYPc65snaBsq6BuCBOYMqPSigi1lapcsJ
         NC1aXnZMPNPuYs2xzB7IZz6rSXvK/Yr8veWVPB258xzwUtCA2HtVM6EKzOcujwpBLTk7
         wvBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PX8FAdqQh24EdwnaktIqirCmpR22njuRbdM9EY19Ij0=;
        b=DtCw5iqBs51xNviiO0MPRLB0DyM0cVr4dfSnRVHkOkwWJC5KQlrf81sCgAQuQiVK0I
         0Nu84SuidEMv7mQLfaaElbDXJta4Twi1PieN7A/kYWVHS2P3q4WgCEGmEZv39f8szTGv
         6ew3Z27ltLGzvrqpnSCrtbO13A3e4QZvpBD+CsoP2zPhX8aQVJ3PS9ALp+X9UdcwtRDf
         l7HmT7mFU1optk0y/uw9QM8Negbkt2eMZ1KrjmYAVceMkoG7+xTsZWmw4BKzHGATX5CP
         OURxVLM6IymJFWIGan9gw23M6gXFDLifU4klSBUIdReqVNEPWrQj/46MNYMTwj+cDBNL
         M6zQ==
X-Gm-Message-State: AOAM531dCGFxg4WT2wl0Xna6BH9+iipOk6rY8LtLxeahNFzHpGFSgywz
        N1cwiLVxGmjvFnzfjESMg8hs8I7zuVESNjKcV74=
X-Google-Smtp-Source: ABdhPJzNofOp6BagZ9xXGXAQ2vbS9lg5gYFivGaAgqwhe9k+IWmJC0/acolFlXdg1eCCVNTwpN/U6Q==
X-Received: by 2002:a63:cf10:: with SMTP id j16mr287676pgg.257.1631719618531;
        Wed, 15 Sep 2021 08:26:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 141sm350077pgf.46.2021.09.15.08.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 08:26:57 -0700 (PDT)
Message-ID: <614210c1.1c69fb81.c282f.13ee@mx.google.com>
Date:   Wed, 15 Sep 2021 08:26:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.14.y
Subject: stable/linux-5.14.y baseline: 178 runs, 1 regressions (v5.14.4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.14.y baseline: 178 runs, 1 regressions (v5.14.4)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.14.y/kernel=
/v5.14.4/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.14.y
  Describe: v5.14.4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d6f7bb5bb29096b2935c55deeb545616dab74406 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6141ddda62c6906f0299a305

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.4/ar=
m64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.4/ar=
m64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141ddda62c6906f0299a=
306
        failing since 3 days (last pass: v5.14.2, first fail: v5.14.3) =

 =20
