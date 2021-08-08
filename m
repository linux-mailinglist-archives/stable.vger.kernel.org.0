Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222503E3A5E
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 15:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhHHNTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 09:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhHHNTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 09:19:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9701EC061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 06:18:44 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so30186544pjr.1
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 06:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5vryR4Txhw77dGypiY347UwspO1/Sc1HAfjajio3NtU=;
        b=iE9skerfCxTSrcI+Stfs+R7MShmnUAa/saepltrOAEG57qcLFo+eKAy+L4WjoHk1Ef
         6XLrd5qenm8syqjnC7xFj6Eqwn2NDYSqcHys4SznA7NUssMvUem3Q3GXpwcBk3xdtC8Z
         IZKkixZiIFrC0JlZmn8rxlt4iEpZnvjnpM++dWQz/X5/aieTp5vLrTZ2pp3VY603qmZu
         P44A6rsCCv/JtENpOGxhC4p26WqB0M7cTbmYo3UzTSr2RRVhy82Za7U+jsNNZGgnCLhg
         wWKZpAOaoLaIjSg0M7xnU2+aFAPXbNWKs/qu/8BUhzwcfYmnCTolN2WjFnYQv0RNigME
         V1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5vryR4Txhw77dGypiY347UwspO1/Sc1HAfjajio3NtU=;
        b=gGVdRR6HEixKc/nL9lTLqLS+4Xs/lCGDFumU78iFUtIWHIfE26mlvO0c8keWeTOqeW
         k2g8MgfhtnqAdbxYiXQgNH85AmvGXn2BM4YGe8bUS71ui9KtwjpJwhwRIIMqlhZLUkbj
         hN0JH0SvthrO0d0qYIYMO+1rwgEUE9c1/SuaZPIQdM9Yc/RpfMXfsMRbn5Hkz+qMgRhO
         Kq3u6xRXbqmXMvYEEBY6uw006XuqusdM3zT4GXA/HTc7KhaoGVLyJwDRxv5UXfkwBYOl
         DAs6SMscvTu1ng/qLD02OY2cEQeuUCn2jo3AyQ/7R8FHgd1HwPuUQVjnO7GYuosoTDXo
         bJNg==
X-Gm-Message-State: AOAM530DB9+FVOYDD0AmP6EHzaPZDgw6Apsm+44xO3IJ4hcoAighYn90
        wgJzkVv6Wni7/11VvcPzV+tOi76h0wBnLoC3
X-Google-Smtp-Source: ABdhPJwsV3pAIOQvWEG+kJZtZesaroUavW5ZzHWZIVgY1eZ4rptG6CZuBZqoIZvbpOuLGTgUQVONeg==
X-Received: by 2002:a17:902:7041:b029:12d:267a:d230 with SMTP id h1-20020a1709027041b029012d267ad230mr922494plt.55.1628428723926;
        Sun, 08 Aug 2021 06:18:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e35sm18757157pjk.28.2021.08.08.06.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 06:18:43 -0700 (PDT)
Message-ID: <610fd9b3.1c69fb81.555c5.7376@mx.google.com>
Date:   Sun, 08 Aug 2021 06:18:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.57
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 77 runs, 2 regressions (v5.10.57)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 77 runs, 2 regressions (v5.10.57)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig          | regressions
------------+------+---------+----------+--------------------+------------
imx6sll-evk | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =

imx7d-sdb   | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.57/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.57
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1cd6e30b83d741562b55bf5b7763b1238a91150c =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig          | regressions
------------+------+---------+----------+--------------------+------------
imx6sll-evk | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fa4776271f37bbab13678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.57/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sll-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.57/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sll-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fa4776271f37bbab13=
679
        new failure (last pass: v5.10.56) =

 =



platform    | arch | lab     | compiler | defconfig          | regressions
------------+------+---------+----------+--------------------+------------
imx7d-sdb   | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fa47b9a2dba52beb13681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.57/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.57/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fa47b9a2dba52beb13=
682
        new failure (last pass: v5.10.56) =

 =20
