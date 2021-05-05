Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E440B374A70
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 23:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhEEVjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 17:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbhEEVjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 17:39:47 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF35C0613ED
        for <stable@vger.kernel.org>; Wed,  5 May 2021 14:38:50 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id i190so3016464pfc.12
        for <stable@vger.kernel.org>; Wed, 05 May 2021 14:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2VpBG/PeLjnCSa5px8s2eHKRZqYOozbnFVRcTcNN/R0=;
        b=Bhy2lUNRNTl7GPseyVqxvaxG+ZW+FiOWscXDjDpt9SlMQfH/Jb+ItBhqS/ljq6nxkn
         +o6lsTRu908yKXhJ2nxdVOyIYc7tnWZx/6vs2G3UwIPE/xNbQX//hNiMfKR6dDQfDvJL
         XKw8WWeBIT/RLVVNLnYooQObJoILjnEZf/4E6BShu7peeQXLvkqdidoDQlGa1lL0z1lZ
         dBmL2poeSnRUugf18Ri4mRNhBoZIJVMT3IsfiGfx2/PpYXorCbVX3Gy74y/sABeUh34x
         8bkPMrUpPz6+mbcqRY7LX2v7AJclYPKxLDGd2ovKR6AcUMF3J6gjljIN8o62JmZH81no
         M7SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2VpBG/PeLjnCSa5px8s2eHKRZqYOozbnFVRcTcNN/R0=;
        b=bqhTdLyP2xjOcevRMMbF/Bq+s/k73deuf4fHyjIbxCJX9+rTujOOHAVNYmdwVQXuQ0
         UK3lzPHQeXUHS9xjq0dlf5+0oAZqCLM1qmkJJfXZ73y2x2pzpt2Jt2E9ZshrZRrjNgu0
         3o332YvyK+KzmT77Uu+JaYaPZ3Sh6wKpGTuHjoD6Ncs1tC2CBLoDMk4qQgpscNG/fiow
         9cvxSmZ46VdZOAWiWXmnGEa0EnkCEAgGvJ0FU0PdqmFCmqgSJ9v/3hXLFk07ZphLtxSd
         t8BFEWVZh+SPb0UXJeLYnXmSguFRt+3uIyzYIneBrSO3YlD8Fys8iJdWvE2XeyGFmJmq
         Iitg==
X-Gm-Message-State: AOAM531NGXWj3mGj+jRU/NaRqW448jTVp70S+RriFi9qw365f/1XmvV4
        9FqfFr8cw6vm5+W9Cc5SkoVk0ZNIKweZLSds
X-Google-Smtp-Source: ABdhPJw202TKs5HrlPAx8xFwV/0RSJ9dmU3oVnD8fFvaJEtRICeYWrKkyQCYOKxMwP6XDywoJy42hg==
X-Received: by 2002:aa7:914e:0:b029:28c:48d6:b27c with SMTP id 14-20020aa7914e0000b029028c48d6b27cmr811539pfi.79.1620250729557;
        Wed, 05 May 2021 14:38:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 128sm155953pfy.194.2021.05.05.14.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:38:49 -0700 (PDT)
Message-ID: <60931069.1c69fb81.5058f.0cf0@mx.google.com>
Date:   Wed, 05 May 2021 14:38:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.34-30-g5f894e4a8758d
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 80 runs,
 1 regressions (v5.10.34-30-g5f894e4a8758d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 80 runs, 1 regressions (v5.10.34-30-g5f894=
e4a8758d)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.34-30-g5f894e4a8758d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.34-30-g5f894e4a8758d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f894e4a8758db7af6eeb43311c0e9314871b031 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6092dfa913d578427e6f547f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
4-30-g5f894e4a8758d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
4-30-g5f894e4a8758d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092dfa913d578427e6f5=
480
        new failure (last pass: v5.10.34-29-g9efe65f2d6926) =

 =20
