Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3E73265E9
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 17:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhBZQzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 11:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBZQzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 11:55:04 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF74C06174A
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 08:54:21 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id t25so6561125pga.2
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 08:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/yu1maY1EM7c2hAZVek9wZunhf7zsE0QZgcYxLMoT+w=;
        b=VmHCyZY4wL5mNjWnMY7nvMfzE5nWhru6kIJpM+GEfav+QCXha03PzF7iqABZI0eKhu
         pvJnj2zqaBMtcUnvJXRCL4TVtLqMeJY6V3DDfh5xzWLROOt/4iH7j5FbnAsqUts3ByWL
         HXEF4/jJhy2AuzwzPHbZ2hMpvyChn4XxXyUgTRK9Hm3My3mQNZ+sJTyrifnmZZ/Y1O2S
         6GG4jADK4xbo+BZghiChAIkJQl94krjdHiFJSIT2Ggf/dZaKzMdSC8xZWU8pM0S+vfvx
         1Ns7clEaS7n5vE3kzRGD8Za7dMg5jTrMTvi0i5rhP5P4dA1hvp90dyClOz/omHF596kJ
         9X1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/yu1maY1EM7c2hAZVek9wZunhf7zsE0QZgcYxLMoT+w=;
        b=tTSFCNrd2fqvfnz8Osg9N1wSqImSAmgX/VS0UzbStv3xrFdd5BUjLjrl+prVfDlz35
         RoaMh8eQZhEhBWuVvvYjINVAfoez42zSXxXsfox6RBsLfAoXkuGpWOAdy3jzU2wch/gv
         QpV8g0vPOn6zrQz1zPPrTlzvfB+Qs9dRjX8P1XQ/gLmkMxsnuKzsYg/SefPj810B0nu4
         JDV9+Hb0a+fZFb+f2IU4vyQA9nznJmpUZE6vg7ylfOWD5/kxughIfwnxajRiEPEbuCiD
         YywXBtd9ySUSUnnlzWQXBdDoG834do2/wd6l7+0mgwe8zRmikZUeGHyklebWBgyRFL1E
         IRVQ==
X-Gm-Message-State: AOAM5338+ykflFBCYi3+9YYQD0XkwezX/6euvpVZOTRXZ8jFK1Ny+siC
        UBgYbzekLnVkNSdkVmIBQYQBU/RRTfeb2w==
X-Google-Smtp-Source: ABdhPJx8YHy1lF+vLnwC2KCaobepx71cXfSOE23lULYXP30+IpVUcPgixucdeUDlBkz/XvZ8/F+EzA==
X-Received: by 2002:a63:cc4f:: with SMTP id q15mr3693176pgi.47.1614358461196;
        Fri, 26 Feb 2021 08:54:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z137sm10929819pfc.172.2021.02.26.08.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 08:54:20 -0800 (PST)
Message-ID: <603927bc.1c69fb81.b1357.8514@mx.google.com>
Date:   Fri, 26 Feb 2021 08:54:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-7-g0e21fb27738e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 65 runs,
 1 regressions (v4.14.222-7-g0e21fb27738e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 65 runs, 1 regressions (v4.14.222-7-g0e21fb2=
7738e)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-7-g0e21fb27738e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-7-g0e21fb27738e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e21fb27738eaed41c367ae1971206aeef1a5c4b =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6038f3b4011a921ca1addcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-7-g0e21fb27738e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-7-g0e21fb27738e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6038f3b4011a921ca1add=
cc3
        failing since 80 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
