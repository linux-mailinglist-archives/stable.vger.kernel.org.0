Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF19A3D6C07
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 04:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhG0CAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 22:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbhG0CAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 22:00:23 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CE0C061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 19:40:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso2018378pjb.1
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 19:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BMQbEkI6C1xVufzPVSe0yM6ElVJZ8tzFesHP0TSBwRI=;
        b=XNCPTf58PddyayRHTAabMJqcRSbZssh2zeL43pFoTEXF+Xn+/dZi92EdEcQwot6+Oo
         BX9/GJGE6URmf03zxqcBv6QNbPkiXaNKZgAXyY8q4OOnX+1V4wuqx9mw8/y/ZqpW/zQO
         LXaborKiWBAjkg7e58R8xe+fRIMXR2UA4fQ4pCHzuQVuYvufNueq181DpIZoZPoAz4qQ
         xecaHXsC9OxxRrIiHeichimYbf98xUJhtKjBP3NRyejSpTR37DfLHxAG9F1cMxrD9bxk
         68xrBQXF0LOjiegDBgMufymxlySAoe86v+4NXmdG5SfLTC9QoV6nF/O392Qj701zBjNk
         Dgig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BMQbEkI6C1xVufzPVSe0yM6ElVJZ8tzFesHP0TSBwRI=;
        b=fGdIeQembplgge9hv6igsz3lRXa53R3MS222gTz86272eNhaEmpqsK30xW6+UTMER0
         aTQbdTIwk0zhMTlyjUlO9tE6X9led5P+EPF96YslyJqSYY/fPdJmfxlRjurF2/JpzH2B
         AKMhtoyjEeqJbJ6vmAsjyKHfJlE28wThOfXFGHpotKMZZb3ijBuKyXIiH1r9eogRNKco
         XJQtzkRkrtxBTPA0x+PG/49PUep7AFE9L0WoqR9ZA9iH7SnzJsp6iCmBaVrpZ90i4Zm1
         34XPoTZ7SV1XhIqgvX6hemQ9coCgob4GPRLc3u/NX9dt1JDK0MxPUlXzDf1aof5mwZgx
         EPAA==
X-Gm-Message-State: AOAM530IFp4uzwCsfhMWPCLlOwsHPvFzL31DoM5pGyd5GGVwR5dFsW1U
        6GgzRqLdeslvsFvTPATXVguqTyYMmTffqxHD
X-Google-Smtp-Source: ABdhPJzcu4dHo9OectfX0oeFbkMIhuNQ8MoBhlXox5VJHWDEOC8GQgShiUqRSGe/kCSdb8lYpCplug==
X-Received: by 2002:a63:e513:: with SMTP id r19mr21007563pgh.30.1627353650701;
        Mon, 26 Jul 2021 19:40:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm1293986pgk.57.2021.07.26.19.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 19:40:50 -0700 (PDT)
Message-ID: <60ff7232.1c69fb81.f6760.5f99@mx.google.com>
Date:   Mon, 26 Jul 2021 19:40:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.13.y baseline: 191 runs, 1 regressions (v5.13.5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 191 runs, 1 regressions (v5.13.5)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.5/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      25423f4bd9a9ac3e6b0ce7ecfe56c36f4e514893 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/60ff3c6264c52dc3603a2f61

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.5/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.5/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff3c6264c52dc3603a2=
f62
        new failure (last pass: v5.13.4) =

 =20
