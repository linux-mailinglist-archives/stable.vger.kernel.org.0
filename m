Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68453767F4
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 17:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhEGPat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 11:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbhEGPat (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 11:30:49 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF6BC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 08:29:49 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s22so7394277pgk.6
        for <stable@vger.kernel.org>; Fri, 07 May 2021 08:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NBfhJroI5LpOcAEQDJ8Iv542LX20l12rvHAHrrq1wys=;
        b=WORy7LNvL486b5YyDdovM9fvMmnyNcsJ1immblYR9jS/19gS/tHozYhv+kLUdmp1ju
         auQXcGYGZCWkZQhd+xxAjhoweL5P5rhovzngRkUPkYk1/lVVrVdR65HJYtIcEXbDphhN
         hAo3ijvR7gMKmqIvktbmdX9w5iAGhU6RBhoSSGX4/tczk2gfMe8KMaFXa0tHx/JNQ2L8
         35MWlUwqHO4/DG0Yz+1wF2oG0XwQQBAw70rJkG6lAjZilL0yD/Jo4MnXSqlNZzNDHQ0V
         +WaiTvb1DDB021BvuhOrBbe6Tw7WfxTHrW13p9GBaZWNNvQhQxhw4WVzpnzE5UsuAPoV
         ppHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NBfhJroI5LpOcAEQDJ8Iv542LX20l12rvHAHrrq1wys=;
        b=E6LMZKHM2pKD9QjyMdyR1yq61QhmZExp8qujhJEBw5k9BZB5zORw/p1zdZccRb1Odf
         uPN+vq238GBnA2bd/ypa8b5FvzG6k0tkSj0hnrXZG5q6Bp0RhtpLj419+xHD9AYcYoeG
         vNJMaa6onghcFAvEOnhZNZ/nIMJEj/OXdHpYnxIJCWv/W2Kt42dEnnbwX0uCKN9WaCMn
         kBd8vuNrCAD9834mSPQO31pgDdLG4AeA9g/zvrvOXfdXPypnIMAjgHMg8HYzH1ZkB4i1
         rHtG8VmO5FRrZOJ8QiRON3INlWgyGqfhOMnO3ffzijXAkLD8IaU3UA54s2PvSzUyX23u
         Qgyw==
X-Gm-Message-State: AOAM530UMItY2xkXxWadWlOyOPATBtvtFWgP3zzNoh3216TIIS/i3TJk
        92RjPtJijghhxn4sTfmkYl1BA4nsUpUnU7fY
X-Google-Smtp-Source: ABdhPJwlzYTheQU1eSW9NknNjmTOHKPrieZHqrB3wdm2O5gylsgPphF36tJdT7E0qJwYmq82h+DDoA==
X-Received: by 2002:a62:2a14:0:b029:263:20c5:6d8c with SMTP id q20-20020a622a140000b029026320c56d8cmr11008727pfq.23.1620401388949;
        Fri, 07 May 2021 08:29:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u1sm4969877pgh.80.2021.05.07.08.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 08:29:48 -0700 (PDT)
Message-ID: <60955cec.1c69fb81.e80e0.ea6c@mx.google.com>
Date:   Fri, 07 May 2021 08:29:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.18-30-g80983e09d98ce
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 106 runs,
 1 regressions (v5.11.18-30-g80983e09d98ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 106 runs, 1 regressions (v5.11.18-30-g80983e=
09d98ce)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.18-30-g80983e09d98ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.18-30-g80983e09d98ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      80983e09d98cead100040800371966922c1c5a93 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60952c34d554b83af16f5482

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
30-g80983e09d98ce/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
30-g80983e09d98ce/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60952c34d554b83af16f5=
483
        failing since 0 day (last pass: v5.11.18-29-g6c2ae64a2a728, first f=
ail: v5.11.18-30-g4232ce7a02cc) =

 =20
