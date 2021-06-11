Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A823A44B1
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 17:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhFKPMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 11:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhFKPMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 11:12:51 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43897C061574
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 08:10:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h1so2998043plt.1
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 08:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t56t+su62RHRfQLt9MZV7sCQlCWm34WftvjNz6FqZEE=;
        b=1NHkx0zGs7vjR5LO/nzvqCrFygBzvI9jCYiQmGzqyfNusI20bQo8v7cIBBlnquyl8I
         z5IhwTs32W377fiFvEvKgeRkRBJzgTGeGzjR8mCdAJIqiY/+woRHJPfWjgk//Qf6w/N/
         jSO/cQqolQ8KSNf8N3mRsgcMLfNqdCtfW3M5bLTEG/8hZbsuk0x0IZcm36/jb4wFjaz9
         XWAXr/9GdJq5itAqTHLL+9PRDePKUi0AWRk7KCVs8VCNYVGAwkANMGW2o/A++hMExXwS
         U4Awd91iuvnE5z9EdstZFZhnHaslGyQLT+BLi2nmz0JkPy9l04feneAKAN659rxvkMhz
         T+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t56t+su62RHRfQLt9MZV7sCQlCWm34WftvjNz6FqZEE=;
        b=YKzViTppvd6HgmDbtLe9vThGEZ8hbKaRCoNRb8y0MtpdK0iAA0NNhygY5cToqd1sYb
         GQhdmiAFqzOmhqrSv6F5xU0T9TaJEsOJgEWyv/07gxdex/UnfX6gYJBr9Aw6nGyZJGOH
         vFqYQlWEbnK7zygEiOKqGjXpKauuWKk8UfJnWePAr3b8o4G5OOxOeGYDPt591MKVhT5l
         Ic13wV3tQXxNfumTAAjT01pM5bPPvt7C0lAV15aIBgwBSjIyixMI+GgaU0i4JyQluU3N
         j65Hz30ppIJ/wV3lG/GcE9OgwgQzV3sqHv2KX+3C3mdoMxPg4fLW5QU2QJZNgAIZYZez
         149g==
X-Gm-Message-State: AOAM531hsQ0YA2EvgL8zt1BDgcRwwvqNFpirCUITpO2CP7FXH8urAHOm
        EWS20Gx9pPKkUMwpWB1ie+MgyVjmcq4N7c9h
X-Google-Smtp-Source: ABdhPJxtCFG/qq7D+ZSkBOGIzt6GcaiBeb6ZGSuLu/KZCgXC4FGxGrHWMbj4QfT67S4aLfeefjFkZw==
X-Received: by 2002:a17:902:b585:b029:f6:5cd5:f128 with SMTP id a5-20020a170902b585b02900f65cd5f128mr4257111pls.43.1623424252601;
        Fri, 11 Jun 2021 08:10:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p62sm3125201pga.88.2021.06.11.08.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 08:10:52 -0700 (PDT)
Message-ID: <60c37cfc.1c69fb81.58fd7.915b@mx.google.com>
Date:   Fri, 11 Jun 2021 08:10:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.236-20-gd7f1f4a1f9f3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 153 runs,
 1 regressions (v4.14.236-20-gd7f1f4a1f9f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 153 runs, 1 regressions (v4.14.236-20-gd7f1f=
4a1f9f3)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.236-20-gd7f1f4a1f9f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.236-20-gd7f1f4a1f9f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7f1f4a1f9f339cc1bdd23ba10c4522a19c10def =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c34a91d24aadd24e0c0e06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-20-gd7f1f4a1f9f3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-20-gd7f1f4a1f9f3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c34a91d24aadd24e0c0=
e07
        failing since 102 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
