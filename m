Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44EB32D862
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 18:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbhCDRLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 12:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239054AbhCDRLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 12:11:33 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02460C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 09:10:53 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j6so2939379plx.6
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 09:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eY3rujZRt/83qSRYT/ljgFjCPtUQgA6/Fg0/BQmJFbA=;
        b=ACJjRrNbnokXLVPi4HAZ0Ffijbj+iA/tMVguKiodhukJa6TcqO87DZWHvGCrrrH/Ke
         4f34O3rMEbk9a+5MteELOoorIaoAbvH+vYz4TustjOjlzIlrfFRMw6C9LOcFGYnBf+Ac
         Q1Hd1X+Mti3iNX7vVPHmC3ViUtYmpAkiifH46iMpOG64e8XavB2qVupemGnkMUp+3ugE
         Whid4NGk7syI055pgihs/eqz0kYPlIMOebjDTMtgTixFxJMAHlbbo4fF0EPZ056tCVjN
         d9aYlzlTyQGw/nCoSWSZ3AlttkwdAxtoZYz1Bv+czGg5ylWj3/2iM9mZ/wWzaLmKkvkR
         6beQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eY3rujZRt/83qSRYT/ljgFjCPtUQgA6/Fg0/BQmJFbA=;
        b=qzwGipLLiCSZ9QfURQ0VVWfv9VHzdFXp8sRiiVHIQANoK6szKFhVJFefQoioxVKVEv
         Clrlw//cxqnvPfkJML/xVCbnkdcF/mWq21M2PvV7KpzBElgUX/ZgELNmUpNZ3dcqVG68
         zaJEbTxrvPASDuuZyvd8VI1Y+g0i5J4LVcbJxF5DT5PMqkfYaI/EXktml4f10xYR3CbQ
         ViT7+kgIc5NRdwA1O1mBY9cHYszmkoh9Yw8QtxnaMQ+7mkRUjIO6am7LON2EUskeTnF9
         uzogocB8Cq3ldjU9GJxEbQUgKRIqn6MRgPauaN/YE4K5qN0EcggEOoCuJrT09DD114lO
         ezJA==
X-Gm-Message-State: AOAM530PmOvpc+lfpGZrjYPQhEsgnI8dBpXgbRLGT8REpTuPQQGYXci4
        FCXcUxdpKDnrshXuzi9xb2vqjDlYnEo2RWEs
X-Google-Smtp-Source: ABdhPJxQrzLu9l3JN0FZokiUmRDxyjzNPuzL8GiAFaLT5zf2r74ecWiUjzHPQ1v2nBqEh5TmgkWGBQ==
X-Received: by 2002:a17:90a:6286:: with SMTP id d6mr5509869pjj.234.1614877852439;
        Thu, 04 Mar 2021 09:10:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm5915pff.61.2021.03.04.09.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 09:10:52 -0800 (PST)
Message-ID: <6041149c.1c69fb81.70a40.003d@mx.google.com>
Date:   Thu, 04 Mar 2021 09:10:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 114 runs, 1 regressions (v5.10.20)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 114 runs, 1 regressions (v5.10.20)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      83be32b6c9e55d5b04181fc9788591d5611d4a96 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040e39cb5571c3c30addcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040e39cb5571c3c30add=
cb3
        new failure (last pass: v5.10.19-658-g083cbba104d9) =

 =20
