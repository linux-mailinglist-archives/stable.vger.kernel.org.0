Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911AC48DB8E
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 17:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiAMQTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 11:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiAMQTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 11:19:38 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1264AC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 08:19:38 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n11so8604967plf.4
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 08:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UsPpXcHniGxbpcQQ/2S905kKNA12Al+08tZxqKThqgs=;
        b=oTFQsexUQfUbvoKgYaIaNdnQVZ5umtjBB9JTn4XvClGRCbuWb6ky4k1LfsYjzjm1+m
         3mTnZRX4R3DB3auwcO2lAPzFRaBa01AzvY4QFJFTElG+ocbCqayl1t+y+1kS4RJ0GCGm
         h0bRdIJF6sG26LSmDy8RRYBcWt78K01nfQ0F824TlJF4zzYD2cmcMYXYn/pLXU0+/C//
         5vYa2pAb1aYzix/Y6iC/TVESoEkCqFXVPBl4yiIKqKcWztXPm/mRv6AUUasnER6ODO5D
         X70FzVlZZbrhK9y9QMEGRJ+cA1TslWEr7R31Az9fVGxrgh5nuTQTadasXAJA3vPgoBWf
         ab4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UsPpXcHniGxbpcQQ/2S905kKNA12Al+08tZxqKThqgs=;
        b=USTiy2/AZPNb1J1DsGZUxhIgVkMxd0mbUyBPzTRo4mbH1Kcrw7He/IlD1Zc/fHAghx
         sGjSS7rxvu8ikYgWFSIzcoqC8ige2fJPGlMkAPeFICQJr14KaxQuOgQGYaBGhv6ye4Ed
         aTQJcadKboX9HAhI4N69wRV80IQWQklk9hL8jlqUWNsqAPRQsgKHHGyBwhQoTRMBiFjc
         BnaIj3qMp2SlzMHPlbK9FuFJ9fMdWq8+GhU/d1B0NSNW1FbHSTNAYgYJrJWNnVK+rCHG
         BHY2ZDz4f8V6Sxx4OOepeZIDz6yWxt4T8yJecce3nVTuxxVysd+bB3L6/gwdZhPuMUbF
         65RQ==
X-Gm-Message-State: AOAM530ASEqbwwHiW4lNuEr5YiHEym1ufOLRl68+BONkzlIY3KJmCF/h
        CzF5ofxnVpSuYqXBs+Y0GnCxxiiSD0+BdGCbAX4=
X-Google-Smtp-Source: ABdhPJxlDVxmD9UiewxaEzNqtrLFtZiHvE5QFNIuAgC44YpkOQUeZlBvMnKjj+iNTSaSoKbRtqjRwg==
X-Received: by 2002:a17:902:7c0d:b0:14a:78c:ce59 with SMTP id x13-20020a1709027c0d00b0014a078cce59mr5352956pll.104.1642090777246;
        Thu, 13 Jan 2022 08:19:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y3sm2761700pgl.83.2022.01.13.08.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 08:19:36 -0800 (PST)
Message-ID: <61e05118.1c69fb81.82ce8.72b2@mx.google.com>
Date:   Thu, 13 Jan 2022 08:19:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.91-2-g2ee9142f3b8c
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 149 runs,
 1 regressions (v5.10.91-2-g2ee9142f3b8c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 149 runs, 1 regressions (v5.10.91-2-g2ee9142=
f3b8c)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.91-2-g2ee9142f3b8c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.91-2-g2ee9142f3b8c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ee9142f3b8cf7f69aaea32d00df2227d9f13977 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61e01e799cf0cebfefef67b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
2-g2ee9142f3b8c/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
2-g2ee9142f3b8c/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e01e799cf0cebfefef6=
7b6
        new failure (last pass: v5.10.91-1-gb65b873608cf) =

 =20
