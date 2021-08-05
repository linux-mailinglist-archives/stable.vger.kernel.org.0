Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36CD3E0D5E
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 06:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhHEElf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 00:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhHEEle (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 00:41:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE2BC061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 21:41:19 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so6879280pjd.0
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 21:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mw2vV4W7wBBODXD8YHMLf2NEeuqLTTP74+3HmADyLBQ=;
        b=i/r4EJUFmqzrlHm6Xm8yd2kMUtvBpVD9IMopHHQEYmQ4VF/foLSrQSnkKjYhixEsoo
         FcscJm6HFoJJg6OR73W71/0kKYj/dDxab5T/da4BOTu3ZHPSdygJs/o/vXQTffX8A3MJ
         fiAHlfbdKKAOrcLoBmvV1TwzBN/sjmT9VN5FEv3Sf0D8kQKu4ZWySMFSj0mfpBey+TfO
         Ma/gzsAmAGvhHiAcMEzwXOGTscB/R7ARcZYSuK+EwHgsCMDB6nnkYB60w0t4lhWS79el
         q1F0BuSoSclqmXB63rRNyuKZE3M9jcCeHvw98KcAiz8Uj8DkqdbneRn7YTzNk4yX8y8v
         Cjfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mw2vV4W7wBBODXD8YHMLf2NEeuqLTTP74+3HmADyLBQ=;
        b=NyOop3sIT57fNPzbi/+j1PvoobAUoNvHQIhBhZmpwMHvD9UB4mPMriDwsZiXBu113V
         GAefFaY5j9u+fFn67gw2MtJFWfl12Gq3svUIkm4rjcsWBcPOl4JVgDucMORNGRjD9B4S
         i7lr+Pywkr/Kr7u8kYPWhLf6clg9Z34v3MY2N2b7iWPgM7wtD/L3V3HaxgMOKMcGdLwP
         RbMeibQCKa55AbIh479VbYJ2bYMDiKvUaoPYnOcT77PNdUqFbwaowB49ZguRvT4y8qbU
         rMqnXkfKHaWZlKn2ohPK6jr3f6HhWKZMPQy/LHUFvLpWNZgArbxwJO1f8GVuDjZbGu8P
         DMTA==
X-Gm-Message-State: AOAM531E5zJ/JnQegNEU8YbVYT3nc1ZxmW4JcFWE4FTbzt3sc/plBJZ7
        og11IfEwycq1k+Zpx5h9RviU5MIDWEz4DmKIvGM=
X-Google-Smtp-Source: ABdhPJxvnMFtGprpaw5GnjrqweiRjFiMI832ULBr2eHeGeg5enfiCb6qOCUaXBoI/4ijEKqqemgECg==
X-Received: by 2002:a17:90b:295:: with SMTP id az21mr2751896pjb.123.1628138479238;
        Wed, 04 Aug 2021 21:41:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 81sm4843280pfv.185.2021.08.04.21.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 21:41:18 -0700 (PDT)
Message-ID: <610b6bee.1c69fb81.1c93e.ef82@mx.google.com>
Date:   Wed, 04 Aug 2021 21:41:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.56-4-g7057d5a05593
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 125 runs,
 1 regressions (v5.10.56-4-g7057d5a05593)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 125 runs, 1 regressions (v5.10.56-4-g7057d5a=
05593)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.56-4-g7057d5a05593/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.56-4-g7057d5a05593
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7057d5a0559336e906dcfa2cd8ba9a0041acf2af =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b33c36f419ace1fb13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.56-=
4-g7057d5a05593/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.56-=
4-g7057d5a05593/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b33c36f419ace1fb13=
663
        failing since 4 days (last pass: v5.10.54-2-g41c54732efb5, first fa=
il: v5.10.55-27-ge0b8a9439c81) =

 =20
