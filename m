Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D447228AF20
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 09:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgJLHip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 03:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbgJLHio (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 03:38:44 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5960C0613CE
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 00:38:44 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id e10so12751093pfj.1
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 00:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=er52Sl3eSH4wtrj/ZHWQoJt7pXD2XQAXzNbY6aCQCcY=;
        b=Shz7wKpcHBc3i5Tn6GfhZ5jG2vdbVIZLGL6eiOMSboFNNYkQf+vLgTdjRo1DIy/06I
         /R/ZxB+mN/lF8nmC0O08IKiV0YLz6lmiqpewCqSAzYzpUPj8ndIKnh/n1AVftAzvrnuA
         Nu6B312MRyw4lI3twAT/QSeb1Nyaj21ywmT2XoCfWdez7zDPkgLP0WKcY4shXhnqttL9
         MOiKL6EVC6chNcoRFgdKhIeKurGsfcuZe1Q+6LlqBwzlKWIsf5SX9NCq1Eqou2cWNDc7
         ms2Qa0RThBppovvwXQp7EJl1s5VXLD93CGE3DwrUH6lK4V8B74ZcddndsFN2Zz+rsLTX
         zcpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=er52Sl3eSH4wtrj/ZHWQoJt7pXD2XQAXzNbY6aCQCcY=;
        b=VEAHGsMhhv9+HDmp/41JONPw2J8j+v1VaWAbMz0wOXnhwOuNU8FQVFzmGEOIg36x1c
         9Jlo0ohfm2vQwWwLxqRdt89dzg2QrPBvSxXT+DocAKJnNBq0wI5ll7PALUrYxz7bEKHK
         3w+j9R1cvtq65kklfOd3JFHVuoaXKTyMHjcBCI93c1gy7pYwdxCC8QjnK1MgLLy2yezG
         FYbKHG3yhWkb1JlohuJkMp0Qf09oNA/+UWrTriG1O5oq4bmQLtA+OH8aAohDWxYk80SG
         jteqtS1t5F3t14oymRFLyWOduKClhkC1IlRsIrvBHw3AuFXteFKCs5SL2JO/1oTcUxN1
         IDsg==
X-Gm-Message-State: AOAM530mGy0ONMLyHagO4CAZyaf2y5bxzS73CN6eBT9IUCERhP6sbYLA
        AbTkh2kcLq88UV8jUwsA2sJJiJsPcw+JCQ==
X-Google-Smtp-Source: ABdhPJyunhu7aAiMkIV0OCvl0cxVaHpxCeV3Teil4/89cyHx2yOWSksiTPJ1TYO9rJEvILZAFQagSQ==
X-Received: by 2002:a63:2051:: with SMTP id r17mr10014474pgm.191.1602488323910;
        Mon, 12 Oct 2020 00:38:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p19sm18520541pfn.204.2020.10.12.00.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 00:38:43 -0700 (PDT)
Message-ID: <5f840803.1c69fb81.fd19b.4332@mx.google.com>
Date:   Mon, 12 Oct 2020 00:38:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.150-29-gd8f1e7f2dffe
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 128 runs,
 1 regressions (v4.19.150-29-gd8f1e7f2dffe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 128 runs, 1 regressions (v4.19.150-29-gd8f1e=
7f2dffe)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.150-29-gd8f1e7f2dffe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.150-29-gd8f1e7f2dffe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8f1e7f2dffeeaa9e6d1228de98089a03bb50deb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f83c6c05cd8cd0be84ff401

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-29-gd8f1e7f2dffe/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-29-gd8f1e7f2dffe/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f83c6c05cd8cd0=
be84ff408
      new failure (last pass: v4.19.150-28-g0d0080f64605)
      2 lines

    2020-10-12 03:00:12.171000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
