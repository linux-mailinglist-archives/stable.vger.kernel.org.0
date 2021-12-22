Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA60D47D342
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 14:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240923AbhLVN4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 08:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237204AbhLVN4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 08:56:30 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7FCC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 05:56:30 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 196so2425696pfw.10
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 05:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y0bmk1rprAorHgJJzFGyivEoMzrICjYfzjwh72nv+zc=;
        b=jtpmhs+/mogthXkmZjTMlzuGzwxkxfZDp0fc1kEYDbLh6zLUCUeYoQhrqRHhNV6mSR
         m8IEv6LIHK/WtaDi+A8WEezr/x+R8Ts/ZFj+o7APic3HbG43vkNbUd+GP/xOZPbTQFID
         CYgeQA+uRSPjTXs5+a2cF5NViUqpjjj1lWTxkQ2LOIsVO96st8VUl8wf/876J9qRYuaa
         GhVgcJGnW8i2pDlgmu1pTv+L1FV4h98MsSp3yL8em2duxsaLh0fXpcfLvDEAByKz3t1j
         628H8b541zKjhzWxcWPqv0oEZAx+h4qI+wv1pROQmDijLXBunb09/p18lrUxKy1WgNOZ
         xwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y0bmk1rprAorHgJJzFGyivEoMzrICjYfzjwh72nv+zc=;
        b=p2KCa2C1NLzVq2wyjb4XYfL+pljeTuH6Csq9boSiRDKJwmmdkcX3r6ArOlvjIXoe6e
         ZUfncTDbmF12Ss/vZu50+oe54meswHcuM3h6GMTE/RkjiuePoKOgSuVIHs62Gdh1WSWL
         7Y+Qe+KmcvrOPLT/xeUC3xx835fwHoTHwva3g6lTKzSn65OKn5btYKI88bF3O+bwJuhW
         b0ZPpRqX8VBSOAHpWuNCT0mw1iwyfOOCiS2C37+8Y0Mh5J4olvvpjEKvsluMEF+oSesM
         sk9rJY3ljY3g9BzQyVRIC44mY9rE6FZurredk2OgDjHA/dnfpD1OG0aHqTvldMuSLZF6
         zARw==
X-Gm-Message-State: AOAM530gQ8EMhev8elM3PZzelTg2xrmFJrdFHQKE54Pm13r9FpO9v+Qx
        sIZRzQkVgff0n58Lot+kfcSfKJNXISOV1RRb
X-Google-Smtp-Source: ABdhPJz3+yllqWkFUCvNywEGYsS5M1KElo9dTXQ3u+dVBAhh4AyN89SdLjsmZAyU5OCCXY3IBRecSw==
X-Received: by 2002:a05:6a00:2182:b0:4a7:ec46:29da with SMTP id h2-20020a056a00218200b004a7ec4629damr3283103pfi.68.1640181389685;
        Wed, 22 Dec 2021 05:56:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l186sm2265504pga.24.2021.12.22.05.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 05:56:29 -0800 (PST)
Message-ID: <61c32e8d.1c69fb81.4dc77.5b8b@mx.google.com>
Date:   Wed, 22 Dec 2021 05:56:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.88
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 229 runs, 2 regressions (v5.10.88)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 229 runs, 2 regressions (v5.10.88)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig           | 1          =

sun50i-a64-bananapi-m64  | arm64  | lab-clabbe    | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.88/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.88
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      856f88f27bbc4d3b4b88ce6fe23964ffe60ea649 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/61c2f648495d4d3c9b397242

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.88/x=
86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E38=
26.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.88/x=
86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E38=
26.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c2f648495d4d3c9b397=
243
        new failure (last pass: v5.10.86) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
sun50i-a64-bananapi-m64  | arm64  | lab-clabbe    | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c2f9a0b85b6cb1c0397132

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.88/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.88/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c2f9a0b85b6cb1c0397=
133
        new failure (last pass: v5.10.87) =

 =20
