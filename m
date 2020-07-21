Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2767222737C
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 02:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgGUAJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 20:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGUAJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 20:09:17 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A783C061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 17:09:17 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id k4so9439252pld.12
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 17:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XyeeuBb4z+YC9olaI6yGVkeHufy1HBv9NfWJeknHTmE=;
        b=Edom+JmKbxO09F8Ip06AQJvmBu3YcIO6iuycmEI9XiIpOZb2KlYeWpLV5IxkrsdNiQ
         8wzHgt5VeG2VpwvdHKI92XdRJLciwaIrEz6iILJqpCAtgGNHhQOa2mU/GxRYHbYIx7/v
         68RukJmt4s/wxMfpjzj0HqJ90kfKHkqvpMMh+w+WDbGGA5tuA2ncMUZ/9y44GCXW7+no
         oxSoGJ07grNYpJ91G3LRrnrztfxFdQapFSI9RWyLxa8C61flHkB1H9+YaA7cjM4lkgTl
         yPpHQYkX2VoGHO3Y1fd4geSKcz/IeA270G7pJ4XgVYzoJFn3d0jQlb546NtRuTvEX9s7
         ZNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XyeeuBb4z+YC9olaI6yGVkeHufy1HBv9NfWJeknHTmE=;
        b=c9XGtGMvOu7iSYcNj49S/jI1RliKpaGYX6N5KfvBr1EHOksZYA4P7mMOjuHcSTuk6D
         RvkU0GSglEgo9aJMgJAZviFXTD//JGFdqBn6tz2CMAS5nX/D7wy1IxH8P7CzU36qSSyT
         J5Rc4cMFBQ6RmLQAyqgHGOvq4wdkADqPV8KirY3ZBfvK1a0k61cB5WqxO7cc3qGjHEjb
         wVFg3VwQwkvQq2OaHAU3eI1P5Fs4yShNU3wAGPcMtQNBYbfO9/aga0+4j80bm9npTwLj
         stw5nXW3kwUHqq3my/4TdYU7she9p7CR6zdMkVHPvJaw0XwLMUAH/dUPBAObJGkMa07R
         BzLA==
X-Gm-Message-State: AOAM530KbokfUy3rREASStDg3hUcPuQlt4Kw2V0o1shjC4djnSg+k5zD
        tSL72Z85t9JqjiTPkmZ+Pvi2QZR4aIE=
X-Google-Smtp-Source: ABdhPJw1UXqPMWs0JABaK9GBbp4ffIcGvfy904lkePI7apQf94XwjKMjNpMGT1Q1ARx2k7JUCsWtLg==
X-Received: by 2002:a17:90a:26a4:: with SMTP id m33mr1950348pje.124.1595290156172;
        Mon, 20 Jul 2020 17:09:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gv16sm750887pjb.5.2020.07.20.17.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 17:09:15 -0700 (PDT)
Message-ID: <5f16322b.1c69fb81.fdecd.2f6e@mx.google.com>
Date:   Mon, 20 Jul 2020 17:09:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.188-126-g5b1e982af0f8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 60 runs,
 1 regressions (v4.14.188-126-g5b1e982af0f8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 60 runs, 1 regressions (v4.14.188-126-g5b1=
e982af0f8)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.188-126-g5b1e982af0f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.188-126-g5b1e982af0f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b1e982af0f810358664827a6333affb4f5d8eb5 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f15fece80543b71b185bb24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88-126-g5b1e982af0f8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88-126-g5b1e982af0f8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f15fece80543b71b185b=
b25
      failing since 111 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20
