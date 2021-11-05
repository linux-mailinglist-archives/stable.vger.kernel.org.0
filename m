Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2AD4463E6
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 14:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhKENRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 09:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbhKENRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 09:17:00 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639CBC06120A
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 06:14:20 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g18so4052967pfk.5
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 06:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iP7IrQvOuYWUHX4+F/ly8CzuklrexTT9kjkJmgrCPKI=;
        b=zdsKSOuw2s5ZO0Bn/HRIrmx4sFglVMrYbtay96l37iucDZt4kktHrvpOu+MQX3rzCy
         4EkU4Vgv8hZw8VIOIyPWuXnWNAOBoWQnHV78GCJji+iAf27lTeM2lRFW5uN9s1nRZgcP
         z2D4ogQz/o7XNM14BJfmG+Mxgvfrk7ZgB2KSkaAO9vSe9aBD7gWjgcfTgkHcBZnVrKxM
         wdOEsYU1qxlGCtQWwp9NtZgjg4ntvU2Vg7vG21XQBso6m1HzjhvVxCjtIntajwxZxFB7
         WCstc2wWSzTHFFdU/mmECdCjhaXS+sjDoWX+6RA5W119uJ/sR8d3pjCJQkg/wms4P7ZZ
         /RXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iP7IrQvOuYWUHX4+F/ly8CzuklrexTT9kjkJmgrCPKI=;
        b=AzE+l9CiuUndAH+Eqy2b9cUEZBi7agG0mU3fbB+50SySUeYAQ90pDHI60Nd/PTdh9F
         /7LiGXP2WLk7zBVM1fW9Fh5YYlKcsmKcTxa/UqVye5bKfRD0IO7IASCY/G0p2q28++vG
         ggVQhNR1B6pjD/vZGJ7HGGz/AAEexudbEI4O7pZI31HIEsy0fyne2T+pdY84PGB0y9Wi
         yc8AdhAm7huQPdoQNaE1VFGiNnCFyuIWAJAZkHFMcuQuggCe4F1sGHX4o3k5a3220zxg
         CplREcdeB7ptXGAhcFOR/b8MMcvtbqLcCWiA/hMzr5/590riqUrvERrrSMx2w5Z+pakn
         hgaw==
X-Gm-Message-State: AOAM531mxte3La2OxsU3u2RSbEX9KE6CfFnrTcXf42luslW6+ginB2Xs
        SPKuB6yGkgjxkX/xxHMaAk06iCo80dQ58ZoX
X-Google-Smtp-Source: ABdhPJxI5SxTP8JjLPQuSs0C/40MeF59BgPB0IL6UDyPwjDl4yBenSO+QukrlLy0gIuVsVsYUA5KKQ==
X-Received: by 2002:a05:6a00:88e:b0:44c:c40:9279 with SMTP id q14-20020a056a00088e00b0044c0c409279mr59559194pfj.85.1636118059749;
        Fri, 05 Nov 2021 06:14:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm7722324pfl.200.2021.11.05.06.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 06:14:19 -0700 (PDT)
Message-ID: <61852e2b.1c69fb81.c70b3.90de@mx.google.com>
Date:   Fri, 05 Nov 2021 06:14:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.77-14-g7031df7ce83a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 54 runs,
 1 regressions (v5.10.77-14-g7031df7ce83a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 54 runs, 1 regressions (v5.10.77-14-g7031df7=
ce83a)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.77-14-g7031df7ce83a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.77-14-g7031df7ce83a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7031df7ce83ae9f49228d6b3aeec16ef4f477d6a =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6183c1181064f1977f3358f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.77-=
14-g7031df7ce83a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.77-=
14-g7031df7ce83a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6183c1181064f1977f335=
8f3
        new failure (last pass: v5.10.77-10-gb4e5b555340f) =

 =20
