Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3ED232350E
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 02:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhBXBOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 20:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhBXApF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 19:45:05 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F93C06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 16:33:13 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id t9so104428pjl.5
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 16:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ef3HDEh5O90onYCv9X+GmwQ5+aBl1JrL2qf+YDWLAMk=;
        b=Dvs7+/JHlKJUZ79k++YHmJPrK393IM6RQ9Br2dadwJcEkcifr0ZOoDhsgAoOiMNL57
         G5SzHmVu7JkdzxNV3vWyMHjYzst5BRAP5DqKC64Ys2MayjZ+Cq4c4azd1QTNM+TQ6DNK
         VoeHsK3KddiAZcuQWdhK6hVafIMlxEDZa5qHHim1SkmhUVOP3OlLrh20eSlbsACzCy3P
         BKhmMYHspGBNC+xPnlcuIvufx0QmiOvmHSyk40Jx3Yg5nq0wlFgQATdx6FzIgUXecrPj
         +BjlRLt0C3z1zCEHU4Kf54nzuV5/zMUs7sJudnA93I6TvvRzE8Pptp2B9VYdM2S7moRV
         kIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ef3HDEh5O90onYCv9X+GmwQ5+aBl1JrL2qf+YDWLAMk=;
        b=gtsraG2fp/Is9hRXKyEiTt6wNEwEISIUNDAj0IErlOZnbi/DBSGFZF59ZvNbL280/O
         2G1Ja+bRtqoBdx887QhqAB4tXLPNj2NowUjIAgUXPTbA2FzU+7KVaHyQVWoW8CoZH9j2
         HsCtxqRtgYGpwnJyEajIVg0vFLkLOtlRSW7ouh01bEeeVDUe3tgMpAj8U5WPmlKnDNzi
         8N2EbR7HQ+3C3uU5wU5T+x6MTaTL/HvmNQTQvCe4CtxVP+Fq/GVNWaRAg52qaI3jk6hH
         v9xheKRC9s5aN56coPL1abKb9sM5CgwyzXUGPQV6Z0CUBsQvbLh/5PJiko2B+e18dQKL
         rAUg==
X-Gm-Message-State: AOAM530o2N9idyHjT6ZV9XU7QR4xB5lQ+q0dGhGdpDkYgnVyk86Vcdqk
        n/oyjp8NiyndJjlXjGTRBKTP7CpCsOuIfg==
X-Google-Smtp-Source: ABdhPJxEzHdcCSFyo0r8n1ebCruMCBXLxnhfzANokiPoUgHIBoex/nbqqmS1aWXgs2VE5ILMMfrebg==
X-Received: by 2002:a17:90b:2389:: with SMTP id mr9mr1424425pjb.141.1614126793390;
        Tue, 23 Feb 2021 16:33:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b207sm350439pfb.68.2021.02.23.16.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 16:33:13 -0800 (PST)
Message-ID: <60359ec9.1c69fb81.8d068.1720@mx.google.com>
Date:   Tue, 23 Feb 2021 16:33:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 50 runs, 1 regressions (v4.9.258)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 50 runs, 1 regressions (v4.9.258)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.258/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.258
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b1d078507bd33ebf6c2083fa363cf5832809c19 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60356e563493c7290eaddcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60356e563493c7290eadd=
cbf
        failing since 97 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
