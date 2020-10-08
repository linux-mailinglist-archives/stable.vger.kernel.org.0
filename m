Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5730B286CF6
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 04:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgJHC7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 22:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgJHC7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 22:59:39 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7845C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 19:59:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y20so2025613pll.12
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 19:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O6D5XJ77WG3AcvMI9aeO/sTstVyFVeVAzvDvMAvBKmA=;
        b=sWgUG4CQ0lDsBA7nQr9W6LQj2JmjYp/v+bneh6QqKGayWMEKiVYWpPYEkcXK4lousb
         lp3R43o5dGk2rW2zTYVZY2S+bFZoDnMLj3HYnri0Zn6lSG34FcyKEgl8pl2YepWpRcJf
         aobUdpKOfO4PPY4ywjwImhu7btmgUmtJsRlPHjPrtcy9S8CG6NfwnXEgFD+x2I39jeHg
         BOFjtSIp0vAxuescny17mDnyv/RhBFmsKtz0/kxRJM1RRKq11qMfRB5CbwGKdcWreNx5
         FTMKo9LUJJMfC6lOpowYfdMlKfASQ7ucTUEj4WfaYgFdaV1USxqiIsxlGLOYW8APe/0m
         /1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O6D5XJ77WG3AcvMI9aeO/sTstVyFVeVAzvDvMAvBKmA=;
        b=JOe9A1TRZh5r22NymdqgmN4NPeQiTGYIWTZ2TzLjCOFD7XCiJRUP3qiwbEzHFUXj8M
         V24vxUKV9SZxRBg97bshFcD4snRRopiaeanSqjPoy/R4UDUM6rUmHsHZ5Nmqh6MFD0rw
         9tLmUXmgbuw4NgpXdjSwhqV14ul4E8dAjQAIGhMAnlQke526e5dM17JKo2MfixgEgZKl
         YWXELMyhy22xnkhv20rxiWhvt3v7HoBIYzdkGQhHpSr29mcjbTF0XWaM71xjmERTT7w7
         sV0XFNaIX0ExNGfM6ED/4Ierq8qWfcNeG8UzPKlRSayqn/I/ka9NlLPNaRoDeU/3meoq
         NLgA==
X-Gm-Message-State: AOAM5314LojqhuE20H6E1XZ1P2JwGZdxBCHs2Z2PHZD1ZuzfmlOMtdKI
        AejlwRzQejmPZa05YWKH/Xlc926vgq8Bfw==
X-Google-Smtp-Source: ABdhPJxorfpcKsWHdD1u/ugtDdd7HVbGwhh1I4AA/2L/mEWaMvsJOIUvwjP0umS8d2UvYgAx+ZAOfg==
X-Received: by 2002:a17:902:8c8b:b029:d2:6356:8b43 with SMTP id t11-20020a1709028c8bb02900d263568b43mr5604564plo.34.1602125978903;
        Wed, 07 Oct 2020 19:59:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b16sm4889756pfp.195.2020.10.07.19.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 19:59:38 -0700 (PDT)
Message-ID: <5f7e809a.1c69fb81.163d0.9bfd@mx.google.com>
Date:   Wed, 07 Oct 2020 19:59:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-21-ge8084fa3b035
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 71 runs,
 1 regressions (v4.4.238-21-ge8084fa3b035)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 71 runs, 1 regressions (v4.4.238-21-ge8084f=
a3b035)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.238-21-ge8084fa3b035/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.238-21-ge8084fa3b035
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8084fa3b0354a08e87847c9140aaf77c0aee166 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f7e469c45ff1b183b4ff402

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.238=
-21-ge8084fa3b035/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.238=
-21-ge8084fa3b035/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7e469c45ff1b1=
83b4ff409
      failing since 2 days (last pass: v4.4.238, first fail: v4.4.238-17-g2=
58721d49aab)
      2 lines  =20
