Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5505147071E
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 18:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244585AbhLJRar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 12:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244611AbhLJRak (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 12:30:40 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52360C061353
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 09:27:05 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so9932806pja.1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 09:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fMEScaIu6+jbZUjdSqrIF4uMibeeUN/BKxV2XFKDNF8=;
        b=DdB60X3nUCj2HYFq3c7ZiTG9lXcnetEAWpn3sXbb/dIpQhbCHDdzJN3p86SMjAmU81
         adUDmYmLlpWBnYvDa6pTZVVSQ9jDs2EdhDgPdnvfB3bXFLaj8exLym5Hg8Z4/VR5ZbUl
         kmlDiqmJsSBIFyrGudejd0gt7ncZIYJV8WhSanu6f3DzKGhnVQpV/DOOXP4bGnwS29CY
         KJ/w0jCIq620LZTFzZChIn7Cxt50YYDk3BtzH4h66Rlf7pGrQjPLzFbIeHf7FffvEcht
         uJ+DbuvZ75wDDY3meYb1m9fyvydUpHx3hBAj6+onKHfoWRSH2xgy4fus3mKpfmVCByEV
         pASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fMEScaIu6+jbZUjdSqrIF4uMibeeUN/BKxV2XFKDNF8=;
        b=nWPHRCqWc4JzLqU9xBoZwszOe0EA6DF98f5cYU/HPc0WXIGCgE9TD92eB/ZVT7vpXT
         zxATthMe3K7ecdWKxWLw4UGQzXbXJlhNHoPl7mL6WOlDNp2P2AUREFv6E8H1t0BGmvX8
         QZYzbdyxu1Zl9LsLOYxPWXwBoPBbQzgQ3aczkgJkpY3H5fFJdpZW1GPt6E0XIk7b+5E+
         s7glitJWQjzYjSP8HIic1zkNaTMKlhaSoEdjYBltOvXXde5Ksp+HoWS7i5GebImZyf7O
         sulWkfxaefHH5gGYKSdaauzRvgC/bnxAbl14eBEt6FOukGIFMA3WKy1jduB8M6+jNa4/
         Nd8Q==
X-Gm-Message-State: AOAM5311rE5K6wQ+YtEfyBrFyhAV73/uojzTuA6l81AdJrFnDcUTiXaN
        HaUQkVrjICQ3WEEh8eHxGiGq9/2zeB/jW2lu
X-Google-Smtp-Source: ABdhPJzYg4kQSbGriDIZICZUSC5vwO0pgDIvTiCcnUjEpn7e/XSHpE+9nTdReO5OZzMfVufdV9pJxw==
X-Received: by 2002:a17:90b:1057:: with SMTP id gq23mr25289189pjb.203.1639157224749;
        Fri, 10 Dec 2021 09:27:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f10sm13328151pjm.52.2021.12.10.09.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:27:04 -0800 (PST)
Message-ID: <61b38de8.1c69fb81.990a5.53a2@mx.google.com>
Date:   Fri, 10 Dec 2021 09:27:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.84-20-ga6e7d64f88b7
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 200 runs,
 1 regressions (v5.10.84-20-ga6e7d64f88b7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 200 runs, 1 regressions (v5.10.84-20-ga6e7d6=
4f88b7)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.84-20-ga6e7d64f88b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.84-20-ga6e7d64f88b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6e7d64f88b7d243c4124e4c9619df27a4d68c4b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b356ff4dd854758a39711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
20-ga6e7d64f88b7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
20-ga6e7d64f88b7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b356ff4dd854758a397=
11f
        failing since 0 day (last pass: v5.10.83-129-g307696aadda6, first f=
ail: v5.10.83-129-gefc3f818915f) =

 =20
