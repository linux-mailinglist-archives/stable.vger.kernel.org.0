Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AD44751D3
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 06:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239787AbhLOFCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 00:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239777AbhLOFCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 00:02:47 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5BDC061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 21:02:47 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id np3so16280646pjb.4
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 21:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ay+XaZQQ/Zz7Y3KQr0KgmyLA95RxbbLTvkF0D/ZCOJU=;
        b=MX54yb8VSOZe0THCdOEuVq9PedqsTaBPNQn/rv1JCNUss2knYcewOpFqVivtLht/zn
         SCZ7XMCZd4AQoLEbLBL+vGkXpUpddnpfEEZjDFI5OoNKIb+/rmiauODefefHaoFVVVg3
         G1lMPTAKDOhOlVhxldb1s/1cTzDJXtrxwWlqYutSws5QSc4SGSaWQAGV39ZolIcI4WUa
         YRkw2knGyajm5HmoexcnIu5i/bhGCNgmwiiuJODvwLnGz826kFF3TdNp4II/n7Vqq0is
         JPOl6Ajg7N0DL5IyaabWJ47DcGjY4zUHgFvBdd59ckScaqmDBtiq0xuSwMerTDOT9S+l
         W3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ay+XaZQQ/Zz7Y3KQr0KgmyLA95RxbbLTvkF0D/ZCOJU=;
        b=wzCgN0tq9cDSwYORkwIyl9k6LaaDwV1gz+MUdNfXmQr2PFmCw16nB/4naQl15hO1/J
         YVG22nOWT5LHZ1uhoYJwkc3H6hpXxMaGYB0yRRgELFCSifcWabR7WCNyNftM7n64/4kk
         N8Vw4GMHAWKls/UPMmQmd9otCMdjrzpZqmk7XXufD4akIT1v4tDgMavQUotdtcb+z1Ae
         bfSHLqPuRCPCVjXEUO7O6SpwzKuH1X3OEi+yBxdbntIjSBacPrN5lQshDuJgcMdMgIVP
         +wmq6Ebk7kr4Ntp6vgRz1fMf8iiFiOvKrW9o5j+J1H5Hm1xuXtICL/SkeRTYFdcsWpmU
         SJtA==
X-Gm-Message-State: AOAM533OTkH7TnUl86l5VvQYfT+zqxhdlnekPUr1QA2QEGcxhNJnKV9L
        FP0sFMPql6V87nzQEbihQGo2h38xRHZ7Vty5
X-Google-Smtp-Source: ABdhPJzjg4sM7OtP5duXjzpJd3vyQIGgPLVCXX0/AS4juxFWErIq+qW2+eXwnbVAfRj8i/IQNbXfsQ==
X-Received: by 2002:a17:902:7b8d:b0:143:95e3:7dc0 with SMTP id w13-20020a1709027b8d00b0014395e37dc0mr9697749pll.21.1639544566739;
        Tue, 14 Dec 2021 21:02:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pi7sm3113729pjb.27.2021.12.14.21.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 21:02:46 -0800 (PST)
Message-ID: <61b976f6.1c69fb81.366f5.8ac6@mx.google.com>
Date:   Tue, 14 Dec 2021 21:02:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.165-1-g0847763b98b8
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 166 runs,
 1 regressions (v5.4.165-1-g0847763b98b8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 166 runs, 1 regressions (v5.4.165-1-g0847763b=
98b8)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.165-1-g0847763b98b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.165-1-g0847763b98b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0847763b98b8a03262065575ed55d35949ab967a =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b93caccc5c11c27139719f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
-g0847763b98b8/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
-g0847763b98b8/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b93caccc5c11c271397=
1a0
        new failure (last pass: v5.4.164-88-gb4f7c3a061a8) =

 =20
